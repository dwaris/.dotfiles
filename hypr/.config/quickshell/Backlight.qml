import QtQuick
import Quickshell
import Quickshell.Io
import "."

BarItem {
    id: root
    isSquare: true

    visible: false
    text: ""
    tooltipText: "Brightness"

    readonly property var icons: [
        "", "", "", "", "", "", "", "", ""
    ]

    function updateBacklight() {
        brightProc.running = true;
    }

    property int lastBrightness: -1

    Process {
        id: brightProc
        command: ["sh", "-c", "brightnessctl -m 2>/dev/null | grep ',backlight,' || true"]
        stdout: StdioCollector {
            onTextChanged: {
                var line = text.trim();
                if (!line) {
                    root.visible = false;
                    return;
                }
                var cols = line.split(",");
                if (cols.length >= 4) {
                    root.visible = true;
                    var percentStr = cols[3].replace("%", "");
                    var percent = parseInt(percentStr, 10) || 100;
                    var iconIdx = Math.min(root.icons.length - 1, Math.max(0, Math.floor(percent / (100 / root.icons.length))));
                    root.text = root.icons[iconIdx];
                    root.tooltipText = "Brightness: " + percent + "%";

                    if (root.lastBrightness >= 0 && root.lastBrightness !== percent) {
                        if (typeof globalOsd !== "undefined" && globalOsd) {
                            globalOsd.showBrightness(percent);
                        }
                    }
                    root.lastBrightness = percent;
                } else {
                    root.visible = false;
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.updateBacklight()
    }

    Component.onCompleted: root.updateBacklight()

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            Quickshell.execDetached(["sh", "-c", "((( $(brightnessctl g) == $(brightnessctl m) )) && brightnessctl s '0') || (brightnessctl s '+10%')"]);
            brightTimer.restart();
        }
    }

    onWheel: wheel => {
        if (wheel.angleDelta.y > 0) {
            Quickshell.execDetached(["brightnessctl", "s", "+10%"]);
        } else if (wheel.angleDelta.y < 0) {
            Quickshell.execDetached(["brightnessctl", "s", "10%-"]);
        }
        brightTimer.restart();
    }

    Timer {
        id: brightTimer
        interval: 100
        onTriggered: root.updateBacklight()
    }
}
