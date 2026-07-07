import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets
import qs.theme

BarPill {
    id: root

    property var targetScreen
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(targetScreen)
    readonly property int activeWorkspace: monitor?.activeWorkspace?.id ?? 1
    readonly property int workspaceGroup: Math.floor((activeWorkspace - 1) / 10)
    property var occupiedWorkspaces: []
    property var clients: []

    function updateOccupiedWorkspaces() {
        occupiedWorkspaces = Hyprland.workspaces.values.map(workspace => workspace.id);
    }

    function refreshClients() {
        if (!clientsProcess.running) {
            clientsProcess.running = true;
        }
    }

    function biggestClient(workspaceId) {
        const workspaceClients = clients.filter(client => client.workspace?.id === workspaceId && client.mapped !== false && !client.hidden);
        const tiledClients = workspaceClients.filter(client => !client.floating);
        const candidates = tiledClients.length > 0 ? tiledClients : workspaceClients;

        return candidates.reduce((biggest, client) => {
            const biggestArea = (biggest?.size?.[0] ?? 0) * (biggest?.size?.[1] ?? 0);
            const clientArea = (client?.size?.[0] ?? 0) * (client?.size?.[1] ?? 0);
            return clientArea > biggestArea ? client : biggest;
        }, null);
    }

    function iconForClient(client) {
        if (!client)
            return "";

        const appId = client.class || client.initialClass || "";
        const entry = DesktopEntries.byId(appId) || DesktopEntries.heuristicLookup(appId);

        return entry?.icon ? Quickshell.iconPath(entry.icon, "application-x-executable") : Quickshell.iconPath(appId.toLowerCase(), "application-x-executable");
    }

    Component.onCompleted: {
        updateOccupiedWorkspaces();
        refreshClients();
    }

    Connections {
        target: Hyprland.workspaces

        function onValuesChanged() {
            root.updateOccupiedWorkspaces();
            clientsRefresh.restart();
        }
    }

    Connections {
        target: Hyprland

        function onFocusedWorkspaceChanged() {
            root.updateOccupiedWorkspaces();
        }

        function onRawEvent(event) {
            const clientEvents = ["openwindow", "closewindow", "movewindow", "resizewindow", "changefloatingmode", "fullscreen", "moveworkspace", "createworkspace", "destroyworkspace",];

            if (clientEvents.includes(event.name)) {
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

    content: Row {
        spacing: 3

        Repeater {
            model: 10

            Rectangle {
                id: workspaceButton

                required property int index
                readonly property int workspace: root.workspaceGroup * 10 + index + 1
                readonly property bool active: root.activeWorkspace === workspace
                readonly property bool occupied: root.occupiedWorkspaces.includes(workspace)
                readonly property var biggestClient: root.biggestClient(workspace)
                readonly property string appIcon: root.iconForClient(biggestClient)

                width: active ? 28 : 22
                height: 22
                radius: 10
                color: active ? Theme.workspaceActive : occupied ? Theme.workspaceInactive : "transparent"

                IconImage {
                    anchors.centerIn: parent
                    visible: workspaceButton.biggestClient !== null
                    implicitSize: workspaceButton.active ? 17 : 15
                    source: workspaceButton.appIcon
                }

                Text {
                    anchors.centerIn: parent
                    visible: workspaceButton.biggestClient === null
                    text: workspaceButton.workspace
                    color: workspaceButton.active ? Theme.text : Theme.textMuted
                    font.pixelSize: 10
                    font.weight: workspaceButton.active ? Font.Bold : Font.Normal
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${workspaceButton.workspace} })`)
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 120
                    }
                }
            }
        }
    }

    WheelHandler {
        onWheel: event => {
            if (event.angleDelta.y < 0) {
                Hyprland.dispatch('hl.dsp.focus({ workspace = "r+1" })');
            } else if (event.angleDelta.y > 0) {
                Hyprland.dispatch('hl.dsp.focus({ workspace = "r-1" })');
            }
        }
    }
}
