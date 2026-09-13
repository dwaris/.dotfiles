import QtQuick
import Quickshell
import Quickshell.Io
import "."

BarItem {
    id: root
    isSquare: true

    text: "󰀂"
    tooltipText: "Connected"

    function updateNetwork() {
        netProc.running = true;
    }

    Process {
        id: netProc
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE,CONNECTION,DEVICE dev && echo '===IP===' && (ip route get 1.1.1.1 2>/dev/null | awk '{print $7}') && echo '===WIFI===' && (nmcli -t -f IN-USE,SIGNAL,SSID dev wifi 2>/dev/null | grep '^\\*')"]
        stdout: StdioCollector {
            onTextChanged: {
                if (!text || text.indexOf("===IP===") === -1) return;
                var parts = text.split("===IP===");
                var devLines = parts[0].trim().split("\n");
                var rest = parts[1].split("===WIFI===");
                var ip = rest[0].trim();
                var wifiLine = rest.length > 1 ? rest[1].trim() : "";

                var isEthernet = false;
                var isWifi = false;
                var ethName = "";
                var wifiSsid = "";
                var wifiSignal = 0;

                for (var i = 0; i < devLines.length; i++) {
                    var cols = devLines[i].split(":");
                    if (cols.length >= 2) {
                        var type = cols[0];
                        var state = cols[1];
                        if (type === "ethernet" && state === "connected") {
                            isEthernet = true;
                            ethName = cols[2] || cols[3] || "Ethernet";
                            break;
                        } else if (type === "wifi" && state === "connected") {
                            isWifi = true;
                        }
                    }
                }

                if (isEthernet) {
                    root.text = "󰀂";
                    root.tooltipText = (ip ? ip + "\n" : "") + ethName;
                } else if (isWifi) {
                    if (wifiLine.startsWith("*")) {
                        var wCols = wifiLine.split(":");
                        wifiSignal = parseInt(wCols[1], 10) || 50;
                        wifiSsid = wCols[2] || "Wi-Fi";
                    }
                    var wifiIcons = ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"];
                    var idx = Math.min(4, Math.max(0, Math.floor(wifiSignal / 25)));
                    root.text = wifiIcons[idx];
                    root.tooltipText = (ip ? ip + "\n" : "") + wifiSsid + " (" + wifiSignal + "%)";
                } else {
                    root.text = "󰤮";
                    root.tooltipText = "Disconnected";
                }
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: root.updateNetwork()
    }

    Component.onCompleted: root.updateNetwork()

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            Quickshell.execDetached(["uwsm-app", "--", "ghostty", "-e", "nmtui"]);
        }
    }
}
