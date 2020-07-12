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
