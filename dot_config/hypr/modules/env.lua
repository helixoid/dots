-- modules/env.lua
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local vars = require("modules/vars")

-- cursor
hl.env("HYPRCURSOR_THEME", "HyprBibataModernClassicSVG")
hl.env("HYPRCURSOR_SIZE",  "24")
hl.env("XCURSOR_THEME",    "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE",     "24")

-- toolkit
hl.env("ELECTRON_OZONE_PLATFORM_HINT",        "wayland")
hl.env("QT_QPA_PLATFORM",                     "wayland")
hl.env("QT_QPA_PLATFORMTHEME",                "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR",         "1")

-- default apps
hl.env("TERMINAL", vars.term)
hl.env("EDITOR",   "nvim")
hl.env("VISUAL",   "nvim")

-- video decode
hl.env("ANV_VIDEO_DECODE", "1")
