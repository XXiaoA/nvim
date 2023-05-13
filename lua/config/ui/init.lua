local current_colorscheme = require("core.colorscheme").current_colorscheme
local add_colorscheme = require("core.colorscheme").add_colorscheme
add_colorscheme("random")

return {
    -- colorscheme
    {
        "sainnhe/everforest",
        init = function()
            add_colorscheme("everforest")
        end,
    },

    {
        "folke/tokyonight.nvim",
        init = function()
            add_colorscheme("tokyonight-storm", "tokyonight-moon")
        end,
    },

    {
        "AlexvZyl/nordic.nvim",
        init = function()
            add_colorscheme("nordic")
        end,
    },

    {
        "sainnhe/gruvbox-material",
        init = function()
            add_colorscheme("gruvbox-material")
        end,
    },

    {
        "EdenEast/nightfox.nvim",
        build = ":NightfoxCompile",
        init = function()
            add_colorscheme("duskfox", "nightfox")
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        init = function()
            add_colorscheme("rose-pine")
        end,
    },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        build = ":CatppuccinCompile" and current_colorscheme:find("catppuccin"),
        init = function()
            add_colorscheme("catppuccin-mocha", "catppuccin-macchiato")
        end,
    },

    -- plugins
    {
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },

    {
        "uga-rosa/ccc.nvim",
        cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterToggle" },
        config = true,
    },

    {
        "folke/zen-mode.nvim",
        dependencies = {
            "folke/twilight.nvim",
        },
        keys = {
            { "<leader>zz", "<CMD>ZenMode<CR>" },
            { "<leader>zt", "<CMD>Twilight<CR>" },
        },
        opts = {
            plugins = {
                options = {
                    enabled = true,
                    showcmd = true,
                },
                twilight = { enabled = true },
                gitsigns = { enabled = true },
                tmux = { enabled = true },
            },
            on_open = function()
                require("lualine").hide()
                vim.opt_local.winbar = nil
            end,
            on_close = function()
                require("lualine").hide({ unhide = true })
            end,
        },
    },
}
