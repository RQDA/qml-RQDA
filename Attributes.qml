import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15


Page {
    id: attr_page
    title: qsTr("Attributes")

    ColumnLayout{
        Row {
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
            Button {
                text: "Class"
            }
        }

        Row {
            ScrollView {
                width: attr_page.width
                height: attr_page.height

                ListView {
                    id: listView
                    model: attr
                    delegate: ItemDelegate {
                        width: attr_page.width
                        text: model.name
                        highlighted: ListView.isCurrentItem
                        onClicked: listView.currentIndex = index
                    }
                }
            }
        }
    }
}



