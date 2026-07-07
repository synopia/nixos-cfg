pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import qs.theme

BarPill {
    id: root

    visible: SystemTray.items.values.length > 0

    content: Row {
        spacing: 4

        Repeater {
            model: ScriptModel {
                values: SystemTray.items.values.filter(
                    item => item.status !== Status.Passive
                )
            }

            delegate: TrayIcon {
                required property SystemTrayItem modelData
                item: modelData
            }
        }
    }
}
