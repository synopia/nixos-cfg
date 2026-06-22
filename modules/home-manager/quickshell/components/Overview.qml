pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.theme

Scope {
    id: root

    property bool open: false

    GlobalShortcut {
        name: "overviewToggle"
        description: "Toggle workspace overview"

        onPressed: root.open = !root.open
    }

    GlobalShortcut {
        name: "overviewClose"
        description: "Close workspace overview"

        onPressed: root.open = false
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window

            required property var modelData
            screen: modelData
            visible: root.open
            color: "transparent"

            WlrLayershell.namespace: "quickshell:overview"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: root.open
                ? WlrKeyboardFocus.Exclusive
                : WlrKeyboardFocus.None

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            Rectangle {
                anchors.fill: parent
                color: Theme.crust
                opacity: 0.86

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.open = false
                }
            }

            OverviewGrid {
                anchors.centerIn: parent
                width: Math.min(window.width - 80, 1720)
                height: Math.min(window.height - 100, 760)
                overviewOpen: root.open
                screen: window.screen
                onCloseRequested: root.open = false
            }

            Item {
                focus: root.open
                Keys.onEscapePressed: root.open = false
            }
        }
    }
}
