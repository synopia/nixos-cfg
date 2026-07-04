pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.LocalStorage
import qs.theme

Singleton {
    id: root

    readonly property var laStart: new Date("2024-01-03T09:00:00")
    readonly property var headers: ["Name", "Lvl", "CP", "Final Act: Kazeros", "Serca", "Horizon Cathedral"]
    readonly property int detailColumns: 9
    readonly property var overviewHeaders: ["Name", "Lvl", "CP", "Final", "Serca", "Cath"]
    readonly property var hourOptions: [
        {
            label: "17:00",
            value: 1020
        },
        {
            label: "17:30",
            value: 1050
        },
        {
            label: "18:00",
            value: 1080
        },
        {
            label: "18:30",
            value: 1110
        },
        {
            label: "19:00",
            value: 1140
        },
        {
            label: "19:30",
            value: 1170
        },
        {
            label: "20:00",
            value: 1200
        },
        {
            label: "20:30",
            value: 1230
        },
        {
            label: "21:00",
            value: 1260
        },
        {
            label: "21:30",
            value: 1290
        },
        {
            label: "22:00",
            value: 1320
        }
    ]
    property var data: []
    property var overviewData: []
    property var rawData: []
    property var reservations: ({})
    property var weekOffset: 0
    property string dpsMode: "ndps"

    onDpsModeChanged: rebuildTables()

    function db() {
        const db = LocalStorage.openDatabaseSync("LOALogs", "1.0", "Lost Ark planning", 100000);
        db.transaction(tx => {
            tx.executeSql("CREATE TABLE IF NOT EXISTS reservations(key TEXT PRIMARY KEY, character TEXT NOT NULL, raid TEXT NOT NULL, weekday INTEGER NOT NULL, hour INTEGER NOT NULL, description TEXT NOT NULL)");
            try {
                tx.executeSql("ALTER TABLE reservations ADD COLUMN difficulty TEXT NOT NULL DEFAULT ''");
            } catch (error) {}
        });
        return db;
    }
    function loadReservations() {
        const loaded = {};
        db().readTransaction(tx => {
            const rows = tx.executeSql("SELECT key, character, raid, weekday, hour, description, difficulty FROM reservations");
            for (let i = 0; i < rows.rows.length; i++) {
                const row = rows.rows.item(i);
                const raid = canonicalRaid(row.raid);
                const key = reservationKey(row.character, raid);
                const difficulty = validDifficulty(raid, row.difficulty);
                loaded[key] = {
                    key: key,
                    character: row.character,
                    raid: raid,
                    weekday: row.weekday,
                    hour: normalizeTime(row.hour),
                    difficulty: difficulty,
                    color: raidColor(raid, difficulty),
                    description: row.description
                };
            }
        });
        reservations = loaded;
    }
    function raidGroups() {
        return [
            {
                raid: "Final",
                gates: ["Final Act: Kazeros G1", "Final Act: Kazeros G2"],
                colors: {
                    "Normal": Theme.text,
                    "Hard": Theme.yellow
                }
            },
            {
                raid: "Serca",
                gates: ["Serca G1", "Serca G2"],
                colors: {
                    "Normal": Theme.text,
                    "Hard": Theme.yellow,
                    "Nightmare": Theme.red
                }
            },
            {
                raid: "Cath",
                gates: ["Horizon Cathedral G1", "Horizon Cathedral G2"],
                colors: {
                    "Level 1": Theme.text,
                    "Level 2": Theme.yellow,
                    "Level 3": Theme.red
                }
            }
        ];
    }
    function raidGroup(raid) {
        const canonical = canonicalRaid(raid);
        return raidGroups().find(group => group.raid === canonical) || null;
    }
    function canonicalRaid(raid) {
        for (const group of raidGroups()) {
            if (raid === group.raid || group.gates.includes(raid))
                return group.raid;
        }
        return raid || "";
    }
    function difficultyOptions(raid) {
        const group = raidGroup(raid);
        if (!group)
            return [];
        return Object.keys(group.colors).map(difficulty => ({
                    label: difficulty,
                    value: difficulty,
                    color: group.colors[difficulty]
                }));
    }
    function validDifficulty(raid, difficulty) {
        const options = difficultyOptions(raid);
        if (options.some(option => option.value === difficulty))
            return difficulty;
        return options.length > 0 ? options[0].value : "";
    }
    function raidColor(raid, difficulty) {
        const group = raidGroup(raid);
        if (!group)
            return Theme.yellow;
        return group.colors[validDifficulty(raid, difficulty)] || Theme.yellow;
    }
    function normalizeTime(value) {
        const number = Number(value);
        if (!Number.isFinite(number))
            return hourOptions[0].value;
        return number < 24 ? number * 60 : number;
    }
    function timeLabel(value) {
        const normalized = normalizeTime(value);
        const option = hourOptions.find(option => option.value === normalized);
        if (option)
            return option.label;
        const hour = Math.floor(normalized / 60).toString().padStart(2, "0");
        const minute = (normalized % 60).toString().padStart(2, "0");
        return `${hour}:${minute}`;
    }
    function reservationKey(character, raid) {
        return `${character}\u001f${canonicalRaid(raid)}`;
    }
    function reservationRaidNames(raid) {
        const canonical = canonicalRaid(raid);
        for (const group of raidGroups()) {
            if (group.raid === canonical)
                return [group.raid].concat(group.gates);
        }
        return [canonical];
    }
    function setReservation(character, raid, weekday, hour, difficulty, description) {
        const canonical = canonicalRaid(raid);
        const key = reservationKey(character, canonical);
        const cleanDescription = description.trim().slice(0, 48);
        const cleanDifficulty = validDifficulty(canonical, difficulty);
        const startTime = normalizeTime(hour);
        db().transaction(tx => {
            for (const oldRaid of reservationRaidNames(canonical)) {
                tx.executeSql("DELETE FROM reservations WHERE key = ?", [reservationKey(character, oldRaid)]);
                tx.executeSql("DELETE FROM reservations WHERE character = ? AND raid = ?", [character, oldRaid]);
            }
            tx.executeSql("INSERT OR REPLACE INTO reservations(key, character, raid, weekday, hour, description, difficulty) VALUES(?, ?, ?, ?, ?, ?, ?)", [key, character, canonical, weekday, startTime, cleanDescription, cleanDifficulty]);
        });
        loadReservations();
        rebuildTables();
    }
    function removeReservation(character, raid) {
        db().transaction(tx => {
            for (const oldRaid of reservationRaidNames(raid)) {
                tx.executeSql("DELETE FROM reservations WHERE key = ?", [reservationKey(character, oldRaid)]);
                tx.executeSql("DELETE FROM reservations WHERE character = ? AND raid = ?", [character, oldRaid]);
            }
        });
        loadReservations();
        rebuildTables();
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
    function plannedText(reservation) {
        if (!reservation || weekOffset > 0)
            return "";
        return `<b style="color:${reservation.color}">${weekdayLabel(reservation.weekday)} ${timeLabel(reservation.hour)}</b><br>${escapeHtml(reservation.description)}`;
    }
    function makeCell(text, type, character, raid, editable, planned, inactive, span) {
        return {
            text: text,
            type: type,
            character: character || "",
            raid: raid || "",
            editable: !!editable,
            planned: planned || null,
            inactive: !!inactive,
            span: span || 1
        };
    }
    function prevWeek() {
        weekOffset++;
        refresh();
    }
    function nextWeek() {
        weekOffset = Math.max(-1, weekOffset - 1);
        refresh();
    }
    function refresh() {
        fetchData.running = true;
    }
    function setDpsMode(mode) {
        if (mode === "dps" || mode === "ndps" || mode === "rdps")
            dpsMode = mode;
    }
    function rebuildTables() {
        data = buildTable(rawData);
        overviewData = buildOverviewTable(rawData);
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
    function characterRaidSummaries(data) {
        const summaries = {};
        for (const run of data) {
            if (!summaries[run.name])
                summaries[run.name] = {};
            for (const group of raidGroups()) {
                const current = summaries[run.name][group.raid] || 0;
                const cleared = group.gates.filter(gate => run.raids[gate]).length;
                summaries[run.name][group.raid] = Math.max(current, cleared);
            }
        }
        return summaries;
    }
    function completedRaidCount(summaries, character) {
        let count = 0;
        const characterSummary = summaries[character] || {};
        for (const group of raidGroups()) {
            if ((characterSummary[group.raid] || 0) > 0)
                count++;
        }
        return count;
    }
    function buildTable(data) {
        const raids = raidGroups();
        const buffColors = ["#ee9090", "#90ee90", "#eeee90", "#9090ee"];
        const summaries = characterRaidSummaries(data);
        const result = [makeCell("Name", "header"), makeCell("Lvl", "header"), makeCell("CP", "header"), makeCell("Final Act: Kazeros", "header", "", "", false, null, false, 2), makeCell("Serca", "header", "", "", false, null, false, 2), makeCell("Horizon Cathedral", "header", "", "", false, null, false, 2)];
        let lastPlayer = "";
        for (const run of data) {
            if (run.name === lastPlayer)
                continue;

            const characterRaids = {};
            for (const characterRun of data) {
                if (characterRun.name === run.name)
                    Object.assign(characterRaids, characterRun.raids);
            }

            const inactive = completedRaidCount(summaries, run.name) >= 3;
            result.push(makeCell(run.name, "character", "", "", false, null, inactive));
            result.push(makeCell(Math.round(run.itemLevel).toString(), "stat", "", "", false, null, inactive));
            result.push(makeCell(Math.round(run.combatPower).toString(), "stat", "", "", false, null, inactive));

            for (const group of raids) {
                const reservation = reservations[reservationKey(run.name, group.raid)];
                const reservationText = plannedText(reservation);
                const hasRunData = group.gates.some(gate => characterRaids[gate]);
                if (reservationText !== "" && !hasRunData) {
                    result.push(makeCell(reservationText, "raid", run.name, group.raid, weekOffset <= 0, reservation, inactive, 2));
                    continue;
                }

                for (const gate of group.gates) {
                    const session = characterRaids[gate];
                    const cell = makeCell("", "raid", run.name, group.raid, weekOffset <= 0, null, inactive);
                    if (session) {
                        const color = group.colors[session.difficulty];
                        if (session.performance.type === "dps") {
                            const {
                                rdps,
                                dpsCon,
                                supCon,
                                ndps,
                                dps
                            } = session.performance;
                            cell.text = `<b style="color:${color}">${abbreviateNumber(customRound(ndps))}/${abbreviateNumber(customRound(dps))}</b><br>+${customRound(100 * supCon, 0)}%+${customRound(100 * dpsCon, 0)}%`;
                        } else {
                            const {
                                rdps,
                                rcon,
                                uptimes
                            } = session.performance;
                            cell.text = `${uptimes.map((u, i) => `<b style="color:${buffColors[i]}">${customRound(u * 100, 0)}</b>`).join(".")}<br>+${customRound(100 * rcon, 0)}%`;
                        }
                    }
                    result.push(cell);
                }
            }
            lastPlayer = run.name;
        }
        return result;
    }
    function buildOverviewTable(data) {
        const raids = raidGroups();
        const head = overviewHeaders;
        const summaries = characterRaidSummaries(data);
        const result = head.map(h => makeCell(h, "header"));
        let lastPlayer = "";
        for (const run of data) {
            if (run.name === lastPlayer)
                continue;

            const inactive = completedRaidCount(summaries, run.name) >= 3;
            result.push(makeCell(run.name, "character", "", "", false, null, inactive));
            result.push(makeCell(Math.round(run.itemLevel).toString(), "stat", "", "", false, null, inactive));
            result.push(makeCell(Math.round(run.combatPower).toString(), "stat", "", "", false, null, inactive));

            for (const group of raids) {
                const cleared = (summaries[run.name] || {})[group.raid] || 0;
                const reservation = !cleared ? reservations[reservationKey(run.name, group.raid)] : undefined;
                const clearText = cleared > 0 ? `${cleared}/${group.gates.length}` : "";
                result.push(makeCell(plannedText(reservation) || clearText, "raid", run.name, group.raid, weekOffset <= 0 && (cleared === 0 || reservation), reservation || null, inactive));
            }
            lastPlayer = run.name;
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
                    root.rebuildTables();
                } else {
                    root.rawData = [];
                    root.rebuildTables();
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
