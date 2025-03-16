local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Catppuccin Frappe'
config.enable_tab_bar = false

wezterm.font("Hack Nerd Font", {weight="Bold", stretch="Normal", style="Italic"}) -- /usr/share/fonts/ttf-hack/Hack-BoldItalic.ttf, FontConfig

config.font = wezterm.font_with_fallback {
  'JetBrains Mono',
}

  keys = {
    -- Add keybinding for Ctrl + P
    { key = "p", mods = "CTRL", action = wezterm.action{ SpawnCommandInNewTab = { args = {"fzf"} } } },
  }

return config
