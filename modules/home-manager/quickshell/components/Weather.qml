import QtQuick
import Quickshell.Io
import qs.theme

BarPill {
    id: root

    property string temperature: "--°"
    property string condition: ""
    property string weatherCode: ""

    function weatherIcon(code) {
        const value = Number(code)

        if (value === 113) return "☀"
        if ([116, 119, 122].includes(value)) return "☁"
        if ([176, 263, 266, 293, 296, 353].includes(value)) return "🌦"
        if ([179, 182, 185, 227, 230, 323, 326, 329, 332, 335, 338, 368, 371, 395].includes(value)) return "❄"
        if ([200, 386, 389, 392].includes(value)) return "⚡"
        if (value >= 143 && value <= 248) return "≋"
        if (value >= 299 && value <= 365) return "🌧"
        return "◌"
    }

    function refresh() {
        if (!weatherProcess.running) {
            weatherProcess.running = true
        }
    }

    content: Row {
        spacing: 5

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.yellow
            font.pixelSize: 13
            text: root.weatherIcon(root.weatherCode)
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.text
            font.pixelSize: 11
            text: root.temperature
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.refresh()
    }

    Process {
        id: weatherProcess
        command: [
            "curl",
            "--fail",
            "--silent",
            "--show-error",
            "--max-time",
            "10",
            "https://wttr.in/?format=j1",
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                if (!text.trim()) return

                try {
                    const data = JSON.parse(text)
                    const current = data.current_condition?.[0]
                    if (!current) return

                    root.temperature = current.temp_C + "°C"
                    root.weatherCode = current.weatherCode
                    root.condition = current.weatherDesc?.[0]?.value ?? ""
                } catch (error) {
                    console.warn("Could not parse weather response:", error)
                }
            }
        }
    }

    Timer {
        interval: 15 * 60 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
