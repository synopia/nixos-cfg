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
    property var from: 0
    property var to: 0
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
        const week = Math.floor((new Date().getTime() - laStart.getTime()) / 1000 / 60 / 60 / 24 / 7) - weekOffset;
        fetchAll(week);
    }
    function fetchAll(week) {
        root.from = (week) * 7 * 24 * 60 * 60 * 1000 + laStart.getTime();
        root.to = (week + 1) * 7 * 24 * 60 * 60 * 1000 + laStart.getTime();
        fetchData.running = true;
    }
    function setDpsMode(mode) {
        if (mode === "dps" || mode === "ndps" || mode === "rdps")
            dpsMode = mode;
    }
    function buildTable(data) {
        const raidBosses = {
            'Abyss Lord Kazeros': ["Final", 1],
            'Death Incarnate Kazeros': ["Final", 2],
            'Archdemon Kazeros': ["Final", 2],
            'Witch of Agony, Serca': ["Serca", 1],
            'Corvus Tul Rak': ["Serca", 2],
            'Archbishop Arcenos': ["Cath", 1],
            'Arcenos, Vanguard of Fanaticism': ["Cath", 2]
        };
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
        const result = ["Name", "Lvl", "Final 1", "Final 2", "Serca 1", "Serca 2", "Cath 1", "Cath 2"];
        let lastPlayer = "";
        let playerIndex = 0;
        for (const run of data) {
            if (run.local_player !== lastPlayer) {
                result.push(run.local_player);
                for (let i = 0; i < 7; i++) {
                    result.push("");
                }
                lastPlayer = run.local_player;
                playerIndex++;
                result[playerIndex * 8] = run.local_player;
                result[playerIndex * 8 + 1] = Math.round(run.item_level);
            }
            const [raid, gate] = raidBosses[run.current_boss] ?? [];
            if (!raid) {
                continue;
            }
            const raidIndex = raids.findIndex(r => r.raid === raid);
            const color = raids[raidIndex].colors[run.difficulty];

            const dps = run.rcon > 20 ? `${Math.round(run.rcon * 10) / 10}%` : `${Math.round((run[root.dpsMode] ?? 0) / 1000 / 1000)}M`;
            result[playerIndex * 8 + 1 + 2 * raidIndex + gate] = `<b style="color:${color}">${dps}</b>`;
        }
        return result;
    }

    Process {
        id: fetchData

        command: ["sqlite3", "-json", "/home/synopia/.local/share/xyz.snow.loa-logs/encounters.db", `select
            max(fight_start) as start,
            local_player, max(entity.gear_score) as item_level,
            current_boss,
            difficulty, max(my_rdps) as rdps, max(my_ndps) as ndps, max(my_dps) as dps, 100*cast(rdps_damage_given as real)/cast((encounter.total_damage_dealt-unbuffed_damage) as real) as rcon
        from encounter_preview
        join entity on entity.encounter_id=encounter_preview.id and entity.name=encounter_preview.local_player
        join encounter on encounter.id=encounter_preview.id
        where cleared=1 and fight_start>=${root.from} and fight_start<${root.to}
        group by local_player, current_boss
        order by item_level desc, local_player, max(fight_start);`]

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
