-- modules/keymaps.lua
-- https://wiki.hypr.land/Configuring/Basics/Binds/

local vars = require("modules/vars")
local mod = vars.mod

-- ── helpers: position-based edge detection ────────────────────────────
-- Checks if the focused tiled window is at the left/right edge of the
-- workspace by comparing X positions — no dispatch-and-recheck needed.
local function is_edge(direction)
	local active = hl.get_active_window()
	if not active or active.floating then
		return true
	end

	local ws_id = active.workspace.id
	local edge_x = active.at.x

	for _, w in ipairs(hl.get_windows()) do
		if not w.floating and w.workspace.id == ws_id then
			if direction == "l" and w.at.x < edge_x then
				return false
			end
			if direction == "r" and w.at.x > edge_x then
				return false
			end
		end
	end
	return true
end

local function smart_focus(dir, ws_delta)
	if is_edge(dir) then
		hl.dispatch(hl.dsp.focus({ workspace = ws_delta }))
	else
		hl.dispatch(hl.dsp.focus({ direction = dir }))
	end
end

local function smart_move(dir, ws_delta)
	if is_edge(dir) then
		hl.dispatch(hl.dsp.window.move({ workspace = ws_delta }))
		hl.dispatch(hl.dsp.focus({ workspace = ws_delta }))
	else
		hl.dispatch(hl.dsp.window.move({ direction = dir }))
	end
end

-- ── apps ──────────────────────────────────────────────────────────────
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(vars.term))
hl.bind("ALT + I", hl.dsp.exec_cmd(vars.browser))
hl.bind("ALT + M", hl.dsp.exec_cmd(vars.term .. " -e rmpc"))
hl.bind("ALT + E", hl.dsp.exec_cmd("thunar"))

-- ── wm ────────────────────────────────────────────────────────────────
hl.bind(mod .. " + BackSpace", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call sessionMenu toggle"))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call launcher toggle"))
hl.bind(mod .. " + C", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call launcher clipboard"))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd(vars.scripts .. "/screenshot.sh s"))
hl.bind("Print", hl.dsp.exec_cmd(vars.scripts .. "/screenshot.sh p"))

-- ── windows ───────────────────────────────────────────────────────────
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

-- ── focus: vim (hjkl) + arrows ────────────────────────────────────────
hl.bind(mod .. " + h", function()
	smart_focus("l", "e-1")
end)
hl.bind(mod .. " + l", function()
	smart_focus("r", "e+1")
end)
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + left", function()
	smart_focus("l", "e-1")
end)
hl.bind(mod .. " + right", function()
	smart_focus("r", "e+1")
end)
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "d" }))

-- ── move window: vim (hjkl) + arrows ─────────────────────────────────
hl.bind(mod .. " + SHIFT + h", function()
	smart_move("l", "e-1")
end)
hl.bind(mod .. " + SHIFT + l", function()
	smart_move("r", "e+1")
end)
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + left", function()
	smart_move("l", "e-1")
end)
hl.bind(mod .. " + SHIFT + right", function()
	smart_move("r", "e+1")
end)
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- ── workspaces 1–10 ───────────────────────────────────────────────────
for i = 1, 10 do
	local key = tostring(i % 10)
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- ── mouse ─────────────────────────────────────────────────────────────
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ── media & brightness ────────────────────────────────────────────────
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("qs -c noctalia-shell ipc call volume increase"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("qs -c noctalia-shell ipc call volume decrease"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call volume muteOutput"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("qs -c noctalia-shell ipc call brightness increase"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("qs -c noctalia-shell ipc call brightness decrease"),
	{ locked = true, repeating = true }
)

-- ── resize submap  (SUPER+R → hjkl/arrows → Escape to exit) ──────────
hl.bind(mod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
	hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
	hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
	hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
	hl.bind("up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
	hl.bind("down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("q", hl.dsp.submap("reset"))
end)
