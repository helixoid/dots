-- modules/appearance.lua
-- https://wiki.hypr.land/Configuring/Basics/Variables/
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

local vars = require("modules/vars")

hl.config({
    general = {
        gaps_in       = 5,
        gaps_out      = 10,
        border_size   = 2,
        allow_tearing = true,
        layout        = "dwindle",
    },

    decoration = {
        rounding       = 20,
        rounding_power = 2,
        blur = {
            enabled  = true,
            size     = 6,
            passes   = 3,
            vibrancy = 0.1696,
        },
    },

    animations = { enabled = true },

    dwindle = { preserve_split = true },

    misc = {
        mouse_move_enables_dpms = true,
        enable_swallow          = true,
        swallow_regex           = "^(" .. vars.term .. ")$",
        focus_on_activate       = true,
        disable_hyprland_logo   = true,
        force_default_wallpaper = 0,
    },
})

-- curves
hl.curve("myBezier",     { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1},   {0.32, 1}   } })
hl.curve("quick",        { type = "bezier", points = { {0.15, 0},   {0.1, 1}    } })

-- animations (matched to original intent from hyprland.conf)
hl.animation({ leaf = "windows",    enabled = true, speed = 7,    bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,    bezier = "myBezier",     style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10,   bezier = "easeOutQuint" })
hl.animation({ leaf = "borderangle",enabled = true, speed = 8,    bezier = "easeOutQuint" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,    bezier = "quick" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,    bezier = "easeOutQuint" })
