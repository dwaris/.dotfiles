import QtQuick
import Quickshell
import Quickshell.Io
import "."

BarItem {
    id: root
    isSquare: true

    visible: true
    text: ""
    textColor: Theme.text
    tooltipText: "Power Profile: Balanced"

    property string currentProfile: "balanced"

    function checkProfile() {
        ppProc.running = true;
    }

    Process {
        id: ppProc
        command: ["sh", "-c", "busctl get-property net.hadess.PowerProfiles /net/hadess/PowerProfiles net.hadess.PowerProfiles ActiveProfile 2>/dev/null | awk '{print $2}' | tr -d '\"' || (command -v powerprofilesctl >/dev/null 2>&1 && powerprofilesctl get) || true"]
        stdout: StdioCollector {
            onTextChanged: {
                var p = text.trim();
                if (!p) {
                    return;
                }
                root.visible = true;
                root.currentProfile = p;
                if (p === "performance") {
                    root.text = "";
                    root.textColor = Theme.red;
                    root.tooltipText = "Power Profile: Performance";
                } else if (p === "power-saver") {
                    root.text = "";
                    root.textColor = Theme.green;
                    root.tooltipText = "Power Profile: Power Saver";
                } else {
                    root.text = "";
                    root.textColor = Theme.text;
                    root.tooltipText = "Power Profile: Balanced";
                }
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: root.checkProfile()
    }

    Component.onCompleted: root.checkProfile()

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            var next = "balanced";
            if (root.currentProfile === "balanced") {
                next = "performance";
            } else if (root.currentProfile === "performance") {
                next = "power-saver";
            } else {
                next = "balanced";
            }
            Quickshell.execDetached(["sh", "-c", "busctl set-property net.hadess.PowerProfiles /net/hadess/PowerProfiles net.hadess.PowerProfiles ActiveProfile s '" + next + "' || (command -v powerprofilesctl >/dev/null 2>&1 && powerprofilesctl set " + next + ")"]);
            root.currentProfile = next;
            ppTimer.restart();
        }
    }

    Timer {
        id: ppTimer
        interval: 200
        onTriggered: root.checkProfile()
    }
}
