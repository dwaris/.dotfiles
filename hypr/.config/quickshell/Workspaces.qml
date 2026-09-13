import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "."

Row {
    id: root

    required property var screen

    property var workspacesList: []
    property var monitorsList: []
    property int activeWorkspaceId: 1

    spacing: 0

    function updateState() {
        queryProc.running = true;
    }

    function focusWorkspace(id) {
        Hyprland.dispatch("hl.dsp.focus({ workspace = \"" + id + "\" })");
        root.activeWorkspaceId = id;
        root.updateState();
    }

    function scrollWorkspace(delta) {
        var target = delta > 0 ? "e+1" : "e-1";
        Hyprland.dispatch("hl.dsp.focus({ workspace = \"" + target + "\" })");
        root.updateState();
    }

    Process {
        id: queryProc
        command: ["sh", "-c", "hyprctl -j workspaces && echo '===SEP===' && hyprctl -j monitors"]
        stdout: StdioCollector {
            onTextChanged: {
                if (!text || text.indexOf("===SEP===") === -1) return;
                var parts = text.split("===SEP===");
                try {
                    var ws = JSON.parse(parts[0].trim());
                    var mons = JSON.parse(parts[1].trim());
                    root.workspacesList = ws;
                    root.monitorsList = mons;

                    if (root.screen) {
                        for (var i = 0; i < mons.length; i++) {
                            if (mons[i].name === root.screen.name) {
                                if (mons[i].activeWorkspace) {
                                    root.activeWorkspaceId = mons[i].activeWorkspace.id;
                                }
                                break;
                            }
                        }
                    }
                } catch(e) {}
            }
        }
    }

    Socket {
        path: Hyprland.eventSocketPath
        connected: true
        parser: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                root.updateState();
            }
        }
    }

    Component.onCompleted: {
        root.updateState();
    }

    // Always include persistent workspaces 1..5 plus any extra workspaces active or on this screen
    readonly property var visibleWorkspaces: {
        var list = [1, 2, 3, 4, 5];
        var screenName = root.screen ? root.screen.name : "";

        for (var k = 0; k < root.workspacesList.length; k++) {
            var ws = root.workspacesList[k];
            if (ws.id > 5 && list.indexOf(ws.id) === -1) {
                if (!ws.monitor || ws.monitor === screenName) {
                    list.push(ws.id);
                }
            }
        }

        if (root.activeWorkspaceId > 5 && list.indexOf(root.activeWorkspaceId) === -1) {
            list.push(root.activeWorkspaceId);
        }

        list.sort((a, b) => a - b);
        return list;
    }

    Repeater {
        model: root.visibleWorkspaces

        delegate: Item {
            id: wsBtn
            required property int modelData

            readonly property int wsId: modelData
            readonly property bool isActive: root.activeWorkspaceId === wsId
            readonly property bool isVisibleOnOtherMonitor: {
                var screenName = root.screen ? root.screen.name : "";
                for (var m = 0; m < root.monitorsList.length; m++) {
                    var mon = root.monitorsList[m];
                    if (mon.name !== screenName && mon.activeWorkspace && mon.activeWorkspace.id === wsId) {
                        return true;
                    }
                }
                return false;
            }
            readonly property var wsInfo: {
                for (var i = 0; i < root.workspacesList.length; i++) {
                    if (root.workspacesList[i].id === wsId) {
                        return root.workspacesList[i];
                    }
                }
                return null;
            }
            readonly property bool hasWindows: wsInfo ? (wsInfo.windows > 0) : false
            readonly property bool isEmpty: !isActive && !hasWindows && !isVisibleOnOtherMonitor

            width: 30
            height: 30

            Rectangle {
                id: btnBg
                anchors.centerIn: parent
                width: 26
                height: 26
                radius: Theme.radiusSmall
                color: btnMouse.containsMouse ? Theme.surface1 : "transparent"
                opacity: (btnMouse.containsMouse || !wsBtn.isEmpty) ? 1.0 : 0.5

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }

                Text {
                    id: wsLabel
                    anchors.centerIn: parent
                    text: wsBtn.isActive ? "󱓻" : wsBtn.wsId.toString()
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.weight: Theme.fontWeight
                }
            }

            MouseArea {
                id: btnMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton

                onClicked: {
                    root.focusWorkspace(wsBtn.wsId);
                }

                onWheel: wheel => {
                    root.scrollWorkspace(wheel.angleDelta.y);
                }
            }
        }
    }
}
