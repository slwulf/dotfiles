return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      override_palette = function()
        return {
          background = "#1a1420", -- kitty's terminal background
          dark1 = "#1a1420", -- same tier, kitty has no third shade
          dark2 = "#120e16", -- kitty's inactive_tab_background
          text = "#eaf2f1", -- kitty foreground
          dimmed1 = "#e3e3dd", -- kitty color7
          dimmed2 = "#a291a5", -- kitty active_border_color
          dimmed3 = "#696d77", -- kitty inactive_tab_foreground
          dimmed4 = "#474747", -- kitty color0
          dimmed5 = "#3c3341", -- kitty inactive_border_color
        }
      end,
      override = function(scheme)
        local blend = require("monokai-pro.colors").blend
        return {
          NormalFloat = { bg = scheme.editor.background }, -- unify float body with its border
          Pmenu = { bg = scheme.editor.background },
          CursorLine = { bg = blend(scheme.base.dimmed1, 0.30, scheme.editor.background) },
          Visual = { bg = blend(scheme.base.dimmed1, 0.40, scheme.editor.background) },
          WinSeparator = { fg = scheme.base.dimmed2 }, -- kitty active_border_color, matches picker border
          SnacksPickerListCursorLine = { bg = blend(scheme.base.dimmed2, 0.35, scheme.editor.background) },
        }
      end,
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "monokai-pro" } },
}
