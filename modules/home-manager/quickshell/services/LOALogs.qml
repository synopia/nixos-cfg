pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.LocalStorage
import qs.theme

Singleton {
    id: root
    Component.onCompleted: {
        refresh();
    }
    readonly property var laStart: new Date("2024-01-03T09:00:00")
    property var data: []
    property var rawData: []
    property var weekOffset: 0
    property string dpsMode: "ndps"

    onDpsModeChanged: data = buildTable(rawData)

    function prevWeek() {
        weekOffset++;
        refresh();
    }
    function nextWeek() {
        weekOffset = Math.max(0, weekOffset - 1);
        refresh();
    }
    function refresh() {
        fetchData.running = true;
    }
    function setDpsMode(mode) {
        if (mode === "dps" || mode === "ndps" || mode === "rdps")
            dpsMode = mode;
    }
    function customRound(num, decimalPlaces = 1) {
        const p = Math.pow(10, decimalPlaces);
        const n = num * p * (1 + Number.EPSILON);
        return (Math.round(n) / p).toString();
    }

    function abbreviateNumber(n, round = 2) {
        if (n >= 1e3 && n < 1e6)
            return (n / 1e3).toFixed(1) + "k";
        if (n >= 1e6 && n < 1e9)
            return +(n / 1e6).toFixed(1) + "m";
        if (n >= 1e9 && n < 1e12)
            return +(n / 1e9).toFixed(round) + "b";
        if (n >= 1e12)
            return +(n / 1e12).toFixed(round) + "t";
        else
            return parseInt(n).toFixed(0);
    }
    function buildTable(data) {
        const baseColors = {
            lvl1: Theme.overlay1,
            lvl2: Theme.teal,
            lvl3: Theme.accent
        };
        const raids = [
            {
                raid: "Final",
                colors: {
                    "Normal": baseColors.lvl1,
                    "Hard": baseColors.lvl3
                }
            },
            {
                raid: "Serca",
                colors: {
                    "Normal": baseColors.lvl1,
                    "Hard": baseColors.lvl2,
                    "Nightmare": baseColors.lvl3
                }
            },
            {
                raid: "Cath",
                colors: {
                    "Level 1": baseColors.lvl1,
                    "Level 2": baseColors.lvl2,
                    "Level 3": baseColors.lvl3
                }
            }
        ];
        const buffColors = ["#ee9090", "#90ee90", "#eeee90", "#9090ee"];
        const head = ["Name", "Lvl", "CP", "Final Act: Kazeros G1", "Final Act: Kazeros G2", "Serca G1", "Serca G2", "Horizon Cathedral G1", "Horizon Cathedral G2"];
        const result = [...head];
        let lastPlayer = "";
        let playerIndex = 0;
        for (const run of data) {
            if (run.name !== lastPlayer) {
                result.push(run.name);
                result.push(Math.round(run.itemLevel));
                result.push(Math.round(run.combatPower));
                for (let i = 0; i < head.length - 3; i++) {
                    result.push("");
                }
                lastPlayer = run.name;
                playerIndex++;
            }
            for (const raid of Object.keys(run.raids)) {
                const headIndex = head.findIndex(r => r === raid);
                if (headIndex === -1) {
                    continue;
                }
                const raidIndex = Math.floor((headIndex - 3) / 2);
                const gateIndex = (headIndex - 3) % 2;
                const session = run.raids[raid];
                const color = raids[raidIndex].colors[session.difficulty];
                if (session.performance.type === "dps") {
                    const {
                        rdps,
                        dpsCon,
                        supCon,
                        ndps,
                        dps
                    } = session.performance;
                    result[playerIndex * head.length + 3 + 2 * raidIndex + gateIndex] = `<b style="color:${color}">${abbreviateNumber(customRound(ndps))}/${abbreviateNumber(customRound(dps))}</b><br>+${customRound(100 * supCon, 0)}%+${customRound(100 * dpsCon, 0)}%`;
                } else {
                    const {
                        rdps,
                        rcon,
                        uptimes
                    } = session.performance;
                    result[playerIndex * head.length + 3 + 2 * raidIndex + gateIndex] = `${uptimes.map((u, i) => `<b style="color:${buffColors[i]}">${customRound(u * 100, 0)}</b>`).join("·")}<br>+${customRound(100 * rcon, 0)}%`;
                }
            }
        }
        return result;
    }

    Process {
        id: fetchData

        command: ["/home/synopia/.local/bin/loa-state", root.weekOffset, `2>/dev/null`]

        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim()) {
                    const data = JSON.parse(text);
                    root.rawData = data;
                    root.data = root.buildTable(data);
                } else {
                    root.rawData = [];
                    root.data = [];
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
