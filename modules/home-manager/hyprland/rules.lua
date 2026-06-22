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
