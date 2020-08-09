#include "listmodel.h"
#include "database.h"

ListModel::ListModel(QObject *parent) :
    QSqlQueryModel(parent)
{
    this->files();
    this->codes();
    this->codecats();
    this->cases();
    this->attr();
    this->filescat();
    this->journals();
    this->viewfilesCodes();
}

// The method for obtaining data from the model
QVariant ListModel::data(const QModelIndex & index, int role) const {

    // Define the column number, on the role of number
    int columnId = role - Qt::UserRole - 1;
    // Create the index using a column ID
    QModelIndex modelIndex = this->index(index.row(), columnId);

    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}


// The method updates the tables in the data model representation
void ListModel::files()
{
    // The update is performed SQL-queries to the database
    this->setQuery("select name, date, id from source where status=1 order by lower(name)");
}

void ListModel::codes()
{
    // The update is performed SQL-queries to the database
    this->setQuery("select name, id,date from freecode where status=1 order by lower(name)");
}

void ListModel::codecats()
{
    // The update is performed SQL-queries to the database
    this->setQuery("select name, date, catid from codecat where status=1");
}

void ListModel::codecatsID(const int codecatid)
{
    QSqlQuery query;
    query.prepare("select a.name, a.id          \
                   from freecode        as a    \
                   left join treecode   as b    \
                   on a.id = b.cid              \
                   where a.status = 1 and b.status = 1 and b.catid = :codecatid");
    query.bindValue(":codecatid", codecatid);
    query.exec();
    // The update is performed SQL-queries to the database
    this->setQuery(query);
}

void ListModel::cases()
{
    this->setQuery("select name, id from cases where status=1");
}

void ListModel::casesID(const int caseid)
{
    QSqlQuery query;
    query.prepare("select a.name, a.id          \
                  from      source      as a    \
                  left join caselinkage as b    \
                  on a.id = b.fid               \
                  where a.status = 1 and b.status = 1 and b.caseid = :caseid");
    query.bindValue(":caseid", caseid);
    query.exec();
    this->setQuery(query);
}

void ListModel::attr()
{
    this->setQuery("select ROW_NUMBER() OVER(ORDER BY lower(name)) AS id, name  from attributes where status=1 order by lower(name)");
}

void ListModel::filescat()
{
    this->setQuery("select catid as id, name from filecat where status=1");
}

void ListModel::filescatID(const int fielscatid)
{
    QSqlQuery query;
    query.prepare("select a.id, a.name       \
                  from      source      as a \
                  left join treefile    as b \
                  on a.id = b.fid            \
                  where a.status = 1 and b.status = 1 and b.catid = :fielscatid");
    query.bindValue(":fielscatid", fielscatid);
    query.exec();
    this->setQuery(query);
}

void ListModel::journals()
{
    this->setQuery("select a.id, a.name \
                   from (select ROW_NUMBER() OVER(ORDER BY date) AS id, \
                                date, \
                                name  \
                         from journal  where status=1 order by date) a");
}


void ListModel::viewfilesCodes()
{
    this->setQuery("select coding.rowid, selfirst, selend, freecode.name, freecode.color, freecode.id from coding, freecode where fid=1 and coding.status=1 and freecode.id=cid and freecode.status=1");
}

QString ListModel::viewfiles(const int fileid)
{
    QSqlQuery query;
    query.prepare("SELECT id, file FROM source WHERE id = :fileid");
    query.bindValue(":fileid", fileid);
    query.exec();
    qDebug() << "next" << query.record();

    QString res = "";
    while(query.next()) {
        res = query.record().value("file").toString();
    }

    return res;
}

QString ListModel::viewmemos(const int fileid, const int memotyp)
{
    QSqlQuery query;

    // memotyp == 1
    query.prepare("SELECT id, memo FROM source WHERE id = :fileid");

    if (memotyp == 2)
        query.prepare("SELECT id, memo FROM cases WHERE id = :fileid");

    if (memotyp == 3)
        query.prepare("SELECT catid as id, memo FROM codecat WHERE catid = :fileid");

    if (memotyp == 4)
        query.prepare("SELECT catid as id, memo FROM filecat WHERE catid = :fileid");

    // attributes provides no id variable, so we do a little sql limbo to be able to select an id variable
    if (memotyp == 5)
        query.prepare("select a.id, a.memo \
                       from (select ROW_NUMBER() OVER(ORDER BY lower(name)) AS id, \
                                    memo, name \
                                    from attributes \
                                    where status=1 \
                                    order by lower(name)) a \
                       where id = :fileid");

    if (memotyp == 6)
        query.prepare("SELECT id, memo FROM freecode WHERE id = :fileid");

    query.bindValue(":fileid", fileid);
    query.exec();
    qDebug() << "next" << query.record();
    query.next();

    return query.record().value("memo").toString();
}

QString ListModel::viewjournals(const int fileid)
{
    QSqlQuery query;
    query.prepare("SELECT a.id, a.journal \
                   FROM (SELECT ROW_NUMBER() OVER(ORDER BY date) AS id, \
                                date, \
                                journal  \
                         FROM journal  WHERE status=1 ORDER BY date) a\
                   WHERE id = :fileid");
    query.bindValue(":fileid", fileid);
    query.exec();
    qDebug() << "next" << query.record();
    query.next();

    return query.record().value("journal").toString();
}

