-- Main neovim configuration
--
-- Copyright (c) 2026 Florian "Ori" Neveu
-- SPDX-License-Identifier: WTFPL

local opt = vim.opt

-- ------------------------------------------------------------------
-- Bootstrap lazy.nvim
-- ------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

opt.rtp:prepend(lazypath)

-- ------------------------------------------------------------------
-- Keymaps
-- ------------------------------------------------------------------
vim.g.mapleader = " "

-- Windows navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Fenêtre gauche" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Fenêtre droite" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Fenêtre bas" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Fenêtre haut" })

-- ------------------------------------------------------------------
-- Relative line numbers
-- ------------------------------------------------------------------
opt.number = true
opt.relativenumber = true

-- ------------------------------------------------------------------
-- Indentation
-- ------------------------------------------------------------------
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- ------------------------------------------------------------------
-- Search
-- ------------------------------------------------------------------
opt.ignorecase = true
opt.smartcase = true

-- ------------------------------------------------------------------
-- Comfort
-- ------------------------------------------------------------------
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.wrap = false
opt.cursorline = true

-- ------------------------------------------------------------------
-- System clipboard
-- ------------------------------------------------------------------
opt.clipboard = "unnamedplus"

-- ------------------------------------------------------------------
-- Windows
-- ------------------------------------------------------------------
opt.splitbelow = true
opt.splitright = true

-- ------------------------------------------------------------------
-- Plugins loading
-- ------------------------------------------------------------------
require("lazy").setup("plugins")
