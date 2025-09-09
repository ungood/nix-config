local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- Basic configuration
config.font = wezterm.font('JetBrains Mono')
config.font_size = 12.0

-- Color scheme (will be overridden by stylix)
config.color_scheme = 'Gruvbox Dark (Gogh)'

-- Window settings
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"

-- Tab bar
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = true

-- Shell integration
config.default_prog = { 'fish' }

-- Key bindings
config.keys = {
  -- New tab
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnTab('CurrentPaneDomain'),
  },
  -- Close tab
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentTab({ confirm = true }),
  },
  -- Split horizontally
  {
    key = 'Enter',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },
  -- Split vertically
  {
    key = '|',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }),
  },
}

return config