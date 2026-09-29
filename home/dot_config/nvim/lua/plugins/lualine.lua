return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local palette = require("config.palette")
    local theme = require("lualine.themes.monokai-pro")
    -- distinguish modes by shade within the purple family, not by hue
    theme.normal.a.bg, theme.normal.b.fg = palette.purple, palette.purple
    theme.command.a.bg, theme.command.b.fg = palette.purple, palette.purple -- matches normal, as in stock theme
    theme.insert.a.bg, theme.insert.b.fg = palette.purple_muted, palette.purple_muted
    theme.visual.a.bg, theme.visual.b.fg = palette.mauve, palette.mauve
    theme.replace.a.bg, theme.replace.a.fg = palette.border_dim, palette.purple -- inverted: dark chip, bright purple text
    theme.replace.b.fg = palette.purple
    opts.options.theme = theme

    opts.sections.lualine_z = {
      function()
        local icon = (vim.env.SSH_CLIENT or vim.env.SSH_TTY) and "🦄" or "💩"
        return icon .. " " .. os.date("%I:%M%p")
      end,
    }

    local winbar = { lualine_c = { { "filename", path = 1 } } }
    opts.winbar = winbar
    opts.inactive_winbar = winbar
  end,
}
