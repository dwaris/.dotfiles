import QtQuick
import Quickshell
import "."

Item {
    id: root

    property bool showAltClock: false
    readonly property bool dndActive: (typeof shellRoot !== "undefined" && shellRoot) ? shellRoot.dndEnabled : false
    readonly property bool idleActive: (typeof shellRoot !== "undefined" && shellRoot) ? shellRoot.idleInhibited : false

    property bool hovered: false
    readonly property bool isHovered: root.hovered || clockItem.containsMouse || dndItem.containsMouse || idleItem.containsMouse || drawerMouseArea.containsMouse

    implicitHeight: 30
    implicitWidth: clockItem.implicitWidth

    // Clock update timer
    property var currentTime: new Date()
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            root.currentTime = new Date();
        }
    }

    Timer {
        id: collapseTimer
        interval: 300
        repeat: false
        onTriggered: {
            root.hovered = false;
        }
    }

    function onHoverEnter() {
        collapseTimer.stop();
        root.hovered = true;
    }

    function onHoverExit() {
        collapseTimer.restart();
    }

    MouseArea {
        id: drawerMouseArea
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: clockItem.implicitWidth + drawerContainer.width
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        onContainsMouseChanged: {
            if (containsMouse) onHoverEnter(); else onHoverExit();
        }
    }

    Row {
        id: groupRow
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        spacing: 0

        BarItem {
            id: clockItem
            text: root.showAltClock
                  ? Qt.formatDateTime(root.currentTime, "dddd dd MMMM yyyy")
                  : Qt.formatDateTime(root.currentTime, "dd/MM - hh:mm")

            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    root.showAltClock = !root.showAltClock;
                }
            }

            onContainsMouseChanged: {
                if (containsMouse) onHoverEnter(); else onHoverExit();
            }
        }

        Item {
            id: drawerContainer
            clip: true
            height: 30
            width: root.isHovered ? drawerContent.implicitWidth : 0

            Behavior on width {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            Row {
                id: drawerContent
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0

                BarItem {
                    id: dndItem
                    isSquare: true
                    text: root.dndActive ? "" : ""
                    textColor: root.dndActive ? Theme.peach : Theme.text
                    tooltipText: root.dndActive ? "Do Not Disturb (Active)" : "Do Not Disturb (Off)"

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            if (typeof shellRoot !== "undefined" && shellRoot) {
                                shellRoot.dndEnabled = !shellRoot.dndEnabled;
                            }
                        }
                    }

                    onContainsMouseChanged: {
                        if (containsMouse) onHoverEnter(); else onHoverExit();
                    }
                }

                BarItem {
                    id: idleItem
                    isSquare: true
                    text: root.idleActive ? "" : ""
                    textColor: root.idleActive ? Theme.green : Theme.text
                    tooltipText: root.idleActive ? "Keep Awake (Active)" : "Keep Awake (Off)"

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            if (typeof shellRoot !== "undefined" && shellRoot) {
                                shellRoot.idleInhibited = !shellRoot.idleInhibited;
                            }
                        }
                    }

                    onContainsMouseChanged: {
                        if (containsMouse) onHoverEnter(); else onHoverExit();
                    }
                }
            }
        }
    }
}
