import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import qs.theme

BarPill {
    id: root

    property bool popupOpen: false
    property bool statusMuted: false
    property real statusVolume: 0

    signal muteAllRequested

    function showPopup() {
        closeTimer.stop();
        popupOpen = true;
    }

    function maybeClosePopup() {
        if (!hoverArea.containsMouse && !popupHoverHandler.hovered)
            closeTimer.restart();
    }

    function refreshStatus() {
        if (!volumeStatusProcess.running)
            volumeStatusProcess.running = true;
    }

    function volumeIcon() {
        if (statusMuted || statusVolume <= 0)
            return "󰝟";
        if (statusVolume < 0.35)
            return "󰕿";
        if (statusVolume < 0.7)
            return "󰖀";
        return "󰕾";
    }

    function muteAllOutputs() {
        muteAllRequested();
        refreshDelay.restart();
    }

    padX: 9

    content: Text {
        color: root.statusMuted ? Theme.textMuted : Theme.text
        font.pixelSize: 14
        text: root.volumeIcon()
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
            if (mouse.button === Qt.RightButton) {
                root.muteAllOutputs();
            } else if (mouse.button === Qt.LeftButton) {
                pwvucontrolProcess.running = true;
            }
        }
    }

    PopupWindow {
        visible: root.popupOpen
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

            implicitWidth: volumeFrame.implicitWidth
            implicitHeight: volumeFrame.implicitHeight + 8
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
                id: volumeFrame

                anchors {
                    top: parent.top
                    topMargin: 8
                    horizontalCenter: parent.horizontalCenter
                }
                color: Theme.popupBg
                border.color: Theme.popupBorder
                border.width: 1
                radius: 8
                implicitWidth: Math.max(sliderRow.implicitWidth, emptyState.implicitWidth) + 24
                implicitHeight: popupContent.implicitHeight + 24
                width: implicitWidth
                height: implicitHeight

                ColumnLayout {
                    id: popupContent

                    anchors.centerIn: parent
                    spacing: 10

                    RowLayout {
                        id: sliderRow

                        Layout.alignment: Qt.AlignHCenter
                        spacing: 12

                        Repeater {
                            model: Pipewire.nodes

                            SinkSlider {
                                required property var modelData

                                node: modelData
                            }
                        }
                    }

                    Text {
                        id: emptyState

                        Layout.alignment: Qt.AlignHCenter
                        visible: !Pipewire.ready
                        color: Theme.accent
                        font.pixelSize: 10
                        text: "PipeWire"
                    }
                }
            }
        }
    }

    Process {
        id: pwvucontrolProcess

        command: ["pwvucontrol"]
    }

    Process {
        id: volumeStatusProcess

        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/Volume:\s+([0-9.]+)/);
                root.statusVolume = match ? Number(match[1]) : 0;
                root.statusMuted = text.includes("[MUTED]");
            }
        }
    }

    Timer {
        id: closeTimer

        interval: 160
        repeat: false
        onTriggered: root.popupOpen = hoverArea.containsMouse || popupHoverHandler.hovered
    }

    Timer {
        id: refreshDelay

        interval: 120
        repeat: false
        onTriggered: root.refreshStatus()
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshStatus()
    }

    component SinkSlider: ColumnLayout {
        id: sink

        required property var node
        readonly property var trackedNode: nodeTracker.objects[0] ?? null
        readonly property var trackedAudio: trackedNode?.audio ?? null
        readonly property bool available: trackedNode?.isSink && trackedAudio != null
        readonly property bool isDefault: Pipewire.defaultAudioSink?.id === trackedNode?.id
        readonly property bool nodeMuted: available ? trackedAudio.muted : false
        readonly property real nodeVolume: available ? trackedAudio.volume : 0
        readonly property string nodeLabel: trackedNode?.nickname || trackedNode?.description || trackedNode?.name || "Output"

        PwObjectTracker {
            id: nodeTracker

            objects: sink.node ? [sink.node] : []
        }

        visible: available
        Layout.preferredWidth: available ? implicitWidth : 0
        Layout.preferredHeight: available ? implicitHeight : 0
        spacing: 6

        Connections {
            target: root

            function onMuteAllRequested() {
                if (sink.available)
                    sink.trackedAudio.muted = true;
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 34
            color: sink.nodeMuted ? Theme.textMuted : sink.isDefault ? Theme.accent : Theme.text
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            text: sink.nodeMuted ? "󰝟" : "󰕾"
        }

        Slider {
            id: volumeSlider

            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 28
            Layout.preferredHeight: 120
            orientation: Qt.Vertical
            from: 0
            to: 1.5
            stepSize: 0.01
            live: true
            value: sink.nodeVolume

            onMoved: {
                if (sink.available) {
                    sink.trackedAudio.volume = value;
                    root.refreshDelay.restart();
                }
            }

            background: Rectangle {
                x: volumeSlider.leftPadding + volumeSlider.availableWidth / 2 - width / 2
                y: volumeSlider.topPadding
                width: 6
                height: volumeSlider.availableHeight
                radius: 3
                color: Theme.surface

                Rectangle {
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                    height: parent.height * volumeSlider.position
                    radius: 3
                    color: sink.nodeMuted ? Theme.surfaceHover : sink.isDefault ? Theme.info : Theme.textMuted
                }
            }

            handle: Rectangle {
                x: volumeSlider.leftPadding + volumeSlider.availableWidth / 2 - width / 2
                y: volumeSlider.topPadding + volumeSlider.visualPosition * (volumeSlider.availableHeight - height)
                width: 16
                height: 16
                radius: 8
                color: sink.nodeMuted ? Theme.surfaceHover : sink.isDefault ? Theme.info : Theme.textMuted
                border.color: Theme.border
                border.width: 1
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 42
            color: Theme.textMuted
            font.pixelSize: 10
            horizontalAlignment: Text.AlignHCenter
            text: Math.round(sink.nodeVolume * 100) + "%"
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 60
            color: Theme.text
            elide: Text.ElideRight
            font.pixelSize: 9
            horizontalAlignment: Text.AlignHCenter
            maximumLineCount: 1
            text: sink.nodeLabel
        }

        MouseArea {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 38
            Layout.preferredHeight: 18
            acceptedButtons: Qt.LeftButton
            hoverEnabled: true

            Rectangle {
                anchors.fill: parent
                radius: 6
                color: parent.containsMouse ? Theme.surfaceHover : Theme.surface
                border.color: Theme.border
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    color: sink.nodeMuted ? Theme.warning : Theme.text
                    font.pixelSize: 10
                    text: sink.nodeMuted ? "on" : "off"
                }
            }

            onClicked: {
                if (sink.available) {
                    sink.trackedAudio.muted = !sink.nodeMuted;
                    root.refreshDelay.restart();
                }
            }
        }
    }
}
