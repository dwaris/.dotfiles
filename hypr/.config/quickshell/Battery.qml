import QtQuick
import Quickshell
import Quickshell.Io
import "."

BarItem {
    id: root

    minWidth: 54
    visible: false
    text: "100% 󰂅"
    textColor: Theme.text

    readonly property var chargingIcons: [
        "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"
    ]

    readonly property var defaultIcons: [
        "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"
    ]

    function checkBattery() {
        batProc.running = true;
    }

    Process {
        id: batProc
        command: ["sh", "-c", "bat=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1); if [ -n \"$bat\" ]; then cat \"$bat/capacity\" 2>/dev/null && echo '---' && cat \"$bat/status\" 2>/dev/null && echo '---' && (cat \"$bat/power_now\" 2>/dev/null || cat \"$bat/current_now\" 2>/dev/null || echo '0'); fi"]
        stdout: StdioCollector {
            onTextChanged: {
                var out = text.trim();
                if (!out) {
                    root.visible = false;
                    return;
                }
                var parts = out.split("---");
                if (parts.length < 2) {
                    root.visible = false;
                    return;
                }
                root.visible = true;
                var cap = parseInt(parts[0].trim(), 10) || 100;
                var status = parts[1].trim().toLowerCase();
                var powerRaw = parts.length > 2 ? (parseInt(parts[2].trim(), 10) || 0) : 0;
                var watts = (powerRaw / 1000000).toFixed(1);

                var idx = Math.min(9, Math.max(0, Math.floor(cap / 10)));
                var icon = "";

                if (status === "charging") {
                    icon = root.chargingIcons[idx];
                    root.textColor = Theme.green;
                    root.tooltipText = watts + "W↑ " + cap + "%";
                } else if (status === "full") {
                    icon = "󰂅";
                    root.textColor = Theme.green;
                    root.tooltipText = "Full (" + cap + "%)";
                } else {
                    icon = root.defaultIcons[idx];
                    if (cap <= 20) {
                        root.textColor = Theme.red;
                    } else {
                        root.textColor = Theme.text;
                    }
                    root.tooltipText = watts + "W↓ " + cap + "%";
                }

                root.text = cap + "% " + icon;
            }
        }
    }

    Timer {
        interval: 15000
        running: true
        repeat: true
        onTriggered: root.checkBattery()
    }

    Component.onCompleted: root.checkBattery()
}
