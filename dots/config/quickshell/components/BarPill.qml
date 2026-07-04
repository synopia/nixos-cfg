import QtQuick
import qs.theme

Rectangle {
    id: root

    property alias content: slot.data
    property int padX: 8
    property int padY: 4

    radius: height / 2
    color: Colors.md3.surface_container
    border.color: Colors.md3.surface_container_high
    border.width: 1

    implicitWidth: slot.implicitWidth + padX * 2
    implicitHeight: 30

    Item {
        id: slot
        anchors.centerIn: parent
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
