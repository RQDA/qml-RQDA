import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15

Page {
    id: filescat_page
    title: qsTr("File Categories")

    ColumnLayout{

        Row {
            ColumnLayout{
                Row{
                    Button {
                        text: "Add"
                    }
                    Button {
                        text: "Delete"
                    }
                    Button {
                        text: "Rename"
                    }
                }
                Row {
                    Button {
                        text: "Add To"
                    }
                    Button {
                        text: "Drop From"
                    }
                    Button {
                        text: "Memo"
                    }
                }
            }
        }

        Row {
            ScrollView {
                width: filescat_page.width
                height: filescat_page.height / 3

                ListView {
                    id: listView_cases
                    model: filescat
                    delegate: ItemDelegate {
                        // anchors.fill: parent
                        width: filescat_page.width
                        text: model.name
                        highlighted: ListView.isCurrentItem
                        onClicked: listView_cases.currentIndex = index
                        onDoubleClicked: {
                            filescatid = model.catid;
                            console.log("double row is ", filescatid);
                            filescatID.filescatID(filescatid)
                        }
                    }
                }
            }
        }

        Row {
            ScrollView {
                width: filescat_page.width
                height: filescat_page.height / 3

                ListView {
                    id: listView_casesfiles
                    model: filescatID
                    delegate: ItemDelegate {
                        // anchors.fill: parent
                        width: filescat_page.width
                        text: model.name
                        highlighted: ListView.isCurrentItem
                        onClicked: listView_casesfiles.currentIndex = index
                        onDoubleClicked: {
                            // gibt den richtigen Index zurück
                            console.log("double row is ", index);
                            // stackView.push("ViewFile.qml")
                        }
                    }
                }
            }
        }
    }
}
