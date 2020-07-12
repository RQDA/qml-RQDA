import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15

Page {
    id: codecats_page
    title: qsTr("Code Categories")

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
                    Button {
                        text: "Memo"
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
                        text: "Unmark"
                    }
                    Button {
                        text: "Mark"
                    }
                }
            }
        }

        Row {
            ScrollView {
                width: codecats_page.width
                height: codecats_page.height / 3

                ListView {
                    id: listView_codecats
                    model: codecats
                    delegate: ItemDelegate {
                        // anchors.fill: parent
                        width: codecats_page.width
                        text: model.name
                        highlighted: ListView.isCurrentItem
                        onClicked: listView_codecats.currentIndex = index
                        onDoubleClicked: {
                            codecatsid = model.catid;
                            console.log("double row is ", codecatsid);
                            codecatsID.codecatsID(codecatsid)
                        }
                    }
                }
            }
        }

        Row {
            ScrollView {
                width: codecats_page.width
                height: codecats_page.height / 3

                ListView {
                    id: listView_codes
                    model: codecatsID
                    delegate: ItemDelegate {
                        // anchors.fill: parent
                        width: codecats_page.width
                        text: model.name
                        highlighted: ListView.isCurrentItem
                        onClicked: listView_codes.currentIndex = index
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
