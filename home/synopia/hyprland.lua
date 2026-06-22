-- User- and machine-specific Hyprland configuration.
-- Shared behavior remains in modules/home-manager/hyprland.
hypr_user_config = {
    workspaces_per_monitor = 10,
    workspace_monitors = {
        { output = "DP-3",    default = true },
        { output = "HDMI-A-1" },
    },
    autostart = {
        "vesktop",
        "karere",
        "obsidian"
    },
}

for monitor_index, monitor in ipairs(hypr_user_config.workspace_monitors) do
    local first_workspace = (monitor_index - 1) * hypr_user_config.workspaces_per_monitor + 1
    local last_workspace = monitor_index * hypr_user_config.workspaces_per_monitor

    for workspace = first_workspace, last_workspace do
        hl.workspace_rule({
            workspace = tostring(workspace),
            monitor = monitor.output,
            default = monitor.default == true and workspace == first_workspace,
        })
    end
end

hl.on("hyprland.start", function()
    for _, command in ipairs(hypr_user_config.autostart) do
        hl.exec_cmd(command)
    end
end)

-- Add personal keybinds here. Shared keybinds are defined in config.binds.
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("firefox"), {
    description = "Open Firefox",
})

hl.window_rule({
    match = { class = "vesktop" },
    workspace = "11",
})
hl.window_rule({
    match = { class = "io.github.tobagin.karere" },
    workspace = "11",
})
hl.window_rule({
    match = { title = "Meter | LOA Logs" },
    workspace = "11",
})
hl.window_rule({
    match = { title = "LOA Logs" },
    workspace = "13",
})
hl.window_rule({
    match = { class = "obsidian" },
    workspace = "3",
})
