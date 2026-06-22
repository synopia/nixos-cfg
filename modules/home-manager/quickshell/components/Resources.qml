import QtQuick
import Quickshell.Io
import qs.theme

BarPill {
    id: root

    property real memoryUsage: 0
    property real cpuUsage: 0
    property real networkRate: 0
    property var previousCpu: null
    property real previousNetworkBytes: 0

    function update() {
        memoryFile.reload()
        cpuFile.reload()
        networkFile.reload()

        const memory = memoryFile.text()
        const total = Number(memory.match(/MemTotal:\s+(\d+)/)?.[1] ?? 1)
        const available = Number(memory.match(/MemAvailable:\s+(\d+)/)?.[1] ?? total)
        memoryUsage = Math.max(0, Math.min(1, (total - available) / total))

        const cpuLine = cpuFile.text().match(
            /^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/
        )
        if (cpuLine) {
            const values = cpuLine.slice(1).map(Number)
            const totalCpu = values.reduce((sum, value) => sum + value, 0)
            const idleCpu = values[3] + values[4]

            if (previousCpu) {
                const totalDelta = totalCpu - previousCpu.total
                const idleDelta = idleCpu - previousCpu.idle
                cpuUsage = totalDelta > 0 ? 1 - idleDelta / totalDelta : 0
            }

            previousCpu = {
                total: totalCpu,
                idle: idleCpu,
            }
        }

        const lines = networkFile.text().split("\n")
        let currentNetworkBytes = 0

        for (const line of lines) {
            const match = line.match(
                /^\s*([^:]+):\s*(\d+)(?:\s+\d+){7}\s+(\d+)/
            )
            if (match && match[1].trim() !== "lo") {
                currentNetworkBytes += Number(match[2]) + Number(match[3])
            }
        }

        if (previousNetworkBytes > 0) {
            networkRate = Math.max(0, currentNetworkBytes - previousNetworkBytes)
        }
        previousNetworkBytes = currentNetworkBytes
    }

    function percentage(value) {
        return Math.round(value * 100) + "%"
    }

    function rate(value) {
        if (value >= 1024 * 1024) {
            return (value / (1024 * 1024)).toFixed(1) + "M"
        }
        if (value >= 1024) {
            return Math.round(value / 1024) + "K"
        }
        return Math.round(value) + "B"
    }

    content: Row {
        spacing: 9

        ResourceLabel {
            label: "MEM"
            value: root.percentage(root.memoryUsage)
            accent: Theme.mauve
        }

        ResourceLabel {
            label: "CPU"
            value: root.percentage(root.cpuUsage)
            accent: Theme.blue
        }

        ResourceLabel {
            label: "NET"
            value: root.rate(root.networkRate)
            valueWidth: 34
            accent: Theme.green
        }
    }

    FileView {
        id: memoryFile
        path: "/proc/meminfo"
    }

    FileView {
        id: cpuFile
        path: "/proc/stat"
    }

    FileView {
        id: networkFile
        path: "/proc/net/dev"
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.update()
    }
}
