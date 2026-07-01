import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme

BarPill {
    id: root

    property string temperature: "--°"
    property string condition: ""
    property string weatherCode: ""
    property string forecast: "Loading forecast..."

    function weatherIcon(code) {
        const value = Number(code);

        if (value === 113)
            return "☀";
        if ([116, 119, 122].includes(value))
            return "☁";
        if ([176, 263, 266, 293, 296, 353].includes(value))
            return "🌦";
        if ([179, 182, 185, 227, 230, 323, 326, 329, 332, 335, 338, 368, 371, 395].includes(value))
            return "❄";
        if ([200, 386, 389, 392].includes(value))
            return "⚡";
        if (value >= 143 && value <= 248)
            return "≋";
        if (value >= 299 && value <= 365)
            return "🌧";
        return "◌";
    }

    function escapeHtml(value) {
        return value.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
    }

    function ansiColor(code) {
        const colors = {
            30: Theme.overlay1,
            31: Theme.red,
            32: Theme.green,
            33: Theme.yellow,
            34: Theme.blue,
            35: Theme.mauve,
            36: Theme.sky,
            37: Theme.text,
            90: Theme.overlay2,
            91: Theme.red,
            92: Theme.green,
            93: Theme.yellow,
            94: Theme.blue,
            95: Theme.pink,
            96: Theme.teal,
            97: Theme.text
        };

        return colors[code] ?? null;
    }

    function ansiToHtml(value) {
        let result = "";
        let lastIndex = 0;
        let color = Theme.text;
        let bold = false;
        let spanOpen = false;
        const ansi = /\x1b\[([0-9;]*)m/g;

        function openSpan() {
            const weight = bold ? "; font-weight: 700" : "";
            result += `<span style="color: ${color}${weight}">`;
            spanOpen = true;
        }

        function closeSpan() {
            if (spanOpen) {
                result += "</span>";
                spanOpen = false;
            }
        }

        openSpan();

        for (let match = ansi.exec(value); match; match = ansi.exec(value)) {
            result += root.escapeHtml(value.slice(lastIndex, match.index));
            closeSpan();

            const codes = match[1] === "" ? [0] : match[1].split(";").map(Number);
            for (const code of codes) {
                const nextColor = root.ansiColor(code);

                if (code === 0) {
                    color = Theme.text;
                    bold = false;
                } else if (code === 1) {
                    bold = true;
                } else if (code === 22) {
                    bold = false;
                } else if (code === 39) {
                    color = Theme.text;
                } else if (nextColor) {
                    color = nextColor;
                }
            }

            openSpan();
            lastIndex = ansi.lastIndex;
        }

        result += root.escapeHtml(value.slice(lastIndex));
        closeSpan();

        return `<pre style="margin: 0; font-family: monospace">${result}</pre>`;
    }

    function refresh() {
        if (!weatherProcess.running) {
            weatherProcess.running = true;
        }

        if (!forecastProcess.running) {
            forecastProcess.running = true;
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
        id: hoverArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.refresh()
    }

    PopupWindow {
        id: forecastPopup

        visible: hoverArea.containsMouse
        color: "transparent"
        grabFocus: false
        implicitWidth: forecastFrame.implicitWidth
        implicitHeight: forecastFrame.implicitHeight

        anchor {
            item: root
            edges: Edges.Bottom
            gravity: Edges.Bottom
            adjustment: PopupAdjustment.SlideX | PopupAdjustment.FlipY
            margins.top: 8
        }

        Rectangle {
            id: forecastFrame

            color: Theme.crust
            border.color: Theme.surface1
            border.width: 1
            radius: 8
            implicitWidth: forecastText.implicitWidth + 24
            implicitHeight: forecastText.implicitHeight + 24

            Text {
                id: forecastText

                anchors.centerIn: parent
                color: Theme.text
                font.family: "monospace"
                font.pixelSize: 10
                lineHeight: 0.92
                textFormat: Text.RichText
                text: root.ansiToHtml(root.forecast)
            }
        }
    }

    Process {
        id: weatherProcess
        command: ["curl", "--fail", "--silent", "--show-error", "--max-time", "10", "https://wttr.in/Regensburg?format=j1",]

        stdout: StdioCollector {
            onStreamFinished: {
                if (!text.trim())
                    return;
                try {
                    const data = JSON.parse(text);
                    const current = data.current_condition?.[0];
                    if (!current)
                        return;
                    root.temperature = current.temp_C + "°C";
                    root.weatherCode = current.weatherCode;
                    root.condition = current.weatherDesc?.[0]?.value ?? "";
                } catch (error) {
                    console.warn("Could not parse weather response:", error);
                }
            }
        }
    }

    Process {
        id: forecastProcess
        command: ["curl", "--fail", "--silent", "--show-error", "--max-time", "10", "https://wttr.in/Regensburg?m",]

        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim()) {
                    root.forecast = text;
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
