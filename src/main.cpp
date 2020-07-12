

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

#include <QDebug>
#include <QSqlError>
#include <QQmlContext>

#include "database.h"
#include "listmodel.h"


int main(int argc, char *argv[])
{

    /*
    QString databasename = "/home/jmg/Source/RQDA-qml/RQDA/SQLite/Test.rqda";
    DataBase database;
    database.connectToDataBase(databasename);
    */

    qmlRegisterType<DataBase>("DB", 1, 0, "Database");

    ListModel *files = new ListModel();
    ListModel *codes = new ListModel();
    ListModel *codecats = new ListModel();
    ListModel *codecatsID = new ListModel();
    ListModel *cases = new ListModel();
    ListModel *casesID = new ListModel();
    ListModel *attr = new ListModel();
    ListModel *filescat = new ListModel();
    ListModel *filescatID = new ListModel();
    ListModel *journals = new ListModel();
    ListModel *viewfile = new ListModel();

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    //QQuickStyle::setStyle("Fusion");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    engine.rootContext()->setContextProperty("files", files);
    engine.rootContext()->setContextProperty("codes", codes);
    engine.rootContext()->setContextProperty("codecats", codecats);
    engine.rootContext()->setContextProperty("codecatsID", codecatsID);
    engine.rootContext()->setContextProperty("cases", cases);
    engine.rootContext()->setContextProperty("casesID", casesID);
    engine.rootContext()->setContextProperty("attr", attr);
    engine.rootContext()->setContextProperty("filescat", filescat);
    engine.rootContext()->setContextProperty("filescatID", filescatID);
    engine.rootContext()->setContextProperty("journals", journals);
    engine.rootContext()->setContextProperty("viewfile", viewfile);
    // engine.rootContext()->setContextProperty("database", &database);

    return app.exec();
}
