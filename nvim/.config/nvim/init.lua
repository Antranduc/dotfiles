-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before lazy.nvim loads plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
  { "neovim/nvim-lspconfig" },
})

-- Enable language servers
-- nvim-lspconfig provides the config data (filetypes, root markers, defaults).
-- vim.lsp.enable() activates them using Neovim's native LSP client.
vim.lsp.enable("clangd")
