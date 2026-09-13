import QtQuick
import Quickshell
import Quickshell.Io
import "."

BarItem {
    id: root
    isSquare: true

    text: ""
    textColor: Theme.text

    function updateVolume() {
        volProc.running = true;
    }

    property int lastVol: -1
    property int lastMuted: -1

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
                var volPercent = Math.round(vol * 100);

                if (isMuted) {
                    root.text = "";
                    root.textColor = Theme.red;
                    root.tooltipText = "Sink Muted (" + volPercent + "%)";
                } else {
                    var icon = "";
                    if (volPercent < 30) {
                        icon = "";
                    } else if (volPercent < 70) {
                        icon = "";
                    }
                    root.text = icon;
                    root.textColor = Theme.text;
                    root.tooltipText = "Volume: " + volPercent + "%";
                }

                if (root.lastVol >= 0 && (root.lastVol !== volPercent || root.lastMuted !== (isMuted ? 1 : 0))) {
                    if (typeof globalOsd !== "undefined" && globalOsd) {
                        globalOsd.showVolume(volPercent, isMuted);
                    }
                }
                root.lastVol = volPercent;
                root.lastMuted = isMuted ? 1 : 0;
            }
        }
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: root.updateVolume()
    }

    Component.onCompleted: root.updateVolume()

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
            updateTimer.restart();
        } else if (mouse.button === Qt.MiddleButton) {
            Quickshell.execDetached(["ghostty", "-e", "wiremix"]);
        }
    }

    onWheel: wheel => {
        if (wheel.angleDelta.y > 0) {
            Quickshell.execDetached(["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "5%+"]);
        } else if (wheel.angleDelta.y < 0) {
            Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]);
        }
        updateTimer.restart();
    }

    Timer {
        id: updateTimer
        interval: 100
        onTriggered: root.updateVolume()
    }
}
