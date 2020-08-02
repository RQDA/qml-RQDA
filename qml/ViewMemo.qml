import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.2
import QtQuick.Layouts 1.15


Window {
    id: frame
    title: qsTr("Memo")
    visible: true
    width: 640
    height: 480

    Shortcut {
        sequence: StandardKey.Close
        context: Qt.ApplicationShortcut
        onActivated: close()
    }

    Flickable{
        id: flick

        width: frame.width; height: parent.height;
        contentWidth: contentarea.paintedWidth
        contentHeight: contentarea.paintedHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds


        function ensureVisible(r)
        {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }


        ScrollBar {
            id: vbar
            hoverEnabled: true
            active: hovered || pressed
            orientation: Qt.Vertical
            size: flick.height
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
        ScrollBar.vertical: ScrollBar {
            active: true;

            onActiveChanged: {
                if (!active)
                    active = true;
            }
        }

        anchors.fill: parent
        TextEdit {

            id: contentarea
            width: flick.width
            text: viewmemo.viewmemos(memoid, memotyp)
            textFormat: TextEdit.RichText
            selectByMouse: true
            focus: true
            wrapMode: TextEdit.Wrap
            onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
            textMargin: 20

            //myTextEdit.text.toString().substring(myTextEdit.selectionStart,
            //        myTextEdit.selectionEnd);
        }

    }
}
