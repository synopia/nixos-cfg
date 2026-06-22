hl.monitor({
    output = "DP-3",
    mode = "preferred",
    position = "1920x0",
    scale = 1,
})
hl.monitor({
    output = "HDMI-A-1",
    mode = "preferred",
    position = "0x0",
    scale = 1,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")
end)

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "intl",
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 35,
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
        },
    },

    general = {
        layout = "dwindle",
        gaps_in = 4,
        gaps_out = 8,
        border_size = 2,
        resize_on_border = true,
        extend_border_grab_area = 15,
        hover_icon_on_border = true,
        col = {
            active_border = "rgba(cba6f7ff)",
            inactive_border = "rgba(45475aff)",
        },
    },

    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
        },
        shadow = {
            enabled = true,
            range = 12,
            render_power = 3,
            color = "rgba(00000055)",
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        focus_on_activate = true,
    },
})

hl.curve("standard", {
    type = "bezier",
    points = {
        { 0.2, 0.0 },
        { 0.0, 1.0 },
    },
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 4,
    bezier = "standard",
})

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 4,
    bezier = "standard",
})

hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 4,
    bezier = "standard",
    style = "slide",
})
