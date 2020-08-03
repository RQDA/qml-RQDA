import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15


Page {
    id: files_page
    title: qsTr("Files")

    ColumnLayout{
        Row {
            Button {
                text: "Import"
            }
            Button {
                text: "Delete"
            }
            Button {
                text: "Open"
            }
            Button {
                text: "Memo"
                onClicked: {
                    memotyp = 1;
                    stackView.push("ViewMemo.qml")
                }
            }
            Button {
                text: "Rename"
            }
            Button {
                text: "Attribute"
            }
        }

        Row {
            ScrollView {
                width: files_page.width
                height: files_page.height

                ListView {
                    id: listView
                    model: files
                    delegate: ItemDelegate {
                        width: files_page.width
                        text: model.name
                        highlighted: ListView.isCurrentItem
                        onClicked: {
                            listView.currentIndex = index
                            // gibt den richtigen Index zurück
                            console.log(filename);
                            filename =  model.name;
                            fileid = model.id;
                            memoid = model.id;
                            console.log("filename is ", filename);
                            // viewfile.viewfiles(fileid)
                        }
                        onDoubleClicked: {
                            filetxt = viewfile.viewfiles(fileid)
                            stackView.push("ViewFile.qml")
                        }
                    }
                }
            }
        }
    }
}



