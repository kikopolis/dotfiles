-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Use ö/ä as [/] (easier on Estonian layout than Option+8/9), e.g. äf = next function
vim.keymap.set({ "n", "x", "o" }, "ö", "[", { remap = true, desc = "[ prefix" })
vim.keymap.set({ "n", "x", "o" }, "ä", "]", { remap = true, desc = "] prefix" })
