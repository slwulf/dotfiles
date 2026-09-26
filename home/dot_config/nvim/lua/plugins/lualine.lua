return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local theme = require("lualine.themes.monokai-pro")
    -- distinguish modes by shade within the purple family, not by hue
    theme.normal.a.bg, theme.normal.b.fg = "#ae81ff", "#ae81ff" -- kitty bright purple
    theme.command.a.bg, theme.command.b.fg = "#ae81ff", "#ae81ff" -- matches normal, as in stock theme
    theme.insert.a.bg, theme.insert.b.fg = "#8c6bc8", "#8c6bc8" -- kitty purple (muted)
    theme.visual.a.bg, theme.visual.b.fg = "#a291a5", "#a291a5" -- mauve border color
    theme.replace.a.bg, theme.replace.a.fg = "#3c3341", "#ae81ff" -- inverted: dark chip, bright purple text
    theme.replace.b.fg = "#ae81ff"
    opts.options.theme = theme

    opts.sections.lualine_z = {
      function()
        local icon = (vim.env.SSH_CLIENT or vim.env.SSH_TTY) and "🦄" or "💩"
        return icon .. " " .. os.date("%I:%M%p")
      end,
    }
  end,
}
