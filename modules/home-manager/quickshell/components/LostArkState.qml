import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls
import qs.theme
import qs.services

BarPill {
    id: root

    property bool screenshotSelecting: false
    property bool popupOpen: false

    function showPopup() {
        closeTimer.stop();
        popupOpen = true;
    }

    function maybeClosePopup() {
        if (!hoverArea.containsMouse && !popupHoverHandler.hovered && !screenshotSelecting)
            closeTimer.restart();
    }

    content: Row {
        property color accent: Theme.mauve

        Text {
            color: parent.accent
            font.pixelSize: 9
            font.weight: Font.Bold

            text: `LOA ${LOALogs.weekOffset !== 0 ? -LOALogs.weekOffset : ""}`
        }
    }
    MouseArea {
        id: hoverArea

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onContainsMouseChanged: {
            if (containsMouse)
                root.showPopup();
            else
                root.maybeClosePopup();
        }

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                LOALogs.prevWeek();
            else
                LOALogs.nextWeek();
        }
    }
    PopupWindow {
        id: loaState

        property var cols: 3 + 2 * 3
        visible: root.popupOpen || root.screenshotSelecting
        color: "transparent"
        grabFocus: false
        implicitWidth: popupSurface.implicitWidth
        implicitHeight: popupSurface.implicitHeight

        anchor {
            item: root
            edges: Edges.Bottom
            gravity: Edges.Bottom
            adjustment: PopupAdjustment.SlideX | PopupAdjustment.FlipY
        }

        Item {
            id: popupSurface

            implicitWidth: stateFrame.implicitWidth
            implicitHeight: stateFrame.implicitHeight + 8
            width: implicitWidth
            height: implicitHeight

            HoverHandler {
                id: popupHoverHandler

                onHoveredChanged: {
                    if (hovered)
                        root.showPopup();
                    else
                        root.maybeClosePopup();
                }
            }

            Rectangle {
                id: stateFrame

                anchors {
                    top: parent.top
                    topMargin: 8
                    horizontalCenter: parent.horizontalCenter
                }
                color: Theme.crust
                border.color: Theme.surface1
                border.width: 1
                radius: 8
                implicitWidth: Math.max(tableGrid.implicitWidth, controls.implicitWidth, dpsModeControls.implicitWidth) + 24
                implicitHeight: popupContent.implicitHeight + 24
                width: implicitWidth
                height: implicitHeight

                ColumnLayout {
                    id: popupContent

                    anchors.centerIn: parent
                    spacing: 8

                    RowLayout {
                        id: controls

                        Layout.fillWidth: true
                        spacing: 8

                        LoaWeekButton {
                            label: "<"
                            onClicked: LOALogs.prevWeek()
                        }

                        Text {
                            Layout.fillWidth: true
                            color: Theme.text
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                            text: LOALogs.weekOffset === 0 ? "This week" : `${LOALogs.weekOffset} week${LOALogs.weekOffset === 1 ? "" : "s"} ago`
                        }

                        LoaWeekButton {
                            label: ">"
                            enabled: LOALogs.weekOffset > 0
                            onClicked: LOALogs.nextWeek()
                        }
                    }

                    RowLayout {
                        id: dpsModeControls

                        Layout.alignment: Qt.AlignHCenter
                        spacing: 2

                        LoaModeButton {
                            label: "DPS"
                            mode: "dps"
                        }

                        LoaModeButton {
                            label: "NDPS"
                            mode: "ndps"
                        }

                        LoaModeButton {
                            label: "RDPS"
                            mode: "rdps"
                        }
                    }

                    GridLayout {
                        id: tableGrid

                        columns: loaState.cols
                        rowSpacing: 1
                        columnSpacing: 1

                        Repeater {
                            model: LOALogs.data

                            Rectangle {
                                required property string modelData
                                required property int index
                                Layout.preferredWidth: 90
                                Layout.preferredHeight: 28
                                color: index < loaState.cols || (index % loaState.cols === 0) ? Theme.surface0 : Theme.mantle

                                Text {
                                    anchors.centerIn: parent
                                    width: parent.width - 8
                                    color: Theme.text
                                    font.family: "monospace"
                                    font.pixelSize: 10
                                    font.bold: index < loaState.cols
                                    // lineHeight: 0.92
                                    textFormat: Text.RichText
                                    horizontalAlignment: Text.AlignHCenter
                                    elide: Text.ElideRight
                                    text: modelData
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Process {
        id: screenshotStateProcess
        command: ["sh", "-c", "test -e \"${XDG_RUNTIME_DIR:-/tmp}/quickshell-screenshot-region\" && printf 1 || printf 0"]

        stdout: StdioCollector {
            onStreamFinished: root.screenshotSelecting = text.trim() === "1"
        }
    }

    Timer {
        id: closeTimer
        interval: 250
        repeat: false
        onTriggered: root.popupOpen = hoverArea.containsMouse || popupHoverHandler.hovered || root.screenshotSelecting
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!screenshotStateProcess.running)
                screenshotStateProcess.running = true;
        }
    }

    component LoaWeekButton: Rectangle {
        id: button

        signal clicked

        property string label: ""

        Layout.preferredWidth: 26
        Layout.preferredHeight: 24
        radius: 6
        color: buttonMouse.containsMouse && enabled ? Theme.surface2 : Theme.surface0
        border.color: enabled ? Theme.surface2 : Theme.surface1
        border.width: 1
        opacity: enabled ? 1 : 0.45

        Text {
            anchors.centerIn: parent
            color: Theme.text
            font.pixelSize: 16
            font.weight: Font.Bold
            text: button.label
        }

        MouseArea {
            id: buttonMouse

            anchors.fill: parent
            hoverEnabled: true
            enabled: button.enabled
            onClicked: button.clicked()
        }
    }

    component LoaModeButton: Rectangle {
        id: button

        property string label: ""
        property string mode: ""
        readonly property bool selected: LOALogs.dpsMode === mode

        Layout.preferredWidth: 42
        Layout.preferredHeight: 22
        radius: 5
        color: selected ? Theme.mauve : modeMouse.containsMouse ? Theme.surface2 : Theme.surface0
        border.color: selected ? Theme.mauve : Theme.surface1
        border.width: 1

        Text {
            anchors.centerIn: parent
            color: button.selected ? Theme.crust : Theme.text
            font.pixelSize: 9
            font.weight: Font.Bold
            text: button.label
        }

        MouseArea {
            id: modeMouse

            anchors.fill: parent
            hoverEnabled: true
            onClicked: LOALogs.setDpsMode(button.mode)
        }
    }
}
