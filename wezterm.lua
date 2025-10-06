local wezterm = require("wezterm")

local config = wezterm.config_builder()

require("config.appearance")(wezterm, config)
require("config.launch")(wezterm, config)
require("config.keybings")(wezterm, config)
require("config.status")(wezterm, config)
require("config.tabs")(wezterm, config)
require("config.theme")(wezterm, config)

return config
