import QtQuick
import Quickshell
import Quickshell.Io
import "."

BarItem {
    id: root
    isSquare: true

    text: ""
    tooltipText: "Bluetooth"

    function checkBt() {
        btProc.running = true;
    }

    Process {
        id: btProc
        command: ["sh", "-c", "bluetoothctl show 2>/dev/null && echo '===CONN===' && bluetoothctl devices Connected 2>/dev/null"]
        stdout: StdioCollector {
            onTextChanged: {
                if (!text) {
                    root.visible = false;
                    return;
                }
                var parts = text.split("===CONN===");
                var showOut = parts[0];
                var connOut = parts.length > 1 ? parts[1].trim() : "";

                if (showOut.indexOf("No default controller") !== -1 || showOut.trim() === "") {
                    root.visible = false;
                    return;
                }

                root.visible = true;
                var isPowered = (showOut.indexOf("Powered: yes") !== -1);
                if (!isPowered) {
                    root.text = "󰂲";
                    root.tooltipText = "Bluetooth off";
                    return;
                }

                var lines = connOut === "" ? [] : connOut.split("\n");
                var connectedCount = lines.length;

                if (connectedCount > 0) {
                    root.text = "󰂱";
                    root.tooltipText = "Devices connected: " + connectedCount;
                } else {
                    root.text = "";
                    root.tooltipText = "Bluetooth on (no devices)";
                }
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: root.checkBt()
    }

    Component.onCompleted: root.checkBt()

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            Quickshell.execDetached(["uwsm-app", "--", "ghostty", "-e", "bluetui"]);
        }
    }
}
