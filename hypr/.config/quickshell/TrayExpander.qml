import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "."

Item {
    id: root

    property bool pinned: false
    property bool hovered: false
    property bool anyMenuOpen: false

    readonly property bool isExpanded: root.pinned || root.hovered || root.anyMenuOpen

    implicitHeight: 30
    implicitWidth: expandIcon.implicitWidth + trayContainer.width
    width: implicitWidth
    height: implicitHeight

    Timer {
        id: collapseTimer
        interval: 350
        repeat: false
        onTriggered: {
            if (!hoverHandler.hovered && !root.anyMenuOpen) {
                root.hovered = false;
            }
        }
    }

    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (hovered) {
                collapseTimer.stop();
                root.hovered = true;
            } else {
                collapseTimer.restart();
            }
        }
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        BarItem {
            id: expandIcon
            isSquare: true
            text: root.isExpanded ? "" : ""
            tooltipText: root.pinned ? "Unpin Tray" : "System Tray"
            clickable: true

            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    root.pinned = !root.pinned;
                }
            }
        }

        Item {
            id: trayContainer
            clip: true
            height: 30
            width: root.isExpanded ? trayRow.implicitWidth : 0

            Behavior on width {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            Row {
                id: trayRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4
                leftPadding: 2
                rightPadding: 4

                Repeater {
                    model: SystemTray.items

                    delegate: Item {
                        id: trayItem
                        required property var modelData

                        width: 26
                        height: 26

                        Rectangle {
                            id: trayItemBg
                            anchors.fill: parent
                            radius: Theme.radiusSmall
                            color: trayMouse.containsMouse ? Theme.surface1 : "transparent"

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }

                        IconImage {
                            id: iconImg
                            anchors.centerIn: parent
                            implicitSize: 16
                            source: trayItem.modelData ? (trayItem.modelData.icon || "") : ""
                        }

                        QsMenuAnchor {
                            id: menuAnchor
                            menu: trayItem.modelData ? trayItem.modelData.menu : null
                            anchor.item: trayItem
                            anchor.edges: Edges.Bottom
                            anchor.gravity: Edges.Bottom

                            onOpened: {
                                root.anyMenuOpen = true;
                            }

                            onClosed: {
                                root.anyMenuOpen = false;
                                if (!hoverHandler.hovered) {
                                    collapseTimer.restart();
                                }
                            }
                        }

                        MouseArea {
                            id: trayMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                            onClicked: mouse => {
                                if (!trayItem.modelData) return;
                                if (mouse.button === Qt.LeftButton) {
                                    trayItem.modelData.activate();
                                } else if (mouse.button === Qt.MiddleButton) {
                                    trayItem.modelData.secondaryActivate();
                                } else if (mouse.button === Qt.RightButton) {
                                    if (trayItem.modelData.hasMenu && menuAnchor.menu) {
                                        menuAnchor.open();
                                    } else {
                                        trayItem.modelData.activate();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
