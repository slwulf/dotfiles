return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      ["*"] = { "trim_whitespace" },
    },
    formatters = {
      trim_whitespace = {
        condition = function(_, ctx)
          return vim.bo[ctx.buf].filetype ~= "markdown"
        end,
      },
    },
  },
}
