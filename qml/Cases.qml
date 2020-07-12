import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15

Page {
    id: cases_page
    title: qsTr("Cases")

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
                        text: "Unlink"
                    }
                    Button {
                        text: "Link"
                    }
                }
                Row {
                    Button {
                        text: "Attribute"
                    }
                    Button {
                        text: "Profile"
                    }
                }
            }
        }

        Row {
            ScrollView {
                width: cases_page.width
                height: cases_page.height / 3

                ListView {
                    id: listView_cases
                    model: cases
                    delegate: ItemDelegate {
                        // anchors.fill: parent
                        width: cases_page.width
                        text: model.name
                        highlighted: ListView.isCurrentItem
                        onClicked: listView_cases.currentIndex = index
                        onDoubleClicked: {
                            caseid = model.id;
                            console.log("double row is ", caseid);
                            casesID.casesID(caseid)
                        }
                    }
                }
            }
        }

        Row {
            ScrollView {
                width: cases_page.width
                height: cases_page.height / 3

                ListView {
                    id: listView_casesfiles
                    model: casesID
                    delegate: ItemDelegate {
                        // anchors.fill: parent
                        width: cases_page.width
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
