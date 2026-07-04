import QtQuick
import Quickshell.Io
import qs.theme

BarPill {
    id: root

    readonly property string connectionName: "bishop.localdomain"
    property bool connected: false
    property bool busy: false

    function refresh() {
        if (!statusProcess.running) {
            statusProcess.running = true;
        }
    }

    function toggle() {
        if (busy)
            return;
        busy = true;
        toggleProcess.command = connected ? ["nmcli", "connection", "down", connectionName] : ["nmcli", "connection", "up", connectionName];
        toggleProcess.running = true;
    }

    content: Row {
        spacing: 5

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 7
            height: 7
            radius: 4
            color: root.busy ? Colors.base16.base0a : root.connected ? Colors.base16.base0b : Colors.md3.outline_variant
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: root.connected ? Colors.md3.on_surface : Colors.md3.on_surface_variant
            font.pixelSize: 10
            font.weight: Font.DemiBold
            text: root.busy ? "VPN…" : "VPN"
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: !root.busy
        onClicked: root.toggle()
    }

    Process {
        id: statusProcess
        command: ["nmcli", "-t", "-f", "NAME,TYPE", "connection", "show", "--active",]

        stdout: StdioCollector {
            onStreamFinished: {
                root.connected = text.split("\n").some(line => line === root.connectionName + ":vpn");
            }
        }
    }

    Process {
        id: toggleProcess

        onExited: {
            root.busy = false;
            refreshDelay.restart();
        }
    }

    Timer {
        id: refreshDelay
        interval: 500
        repeat: false
        onTriggered: root.refresh()
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
