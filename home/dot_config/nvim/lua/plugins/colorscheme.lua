local palette = require("config.palette")

return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      override_palette = function()
        return {
          background = palette.background,
          dark1 = palette.background,
          dark2 = palette.background_dark,
          text = palette.foreground,
          dimmed1 = palette.light,
          dimmed2 = palette.mauve,
          dimmed3 = palette.gray,
          dimmed4 = palette.dark_gray,
          dimmed5 = palette.border_dim,
        }
      end,
      override_scheme = function()
        return { tab = { activeForeground = palette.purple, activeBorder = palette.purple } }
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
