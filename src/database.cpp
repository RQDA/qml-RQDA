#include "database.h"

DataBase::DataBase(QObject *parent) : QObject(parent)
{

}

DataBase::~DataBase()
{

}

void DataBase::connectToDataBase(const QString databasename)
{
    if(!QFile(databasename).exists()){
        qDebug() << "cannot open database";
    } else {
        this->openDataBase(databasename);
    }
}


bool DataBase::openDataBase(const QString databasename)
{
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setHostName(DATABASE_HOSTNAME);
    db.setDatabaseName(databasename);
    if(db.open()){
        return true;
    } else {
        return false;
    }
}

void DataBase::closeDataBase()
{
    db.close();
}

bool DataBase::execquery(const QString sqlquery)
{
    QSqlQuery query;
    query.prepare(sqlquery);

    if(!query.exec()){
        qDebug() << "SQL Error with " << sqlquery;
        qDebug() << query.lastError().text();
        return false;
    } else {
        return true;
    }
}

bool DataBase::updateMemo(const QString memo, const int memotyp, const int memoid)
{
    QSqlQuery query;

    if (memotyp == 1)
        query.prepare("UPDATE source SET memo = :newmemo WHERE id = :fileid");

    else if (memotyp == 2)
        query.prepare("UPDATE cases SET memo = :newmemo WHERE id = :fileid");

    else if (memotyp == 3)
        query.prepare("UPDATE codecat SET memo = :newmemo WHERE  catid = :fileid");

    else if (memotyp == 4)
        query.prepare("UPDATE filecat SET memo = :newmemo WHERE  catid = :fileid");

    /*
    // attributes provides no id variable, so we do a little sql limbo to be able to select an id variable
    if (memotyp == 5)
        query.prepare("select a.id, a.memo \
                       from (select ROW_NUMBER() OVER(ORDER BY lower(name)) AS id, \
                                    memo, name \
                                    from attributes \
                                    where status=1 \
                                    order by lower(name)) a \
                       where id = :fileid");

    */

    else if (memotyp == 6)
        query.prepare("UPDATE freecode SET memo = :newmemo WHERE id = :fileid");

    else {
        qDebug() << "Unimplemented memotyp.";
        return false;
    }


    query.bindValue(":fileid", memoid);
    query.bindValue(":newmemo", memo);

    if(!query.exec()){
        qDebug() << "SQL Error with " << query.executedQuery();
        qDebug() << query.lastError().text();
        return false;
    } else {
        return true;
    }
}
