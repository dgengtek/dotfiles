{ config, lib, pkgs, ... }:

let
  cfg = config.dgeng.neovim;
  nvim_path = "../nvim/.config/nvim";
  lsp_servers =
    {
      clangd = { };
      nil_ls = { };
      pyright = { };
      dockerls = { };
      bashls = { };
      terraformls = { };
      gopls = { };
      tsserver = {
        init_options.tsserver.path = "${pkgs.nodePackages.typescript}/bin/tsserver";
      };
      taplo = { };
      cssls = { };
      eslint = { settings.format = false; };
      jsonls = { init_options.provideFormatter = false; };
      html = { init_options.provideFormatter = false; };
      lua_ls = {
        settings.Lua = {
          runtime.version = "LuaJIT";
          diagnostics.globals = [ "vim" ];
          workspace.library = { };
          telemetry.enable = false;
        };
      };
    };
in
{
  options.dgeng.neovim = with lib; {
    enable = mkEnableOption "neovim";
    enableLSP = mkEnableOption "enableLSP";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.neovim = lib.mkMerge [
      {
        enable = true;
        package = pkgs.neovim.overrideAttrs (_: { CFLAGS = "-O3"; });
        vimAlias = true;
        viAlias = true;
        withNodeJs = true;
        withPython3 = true;
        withRuby = false;
        extraConfig = builtins.readFile "${nvim_path}/init.vim";
        plugins = with pkgs.nvimPlugins; [
          {
            plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
            #plugin = nvim-treesitter;
            type = "lua";
            config = ''

              			require("nushell/tree-sitter-nu")
          '';
          }
          {
            plugin = none-ls-nvim;
            type = "lua";
            config = ''
              			require("nvim-lua/plenary.nvim")
              			require("nvimtools/none-ls-extras.nvim")
              			require("gbprod/none-ls-shellcheck.nvim")
            '';
          }
          {
            plugin = nvim-web-devicons;
            type = "lua";
          }
          {
            plugin = plenary.nvim;
            type = "lua";
          }
          {
            plugin = harpoon;
            type = "lua";
          }
          {
            plugin = marks.nvim;
            type = "lua";
          }
          {
            plugin = leap.nvim;
            type = "lua";
            config = ''
              		require("tpope/vim-repeat")
                  require("leap").add_default_mappings()
            '';
          }
          {
            plugin = firenvim;
            type = "lua";
            config = ''vim.fn["firenvim#install"](0)'';
          }
          {
            plugin = coq_nvim;
            type = "lua";
            config = ''
              			require("ms-jpq/coq.artifacts", branch = "artifacts")

            '';
          }
          {
            plugin = coq.artifacts;
            type = "lua";
            branch = "artifacts";
          }
          {
            plugin = fzf-lua;
            type = "lua";
            config = ''
              		require("nvim-tree/nvim-web-devicons")
            '';
          }
          {
            plugin = nvim-jqx;
            type = "lua";
          }
          {
            plugin = nvim-surround;
            type = "lua";
            config = ''require("nvim-surround").setup({})'';
          }
          {
            plugin = fm-nvim;
            type = "lua";
          }
          {
            plugin = oil.nvim;
            type = "lua";
            config = ''require("oil").setup()'';
          }
          {
            plugin = nvim-lspfuzzy;
            type = "lua";
            config = ''
              			require("junegunn/fzf")
              			require("junegunn/fzf.vim")
            '';
          }
          {
            plugin = nvim-treesitter-context;
            type = "lua";
          }
          {
            plugin = registers.nvim;
            type = "lua";
            config = ''require("registers").setup()'';
          }
          {
            plugin = fidget.nvim;
            type = "lua";
            config = ''require("fidget").setup()'';
          }
          {
            plugin = which-key.nvim;
            type = "lua";
            config = ''
              vim.o.timeout = true
              vim.o.timeoutlen = 300
              require("which-key").setup({})
            '';
          }
          {
            plugin = "cuducos/yaml.nvim";
            type = "lua";
            config = ''
              require("nvim-treesitter/nvim-treesitter")
            '';
          }
          {
            plugin = nvim-colorizer.lua;
            type = "lua";
            config = ''require("colorizer").setup({})'';
          }
          {
            plugin = Comment.nvim;
            type = "lua";
            config = ''require("Comment").setup()'';
          }
          {
            plugin = kanagawa.nvim;
            type = "lua";
          }
          {
            plugin = solarized.nvim;
            type = "lua";
          }
          {
            plugin = modus-theme-vim;
            type = "lua";
          }
          {
            plugin = aurora;
            type = "lua";
          }
          {
            plugin = nvim-hybrid;
            type = "lua";
          }
          {
            plugin = starry.nvim;
            type = "lua";
          }
          {
            plugin = "dracula/vim";
            type = "lua";
          }
          {
            plugin = indent-blankline.nvim;
            type = "lua";
          }
          {
            plugin = vim-fugitive;
            type = "lua";
          }
          {
            plugin = gitsigns.nvim;
            type = "lua";
            config = ''require("gitsigns").setup()'';
          }
          {
            plugin = vim-ledger;
            type = "lua";
          }
          {
            plugin = vimtex;
            type = "lua";
          }
          {
            plugin = vim-toml;
            type = "lua";
          }
          {
            plugin = csv.vim;
            type = "lua";
          }
          {
            plugin = vim-json;
            type = "lua";
          }
          {
            plugin = rust.vim;
            type = "lua";
          }
          {
            plugin = salt-vim;
            type = "lua";
          }
          {
            plugin = vim-go;
            type = "lua";
          }
          {
            plugin = Vim-Jinja2-Syntax;
            type = "lua";
          }
          {
            plugin = vim-yaml;
            type = "lua";
          }
          {
            plugin = vim-just;
            type = "lua";
          }
          {
            plugin = vim-hcl;
            type = "lua";
          }
          {
            plugin = vim-nickel;
            type = "lua";
          }
          {
            plugin = quick-scope;
            type = "lua";
          }
          {
            plugin = zk-nvim;
            type = "lua";
          }



          nvim-treesitter-textobjects
          vim-repeat
        ];
        extraPackages = with pkgs; [
          ripgrep
          fd
          fzf
        ];
      }

      (lib.mkIf cfg.enableLSP {
        plugins = with pkgs.nvimPlugins; [
          (
            let
              lspServers = pkgs.writeText "lsp_servers.json" builtins.toJSON lsp_servers;
            in
            {
              plugin = nvim-lspconfig;
              type = "lua";
            }
          )
          lsp_signature
          nvim-autopairs
          # {
          #   plugin = nvim-dap;
          #   type = "lua";
          #   config = ''
          #     require("config.debug")
          #   '';
          # }
          # nvim-dap-ui
          # nvim-dap-go
          # nvim-dap-python
        ];
        extraPackages = with pkgs; [
          # Python
          ruff
          (python3.withPackages (ps: with ps; [
          ]))
          # Lua
          unstable.lua-language-server
          selene
          stylua

          # text markdown
          textlint

          # html
          html-tidy

          # bash, nickel
          topiary


          # tools
          yamlfmt
          jq
          just
          rustfmt

          # Nix
          statix
          nixpkgs-fmt
          nil

          # Shell scripting
          shfmt
          shellcheck

          # JavaScript
          biome

          # Go
          go
        ];
      })
    ];

    xdg.configFile.nvim = {
      recursive = true;
      source = ../nvim/.config/nvim/lua;
    };
  };
}
