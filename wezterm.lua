local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Catppuccin Frappe'
warn_about_missing_glyphs = false

return config
