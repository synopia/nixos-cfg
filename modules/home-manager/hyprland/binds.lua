local terminal = "kitty"
local browser = "google-chrome"
local file_manager = "dolphin"
local launcher = "rofi -show drun"
local workspaces_per_monitor = hypr_user_config.workspaces_per_monitor
local workspace_count = workspaces_per_monitor * #hypr_user_config.workspace_monitors

function workspace_on_current_monitor(i)
    local first = math.floor((hl.get_active_workspace().id - 1) / workspaces_per_monitor) * workspaces_per_monitor
    local next = first + i
    local new = math.min(workspace_count, math.max(1, next))
    return tostring(new)
end

hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal), {
    description = "Open terminal",
})
hl.bind("SUPER + T", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + W", hl.dsp.exec_cmd(browser), {
    description = "Open browser",
})
hl.bind("SUPER + E", hl.dsp.exec_cmd(file_manager), {
    description = "Open file manager",
})
hl.bind("SUPER + Space", hl.dsp.exec_cmd(launcher), {
    description = "Open application launcher",
})

hl.bind("SUPER + Q", hl.dsp.window.close(), {
    description = "Close window",
})
hl.bind("SUPER + F", hl.dsp.window.fullscreen({
    mode = "fullscreen",
    action = "toggle",
}), {
    description = "Toggle fullscreen",
})
hl.bind("SUPER + V", hl.dsp.window.float({
    action = "toggle",
}), {
    description = "Toggle floating",
})
hl.bind("SUPER + P", hl.dsp.layout("pseudo"), {
    description = "Toggle pseudotiling",
})
hl.bind("SUPER + D", hl.dsp.exec_cmd("rofi -show drun"))
local directions = {
    { key = "Left",  direction = "l" },
    { key = "Right", direction = "r" },
    { key = "Up",    direction = "u" },
    { key = "Down",  direction = "d" },
}

for _, binding in ipairs(directions) do
    hl.bind(
        "SUPER + " .. binding.key,
        hl.dsp.focus({ direction = binding.direction })
    )
    hl.bind(
        "SUPER + SHIFT + " .. binding.key,
        hl.dsp.window.move({ direction = binding.direction })
    )
end

for workspace = 1, math.min(workspaces_per_monitor, 10) do
    local key = workspace % 10

    hl.bind(
        "SUPER + " .. key, function()
            hl.dispatch(hl.dsp.focus({ workspace = workspace_on_current_monitor(workspace) }))
        end
    )
    hl.bind(
        "SUPER + SHIFT + " .. key, function()
            hl.dispatch(
                hl.dsp.window.move({
                    workspace = workspace_on_current_monitor(workspace),
                    follow = false
                })
            )
        end
    )
end

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), {
    mouse = true,
    description = "Move window",
})
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), {
    mouse = true,
    description = "Resize window",
})

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true }
)

hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("uwsm stop"), {
    description = "Exit Hyprland",
})
hl.bind("SUPER + Tab", hl.dsp.global("quickshell:overviewToggle"), {
    description = "Overview",
})
