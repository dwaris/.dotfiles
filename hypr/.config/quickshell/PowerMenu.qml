import QtQuick
import Quickshell
import "."

BarItem {
    id: root
    isSquare: true

    text: "⏻"
    textColor: Theme.red
    tooltipText: "Power (Left: Shutdown, Middle: Logout, Right: Reboot)"

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            Quickshell.execDetached(["uwsm-app", "--", "hyprshutdown", "-t", "Shutting down...", "-p", "systemctl poweroff"]);
        } else if (mouse.button === Qt.MiddleButton) {
            Quickshell.execDetached(["uwsm-app", "--", "hyprshutdown", "-t", "Logging out..."]);
        } else if (mouse.button === Qt.RightButton) {
            Quickshell.execDetached(["uwsm-app", "--", "hyprshutdown", "-t", "Rebooting...", "-p", "systemctl reboot"]);
        }
    }
}
