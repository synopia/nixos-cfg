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
    property var from: 0
    property var to: 0
    property var weekOffset: 0

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

    Process {
        id: fetchData

        command: ["sqlite3", "-json", "/home/synopia/.local/share/xyz.snow.loa-logs/encounters.db", `select
            max(fight_start) as start,
            local_player, max(entity.gear_score) as item_level,
            current_boss,
            difficulty, max(my_rdps) as rdps, max(my_ndps) as ndps, max(my_dps) as dps
        from encounter_preview
        join entity on entity.name=encounter_preview.local_player
        where cleared=1 and fight_start>=${root.from} and fight_start<${root.to}
        group by local_player, current_boss
        order by item_level desc, local_player, max(fight_start);`]

        stdout: StdioCollector {
            function buildTable(data) {
                const raids = {
                    'Abyss Lord Kazeros': 0,
                    'Death Incarnate Kazeros': 1,
                    'Archdemon Kazeros': 1,
                    'Witch of Agony, Serca': 2,
                    'Corvus Tul Rak': 3,
                    'Archbishop Arcenos': 4,
                    'Arcenos, Vanguard of Fanaticism': 5
                };
                const colors = {
                    "Normal": Theme.overlay1,
                    "Hard": Theme.teal,
                    "Nightmare": Theme.accent,
                    "Level 1": Theme.overlay1,
                    "Level 2": Theme.teal,
                    "Level 3": Theme.accent
                };
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

                    const bossIndex = raids[run.current_boss] + 2;
                    const color = colors[run.difficulty];
                    result[playerIndex * 8 + bossIndex] = `<b style="color:${color}">${Math.round(run.rdps / 1000 / 1000)}M</b>`;
                }
                return result;
            }
            onStreamFinished: {
                if (text.trim()) {
                    const data = JSON.parse(text);
                    root.data = buildTable(data);
                } else {
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
