pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
    id: root

    readonly property string stateDirectory: Quickshell.env("HOME") + "/.local/state/quickshell/notifications"
    readonly property string historyPath: stateDirectory + "/history.json"
    readonly property string receivedPath: stateDirectory + "/received.json"

    property var history: []
    property var received: []
    property var popupList: history.filter(item => item.popup)
    property bool doNotDisturb: false
    property bool historyOpen: false
    property var displayScreen: Quickshell.screens[0] ?? null
    property int nextId: 1
    property var nativeNotifications: ({})

    function safeValue(value, depth) {
        if (value === null || value === undefined)
            return value === undefined ? null : value;
        if (depth > 5)
            return String(value);

        const type = typeof value;
        if (type === "string" || type === "number" || type === "boolean")
            return value;
        if (type === "function")
            return "[function]";
        if (Array.isArray(value))
            return value.map(item => safeValue(item, depth + 1));

        if (type === "object") {
            const result = {};
            try {
                for (const key in value)
                    result[key] = safeValue(value[key], depth + 1);
                return result;
            } catch (error) {
                return String(value);
            }
        }

        return String(value);
    }

    function copyNotification(notification) {
        const actions = [];
        for (const action of notification.actions ?? []) {
            actions.push({
                identifier: action.identifier,
                text: action.text
            });
        }

        return {
            historyId: nextId++,
            notificationId: notification.id,
            lastGeneration: notification.lastGeneration,
            receivedAt: new Date().toISOString(),
            receivedAtEpochMs: Date.now(),
            expireTimeout: notification.expireTimeout,
            appName: notification.appName ?? "",
            appIcon: notification.appIcon ?? "",
            summary: notification.summary ?? "",
            body: notification.body ?? "",
            urgency: notification.urgency?.toString() ?? "normal",
            actions: actions,
            hasActionIcons: notification.hasActionIcons ?? false,
            resident: notification.resident ?? false,
            transient: notification.transient ?? false,
            desktopEntry: notification.desktopEntry ?? "",
            image: safeValue(notification.image, 0),
            hasInlineReply: notification.hasInlineReply ?? false,
            inlineReplyPlaceholder: notification.inlineReplyPlaceholder ?? "",
            hints: safeValue(notification.hints, 0),
            popup: !doNotDisturb
        };
    }

    function serializable(record) {
        const copy = {};
        for (const key in record) {
            if (key !== "popup")
                copy[key] = safeValue(record[key], 0);
        }
        return copy;
    }

    function saveHistory() {
        historyFile.setText(JSON.stringify(history.map(item => serializable(item)), null, 2));
    }

    function saveReceived() {
        receivedFile.setText(JSON.stringify(received, null, 2));
    }

    function triggerHistoryChange() {
        history = history.slice(0);
    }

    function hidePopup(historyId) {
        const index = history.findIndex(item => item.historyId === historyId);
        if (index === -1)
            return;
        history[index].popup = false;
        triggerHistoryChange();
    }

    function removeNotification(historyId) {
        const nativeNotification = nativeNotifications[historyId];
        if (nativeNotification) {
            if (typeof nativeNotification.dismiss === "function") {
                nativeNotification.dismiss();
            }
            delete nativeNotifications[historyId];
        }

        history = history.filter(item => item.historyId !== historyId);
        saveHistory();
        if (history.length === 0)
            historyOpen = false;
    }

    function toggleHistory(screen) {
        if (screen)
            displayScreen = screen;
        historyOpen = !historyOpen;
    }

    function toggleDoNotDisturb() {
        doNotDisturb = !doNotDisturb;
        if (doNotDisturb) {
            history = history.map(item => {
                item.popup = false;
                return item;
            });
            triggerHistoryChange();
        }
    }

    component PopupTimer: Timer {
        required property int historyId
        interval: 6000
        running: true
        repeat: false

        onTriggered: {
            root.hidePopup(historyId);
            destroy();
        }
    }

    Component {
        id: popupTimerComponent
        PopupTimer {}
    }

    NotificationServer {
        id: server

        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        keepOnReload: false
        persistenceSupported: true

        onNotification: notification => {
            notification.tracked = true;

            const record = root.copyNotification(notification);
            root.nativeNotifications[record.historyId] = notification;
            root.history = [record, ...root.history];

            const auditRecord = root.serializable(record);
            root.received = [auditRecord, ...root.received];
            root.saveHistory();
            root.saveReceived();

            if (record.popup) {
                const requestedTimeout = record.expireTimeout;
                const timeout = requestedTimeout > 0 ? Math.max(3000, Math.min(requestedTimeout, 15000)) : 6000;
                popupTimerComponent.createObject(root, {
                    historyId: record.historyId,
                    interval: timeout
                });
            }
        }
    }

    FileView {
        id: historyFile
        path: root.historyPath

        onLoaded: {
            const text = historyFile.text().trim();
            if (text.length === 0) {
                root.saveHistory();
                return;
            }

            try {
                const saved = JSON.parse(text);
                root.history = saved.map(item => {
                    item.popup = false;
                    return item;
                });
                root.nextId = root.history.reduce((maximum, item) => Math.max(maximum, item.historyId ?? 0), 0) + 1;
            } catch (error) {
                console.warn("[Notifications] Cannot parse history:", error);
            }
        }

        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound)
                root.saveHistory();
            else
                console.warn("[Notifications] Cannot load history:", error);
        }
    }

    FileView {
        id: receivedFile
        path: root.receivedPath

        onLoaded: {
            const text = receivedFile.text().trim();
            if (text.length === 0) {
                root.saveReceived();
                return;
            }

            try {
                root.received = JSON.parse(text);
            } catch (error) {
                console.warn("[Notifications] Cannot parse inspection log:", error);
            }
        }

        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound)
                root.saveReceived();
            else
                console.warn("[Notifications] Cannot load inspection log:", error);
        }
    }
}
