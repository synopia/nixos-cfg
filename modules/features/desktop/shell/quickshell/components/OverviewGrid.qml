pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import qs.theme

Item {
    id: root

    required property var screen
    required property bool overviewOpen

    signal closeRequested

    readonly property int columns: 5
    readonly property int rows: 2
    readonly property real spacing: 12
    readonly property real cellWidth: (width - spacing * (columns - 1)) / columns
    readonly property real cellHeight: Math.min((height - spacing * (rows - 1)) / rows, cellWidth * 0.62)
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen)
    readonly property int activeWorkspace: monitor?.activeWorkspace?.id ?? 1
    readonly property int workspaceGroup: Math.floor((activeWorkspace - 1) / 10)
    readonly property int firstWorkspace: workspaceGroup * 10 + 1

    property var clients: []
    property var monitors: []
    property int dragTargetWorkspace: -1

    function refresh() {
        if (!clientsProcess.running)
            clientsProcess.running = true;
        if (!monitorsProcess.running)
            monitorsProcess.running = true;
    }

    function monitorForClient(client) {
        return monitors.find(monitor => monitor.id === client.monitor) ?? {
            x: 0,
            y: 0,
            width: screen.width,
            height: screen.height
        };
    }

    function toplevelForClient(client) {
        return ToplevelManager.toplevels.values.find(toplevel => `0x${toplevel.HyprlandToplevel?.address}` === client.address) ?? null;
    }

    function iconForClient(client) {
        const appId = client?.class || client?.initialClass || "";
        const entry = DesktopEntries.byId(appId) || DesktopEntries.heuristicLookup(appId);

        return Quickshell.iconPath(entry?.icon || appId.toLowerCase(), "application-x-executable");
    }

    onOverviewOpenChanged: {
        if (overviewOpen)
            refresh();
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (!root.overviewOpen)
                return;
            const refreshEvents = ["openwindow", "closewindow", "movewindow", "resizewindow", "changefloatingmode", "fullscreen", "moveworkspace", "createworkspace", "destroyworkspace",];

            if (refreshEvents.includes(event.name)) {
                refreshTimer.restart();
            }
        }
    }

    Timer {
        id: refreshTimer
        interval: 75
        repeat: false
        onTriggered: root.refresh()
    }

    Process {
        id: clientsProcess
        command: ["hyprctl", "clients", "-j"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.clients = JSON.parse(text).filter(client => client.mapped !== false && !client.hidden);
                } catch (error) {
                    console.warn("Could not parse Hyprland clients:", error);
                }
            }
        }
    }

    Process {
        id: monitorsProcess
        command: ["hyprctl", "monitors", "-j"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.monitors = JSON.parse(text);
                } catch (error) {
                    console.warn("Could not parse Hyprland monitors:", error);
                }
            }
        }
    }

    Grid {
        anchors.centerIn: parent
        columns: root.columns
        rows: root.rows
        columnSpacing: root.spacing
        rowSpacing: root.spacing

        Repeater {
            model: 10

            Rectangle {
                id: workspace

                required property int index
                readonly property int workspaceId: root.firstWorkspace + index
                readonly property bool active: root.activeWorkspace === workspaceId
                property bool dragHovered: false

                width: root.cellWidth
                height: root.cellHeight
                radius: 14
                color: dragHovered ? Theme.surfaceHover : Theme.surface
                border.width: active || dragHovered ? 2 : 1
                border.color: dragHovered ? Theme.accent2 : active ? Theme.accent : Theme.surface

                Text {
                    anchors {
                        top: parent.top
                        left: parent.left
                        margins: 10
                    }
                    z: 20
                    text: workspace.workspaceId
                    color: workspace.active ? Theme.accent : Theme.text
                    font.pixelSize: 13
                    font.weight: Font.Bold
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${workspace.workspaceId} })`);
                        root.closeRequested();
                    }
                }

                DropArea {
                    anchors.fill: parent
                    keys: ["overview-window"]

                    onEntered: {
                        workspace.dragHovered = true;
                        root.dragTargetWorkspace = workspace.workspaceId;
                    }

                    onExited: {
                        workspace.dragHovered = false;
                        if (root.dragTargetWorkspace === workspace.workspaceId) {
                            root.dragTargetWorkspace = -1;
                        }
                    }

                    onDropped: {
                        workspace.dragHovered = false;
                        root.dragTargetWorkspace = workspace.workspaceId;
                    }
                }

                Item {
                    anchors {
                        fill: parent
                        margins: 5
                    }
                    clip: false

                    Repeater {
                        model: ScriptModel {
                            values: root.clients.filter(client => client.workspace.id === workspace.workspaceId)
                        }

                        delegate: Item {
                            id: preview

                            required property var modelData

                            readonly property var client: modelData
                            readonly property var clientMonitor: root.monitorForClient(client)
                            readonly property var toplevel: root.toplevelForClient(client)
                            property bool dragging: false
                            property bool moved: false
                            readonly property real homeX: Math.max(0, (client.at[0] - clientMonitor.x) / clientMonitor.width * parent.width)
                            readonly property real homeY: Math.max(0, (client.at[1] - clientMonitor.y) / clientMonitor.height * parent.height)
                            readonly property real previewWidth: Math.max(42, Math.min(client.size[0] / clientMonitor.width * parent.width, parent.width - homeX))
                            readonly property real previewHeight: Math.max(30, Math.min(client.size[1] / clientMonitor.height * parent.height, parent.height - homeY))

                            width: previewWidth
                            height: previewHeight
                            z: Drag.active ? 1000 : client.floating ? 10 : 1

                            Binding {
                                target: preview
                                property: "x"
                                value: preview.homeX
                                when: !preview.dragging
                                restoreMode: Binding.RestoreNone
                            }

                            Binding {
                                target: preview
                                property: "y"
                                value: preview.homeY
                                when: !preview.dragging
                                restoreMode: Binding.RestoreNone
                            }

                            Drag.active: dragging
                            Drag.source: preview
                            Drag.hotSpot.x: width / 2
                            Drag.hotSpot.y: height / 2
                            Drag.keys: ["overview-window"]

                            Rectangle {
                                anchors.fill: parent
                                radius: 7
                                color: Theme.text
                                border.width: 1
                                border.color: hoverHandler.hovered ? Theme.surfaceHover : Theme.surface
                                clip: true

                                ScreencopyView {
                                    anchors.fill: parent
                                    captureSource: root.overviewOpen ? preview.toplevel : null
                                    live: true

                                    Rectangle {
                                        anchors.fill: parent
                                        color: "transparent"
                                        border.width: 1
                                        border.color: Theme.surface
                                    }

                                    IconImage {
                                        anchors.centerIn: parent
                                        visible: !parent.hasContent
                                        implicitSize: Math.min(36, preview.width * 0.35, preview.height * 0.5)
                                        source: root.iconForClient(preview.client)
                                    }
                                }
                            }

                            HoverHandler {
                                id: hoverHandler
                            }

                            DragHandler {
                                id: windowDrag

                                target: preview
                                acceptedButtons: Qt.LeftButton

                                onActiveChanged: {
                                    if (active) {
                                        preview.moved = true;
                                        preview.dragging = true;
                                        return;
                                    }

                                    if (!preview.dragging)
                                        return;
                                    const targetWorkspace = root.dragTargetWorkspace;
                                    preview.dragging = false;

                                    if (targetWorkspace !== -1 && targetWorkspace !== preview.client.workspace.id) {
                                        Hyprland.dispatch(`hl.dsp.window.move({ workspace = ${targetWorkspace}, follow = false, window = "address:${preview.client.address}" })`);
                                        refreshTimer.restart();
                                    }

                                    root.dragTargetWorkspace = -1;
                                }
                            }

                            TapHandler {
                                acceptedButtons: Qt.LeftButton

                                onTapped: {
                                    Hyprland.dispatch(`hl.dsp.focus({ window = "address:${preview.client.address}" })`);
                                    root.closeRequested();
                                }
                            }

                            TapHandler {
                                acceptedButtons: Qt.MiddleButton

                                onTapped: {
                                    Hyprland.dispatch(`hl.dsp.window.close({ window = "address:${preview.client.address}" })`);
                                    refreshTimer.restart();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
