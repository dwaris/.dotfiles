import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "."

Scope {
    id: root

    property string osdType: "volume" // "volume", "mic", "brightness"
    property real osdValue: 0.0
    property bool osdMuted: false
    property string osdIcon: ""
    property string osdText: ""
    property bool active: false
    property bool initialized: true

    Timer {
        id: hideTimer
        interval: 1600
        onTriggered: root.active = false
    }

    function triggerOsd() {
        root.active = true;
        hideTimer.restart();
    }

    function showVolume(volPercent, isMuted) {
        root.osdType = "volume";
        root.osdValue = Math.min(100, Math.max(0, volPercent));
        root.osdMuted = isMuted;

        if (isMuted) {
            root.osdIcon = "";
            root.osdText = "Muted";
        } else {
            if (volPercent < 30) root.osdIcon = "";
            else if (volPercent < 70) root.osdIcon = "";
            else root.osdIcon = "";
            root.osdText = Math.round(volPercent) + "%";
        }
        triggerOsd();
    }

    function showMic(isMuted) {
        root.osdType = "mic";
        root.osdMuted = isMuted;
        root.osdValue = isMuted ? 0 : 100;
        root.osdIcon = isMuted ? "" : "";
        root.osdText = isMuted ? "Mic Muted" : "Mic Active";
        triggerOsd();
    }

    function showBrightness(percent) {
        root.osdType = "brightness";
        root.osdMuted = false;
        root.osdValue = Math.min(100, Math.max(0, percent));
        var icons = ["", "", "", "", "", "", "", "", ""];
        var idx = Math.min(icons.length - 1, Math.max(0, Math.floor(percent / (100 / icons.length))));
        root.osdIcon = icons[idx];
        root.osdText = Math.round(percent) + "%";
        triggerOsd();
    }

    function syncVolume() {
        volProc.running = true;
    }

    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onTextChanged: {
                var out = text.trim();
                if (!out) return;
                var isMuted = (out.indexOf("MUTED") !== -1);
                var match = out.match(/Volume:\s+([0-9.]+)/);
                var vol = match ? parseFloat(match[1]) : 1.0;
                root.showVolume(Math.round(vol * 100), isMuted);
            }
        }
    }

    function syncMic() {
        micProc.running = true;
    }

    Process {
        id: micProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SOURCE@"]
        stdout: StdioCollector {
            onTextChanged: {
                var out = text.trim();
                if (!out) return;
                var isMuted = (out.indexOf("MUTED") !== -1);
                root.showMic(isMuted);
            }
        }
    }

    IpcHandler {
        target: "osd"

        function volume(val: string, muted: string) {
            root.showVolume(parseFloat(val) || 0, muted === "true" || muted === "1");
        }

        function volumeSync() {
            root.syncVolume();
        }

        function mic(muted: string) {
            root.showMic(muted === "true" || muted === "1");
        }

        function micSync() {
            root.syncMic();
        }

        function brightness(val: string) {
            root.showBrightness(parseFloat(val) || 0);
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                id: osdWindow
                required property var modelData

                screen: modelData
                visible: root.active || osdCard.opacity > 0.01

                anchors {
                    bottom: true
                }

                margins {
                    bottom: 80
                }

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
                WlrLayershell.namespace: "osd"
                exclusionMode: ExclusionMode.Ignore
                mask: Region {}

                color: "transparent"
                implicitWidth: 260
                implicitHeight: 46

                Rectangle {
                    id: osdCard
                    anchors.fill: parent
                    radius: Theme.radiusLarge
                    color: Theme.base
                    border.color: Theme.surface1
                    border.width: 1

                    opacity: root.active ? 1.0 : 0.0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }

                    Row {
                        anchors.centerIn: parent
                        spacing: 14

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 26
                            text: root.osdIcon
                            color: root.osdMuted ? Theme.red : (root.osdType === "brightness" ? Theme.yellow : Theme.mauve)
                            font.family: Theme.fontFamily
                            font.pixelSize: 20
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        // Progress Bar (only for volume and brightness)
                        Item {
                            anchors.verticalCenter: parent.verticalCenter
                            width: (root.osdType === "mic") ? 0 : 130
                            height: 8
                            visible: root.osdType !== "mic"

                            Rectangle {
                                anchors.fill: parent
                                radius: Theme.radiusSmall
                                color: Theme.surface0

                                Rectangle {
                                    id: fillBar
                                    height: parent.height
                                    width: parent.width * (root.osdMuted ? 0 : (root.osdValue / 100.0))
                                    radius: Theme.radiusSmall
                                    color: root.osdMuted ? Theme.surface2 : (root.osdType === "brightness" ? Theme.yellow : Theme.mauve)

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 120
                                            easing.type: Easing.OutQuad
                                        }
                                    }
                                }
                            }
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            width: (root.osdType === "mic") ? 82 : 44
                            text: root.osdText
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pixelSize: 13
                            font.weight: Theme.fontWeight
                            horizontalAlignment: (root.osdType === "mic") ? Text.AlignHCenter : Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}
