import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import qs.theme

BarPill {
    id: root

    property var targetScreen
    property var clients: []

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(targetScreen)
    readonly property int workspaceId: monitor?.activeWorkspace?.id ?? 1
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
    readonly property var workspaceWindow: biggestClient(workspaceId)
    readonly property bool activeWindowIsLocal: (monitor?.focused ?? false) && (activeWindow?.activated ?? false)
    readonly property string appName: activeWindowIsLocal ? (activeWindow?.appId || "Desktop") : (workspaceWindow?.class || workspaceWindow?.initialClass || "Desktop")
    readonly property string windowTitle: activeWindowIsLocal ? (activeWindow?.title || `Workspace ${workspaceId}`) : (workspaceWindow?.title || `Workspace ${workspaceId}`)

    function biggestClient(workspace) {
        const workspaceClients = clients.filter(client => client.workspace?.id === workspace && client.mapped !== false && !client.hidden);
        const tiledClients = workspaceClients.filter(client => !client.floating);
        const candidates = tiledClients.length > 0 ? tiledClients : workspaceClients;

        return candidates.reduce((biggest, client) => {
            const biggestArea = (biggest?.size?.[0] ?? 0) * (biggest?.size?.[1] ?? 0);
            const clientArea = (client?.size?.[0] ?? 0) * (client?.size?.[1] ?? 0);
            return clientArea > biggestArea ? client : biggest;
        }, null);
    }

    function refreshClients() {
        if (!clientsProcess.running) {
            clientsProcess.running = true;
        }
    }

    Component.onCompleted: refreshClients()

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (["activewindow", "activewindowv2", "changefloatingmode", "closewindow", "fullscreen", "movewindow", "moveworkspace", "openwindow", "resizewindow", "workspace",].includes(event.name)) {
                clientsRefresh.restart();
            }
        }
    }

    Timer {
        id: clientsRefresh
        interval: 75
        repeat: false
        onTriggered: root.refreshClients()
    }

    Process {
        id: clientsProcess
        command: ["hyprctl", "clients", "-j"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.clients = JSON.parse(text);
                } catch (error) {
                    console.warn("Could not parse Hyprland clients:", error);
                }
            }
        }
    }

    content: ColumnLayout {
        width: Math.max(0, root.width - root.padX * 2)
        spacing: -2

        Text {
            Layout.fillWidth: true
            color: Theme.accent
            font.pixelSize: 10
            horizontalAlignment: Text.AlignLeft
            text: root.appName
            elide: Text.ElideRight
        }

        Text {
            Layout.fillWidth: true
            color: Theme.text
            font.weight: Font.Bold
            font.pixelSize: 11
            horizontalAlignment: Text.AlignLeft
            text: root.windowTitle
            elide: Text.ElideRight
        }
    }
}
