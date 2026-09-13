import QtQuick
import Quickshell
import "."

Item {
    id: root

    property string text: ""
    property color textColor: Theme.text
    property color hoverColor: Theme.surface1
    property string tooltipText: ""
    property real customOpacity: 1.0
    property bool clickable: true
    property bool isSquare: false
    property real fixedWidth: 0
    property real minWidth: 0
    property alias containsMouse: mouseArea.containsMouse

    signal clicked(var mouse)
    signal wheel(var wheel)

    implicitWidth: bg.width + 4
    implicitHeight: 30

    Rectangle {
        id: bg
        anchors.centerIn: parent
        width: root.isSquare ? 26
               : (root.fixedWidth > 0 ? root.fixedWidth
               : Math.max(root.minWidth, label.implicitWidth + 16))
        height: 26
        radius: 8
        color: (mouseArea.containsMouse && root.clickable) ? root.hoverColor : "transparent"
        opacity: root.customOpacity

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        Text {
            id: label
            anchors.centerIn: parent
            text: root.text
            color: root.textColor
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.weight: Theme.fontWeight

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

        onClicked: mouse => {
            if (root.clickable) {
                root.clicked(mouse);
            }
        }

        onWheel: wheel => {
            root.wheel(wheel);
        }
    }

    Timer {
        id: tipTimer
        interval: 350
        running: mouseArea.containsMouse && root.tooltipText !== ""
        repeat: false
    }

    PopupWindow {
        id: tooltipPopup
        visible: tipTimer.running === false && mouseArea.containsMouse && root.tooltipText !== ""
        anchor.item: root
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        color: "transparent"

        implicitWidth: tipBox.width
        implicitHeight: tipBox.height

        Rectangle {
            id: tipBox
            width: tipText.implicitWidth + 16
            height: tipText.implicitHeight + 10
            color: Theme.base
            border.color: Theme.mauve
            border.width: 1
            radius: 8

            Text {
                id: tipText
                anchors.centerIn: parent
                text: root.tooltipText
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: 12
                font.weight: Theme.fontWeight
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
