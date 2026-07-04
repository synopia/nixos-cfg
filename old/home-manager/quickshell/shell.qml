//@ pragma UseQApplication
//
import QtQuick
import QtQuick.Layouts
import QtQuick.LocalStorage
import Quickshell
import qs.components
import qs.theme
import qs.services

Scope {

    Overview {}
    NotificationCenter {}

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 36
            color: Colors.md3.background

            RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 8
                    rightMargin: 8
                }
                spacing: 8

                ActiveWindow {
                    targetScreen: bar.screen
                    Layout.minimumWidth: 450
                    Layout.preferredWidth: 450
                    Layout.maximumWidth: 450
                }

                Resources {}

                LostArkState {}
                Item {
                    Layout.fillWidth: true
                }

                Workspaces {
                    targetScreen: bar.screen
                }

                Item {
                    Layout.fillWidth: true
                }

                Clock {}
                Weather {}
                Vpn {}
                NotificationIcon {
                    notificationScreen: bar.screen
                }
                Volume {}
                Tray {}
            }
        }
    }
}
