import QtQuick
import Quickshell
import qs.theme

BarPill {
    content: Row {
        spacing: 6

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.text
            font.pixelSize: 12
            font.weight: Font.DemiBold
            text: Qt.formatDateTime(clock.date, "HH:mm")
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.textMuted
            font.pixelSize: 11
            text: Qt.formatDateTime(clock.date, "ddd, dd MMM")
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
