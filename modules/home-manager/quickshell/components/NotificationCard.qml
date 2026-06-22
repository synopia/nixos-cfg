import QtQuick
import QtQuick.Layouts
import qs.theme

Rectangle {
    id: root

    required property var notification
    property bool compact: false
    signal removeRequested

    width: ListView.view?.width ?? 360
    implicitHeight: content.implicitHeight + 20
    radius: 10
    color: Theme.surface0
    border.color: hovered ? Theme.accent : Theme.surface1
    border.width: 1

    property bool hovered: false

    ColumnLayout {
        id: content
        anchors {
            fill: parent
            margins: 10
        }
        spacing: 4

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Rectangle {
                Layout.preferredWidth: 26
                Layout.preferredHeight: 26
                radius: 7
                color: Theme.surface1

                Text {
                    anchors.centerIn: parent
                    color: Theme.accent
                    font.pixelSize: 13
                    font.weight: Font.Bold
                    text: {
                        const name = root.notification.appName || "?"
                        return name.charAt(0).toUpperCase()
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                Text {
                    Layout.fillWidth: true
                    color: Theme.subtext0
                    elide: Text.ElideRight
                    font.pixelSize: 9
                    text: root.notification.appName || "Notification"
                }

                Text {
                    Layout.fillWidth: true
                    color: Theme.text
                    elide: Text.ElideRight
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    text: root.notification.summary || "Notification"
                }
            }

            Text {
                color: Theme.overlay1
                font.pixelSize: 9
                text: {
                    const date = new Date(root.notification.receivedAtEpochMs)
                    return isNaN(date.getTime())
                        ? ""
                        : Qt.formatTime(date, "HH:mm")
                }
            }
        }

        Text {
            visible: text.length > 0
            Layout.fillWidth: true
            color: Theme.subtext1
            font.pixelSize: 10
            maximumLineCount: root.compact ? 3 : 6
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            textFormat: Text.StyledText
            text: root.notification.body || ""
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: root.removeRequested()
    }
}
