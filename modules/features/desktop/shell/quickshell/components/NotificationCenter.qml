pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.services
import qs.theme

Scope {
    id: root

    PanelWindow {
        id: popupWindow

        visible: NotificationService.popupList.length > 0 && !NotificationService.doNotDisturb
        screen: Quickshell.screens.find(candidate => candidate.name === Hyprland.focusedMonitor?.name) ?? NotificationService.displayScreen
        color: "transparent"
        implicitWidth: 380
        exclusiveZone: 0

        WlrLayershell.namespace: "quickshell:notifications"
        WlrLayershell.layer: WlrLayer.Overlay

        anchors {
            top: true
            right: true
            bottom: true
        }

        mask: Region {
            item: popupColumn
        }

        Column {
            id: popupColumn

            anchors {
                top: parent.top
                right: parent.right
                topMargin: 46
                rightMargin: 10
            }
            width: 360
            spacing: 8

            Repeater {
                model: NotificationService.popupList

                NotificationCard {
                    required property var modelData
                    width: popupColumn.width
                    notification: modelData
                    compact: true
                    onDefaultActionRequested: NotificationService.invokeDefaultAction(modelData.historyId)
                    onRemoveRequested: NotificationService.removeNotification(modelData.historyId)
                }
            }
        }
    }

    PanelWindow {
        id: historyWindow

        visible: NotificationService.historyOpen
        screen: NotificationService.displayScreen
        color: "transparent"
        implicitWidth: 390
        exclusiveZone: 0

        WlrLayershell.namespace: "quickshell:notification-history"
        WlrLayershell.layer: WlrLayer.Overlay

        anchors {
            top: true
            right: true
            bottom: true
        }

        Rectangle {
            anchors {
                fill: parent
                topMargin: 42
                rightMargin: 6
                bottomMargin: 6
            }
            radius: 12
            color: Theme.bg
            border.color: Theme.border
            border.width: 1

            ColumnLayout {
                anchors {
                    fill: parent
                    margins: 12
                }
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        color: Theme.text
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        text: "Notifications"
                    }

                    Text {
                        color: NotificationService.doNotDisturb ? Theme.warning : Theme.textMuted
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                        text: NotificationService.doNotDisturb ? "DND" : ""
                    }

                    Text {
                        color: Theme.textMuted
                        font.pixelSize: 18
                        text: "×"

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -8
                            onClicked: NotificationService.historyOpen = false
                        }
                    }
                }

                Text {
                    visible: NotificationService.history.length === 0
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 24
                    color: Theme.textMuted
                    font.pixelSize: 11
                    text: "No notifications"
                }

                ListView {
                    id: historyList

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8
                    clip: true
                    model: NotificationService.history

                    delegate: NotificationCard {
                        required property var modelData
                        width: historyList.width
                        notification: modelData
                        onDefaultActionRequested: NotificationService.invokeDefaultAction(modelData.historyId)
                        onRemoveRequested: NotificationService.removeNotification(modelData.historyId)
                    }
                }
            }
        }
    }
}
