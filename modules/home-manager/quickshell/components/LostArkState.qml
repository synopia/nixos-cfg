import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Controls
import qs.theme
import qs.services

BarPill {
    id: root

    property bool screenshotSelecting: false
    property bool popupOpen: false
    property bool detailWindowOpen: false
    property bool reservationEditorOpen: false
    property var reservationCell: ({})
    property var weekdayOptions: []
    property var difficultyOptions: []
    readonly property var editorScreen: QsWindow.window?.screen ?? Quickshell.screens[0]
    property int selectedWeekdayIndex: 0
    property int selectedHourIndex: 0
    property int selectedDifficultyIndex: 0

    function showPopup() {
        closeTimer.stop();
        popupOpen = true;
    }

    function maybeClosePopup() {
        if (!hoverArea.containsMouse && !popupHoverHandler.hovered && !screenshotSelecting)
            closeTimer.restart();
    }

    function weekLabel() {
        if (LOALogs.weekOffset === 0)
            return "This week";
        if (LOALogs.weekOffset > 0) {
            const suffix = LOALogs.weekOffset === 1 ? "" : "s";
            return LOALogs.weekOffset + " week" + suffix + " ago";
        }
        const futureWeeks = -LOALogs.weekOffset;
        return futureWeeks === 1 ? "Next week" : futureWeeks + " weeks ahead";
    }

    function weekBadge() {
        if (LOALogs.weekOffset === 0)
            return "";
        return LOALogs.weekOffset > 0 ? "-" + LOALogs.weekOffset : "+" + (-LOALogs.weekOffset);
    }

    function openDetailWindow() {
        detailWindowOpen = true;
        Qt.callLater(() => {
            detailWindow.raise();
            detailWindow.requestActivate();
        });
    }

    function openReservationEditor(cell) {
        if (!cell.editable || LOALogs.weekOffset > 0)
            return;

        reservationCell = cell;
        weekdayOptions = LOALogs.reservationWeekdays();
        difficultyOptions = LOALogs.difficultyOptions(cell.raid);
        selectedWeekdayIndex = 0;
        selectedHourIndex = 0;
        selectedDifficultyIndex = 0;
        descriptionField.text = "";

        if (cell.planned) {
            for (let i = 0; i < weekdayOptions.length; i++) {
                if (weekdayOptions[i].value === cell.planned.weekday) {
                    selectedWeekdayIndex = i;
                    break;
                }
            }
            const hourIndex = LOALogs.hourOptions.findIndex(option => option.value === LOALogs.normalizeTime(cell.planned.hour));
            selectedHourIndex = Math.max(0, hourIndex);
            const difficultyIndex = difficultyOptions.findIndex(option => option.value === cell.planned.difficulty);
            selectedDifficultyIndex = Math.max(0, difficultyIndex);
            descriptionField.text = cell.planned.description;
        }

        reservationEditorOpen = true;
        Qt.callLater(() => descriptionField.forceActiveFocus());
    }

    function closeReservationEditor() {
        reservationEditorOpen = false;
        reservationCell = ({});
        root.maybeClosePopup();
    }

    content: Row {
        property color accent: Theme.mauve

        Text {
            color: parent.accent
            font.pixelSize: 9
            font.weight: Font.Bold

            text: "LOA " + root.weekBadge()
        }
    }
    MouseArea {
        id: hoverArea

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        onContainsMouseChanged: {
            if (containsMouse)
                root.showPopup();
            else
                root.maybeClosePopup();
        }

        onClicked: root.openDetailWindow()
    }
    PopupWindow {
        id: loaOverview

        property var cols: LOALogs.overviewHeaders.length
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

            implicitWidth: overviewFrame.implicitWidth
            implicitHeight: overviewFrame.implicitHeight + 8
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
                id: overviewFrame

                anchors {
                    top: parent.top
                    topMargin: 8
                    horizontalCenter: parent.horizontalCenter
                }
                color: Theme.crust
                border.color: Theme.surface1
                border.width: 1
                radius: 8
                implicitWidth: overviewGrid.implicitWidth + 24
                implicitHeight: overviewGrid.implicitHeight + 24
                width: implicitWidth
                height: implicitHeight

                GridLayout {
                    id: overviewGrid

                    anchors.centerIn: parent
                    columns: loaOverview.cols
                    rowSpacing: 1
                    columnSpacing: 1

                    Repeater {
                        model: LOALogs.overviewData

                        Rectangle {
                            required property var modelData
                            required property int index
                            readonly property bool isHeader: modelData.type === "header" || modelData.type === "character"
                            readonly property bool canPlan: modelData.editable && LOALogs.weekOffset <= 0 && ((modelData.text === "" && modelData.clearCount === 0) || modelData.planned)

                            Layout.preferredWidth: index % loaOverview.cols === 0 ? 96 : 62
                            Layout.preferredHeight: 26
                            color: index < loaOverview.cols || (index % loaOverview.cols === 0) ? Theme.surface0 : canPlan && modelData.planned ? Theme.surface1 : cellMouse.containsMouse && canPlan ? Theme.surface0 : Theme.mantle
                            border.color: canPlan && modelData.planned ? modelData.planned.color : Theme.mantle
                            border.width: canPlan && modelData.planned ? 1 : 0
                            opacity: modelData.inactive && index >= loaOverview.cols ? 0.45 : 1

                            Text {
                                anchors.centerIn: parent
                                width: parent.width - 8
                                color: parent.canPlan && modelData.text === "" ? Theme.overlay1 : Theme.text
                                font.family: "monospace"
                                font.pixelSize: 10
                                font.bold: parent.isHeader
                                textFormat: Text.RichText
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                                text: modelData.text !== "" ? modelData.text : modelData.statusText
                            }

                            MouseArea {
                                id: cellMouse

                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                enabled: parent.canPlan
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: mouse => {
                                    if (mouse.button === Qt.RightButton && modelData.planned) {
                                        LOALogs.removeReservation(modelData.character, modelData.raid);
                                        root?.closeReservationEditor();
                                    } else if (mouse.button === Qt.LeftButton) {
                                        root?.openReservationEditor(modelData);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Window {
        id: detailWindow

        visible: root.detailWindowOpen
        title: "LOA State"
        color: Theme.crust
        minimumWidth: 940
        minimumHeight: 360
        width: Math.max(minimumWidth, Math.max(detailGrid.implicitWidth, controls.implicitWidth, dpsModeControls.implicitWidth) + 32)
        height: Math.max(minimumHeight, detailContent.implicitHeight + 32)

        onClosing: close => {
            close.accepted = false;
            root.detailWindowOpen = false;
        }

        Rectangle {
            anchors.fill: parent
            color: Theme.crust

            ColumnLayout {
                id: detailContent

                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    margins: 16
                }
                width: Math.max(detailGrid.implicitWidth, controls.implicitWidth, dpsModeControls.implicitWidth)
                spacing: 8

                RowLayout {
                    id: controls

                    Layout.fillWidth: true
                    spacing: 8

                    LoaWeekButton {
                        label: "<"
                        onClicked: {
                            root.closeReservationEditor();
                            LOALogs.prevWeek();
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        color: Theme.text
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignHCenter
                        text: root.weekLabel()
                    }

                    LoaWeekButton {
                        label: ">"
                        enabled: LOALogs.weekOffset > -1
                        onClicked: {
                            root.closeReservationEditor();
                            LOALogs.nextWeek();
                        }
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
                    id: detailGrid

                    columns: LOALogs.detailColumns
                    rowSpacing: 1
                    columnSpacing: 1

                    Repeater {
                        model: LOALogs.data

                        Rectangle {
                            required property var modelData
                            required property int index
                            readonly property bool isHeader: modelData.type === "header" || modelData.type === "character"
                            readonly property bool canPlan: modelData.editable && LOALogs.weekOffset <= 0 && (modelData.text === "" || modelData.planned)
                            readonly property int columnSpan: modelData.span || 1

                            Layout.columnSpan: columnSpan
                            Layout.preferredWidth: 90 * columnSpan + (columnSpan - 1)
                            Layout.preferredHeight: 28
                            color: modelData.type === "header" || modelData.type === "character" ? Theme.surface0 : canPlan && modelData.planned ? Theme.surface1 : cellMouse.containsMouse && canPlan ? Theme.surface0 : Theme.mantle
                            border.color: canPlan && modelData.planned ? modelData.planned.color : Theme.mantle
                            border.width: canPlan && modelData.planned ? 1 : 0
                            opacity: modelData.inactive && modelData.type !== "header" ? 0.45 : 1

                            Text {
                                anchors.centerIn: parent
                                width: parent.width - 8
                                color: parent.canPlan && modelData.text === "" ? Theme.overlay1 : Theme.text
                                font.family: "monospace"
                                font.pixelSize: 10
                                font.bold: parent.isHeader
                                textFormat: Text.RichText
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                                text: modelData.text
                            }

                            MouseArea {
                                id: cellMouse

                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                enabled: parent.canPlan
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: mouse => {
                                    if (mouse.button === Qt.RightButton && modelData.planned) {
                                        LOALogs.removeReservation(modelData.character, modelData.raid);
                                        root?.closeReservationEditor();
                                    } else if (mouse.button === Qt.LeftButton) {
                                        root?.openReservationEditor(modelData);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    PanelWindow {
        id: reservationWindow

        visible: root.reservationEditorOpen
        screen: root.editorScreen
        color: "transparent"
        exclusiveZone: 0

        WlrLayershell.namespace: "quickshell:loa-reservation-editor"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: root.reservationEditorOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        mask: Region {
            item: reservationDialog
        }

        Rectangle {
            id: reservationDialog

            width: 520
            height: implicitHeight
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 300
            }
            implicitWidth: 520
            implicitHeight: reservationContent.implicitHeight + 18
            radius: 6
            color: Theme.base
            border.color: Theme.surface2
            border.width: 1

            ColumnLayout {
                id: reservationContent

                anchors.centerIn: parent
                width: parent.width - 18
                spacing: 8

                Text {
                    Layout.fillWidth: true
                    color: Theme.text
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    text: root.reservationCell.character ? `${root.reservationCell.character} - ${root.reservationCell.raid}` : ""
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    ComboBox {
                        id: weekdayCombo

                        Layout.preferredWidth: 140
                        model: root.weekdayOptions
                        textRole: "label"
                        currentIndex: root.selectedWeekdayIndex
                        onActivated: index => root.selectedWeekdayIndex = index
                    }

                    ComboBox {
                        id: hourCombo

                        Layout.preferredWidth: 92
                        model: LOALogs.hourOptions
                        textRole: "label"
                        currentIndex: root.selectedHourIndex
                        displayText: currentValue ? currentValue.label : ""
                        delegate: ItemDelegate {
                            width: hourCombo.width
                            text: modelData.label
                        }
                        onActivated: index => root.selectedHourIndex = index
                    }

                    ComboBox {
                        id: difficultyCombo

                        Layout.preferredWidth: 118
                        model: root.difficultyOptions
                        textRole: "label"
                        currentIndex: root.selectedDifficultyIndex
                        displayText: currentValue ? currentValue.label : ""
                        delegate: ItemDelegate {
                            width: difficultyCombo.width
                            text: modelData.label
                        }
                        onActivated: index => root.selectedDifficultyIndex = index
                    }

                    TextField {
                        id: descriptionField

                        Layout.fillWidth: true
                        maximumLength: 48
                        placeholderText: "Description"
                        selectByMouse: true
                        focus: root.reservationEditorOpen
                        activeFocusOnPress: true
                        font.pixelSize: 11
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: 6

                    LoaActionButton {
                        label: "Remove"
                        visible: !!root.reservationCell.planned
                        danger: true
                        onClicked: {
                            LOALogs.removeReservation(root.reservationCell.character, root.reservationCell.raid);
                            root.closeReservationEditor();
                        }
                    }

                    LoaActionButton {
                        label: "Cancel"
                        onClicked: root.closeReservationEditor()
                    }

                    LoaActionButton {
                        label: "Confirm"
                        primary: true
                        enabled: descriptionField.text.trim().length > 0 && root.weekdayOptions.length > 0 && root.difficultyOptions.length > 0
                        onClicked: {
                            const weekday = root.weekdayOptions[root.selectedWeekdayIndex].value;
                            const hour = LOALogs.hourOptions[root.selectedHourIndex].value;
                            const difficulty = root.difficultyOptions[root.selectedDifficultyIndex].value;
                            LOALogs.setReservation(root.reservationCell.character, root.reservationCell.raid, weekday, hour, difficulty, descriptionField.text);
                            root.closeReservationEditor();
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

    component LoaActionButton: Rectangle {
        id: button

        signal clicked

        property string label: ""
        property bool primary: false
        property bool danger: false

        Layout.preferredWidth: 72
        Layout.preferredHeight: 24
        radius: 5
        color: primary ? Theme.mauve : danger ? Theme.red : buttonMouse.containsMouse && enabled ? Theme.surface2 : Theme.surface0
        border.color: primary ? Theme.mauve : danger ? Theme.red : Theme.surface1
        border.width: 1
        opacity: enabled ? 1 : 0.45

        Text {
            anchors.centerIn: parent
            color: button.primary || button.danger ? Theme.crust : Theme.text
            font.pixelSize: 9
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
}
