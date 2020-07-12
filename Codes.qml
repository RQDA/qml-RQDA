import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15

Page {
    id: codes_page
    title: qsTr("Codes")

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
                text: "Anno"
            }
            Button {
                text: "Coding"
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
                width: codes_page.width
                height: codes_page.height

                ListView {
                    id: listView
                    model: codes
                    delegate: ItemDelegate {
                        // anchors.fill: parent
                        width: codes_page.width
                        text: model.name
                        highlighted: ListView.isCurrentItem
                        onClicked: listView.currentIndex = index
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
