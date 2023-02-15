--[=====[ 
-- You must run this or `PackerSync` whenever you make changes to your plugin configuration
-- Regenerate compiled loader file
:PackerCompile

-- Remove any disabled or unused plugins
:PackerClean

-- Clean, then install missing plugins
:PackerInstall

-- Clean, then update and install plugins
-- supports the `--preview` flag as an optional first argument to preview updates
:PackerUpdate

-- Perform `PackerUpdate` and then `PackerCompile`
-- supports the `--preview` flag as an optional first argument to preview updates
:PackerSync

-- Show list of installed plugins
:PackerStatus

-- Loads opt plugin immediately
:PackerLoad completion-nvim ale


-- TODO for folding maybe https://github.com/kevinhwang91/nvim-ufo

--- TODO try out and configure, check lsp plugins
neovim/nvim-lspconfig: Quickstart configs for Nvim LSP
https://github.com/neovim/nvim-lspconfig

 mfussenegger/nvim-lint: An asynchronous linter plugin for Neovim complementary to the built-in Language Server Protocol support.
https://github.com/mfussenegger/nvim-lint

 jose-elias-alvarez/null-ls.nvim: Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
https://github.com/jose-elias-alvarez/null-ls.nvim

 mhartington/formatter.nvim
https://github.com/mhartington/formatter.nvim

Snippets · neovim/nvim-lspconfig Wiki
https://github.com/neovim/nvim-lspconfig/wiki/Snippets
--]=====]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- install and manage lsp, formatters, linters etc.
  -- use {
  --   "williamboman/mason.nvim",
  --   config = function()
  --     require("mason").setup({
  --         ui = {
  --             icons = {
  --                 package_installed = "✓",
  --                 package_pending = "➜",
  --                 package_uninstalled = "✗"
  --             }
  --         }
  --     })
  --   end,
  -- }
  -- use {
  --   'williamboman/mason-lspconfig.nvim',
  --   config = function()
  --     require("mason-lspconfig").setup()
  --   end,
  -- }

  -- nvim-lspconfig/server_configurations.md at master · neovim/nvim-lspconfig
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require('null-ls').setup()
    end,
    requires = { "nvim-lua/plenary.nvim" },
  }
  use 'nvim-tree/nvim-web-devicons'
  -- lua lib
  use 'nvim-lua/plenary.nvim'
  -- marks across nvim
  use 'ThePrimeagen/harpoon'
  -- better marks
  use 'chentoast/marks.nvim'

  -- quick move with s
  use {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end,
    requires = { 'tpope/vim-repeat' },
  }

  -- Post-install/update hook with call of vimscript function with argument
  -- embed nvim in firefox
  use {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end 
  }

  -- Use specific branch, dependency and run lua file after load
  use {
    'ms-jpq/coq_nvim',
    branch = 'coq',
    requires = {
      { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
    },
  }

  use {
    'ms-jpq/coq.artifacts',
    branch = 'artifacts',
  }

  -- https://github.com/ibhagwan/fzf-lua
  -- :FzfLua 
  use { 'ibhagwan/fzf-lua',
    -- optional for icon support
    requires = { 'nvim-tree/nvim-web-devicons' }
  }
  
  -- json editing with jq, for yaml requires yq
  use "gennaro-tedesco/nvim-jqx"

  use({
      "kylechui/nvim-surround",
      tag = "*", -- Use for stability; omit to use `main` branch for the latest features
      config = function()
          require("nvim-surround").setup({
              -- Configuration here, or leave empty to use defaults
          })
      end
  })

  -- file explorer
  -- :RnvimrToggle
  use 'kevinhwang91/rnvimr'
  -- https://github.com/is0n/fm-nvim
  -- use {'is0n/fm-nvim'}

  -- edit filesystem like a buffer
  use {
    'stevearc/oil.nvim',
    config = function() require('oil').setup() end
  }
  -- https://github.com/elihunter173/dirbuf.nvim
  -- use "elihunter173/dirbuf.nvim"

  -- fzf lsp
  use {
    'ojroques/nvim-lspfuzzy',
    requires = {
      {'junegunn/fzf'},
      {'junegunn/fzf.vim'},  -- to enable preview (optional)
    },
  }

  -- Load on a combination of conditions: specific filetypes or commands
  -- Also run code after load (see the "config" key)
  -- syntax analyzer
  use {
    'w0rp/ale',
    -- ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
    -- cmd = 'ALEEnable',
    -- config = 'vim.cmd[[ALEEnable]]'
  }

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/nvim-treesitter-context'

  use {
    "windwp/nvim-autopairs",
  }

  use {
    "tversteeg/registers.nvim",
    config = function()
      require("registers").setup()
    end,
  }

  use {
    'j-hui/fidget.nvim',
    config = function()
      require("fidget").setup()
    end,
  }

  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use {
    "cuducos/yaml.nvim",
    ft = {"yaml"}, -- optional
    requires = {
      "nvim-treesitter/nvim-treesitter",
    },
  }

  use { "nvchad/nvim-colorizer.lua",
    config = function ()
      require("colorizer").setup {
      }
    end
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  -- colorschemes
  -- https://github.com/rebelot/kanagawa.nvim
  use {
    'rebelot/kanagawa.nvim',
    config = function()
      require("kanagawa").setup({
        overrides = {
          Visual = { bg = "#938056" }
        },
      })
    end
  }
  -- modus-vivendi, maybe, not good function color
  use 'ishan9299/modus-theme-vim'
  use 'ray-x/aurora'
  -- use { "bluz71/vim-moonfly-colors", as = "moonfly" }
  -- maybe, functions are too bright
  use 'PHSix/nvim-hybrid'
  -- starry_style = moonlight, dracula, dracula_blood, monokai, mariana, emerald, middlenight_blue, earlysummer, darksolar
  -- moonlight, too much red
  -- dracula good
  -- monokai good
  -- middlenight_blue ok
  -- earlysummer good
  use 'ray-x/starry.nvim'
  use 'dracula/vim'
  -- 
  use "lukas-reineke/indent-blankline.nvim"
  --
  use 'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  -- use 'vimwiki/vimwiki'
  -- syntax
  use 'ledger/vim-ledger'
  use 'lervag/vimtex'
  use 'cespare/vim-toml'
  use 'chrisbra/csv.vim'
  use 'elzr/vim-json'
  use 'rust-lang/rust.vim'
  use 'saltstack/salt-vim'
  use 'fatih/vim-go'
  use 'Glench/Vim-Jinja2-Syntax'
  use 'stephpy/vim-yaml'
  use 'NoahTheDuke/vim-just'

  -- etc
  use 'unblevable/quick-scope'
end)
