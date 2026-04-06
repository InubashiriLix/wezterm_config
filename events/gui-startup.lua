local wezterm = require('wezterm')
local mux = wezterm.mux
local platform = require('utils.platform')

local M = {}

M.setup = function()
    wezterm.on('gui-startup', function(cmd)
        local _, _, window = mux.spawn_window(cmd or {})
        if not platform.is_niri then
            window:gui_window():maximize()
        end
    end)
end

return M
