-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local palette = require("config.palette")

local function recolor(group, values)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, values))
end

local function apply_recolors()
  recolor("SnacksPickerTitle", { fg = palette.mauve })
  recolor("SnacksTitle", { fg = palette.mauve })
  recolor("FzfLuaTitle", { bg = palette.background, fg = palette.mauve })
end

apply_recolors()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_recolors })
vim.api.nvim_create_autocmd("FileType", { pattern = "fzf", callback = apply_recolors })
