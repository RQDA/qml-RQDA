import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15

Page {
    id: jour_page
    title: qsTr("Journals")

    ColumnLayout{
        Row {
            Button {
                text: "Add"
            }
            Button {
                text: "Delete"
            }
            Button {
                text: "Open"
            }
            Button {
                text: "Rename"
            }
        }

        Row {
            ScrollView {
                width: jour_page.width
                height: jour_page.height

                ListView {
                    id: listView
                    model: journals
                    delegate: ItemDelegate {
                        width: jour_page.width
                        text: model.name
                        highlighted: ListView.isCurrentItem
                        onClicked: listView.currentIndex = index
                    }
                }
            }
        }
    }
}



