import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.2
import QtQuick.Layouts 1.15


ApplicationWindow {
    id: frame
    title: qsTr(filename)
    visible: true
    width: 640
    height: 480

    Shortcut {
        sequence: StandardKey.Close
        context: Qt.WindowShortcut
        onActivated: close()
    }



    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Save")
            }            
        }
        Menu {
            title: qsTr("Close")
            MenuItem {
                text: qsTr("Position")

                onClicked: {
                    console.log("sel beg: " + flick.contentarea.selectionStart())
                    console.log("sel end: " +flick.contentarea.selectionEnd())
                }
            }
        }
    }


    Flickable{
        id: flick

        anchors.fill: parent

        width: frame.width; height: frame.height - parent.height;
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

        /*
        FocusScope {
            id: root
            property alias font: textEdit.font
            property alias text: textEdit.text

            Rectangle {
                color: "lightyellow"
                height: textEdit.cursorRectangle.height
                width: root.width
                visible: root.focus
                y: textEdit.cursorRectangle.y
            }

            TextEdit {
                id: textEdit
                anchors.fill: parent
                focus: true
             }
        }
        */

        function hl(element, start, end) {
            var str = element
            str = str.substr(0, start) +
                '<span class="highlight">' +
                str.substr(start, end - start + 1) +
                '</span>' +
                str.substr(end + 1);
            return str;
        }



        function flattenRanges(ranges) {
          var points = [];
          var flattened = [];
          for (var i in ranges) {
            if (ranges[i].end < ranges[i].begin) { //RE-ORDER THIS ITEM (BEGIN/END)
              var tmp = ranges[i].end; //RE-ORDER BY SWAPPING
              ranges[i].end = ranges[i].begin;
              ranges[i].begin = tmp;
            }
            points.push(ranges[i].begin);
            points.push(ranges[i].end);
          }
          //MAKE SURE OUR LIST OF POINTS IS IN ORDER
          points.sort(function(a, b){return a-b});
          //FIND THE INTERSECTING SPANS FOR EACH PAIR OF POINTS (IF ANY)
          //ALSO MERGE THE ATTRIBUTES OF EACH INTERSECTING SPAN, AND INCREASE THE COUNT FOR EACH INTERSECTION
          for (var p in points) {
            if (p==0 || points[p]==points[p-1]) continue;
            var includedRanges = ranges.filter(function(x){
              return (Math.max(x.begin,points[p-1]) < Math.min(x.end,points[p]));
            });
            if (includedRanges.length > 0) {
              var flattenedRange = {
                begin:points[p-1],
                end:points[p],
                count:0
              }
              for (var j in includedRanges) {
                var includedRange = includedRanges[j];
                for (var prop in includedRange) {
                  if (prop != 'begin' && prop != 'end') {
                    if (!flattenedRange[prop]) flattenedRange[prop] = [];
                    flattenedRange[prop].push(includedRange[prop]);
                  }
                }
                flattenedRange.count++;
              }
              flattened.push(flattenedRange);
            }
          }
          return flattened;
        }

        function inflateRanges(ranges, length=0) {
          var inflated = [];
          var lastIndex;
          for (var i in ranges) {
            if (i==0) {
              //IF THERE IS EMPTY TEXT IN THE BEGINNING, CREATE AN EMOTY RANGE
              if (ranges[i].begin > 0){
                inflated.push({
                  begin:0,
                  end:ranges[i].begin-1,
                  count:0
                });
              }
              inflated.push(ranges[i]);
            } else {
              if (ranges[i].begin == ranges[i-1].end) {
                ranges[i-1].end--;
              }
              if (ranges[i].begin - ranges[i-1].end > 1) {
                inflated.push({
                  begin:ranges[i-1].end+1,
                  end:ranges[i].begin-1,
                  count:0
                });
              }
              inflated.push(ranges[i]);
            }
            lastIndex = ranges[i].end;
          }
          //FOR SIMPLICITY, ADD ANY REMAINING TEXT AS AN EMPTY RANGE
          if (lastIndex+1 < length-1) {
            inflated.push({
              begin:lastIndex+1,
              end:length-1,
              count:0
            })
          }
          return inflated;
        }

        function fillRanges(ranges, text) {
          for (var i in ranges) {
            ranges[i].text = text.slice(ranges[i].begin,ranges[i].end+1);
          }
          return ranges;
        }


        function createHighlightedString(ranges, text) {


            var colors = [];
            for(var k = 0; k < 99; ++k)
            {
                // https://stackoverflow.com/a/55346027/12340029
                let c= "#xxxxxx".replace(/x/g, y=>(Math.random()*16|0).toString(16));
                colors.push(c);
            }

            // console.log("ranges: " + ranges)
          var flatRanges = flattenRanges(ranges);
          var inflatedRanges = inflateRanges(flatRanges, text.length);
          var filledRanges = fillRanges(inflatedRanges, text);
          var str = "";
          var index = 0;
          for (var i in filledRanges) {
            var range = filledRanges[i];
            var begin = range.begin, end = range.end;
            if (range.count > 0) {
              if (range.tooltip) {
                str += "<span style='background:" + colors[range.id] + "'>" + range.text + "<span class='tooltiptext tooltip-bottom'>" + range.tooltip.join('<br/>') + "</span></span>";
              } else {
                str += "<span style='background:" + colors[range.id] + "'>" + range.text + "</span>";
              }
            } else {
              str += range.text;
            }
          }
          return str;
        }

        // https://www.codegrepper.com/code-examples/javascript/javascript+replace+line+breaks+with+br
        function nl2br(str){
         return str.replace(/(?:\r\n|\r|\n)/g, '<br />');
        }


        TextEdit {

            id: contentarea
            width: flick.width
            text:  '
                <html>
                    <head><style>
                        .tooltip {
                            position: relative;
                            display: inline-block;
                            border-bottom: 1px dotted black;
                        }

                        .tooltip .tooltiptext {
                        visibility: hidden;
                            position: absolute;
                            width: 120px;
                            background-color: #555;
                            color: #fff;
                            text-align: center;
                            padding: 5px 0;
                            border-radius: 6px;
                            z-index: 1;
                            opacity: 0;
                            transition: opacity 1s;
                         }

                        .tooltip:hover .tooltiptext {
                            visibility: visible;
                            opacity: 1;
                        }

                        .tooltip-bottom {
                            top: 135%;
                            left: 50%;
                            margin-left: -60px;
                        }
                        .tooltip-bottom:after {
                            content: "";
                            position: absolute;
                            bottom: 100%;
                            left: 50%;
                            margin-left: -5px;
                            border-width: 5px;
                            border-style: solid;
                            border-color: transparent transparent #555 transparent;
                            display:block;
                        }
                    </style></head>
                    <body><div id="text">' +
                    flick.nl2br(flick.createHighlightedString(ranges, filetxt)) +
                    '</div></body>
                </html>
            '
            textFormat: TextEdit.RichText
            readOnly: true
            selectByMouse: true
            focus: true
            wrapMode: TextEdit.Wrap
            // onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
            textMargin: 20

            //myTextEdit.text.toString().substring(myTextEdit.selectionStart,
            //        myTextEdit.selectionEnd);
        }
    }
}
