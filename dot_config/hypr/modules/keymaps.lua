-- modules/keymaps.lua
-- https://wiki.hypr.land/Configuring/Basics/Binds/

local vars = require("modules/vars")
local mod  = vars.mod

-- ── apps ──────────────────────────────────────────────────────────────
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(vars.term))
hl.bind(mod .. " + b",      hl.dsp.exec_cmd(vars.browser))
hl.bind(mod .. " + m",      hl.dsp.exec_cmd(vars.term .. " -e rmpc"))
hl.bind(mod .. " + e",      hl.dsp.exec_cmd("thunar"))

-- ── wm ────────────────────────────────────────────────────────────────
hl.bind(mod .. " + BackSpace", hl.dsp.exec_cmd("hyprshutdown"))
hl.bind(mod .. " + SPACE",     hl.dsp.exec_cmd("hyprlauncher"))
hl.bind(mod .. " + s",         hl.dsp.exec_cmd(vars.scripts .. "/screenshot.sh s"))
hl.bind("Print",               hl.dsp.exec_cmd(vars.scripts .. "/screenshot.sh p"))

-- ── windows ───────────────────────────────────────────────────────────
hl.bind(mod .. " + q", hl.dsp.window.close())
hl.bind(mod .. " + v", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + p", hl.dsp.window.pseudo())
hl.bind(mod .. " + f", hl.dsp.window.fullscreen())

-- ── smart focus / workspace (niri-style "or") ─────────────────────────
-- SUPER+h / SUPER+l : focus left/right if a neighbour exists,
--                     otherwise jump to prev/next workspace.
-- SUPER+k / SUPER+j : focus up/down (no workspace wrap — vertical is
--                     always within the current workspace).
--
-- The check uses hl.get_active_window() after a focus attempt.
-- A cleaner approach: attempt movefocus; if the active window didn't
-- change (no neighbour in that direction), fall back to workspace switch.

local function smart_h()
    local before = hl.get_active_window()
    hl.dispatch(hl.dsp.focus({ direction = "l" }))
    local after = hl.get_active_window()
    -- if window didn't change there is no neighbour → go to prev workspace
    if before ~= nil and after ~= nil and before.address == after.address then
        hl.dispatch(hl.dsp.focus({ workspace = "e-1" }))
    end
end

local function smart_l()
    local before = hl.get_active_window()
    hl.dispatch(hl.dsp.focus({ direction = "r" }))
    local after = hl.get_active_window()
    if before ~= nil and after ~= nil and before.address == after.address then
        hl.dispatch(hl.dsp.focus({ workspace = "e+1" }))
    end
end

hl.bind(mod .. " + h", smart_h)
hl.bind(mod .. " + l", smart_l)
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "d" }))

-- ── move window ───────────────────────────────────────────────────────
-- SUPER+SHIFT+h/l  : move window left/right; if no neighbour, carry it
--                    to the adjacent workspace (window follows you).
-- SUPER+SHIFT+k/j  : move window up/down within workspace.

local function smart_move_h()
    local before = hl.get_active_window()
    hl.dispatch(hl.dsp.window.move({ direction = "l" }))
    local after = hl.get_active_window()
    if before ~= nil and after ~= nil and before.address == after.address then
        hl.dispatch(hl.dsp.window.move({ workspace = "e-1" }))
        hl.dispatch(hl.dsp.focus({ workspace = "e-1" }))
    end
end

local function smart_move_l()
    local before = hl.get_active_window()
    hl.dispatch(hl.dsp.window.move({ direction = "r" }))
    local after = hl.get_active_window()
    if before ~= nil and after ~= nil and before.address == after.address then
        hl.dispatch(hl.dsp.window.move({ workspace = "e+1" }))
        hl.dispatch(hl.dsp.focus({ workspace = "e+1" }))
    end
end

hl.bind(mod .. " + SHIFT + h", smart_move_h)
hl.bind(mod .. " + SHIFT + l", smart_move_l)
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

-- ── workspaces 1–10 ───────────────────────────────────────────────────
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- ── mouse ─────────────────────────────────────────────────────────────
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ── media & brightness ────────────────────────────────────────────────
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- ── resize submap  (SUPER+r → hjkl → Escape/q to exit) ───────────────
hl.bind(mod .. " + r", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("l",      hl.dsp.window.resize({ x =  10, y =   0, relative = true }), { repeating = true })
    hl.bind("h",      hl.dsp.window.resize({ x = -10, y =   0, relative = true }), { repeating = true })
    hl.bind("k",      hl.dsp.window.resize({ x =   0, y = -10, relative = true }), { repeating = true })
    hl.bind("j",      hl.dsp.window.resize({ x =   0, y =  10, relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("q",      hl.dsp.submap("reset"))
end)
