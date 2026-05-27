-- modules/vars.lua
-- single source of truth — edit this file to change your terminal, mod key, etc.

local M = {}

M.mod     = "SUPER"
M.term    = "kitty"
M.browser = "brave-origin-nightly"

local home  = os.getenv("HOME")
M.config    = home .. "/.config/hypr"
M.scripts   = M.config .. "/scripts"

return M
