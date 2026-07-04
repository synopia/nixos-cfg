import QtQuick
import Quickshell
import qs.services
import qs.theme

BarPill {
    id: root

    required property var notificationScreen

    content: Row {
        spacing: 5

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: NotificationService.doNotDisturb
                ? Colors.md3.error
                : NotificationService.history.length > 0
                    ? Colors.md3.primary
                    : Colors.md3.on_surface_variant
            font.pixelSize: 13
            font.weight: Font.Bold
            text: NotificationService.doNotDisturb ? "×" : "●"
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.md3.on_surface
            font.pixelSize: 10
            font.weight: Font.DemiBold
            text: NotificationService.history.length.toString()
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                NotificationService.toggleDoNotDisturb()
            else
                NotificationService.toggleHistory(root.notificationScreen)
        }
    }
}
