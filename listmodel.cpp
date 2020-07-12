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
    this->setQuery("select name from attributes where status=1 order by lower(name)");
}

void ListModel::filescat()
{
    this->setQuery("select name, catid from filecat where status=1");
}

void ListModel::filescatID(const int fielscatid)
{
    QSqlQuery query;
    query.prepare("select a.name, a.id       \
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
    this->setQuery("select name from journal where status=1");
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
    query.next();
    // qDebug() << "next" << query.record();
    QString res = query.record().value("file").toString();
    // qDebug() << "record" << res;
    return res;

    /*
    this->setQuery(query);

    for (int i = 0; i < this->rowCount(); ++i) {
        int id = this->record(i).value("id").toInt();
        QString name = this->record(i).value("file").toString();
        qDebug() << id << name;
    }

    qDebug() << fileid;
    while(this->canFetchMore()) this->fetchMore();

    qDebug() << "record->value" << this->record(0);
    qDebug() << "record->value" << this->record(0).value(0).toInt();
    qDebug() << "record->value" << this->record(1).value(1).toString();
    qDebug() << "record->value" << this->rowCount();

    for (int i = 0; i < this->rowCount(); ++i) {
        int id = this->record(i).value("id").toInt();
        QString name = this->record(i).value("file").toString();
        qDebug() << id << name;
    }

        return this->record(0).value("file").toString();
    */
}

