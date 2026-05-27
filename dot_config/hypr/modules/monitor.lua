-- modules/monitor.lua
-- monitor layout and scaling
-- https://wiki.hypr.land/Configuring/Basics/Monitors/
--
-- To add more monitors, duplicate the hl.monitor block and set the output
-- name from `hyprctl monitors` or `wlr-randr`.

hl.monitor({
	output = "", -- "" matches any/all monitors
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

hl.monitor({
	output = "eDP-1", -- "" matches any/all monitors
	mode = "preferred",
	position = "auto",
	scale = "1.25",
})
