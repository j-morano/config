local wezterm = require 'wezterm'
local act = wezterm.action

-- local scheme = wezterm.get_builtin_color_schemes()['Dracula (base16)']
-- scheme.background = '#e1e2e7'
-- scheme.selection_bg = '#d0d0d0'


local function recompute_padding(window)
  local window_dims = window:get_dimensions();
  local overrides = window:get_config_overrides() or {}
  -- Check if overrides.window_padding_enabled is set
  if overrides.window_padding_enabled == nil then
    -- Check if a shell is running (bash, fish)
    -- If so, enable padding, otherwise disable it
    local shell = window:active_pane():get_foreground_process_name()
    if shell:match("bash") or shell:match("fish") then
      overrides.window_padding_enabled = true
    else
      overrides.window_padding_enabled = false
    end
  end

  if window_dims.pixel_width < 1500 then
    if not overrides.window_padding then
      -- not changing anything
      return;
    end
    overrides.window_padding = nil;
  else
    -- Use only the middle 33%
    local pad = 8  -- minimum padding
    if overrides.window_padding_enabled then
      pad = math.floor(window_dims.pixel_width / 6)
    end
    local new_padding = {
      left = pad,
      right = pad,
      top = 0,
      bottom = 0
    };
    if overrides.window_padding and new_padding.left == overrides.window_padding.left then
      -- padding is same, avoid triggering further changes
      return
    end
    overrides.window_padding = new_padding
    -- Apply different colors to the padding area
  end
  window:set_config_overrides(overrides)
end

wezterm.on("window-resized", function(window, _)
  recompute_padding(window)
end);

wezterm.on("window-config-reloaded", function(window)
  recompute_padding(window)
end);


local function disable_padding(window)
  local overrides = window:get_config_overrides() or {}
  overrides.window_padding_enabled = not overrides.window_padding_enabled
  window:set_config_overrides(overrides)
end


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
  -- font_rules = {
  --   -- For Bold-but-not-italic text, use this relatively bold font, and override
  --   -- its color to a tomato-red color to make bold text really stand out.
  --   {
  --     intensity="Bold",
  --     italic=false,
  --     font=wezterm.font("Fira Code", {bold=true, italic=false}),
  --   },

  --   -- Bold-and-italic
  --   {
  --     intensity = 'Bold',
  --     italic = true,
  --     font=wezterm.font("Fira Code", {bold=true, italic=false}),
  --   },

  --   -- normal-intensity-and-italic
  --   {
  --     intensity = 'Normal',
  --     italic = true,
  --     font=wezterm.font("Fira Code", {bold=false, italic=false}),
  --   },

  --   -- half-intensity-and-italic (half-bright or dim); use a lighter weight font
  --   {
  --     intensity = 'Half',
  --     italic = true,
  --     font=wezterm.font("Fira Code", {bold=false, italic=false}),
  --   },

  --   -- half-intensity-and-not-italic
  --   {
  --     intensity = 'Half',
  --     italic = false,
  --     font=wezterm.font("Fira Code", {bold=false, italic=false}),
  --   },
  -- },
  line_height = 1.15,
  font_size = 13,
  window_frame = {
     font_size = 13,
  },
  disable_default_key_bindings = true,
  colors = colors,
  key_tables = {
    copy_mode = {
      { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'Space', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
      { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
      { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
      { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
      { key = 'F', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
      { key = 'F', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
      { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'Ñ', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'Ñ', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'T', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
      { key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
      { key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Line' } },
      { key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode =  'Line' } },
      { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
      { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'd', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (0.5) } },
      { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
      { key = 'f', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = false } } },
      { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
      { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
      { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
      { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'ñ', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
      { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
      { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 't', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = true } } },
      { key = 'u', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (-0.5) } },
      { key = 'v', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
      { key = 'v', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode =  'Block' } },
      { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'y', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
      { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
      { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    },
  },
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
      mods = 'CTRL',
      action = wezterm.action { CopyTo="Clipboard" },
    },
    {
      key = 'v',
      mods = 'CTRL',
      action = wezterm.action { PasteFrom="Clipboard" },
    },
    {
      key = 'x',
      mods = 'CTRL',
      -- Ctrl-c alternative to kill job
      action = wezterm.action { SendString="\x03" },
    },
    { -- Disable padding
      key = 'f',
      mods = 'ALT',
      action = wezterm.action_callback(disable_padding),
    },
    { -- Increase font size
      key = '+',
      mods = 'CTRL',
      action = wezterm.action.IncreaseFontSize,
    },
    { -- Increase font size
      key = '=',
      mods = 'CTRL',
      action = wezterm.action.IncreaseFontSize,
    },
    { -- Decrease font size
      key = '-',
      mods = 'CTRL',
      action = wezterm.action.DecreaseFontSize,
    },
    { -- Reset font size
      key = '0',
      mods = 'CTRL',
      action = wezterm.action.ResetFontSize,
    },
    -- CTRL-SHIFT-l activates the debug overlay
    { key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },
    -- CTRL-SHIFT-SPACE enables copy mode
    { key = ' ', mods = 'CTRL', action = wezterm.action.ActivateCopyMode },
    { key = 'Backspace', mods = 'CTRL', action = wezterm.action.SendKey {key = 'w', mods = 'CTRL'} },
  },
  -- color_schemes = {
  --   -- Override the builtin Gruvbox Light scheme with our modification.
  --   ['Dracula (base16)'] = scheme,
  -- },
  -- color_scheme = 'Dracula (base16)',
  custom_block_glyphs = false,
  cursor_thickness = 2,
  -- color_scheme = "AtomOneLight",
  force_reverse_video_cursor = false,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = true,
  -- Disable ligatures
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  front_end = 'OpenGL',
  freetype_load_target = 'Light',
  freetype_render_target = 'HorizontalLcd',
  freetype_load_flags = 'NO_HINTING',
  -- cell_width = 0.9,
}
