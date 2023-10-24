local wezterm = require 'wezterm'

-- local scheme = wezterm.get_builtin_color_schemes()['AtomOneLight']
-- scheme.background = '#e1e2e7'
-- scheme.selection_bg = '#d0d0d0'

local colors = {
  -- The default text color
  foreground = 'black',
  -- The default background color
  background = '#e1e2e7',

  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = '#333333',
  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = 'white',
  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = '#333333',

  -- the foreground color of selected text
  selection_fg = 'black',
  -- the background color of selected text
  selection_bg = '#aaaaaa',

  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = '#222222',

  -- The color of the split lines between panes
  split = '#444444',

  ansi = {
    'black',
    'maroon',
    'green',
    'DarkGoldenrod',
    'navy',
    'purple',
    'teal',
    'silver',
  },
  brights = {
    'black',
    'maroon',
    'green',
    'olive',
    'navy',
    'purple',
    'teal',
    'silver',
  },

  -- Arbitrary colors of the palette in the range from 16 to 255
  -- indexed = { [136] = '#af8700' },

  -- Since: 20220319-142410-0fcdea07
  -- When the IME, a dead key or a leader key are being processed and are effectively
  -- holding input pending the result of input composition, change the cursor
  -- to this color to give a visual cue about the compose state.
  compose_cursor = 'black',

  -- Colors for copy_mode and quick_select
  -- available since: 20220807-113146-c2fee766
  -- In copy_mode, the color of the active text is:
  -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
  -- 2. selection_* otherwise
  copy_mode_active_highlight_bg = { Color = '#000000' },
  -- use `AnsiColor` to specify one of the ansi color palette values
  -- (index 0-15) using one of the names "Black", "Maroon", "Green",
  --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
  -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
  copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
  copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
  copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

  quick_select_label_bg = { Color = 'peru' },
  quick_select_label_fg = { Color = '#ffffff' },
  quick_select_match_bg = { AnsiColor = 'Navy' },
  quick_select_match_fg = { Color = '#ffffff' },
}


return {
  font = wezterm.font 'Fira Code',
  font_rules = {
    -- For Bold-but-not-italic text, use this relatively bold font, and override
    -- its color to a tomato-red color to make bold text really stand out.
    {
      intensity="Bold",
      italic=false,
      font=wezterm.font("Fira Code SemiBold", {bold=false, italic=false}),
    },

    -- Bold-and-italic
    {
      intensity = 'Bold',
      italic = true,
      font=wezterm.font("Fira Code SemiBold", {bold=false, italic=false}),
    },

    -- normal-intensity-and-italic
    {
      intensity = 'Normal',
      italic = true,
      font=wezterm.font("Fira Code", {bold=false, italic=false}),
    },

    -- half-intensity-and-italic (half-bright or dim); use a lighter weight font
    {
      intensity = 'Half',
      italic = true,
      font=wezterm.font("Fira Code", {bold=false, italic=false}),
    },

    -- half-intensity-and-not-italic
    {
      intensity = 'Half',
      italic = false,
      font=wezterm.font("Fira Code", {bold=false, italic=false}),
    },
  },
  line_height = 1,
  font_size = 12,
  disable_default_key_bindings = true,
  colors = colors,
  keys = {
    {
      key = 'n',
      mods = 'ALT',
      action = wezterm.action { SpawnTab="CurrentPaneDomain" },
    },
    {
      key = '.',
      mods = 'ALT',
      action = wezterm.action { ActivateTabRelative=-1 },
    },
    {
      key = ',',
      mods = 'ALT',
      action = wezterm.action { ActivateTabRelative=1 },
    },
    {
      key = 'c',
      mods = 'CTRL|SHIFT',
      action = wezterm.action { CopyTo="Clipboard" },
    },
    {
      key = 'v',
      mods = 'CTRL|SHIFT',
      action = wezterm.action { PasteFrom="Clipboard" },
    },
  },
  -- color_schemes = {
  --   -- Override the builtin Gruvbox Light scheme with our modification.
  --   ['AtomOneLight'] = scheme,
  -- },
  custom_block_glyphs = false,
  cursor_thickness = 3,
  -- color_scheme = "AtomOneLight",
  force_reverse_video_cursor = false,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = true,
  -- Disable ligatures
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  front_end = "OpenGL",
  freetype_render_target = 'HorizontalLcd',
}
