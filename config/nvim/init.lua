-- Main neovim configuration
--
-- Copyright (c) 2026 Florian "Ori" Neveu
-- SPDX-License-Identifier: WTFPL

local opt = vim.opt

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
