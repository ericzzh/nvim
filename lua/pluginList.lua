local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute "packadd packer.nvim"
end

local packer = require("packer")
local use = packer.use

return packer.startup(
    function()
        use "wbthomason/packer.nvim"

        use "akinsho/nvim-bufferline.lua"
        use "glepnir/galaxyline.nvim"

        -- color related stuff
        use "siduck76/nvim-base16.lua"

        use {
            "norcalli/nvim-colorizer.lua",
            event = "BufRead",
            config = function()
                require("colorizer").setup()
                vim.cmd("ColorizerReloadAllBuffers")
            end
        }

        -- language related plugins
        use {
            "nvim-treesitter/nvim-treesitter",
            event = "BufRead",
            config = function()
                require("treesitter-nvim").config()
            end
        }

        use {
            "neovim/nvim-lspconfig",
            event = "BufRead",
            config = function()
                require("nvim-lspconfig").config()
            end
        }

        use {
            "onsails/lspkind-nvim",
            event = "BufRead",
            config = function()
                require("lspkind").init()
            end
        }

        -- load compe in insert mode only
        -- use {
        --     "hrsh7th/nvim-compe",
        --     event = "InsertEnter",
        --     config = function()
        --         require("compe-completion").config()
        --     end,
        --     wants = {"LuaSnip"},
        --     requires = {
        --         {
        --             "L3MON4D3/LuaSnip",
        --             wants = "friendly-snippets",
        --             event = "InsertCharPre",
        --             config = function()
        --                 require("compe-completion").snippets()
        --             end
        --         },
        --         "rafamadriz/friendly-snippets"
        --     }
        -- }
   -- load luasnips + cmp related in insert mode only

        use {
           "rafamadriz/friendly-snippets",
           event = "InsertEnter",
        }

        use {
           "hrsh7th/nvim-cmp",
           after = "friendly-snippets",
           config = function()
               require"cmp"
           end
        }

        use {
           "L3MON4D3/LuaSnip",
           wants = "friendly-snippets",
           after = "nvim-cmp",
           config = function()
               require"set-luasnip"
           end
        }

        use {
           "saadparwaiz1/cmp_luasnip",
           after = "LuaSnip",
        }

        use {
           "hrsh7th/cmp-nvim-lua",
           after = "cmp_luasnip",
        }

        use {
           "hrsh7th/cmp-nvim-lsp",
           after = "cmp-nvim-lua",
        }

        use {
           "hrsh7th/cmp-buffer",
           after = "cmp-nvim-lsp",
        }

        use {
           "hrsh7th/cmp-path",
           after = "cmp-buffer",
        }

        -- neoformat
        use {"sbdchd/neoformat", cmd = "Neoformat"}

        -- file managing , picker etc
        use {
            "kyazdani42/nvim-tree.lua",
            config = function() 
              require("nvim-tree").setup {
                view = {
                  auto_resize = true
                }
              } 
            end
        }

        use "kyazdani42/nvim-web-devicons"
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                {"nvim-lua/popup.nvim"},
                {"nvim-lua/plenary.nvim"},
                {"nvim-telescope/telescope-fzf-native.nvim", run = "make"},
                {"nvim-telescope/telescope-media-files.nvim"}
            },
            cmd = "Telescope",
            config = function()
                require("telescope-nvim").config()
            end
        }

        -- git stuff
        use {
            "lewis6991/gitsigns.nvim",
            event = "BufRead",
            config = function()
                require("gitsigns-nvim").config()
            end
        }

        -- misc plugins
        use {
            "windwp/nvim-autopairs",
            event = "InsertEnter",
            config = function()
                require("nvim-autopairs").setup()
            end
        }

        use {"andymass/vim-matchup", event = "CursorMoved"}

        use {
            "terrortylor/nvim-comment",
            cmd = "CommentToggle",
            config = function()
                require("nvim_comment").setup()
            end
        }

        use {"tweekmonster/startuptime.vim", cmd = "StartupTime"}

        -- load autosave only if its globally enabled
        use {
            "907th/vim-auto-save",
            cond = function()
                return vim.g.auto_save == 1
            end
        }

        use {
            "Pocco81/TrueZen.nvim",
            cmd = {"TZAtaraxis", "TZMinimalist", "TZFocus"},
            config = function()
                require("zenmode").config()
            end
        }

        --   use "alvan/vim-closetag" -- for html autoclosing tag

        use {
            "lukas-reineke/indent-blankline.nvim",
            -- branch = "lua",
            event = "BufRead",
            setup = function()
                require("misc-utils").blankline()
            end
        }

        use {
          "jbyuki/one-small-step-for-vimkind",
          event = "BufRead",
          --cmd = {"lua require'osv'.launch()"}
        }

    end,
    {
        display = {
            border = {"┌", "─", "┐", "│", "┘", "─", "└", "│"}
        }
    }
)
