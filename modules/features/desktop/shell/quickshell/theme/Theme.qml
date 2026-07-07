pragma Singleton
import QtQuick

QtObject {
    // Raw Base16
    readonly property color base00: "#262427"
    readonly property color base01: "#3b393c"
    readonly property color base02: "#514f52"
    readonly property color base03: "#676567"
    readonly property color base04: "#7c7b7d"
    readonly property color base05: "#fcfcfc"
    readonly property color base06: "#eae9eb"
    readonly property color base07: "#fcfcfc"
    readonly property color base08: "#ff7272"
    readonly property color base09: "#fc9d6f"
    readonly property color base0A: "#ffca58"
    readonly property color base0B: "#bcdf59"
    readonly property color base0C: "#aee8f4"
    readonly property color base0D: "#49cae4"
    readonly property color base0E: "#a093e2"
    readonly property color base0F: "#ff8787"

    // Semantic UI roles
    readonly property color bg: base00
    readonly property color surface: base01
    readonly property color surfaceHover: base02
    readonly property color border: base03

    readonly property color textMuted: base04
    readonly property color text: base05
    readonly property color textStrong: base06

    readonly property color accent: base0D
    readonly property color accent2: base0E
    readonly property color success: base0B
    readonly property color info: base0C
    readonly property color warning: base0A
    readonly property color urgent: base09
    readonly property color error: base08

    // Useful bar-specific aliases
    readonly property color workspaceActive: accent
    readonly property color workspaceInactive: textMuted
    readonly property color moduleBg: surface
    readonly property color moduleBgHover: surfaceHover
    readonly property color popupBg: bg
    readonly property color popupBorder: accent

    readonly property color difficultyNormal: base0B
    readonly property color difficultyHard: base0E
    readonly property color difficultyNightmare: base08

    readonly property color difficultyNormalBg: Qt.alpha(base0B, 0.18)
    readonly property color difficultyHardBg: Qt.alpha(base0E, 0.18)
    readonly property color difficultyNightmareBg: Qt.alpha(base08, 0.18)

    readonly property color difficultyNormalText: base0B
    readonly property color difficultyHardText: base0E
    readonly property color difficultyNightmareText: base08
}
