import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.1

MessageDialog {
    id: selectfirst
    icon: StandardIcon.Information
    title: "No item selected"
    text: "You have to select an item first."
    onAccepted: {
        console.log("No item selected.")
    }
    Component.onCompleted: visible = false
    visible: false
}
