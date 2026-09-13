//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "."

ShellRoot {
    id: shellRoot

    property bool barVisible: true
    property bool idleInhibited: false
    property bool dndEnabled: false

    // Sync idle inhibitor with systemd-inhibit
    onIdleInhibitedChanged: {
        if (idleInhibited) {
            Quickshell.execDetached(["sh", "-c", "nohup systemd-inhibit --what=idle:sleep:handle-lid-switch --why='Quickshell keep-awake' --mode=block sleep infinity >/dev/null 2>&1 &"]);
        } else {
            Quickshell.execDetached(["sh", "-c", "pkill -f 'systemd-inhibit.*Quickshell keep-awake' || true"]);
        }
    }

    // Process to check initial idle inhibitor state
    Process {
        id: initIdleCheck
        command: ["sh", "-c", "systemd-inhibit --list | grep -q 'Quickshell keep-awake' && echo 'active' || echo 'inactive'"]
        stdout: StdioCollector {
            onTextChanged: {
                if (text.trim() === "active") {
                    shellRoot.idleInhibited = true;
                }
            }
        }
    }

    Component.onCompleted: {
        initIdleCheck.running = true;
    }

    IpcHandler {
        target: "bar"

        function toggle() {
            shellRoot.barVisible = !shellRoot.barVisible;
        }

        function show() {
            shellRoot.barVisible = true;
        }

        function hide() {
            shellRoot.barVisible = false;
        }

        function toggleIdle() {
            shellRoot.idleInhibited = !shellRoot.idleInhibited;
        }

        function toggleDnd() {
            shellRoot.dndEnabled = !shellRoot.dndEnabled;
        }
    }

    // Global Services: On-Screen Display & Notifications
    Osd {
        id: globalOsd
    }

    Notifications {
        id: globalNotifications
    }

    // Top Bar (Instantiated on all connected monitors)
    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                id: barWindow
                required property var modelData

                screen: modelData
                visible: shellRoot.barVisible

                anchors {
                    top: true
                    left: true
                    right: true
                }

                margins {
                    top: 8
                    left: 8
                    right: 8
                }

                WlrLayershell.layer: WlrLayer.Top
                WlrLayershell.namespace: "quickshell"

                color: "transparent"
                implicitHeight: 34

                // Native Wayland Idle Inhibitor protocol
                IdleInhibitor {
                    window: barWindow
                    enabled: shellRoot.idleInhibited
                }

                Rectangle {
                    id: barContainer
                    anchors.fill: parent
                    color: Theme.base
                    radius: Theme.radiusLarge

                    // Left Section: Launcher & Workspaces
                    Row {
                        id: leftSection
                        anchors.left: parent.left
                        anchors.leftMargin: 4
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Launcher {}
                        Workspaces {
                            screen: barWindow.screen
                        }
                    }

                    // Center Section: Clock Drawer (with DND & Idle Inhibitor)
                    ClockDrawer {
                        id: centerSection
                        anchors.centerIn: parent
                    }

                    // Right Section: Tray, Network, VPN, Bluetooth, Audio, Power
                    Row {
                        id: rightSection
                        anchors.right: parent.right
                        anchors.rightMargin: 4
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        TrayExpander {}
                        Network {}
                        Vpn {}
                        Bluetooth {}
                        Volume {}
                        Microphone {}
                        Backlight {}
                        PowerProfile {}
                        Battery {}
                        PowerMenu {}
                    }
                }
            }
        }
    }
}
