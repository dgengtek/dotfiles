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
--]=====]


-- TODO for folding maybe https://github.com/kevinhwang91/nvim-ufo

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  use 'nvim-tree/nvim-web-devicons'
  use 'nvim-lua/plenary.nvim'
  use 'ThePrimeagen/harpoon'
  use 'chentoast/marks.nvim'
  use "sitiom/nvim-numbertoggle"

  use {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end,
    requires = { 'tpope/vim-repeat' },
  }

  -- Post-install/update hook with call of vimscript function with argument
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
    config = function()
      vim.g.coq_settings = {
        keymap = {
          recommended = false,
        },
        auto_start = "shut-up",
      }
    end,
  }

  use {
    'ms-jpq/coq.artifacts',
    branch = 'artifacts',
  }

  -- maybe? https://github.com/toppair/reach.nvim
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
  use {
    'w0rp/ale',
    -- ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
    -- cmd = 'ALEEnable',
    -- config = 'vim.cmd[[ALEEnable]]'
  }

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/nvim-treesitter-context'

  use "williamboman/mason.nvim"
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }
  use "lukas-reineke/indent-blankline.nvim"

  use {
    'abecodes/tabout.nvim',
    config = function()
      require('tabout').setup {
      tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
      backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
      act_as_tab = true, -- shift content if tab out is not possible
      act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
      default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
      default_shift_tab = '<C-d>', -- reverse shift default action,
      enable_backwards = true, -- well ...
      completion = true, -- if the tabkey is used in a completion pum
      tabouts = {
        {open = "'", close = "'"},
        {open = '"', close = '"'},
        {open = '`', close = '`'},
        {open = '(', close = ')'},
        {open = '[', close = ']'},
        {open = '{', close = '}'}
      },
      ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
      exclude = {} -- tabout will ignore these filetypes
    }
    end,
    wants = {'nvim-treesitter'}, -- or require if not used so far
    after = {'coq_nvim'} -- if a completion plugin is using tabs load it before
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

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
end)

--[=====[ 
  Plug 'vimwiki/vimwiki'
  Plug 'junegunn/fzf.vim'
  Plug 'scrooloose/nerdcommenter'
  Plug 'Chiel92/vim-autoformat'
  Plug 'scrooloose/syntastic'
  Plug 'https://github.com/ludovicchabant/vim-gutentags'
  " syntax
  Plug 'lervag/vimtex'
  Plug 'https://github.com/cespare/vim-toml'
  Plug 'https://github.com/chrisbra/csv.vim'
  Plug 'https://github.com/elzr/vim-json'
  Plug 'https://github.com/rust-lang/rust.vim'
  Plug 'saltstack/salt-vim'
  Plug 'https://github.com/fatih/vim-go'
  Plug 'Glench/Vim-Jinja2-Syntax'
  Plug 'stephpy/vim-yaml'
  Plug 'lervag/wiki.vim'
  Plug 'NoahTheDuke/vim-just'
  Plug 'unblevable/quick-scope'



  " snippets
  Plug 'SirVer/ultisnips'
  " snippets collection
  Plug 'honza/vim-snippets'


  -- Simple plugins can be specified as strings
  use 'rstacruz/vim-closer'

  -- Lazy loading:
  -- Load on specific commands
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  -- Load on an autocommand event
  use {'andymass/vim-matchup', event = 'VimEnter'}


--]=====]
