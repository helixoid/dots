-- modules/input.lua
-- https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
    input = {
        numlock_by_default = true,
        accel_profile      = "flat",
        sensitivity        = 0.0,
        kb_options         = "caps:swapescape",
        touchpad = {
            natural_scroll = true,
        },
    },
})

-- 3-finger horizontal swipe switches workspaces
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
