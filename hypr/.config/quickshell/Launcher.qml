import QtQuick
import Quickshell
import Quickshell.Io
import "."

BarItem {
    id: root
    isSquare: true
    text: ""

    Process {
        id: iconProc
        command: ["sh", Quickshell.shellDir + "/scripts/get_icon.sh"]
        running: true
        stdout: StdioCollector {
            onTextChanged: {
                var cleaned = text.trim();
                if (cleaned !== "") {
                    root.text = cleaned;
                }
            }
        }
    }

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            Quickshell.execDetached(["sh", "-c", "rofi -show drun -run-command 'uwsm-app -- {cmd}'"]);
        }
    }
}
