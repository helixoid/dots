-- modules/rules.lua
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- ignore maximize requests from all apps
hl.window_rule({
    name           = "suppress-maximize",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- fix XWayland drag issues
hl.window_rule({
    name     = "fix-xwayland-drag",
    match    = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})
