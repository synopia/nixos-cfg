import QtQuick
import qs.theme

Row {
    required property string label
    required property string value
    property int valueWidth: 0

    spacing: 3

    Text {
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.textMuted
        font.pixelSize: 9
        font.weight: Font.Bold
        text: parent.label
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.valueWidth > 0 ? parent.valueWidth : implicitWidth
        color: Theme.text
        font.pixelSize: 10
        horizontalAlignment: Text.AlignRight
        text: parent.value
    }
}
