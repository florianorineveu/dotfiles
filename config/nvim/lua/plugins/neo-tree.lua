-- neo-tree configuration
--
-- Copyright (c) 2026 Florian "Ori" Neveu
-- SPDX-License-Identifier: WTFPL

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    lazy = false,

    config = function()
        require("neo-tree").setup({
            window = {
                position = "right",
                width = 30,
            },
            filesystem = {
                filtered_stats = {
                    hide_dotfiles = false,
                },
            },
        })

        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                require("neo-tree.command").execute({ action = "show" })
            end,
        })
    end,

    keys = {
        { "<leader>e", ":Neotree toggle<CR>", desc = "Explorateur de fichiers" },
    },
}
