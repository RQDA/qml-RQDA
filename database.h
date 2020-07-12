#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QSql>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlDatabase>
#include <QFile>
#include <QDate>
#include <QDebug>

#define DATABASE_HOSTNAME   "127.0.0.1"

class DataBase : public QObject
{
    Q_PROPERTY(QString db READ databasename WRITE dbfile)
    Q_OBJECT
public:
    explicit DataBase(QObject *parent = 0);
    ~DataBase();
    QString databasename() const {
        return 0;
    }

    void dbfile(QString &dbfilestr){
        qDebug() << "dbfilestr" << dbfilestr;

        // guard against open databases
        closeDataBase();
        connectToDataBase(dbfilestr);
    }
    void connectToDataBase(const QString databasename);

private:
    QSqlDatabase    db;

private:
    bool openDataBase(const QString databasename);
    void closeDataBase();
};

#endif // DATABASE_H
