import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Notifications
import Quickshell.Io
import "."

Scope {
    id: root

    readonly property bool dndActive: (typeof shellRoot !== "undefined" && shellRoot) ? shellRoot.dndEnabled : false

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true

        onNotification: notif => {
            // When DND is enabled, suppress all non-critical notifications
            if (root.dndActive && notif.urgency !== NotificationUrgency.Critical) {
                notif.dismiss();
                return;
            }
            notif.tracked = true;
        }
    }

    IpcHandler {
        target: "notif"

        function dismissLast() {
            var list = server.trackedNotifications.values;
            if (list.length > 0) {
                list[list.length - 1].dismiss();
            }
        }

        function dismissAll() {
            var list = server.trackedNotifications.values;
            for (var i = list.length - 1; i >= 0; i--) {
                list[i].dismiss();
            }
        }

        function toggleDnd() {
            if (typeof shellRoot !== "undefined" && shellRoot) {
                shellRoot.dndEnabled = !shellRoot.dndEnabled;
            }
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                id: notifWindow
                required property var modelData

                screen: modelData
                visible: server.trackedNotifications.values.length > 0

                anchors {
                    top: true
                    right: true
                }

                margins {
                    top: 50
                    right: 12
                }

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "notifications"
                exclusionMode: ExclusionMode.Ignore

                color: "transparent"
                implicitWidth: 360
                implicitHeight: notifColumn.implicitHeight

                Column {
                    id: notifColumn
                    spacing: 8
                    width: 360

                    Repeater {
                        model: server.trackedNotifications.values

                        delegate: Rectangle {
                            id: notifCard
                            required property var modelData
                            property var notif: modelData

                            width: 360
                            implicitHeight: cardContent.implicitHeight + 20
                            radius: Theme.radiusLarge
                            color: Theme.base
                            border.color: notif.urgency === NotificationUrgency.Critical
                                          ? Theme.red
                                          : (notif.urgency === NotificationUrgency.Low ? Theme.surface0 : Theme.surface1)
                            border.width: 1

                            // Auto-expire timer
                            Timer {
                                interval: notif.expireTimeout > 0 ? notif.expireTimeout : 6000
                                running: notif.urgency !== NotificationUrgency.Critical
                                repeat: false
                                onTriggered: notif.dismiss()
                            }

                            Column {
                                id: cardContent
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.margins: 12
                                spacing: 8

                                // App Header
                                Row {
                                    width: parent.width
                                    spacing: 8

                                    IconImage {
                                        anchors.verticalCenter: parent.verticalCenter
                                        implicitSize: 16
                                        source: notif.appIcon || ""
                                        visible: notif.appIcon !== ""
                                    }

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: notif.appName || "Notification"
                                        color: Theme.mauve
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 11
                                        font.weight: Theme.fontWeight
                                        elide: Text.ElideRight
                                        width: parent.width - 48
                                    }

                                    Item {
                                        width: 1
                                        height: 1
                                    }

                                    // Close button
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "✕"
                                        color: closeMouse.containsMouse ? Theme.red : Theme.subtext0
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 12
                                        font.weight: Theme.fontWeight

                                        MouseArea {
                                            id: closeMouse
                                            anchors.fill: parent
                                            anchors.margins: -4
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: notif.dismiss()
                                        }
                                    }
                                }

                                // Main Content (Image + Texts)
                                Row {
                                    width: parent.width
                                    spacing: 12

                                    Image {
                                        width: 44
                                        height: 44
                                        source: notif.image || ""
                                        visible: notif.image !== ""
                                        fillMode: Image.PreserveAspectCrop
                                        layer.enabled: true
                                    }

                                    Column {
                                        width: notif.image !== "" ? parent.width - 56 : parent.width
                                        spacing: 4

                                        Text {
                                            width: parent.width
                                            text: notif.summary
                                            color: Theme.text
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 13
                                            font.weight: Font.Bold
                                            wrapMode: Text.Wrap
                                            maximumLineCount: 2
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            width: parent.width
                                            text: notif.body
                                            color: Theme.subtext1
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 12
                                            wrapMode: Text.Wrap
                                            textFormat: Text.StyledText
                                            maximumLineCount: 4
                                            elide: Text.ElideRight
                                            visible: notif.body !== ""
                                        }
                                    }
                                }

                                // Action Buttons
                                Flow {
                                    width: parent.width
                                    spacing: 6
                                    visible: notif.actions && notif.actions.length > 0

                                    Repeater {
                                        model: notif.actions

                                        delegate: Rectangle {
                                            id: actionBtn
                                            required property var modelData
                                            property var action: modelData

                                            width: btnLabel.implicitWidth + 16
                                            height: 26
                                            radius: Theme.radiusSmall
                                            color: btnMouse.containsMouse ? Theme.surface1 : Theme.surface0

                                            Behavior on color {
                                                ColorAnimation { duration: 150 }
                                            }

                                            Text {
                                                id: btnLabel
                                                anchors.centerIn: parent
                                                text: action.text
                                                color: Theme.text
                                                font.family: Theme.fontFamily
                                                font.pixelSize: 11
                                                font.weight: Theme.fontWeight
                                            }

                                            MouseArea {
                                                id: btnMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    action.invoke();
                                                    notif.dismiss();
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            // Click card to dismiss or trigger default action
                            MouseArea {
                                anchors.fill: parent
                                z: -1
                                onClicked: {
                                    if (notif.actions) {
                                        for (var i = 0; i < notif.actions.length; i++) {
                                            if (notif.actions[i].identifier === "default") {
                                                notif.actions[i].invoke();
                                                break;
                                            }
                                        }
                                    }
                                    notif.dismiss();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
