#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QObject>
#include <QSqlQueryModel>
#include <QSqlQuery>
#include <QSqlRecord>

#include <QDebug>

class ListModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    explicit ListModel(QObject *parent = 0);
    QHash<int, QByteArray> roleNames() const
    {
       QHash<int, QByteArray> roles;
       for (int i = 0; i < record().count(); i ++) {
           // qDebug() << "i" << i;
           roles.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
       }
       return roles;
    }

    // Override the method that will return the data
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    QStringList userRoleNames() {
        QStringList names;
        for (int i = 0; i < record().count(); i ++) {
            names << record().fieldName(i).toUtf8();
            // qDebug() << "names" << names;
        }
        return names;
    }

protected:
    QHash<int, QByteArray> roleNames();

signals:

public slots:
    void files();
    void codes();
    void codecats();
    void codecatsID(const int codecatid);
    void cases();
    void casesID(const int caseid);
    void attr();
    void filescat();
    void filescatID(const int filecatid);
    void journals();
    void viewfilesCodes();
    QString viewfiles(const int fileid);
};

#endif // LISTMODEL_H
