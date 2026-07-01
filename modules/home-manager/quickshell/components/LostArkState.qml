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

    content: Row {
        property color accent: Theme.mauve

        Text {
            color: parent.accent
            font.pixelSize: 9
            font.weight: Font.Bold

            text: `LOA ${LOALogs.weekOffset !== 0 ? LOALogs.weekOffset : ""}`
        }
    }
    MouseArea {
        id: hoverArea

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                LOALogs.prevWeek();
            else
                LOALogs.nextWeek();
        }
    }
    PopupWindow {
        id: loaState

        property var cols: 8
        visible: hoverArea.containsMouse || root.screenshotSelecting
        color: "transparent"
        grabFocus: false
        implicitWidth: stateFrame.implicitWidth
        implicitHeight: stateFrame.implicitHeight

        anchor {
            item: root
            edges: Edges.Bottom
            gravity: Edges.Bottom
            adjustment: PopupAdjustment.SlideX | PopupAdjustment.FlipY
            margins.top: 8
        }

        Rectangle {
            id: stateFrame

            color: Theme.crust
            border.color: Theme.surface1
            border.width: 1
            radius: 8
            implicitWidth: tableGrid.implicitWidth + 24
            implicitHeight: tableGrid.implicitHeight + 24
            GridLayout {
                id: tableGrid
                anchors.centerIn: parent
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

    Process {
        id: screenshotStateProcess
        command: ["sh", "-c", "test -e \"${XDG_RUNTIME_DIR:-/tmp}/quickshell-screenshot-region\" && printf 1 || printf 0"]

        stdout: StdioCollector {
            onStreamFinished: root.screenshotSelecting = text.trim() === "1"
        }
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
}
