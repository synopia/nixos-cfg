pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.theme

MouseArea {
    id: root

    required property SystemTrayItem item

    implicitWidth: 20
    implicitHeight: 20
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    hoverEnabled: true

    onClicked: mouse => {
        if (mouse.button === Qt.RightButton && root.item.hasMenu) {
            menu.open()
        } else if (mouse.button === Qt.MiddleButton) {
            root.item.secondaryActivate()
        } else {
            root.item.activate()
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: root.containsMouse ? Colors.md3.surface_container_highest : "transparent"
    }

    IconImage {
        anchors.centerIn: parent
        implicitSize: 16
        source: root.item.icon
    }

    QsMenuAnchor {
        id: menu
        menu: root.item.menu

        anchor {
            item: root
            edges: Edges.Bottom
            gravity: Edges.Bottom
            adjustment: PopupAdjustment.SlideX | PopupAdjustment.ResizeY
        }
    }
}
