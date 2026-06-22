local function floating_dialog(match)
    hl.window_rule({
        match = match,
        float = true,
        center = true,
    })
end

floating_dialog({ title = "^(Open File)(.*)$" })
floating_dialog({ title = "^(Open Folder)(.*)$" })
floating_dialog({ title = "^(Save As)(.*)$" })
floating_dialog({ title = "^(File Upload)(.*)$" })
floating_dialog({ class = "^(org.pulseaudio.pavucontrol)$" })
floating_dialog({ class = "^(nm-connection-editor)$" })

hl.window_rule({
    match = {
        title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$",
    },
    float = true,
    pin = true,
    keep_aspect_ratio = true,
})
for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-3", default = true })
end
for i = 11, 20 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end
hl.window_rule({
    match = { class = "vesktop" },
    workspace = "11"
})
hl.window_rule({
    match = { class = "io.github.tobagin.karere" },
    workspace = "11"
})
hl.window_rule({
    match = { title = "Meter | LOA Logs" },
    workspace = "11"
})
hl.window_rule({
    match = { title = "LOA Logs" },
    workspace = "13"
})
hl.window_rule({
    match = { class = "obsidian" },
    workspace = "3"
})
