-- modules/autostart.lua
-- programs launched once on session start
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
	hl.exec_cmd("qs -c noctalia-shell")
	hl.exec_cmd("cliphist wipe")
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
end)
