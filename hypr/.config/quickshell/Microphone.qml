import QtQuick
import Quickshell
import Quickshell.Io
import "."

BarItem {
    id: root
    isSquare: true

    text: ""
    textColor: Theme.text
    tooltipText: "Microphone Active"

    function updateMic() {
        micProc.running = true;
    }

    property int lastMuted: -1

    Process {
        id: micProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SOURCE@"]
        stdout: StdioCollector {
            onTextChanged: {
                var out = text.trim();
                if (!out) return;
                var isMuted = (out.indexOf("MUTED") !== -1);
                var match = out.match(/Volume:\s+([0-9.]+)/);
                var vol = match ? parseFloat(match[1]) : 1.0;
                var volPercent = Math.round(vol * 100);

                if (isMuted) {
                    root.text = "";
                    root.textColor = Theme.red;
                    root.tooltipText = "Microphone Muted";
                } else {
                    root.text = "";
                    root.textColor = Theme.text;
                    root.tooltipText = "Microphone Active (" + volPercent + "%)";
                }

                if (root.lastMuted >= 0 && root.lastMuted !== (isMuted ? 1 : 0)) {
                    if (typeof globalOsd !== "undefined" && globalOsd) {
                        globalOsd.showMic(isMuted);
                    }
                }
                root.lastMuted = isMuted ? 1 : 0;
            }
        }
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: root.updateMic()
    }

    Component.onCompleted: root.updateMic()

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"]);
            updateTimer.restart();
        }
    }

    onWheel: wheel => {
        if (wheel.angleDelta.y > 0) {
            Quickshell.execDetached(["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SOURCE@", "5%+"]);
        } else if (wheel.angleDelta.y < 0) {
            Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", "5%-"]);
        }
        updateTimer.restart();
    }

    Timer {
        id: updateTimer
        interval: 100
        onTriggered: root.updateMic()
    }
}
