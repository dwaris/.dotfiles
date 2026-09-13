import QtQuick
import Quickshell
import Quickshell.Io
import "."

BarItem {
    id: root
    isSquare: true

    text: ""
    textColor: Theme.text
    tooltipText: "VPN Disconnected"

    function checkVpn() {
        vpnProc.running = true;
    }

    Process {
        id: vpnProc
        command: ["sh", Quickshell.shellDir + "/scripts/vpn_status.sh"]
        stdout: StdioCollector {
            onTextChanged: {
                try {
                    var data = JSON.parse(text.trim());
                    root.text = data.text || "";
                    root.tooltipText = data.tooltip || "Proton VPN";
                    if (data.class === "connected") {
                        root.textColor = Theme.text;
                    } else if (data.class === "warning") {
                        root.textColor = Theme.peach;
                    } else {
                        root.textColor = Theme.text;
                    }
                } catch(e) {}
            }
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: root.checkVpn()
    }

    Component.onCompleted: root.checkVpn()

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            Quickshell.execDetached(["sh", Quickshell.shellDir + "/scripts/vpn_toggle.sh"]);
            vpnTimer.restart();
        } else if (mouse.button === Qt.MiddleButton) {
            Quickshell.execDetached(["uwsm-app", "--", "ghostty", "-e", "sh", "-lc", "protonvpn status; echo; echo Press Enter to close; read _"]);
        } else if (mouse.button === Qt.RightButton) {
            Quickshell.execDetached(["sh", Quickshell.shellDir + "/scripts/vpn_toggle.sh", "safe"]);
            vpnTimer.restart();
        }
    }

    Timer {
        id: vpnTimer
        interval: 2000
        onTriggered: root.checkVpn()
    }
}
