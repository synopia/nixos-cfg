pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.LocalStorage
import qs.theme

Singleton {
    id: root

    readonly property var laStart: new Date("2024-01-03T09:00:00")
    readonly property var headers: ["Name", "Lvl", "CP", "Final Act: Kazeros G1", "Final Act: Kazeros G2", "Serca G1", "Serca G2", "Horizon Cathedral G1", "Horizon Cathedral G2"]
    readonly property var hourOptions: [17, 18, 19, 20, 21, 22]
    property var data: []
    property var rawData: []
    property var reservations: ({})
    property var weekOffset: 0
    property string dpsMode: "ndps"

    onDpsModeChanged: data = buildTable(rawData)

    function db() {
        const db = LocalStorage.openDatabaseSync("LOALogs", "1.0", "Lost Ark planning", 100000);
        db.transaction(tx => {
            tx.executeSql("CREATE TABLE IF NOT EXISTS reservations(key TEXT PRIMARY KEY, character TEXT NOT NULL, raid TEXT NOT NULL, weekday INTEGER NOT NULL, hour INTEGER NOT NULL, description TEXT NOT NULL)");
        });
        return db;
    }
    function loadReservations() {
        const loaded = {};
        db().readTransaction(tx => {
            const rows = tx.executeSql("SELECT key, character, raid, weekday, hour, description FROM reservations");
            for (let i = 0; i < rows.rows.length; i++) {
                const row = rows.rows.item(i);
                loaded[row.key] = {
                    key: row.key,
                    character: row.character,
                    raid: row.raid,
                    weekday: row.weekday,
                    hour: row.hour,
                    description: row.description
                };
            }
        });
        reservations = loaded;
    }
    function reservationKey(character, raid) {
        return `${character}\u001f${raid}`;
    }
    function setReservation(character, raid, weekday, hour, description) {
        const key = reservationKey(character, raid);
        const cleanDescription = description.trim().slice(0, 48);
        db().transaction(tx => {
            tx.executeSql("INSERT OR REPLACE INTO reservations(key, character, raid, weekday, hour, description) VALUES(?, ?, ?, ?, ?, ?)", [key, character, raid, weekday, hour, cleanDescription]);
        });
        loadReservations();
        data = buildTable(rawData);
    }
    function removeReservation(character, raid) {
        const key = reservationKey(character, raid);
        db().transaction(tx => {
            tx.executeSql("DELETE FROM reservations WHERE key = ?", [key]);
        });
        loadReservations();
        data = buildTable(rawData);
    }
    function reservationWeekdays() {
        const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        const today = new Date();
        const todayIndex = today.getDay();
        const daysUntilTuesday = (2 - todayIndex + 7) % 7;
        const result = [];
        for (let offset = 0; offset <= daysUntilTuesday; offset++) {
            const date = new Date(today);
            date.setDate(today.getDate() + offset);
            const weekday = date.getDay();
            result.push({
                label: offset === 0 ? `Today (${days[weekday]})` : days[weekday],
                value: weekday
            });
        }
        return result;
    }
    function weekdayLabel(weekday) {
        return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][weekday] || "";
    }
    function escapeHtml(text) {
        return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
    }
    function makeCell(text, type, character, raid, editable, planned) {
        return {
            text: text,
            type: type,
            character: character || "",
            raid: raid || "",
            editable: !!editable,
            planned: planned || null
        };
    }
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
        const head = headers;
        const result = head.map(h => makeCell(h, "header"));
        let lastPlayer = "";
        let playerIndex = 0;
        for (const run of data) {
            if (run.name !== lastPlayer) {
                result.push(makeCell(run.name, "character"));
                result.push(makeCell(Math.round(run.itemLevel).toString(), "stat"));
                result.push(makeCell(Math.round(run.combatPower).toString(), "stat"));
                for (let i = 0; i < head.length - 3; i++) {
                    const raid = head[i + 3];
                    const reservation = reservations[reservationKey(run.name, raid)];
                    const plannedText = reservation && weekOffset === 0 ? `<b style="color:${Theme.yellow}">${weekdayLabel(reservation.weekday)} ${reservation.hour}:00</b><br>${escapeHtml(reservation.description)}` : "";
                    result.push(makeCell(plannedText, "raid", run.name, raid, weekOffset === 0, reservation || null));
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
                const cellIndex = playerIndex * head.length + 3 + 2 * raidIndex + gateIndex;
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
                    result[cellIndex].text = `<b style="color:${color}">${abbreviateNumber(customRound(ndps))}/${abbreviateNumber(customRound(dps))}</b><br>+${customRound(100 * supCon, 0)}%+${customRound(100 * dpsCon, 0)}%`;
                    result[cellIndex].planned = null;
                } else {
                    const {
                        rdps,
                        rcon,
                        uptimes
                    } = session.performance;
                    result[cellIndex].text = `${uptimes.map((u, i) => `<b style="color:${buffColors[i]}">${customRound(u * 100, 0)}</b>`).join("·")}<br>+${customRound(100 * rcon, 0)}%`;
                    result[cellIndex].planned = null;
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

    Component.onCompleted: {
        loadReservations();
        refresh();
    }
}
