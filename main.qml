import QtQuick 2.12
import QtQuick.Window 2.10
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.3
//import Qt.labs.platform 1.1

import DB 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Stack")

    property string filename: ""
    property string project: ""
    property int fileid: 0;
    property int caseid: 0;
    property int codecatsid: 0;
    property int filescatid: 0;


    Shortcut {
        sequence: StandardKey.Quit
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
    }
    Database {
        id: database
        db: project
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrls)
                var str = ""
                str = fileDialog.fileUrls.toString()
                // remove prefixed "file://"
                if (Qt.platform.os === "windows")
                    str = str.replace(/^(file:\/{3})/,"");
                else
                    str = str.replace(/^(file:\/{2})/,"");

                // unescape html codes like '%23' for '#'
                str = decodeURIComponent(str);
                // str += Qt.resolvedUrl(str) // what does this do?

                project = str
        }
        onRejected: {
            console.log("Canceled")
        }
        Component.onCompleted: visible = false
    }

    //menu containing two menu items
    menuBar: MenuBar {
        Menu {
            title: qsTr("Project")
            MenuItem {
                text: qsTr("&Open")
                onTriggered:   fileDialog.open();
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("Settings")
        }
    }

    header: TabBar {
            id: tabBar
            currentIndex: swipeView.currentIndex

            TabButton {
                text: qsTr("Project")
                onClicked: {
                    stackView.push("qml/HomeForm.ui.qml")
                }
            }
            TabButton {
                text: qsTr("Files")
                onClicked: {
                    files.files();
                    stackView.push("qml/Files.qml")
                }
            }
            TabButton {
                text: qsTr("Codes")
                onClicked: {
                    codes.codes();
                    stackView.push("qml/Codes.qml")
                }
            }
            TabButton {
                text: qsTr("Code Categories")
                onClicked: {
                    codecats.codecats();
                    stackView.push("qml/CodesCat.qml")
                }
            }
            TabButton {
                text: qsTr("Cases")
                onClicked: {
                    cases.cases();
                    stackView.push("qml/Cases.qml")
                }
            }
            TabButton {
                text: qsTr("Attributes")
                onClicked: {
                    attr.attr();
                    stackView.push("qml/Attributes.qml")
                }
            }
            TabButton {
                text: qsTr("File Categories")
                onClicked: {
                    filescat.filescat();
                    stackView.push("qml/FilesCat.qml")
                }
            }
            TabButton {
                text: qsTr("Journals")
                onClicked: {
                    journals.journals();
                    stackView.push("qml/Journals.qml")
                }
            }
        }

    StackView {
        id: stackView
        initialItem: "qml/HomeForm.ui.qml"
        anchors.fill: parent
    }
}
