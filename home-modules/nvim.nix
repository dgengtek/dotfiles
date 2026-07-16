{ config, options, lib, pkgs, ... }:

let
  cfg = config.dotfiles.neovim;
  nvim_path = "../nvim/.config/nvim";
  vimrc = ../vim/.vimrc;
in
{
  options.dotfiles.neovim = with lib; {
    enable = mkEnableOption "neovim";
    enableLSP = mkEnableOption "enableLSP";
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;
      configFile."nvim/lua".source = ./. + "/${nvim_path}/lua";
      desktopEntries = lib.optionalAttrs pkgs.stdenv.isLinux {
        neovim = {
          name = "Neovim";
          genericName = "editor";
          exec = "nvim -f %F";
          mimeType = [
            "text/html"
            "text/xml"
            "text/plain"
            "text/english"
            "text/x-makefile"
            "text/x-c++hdr"
            "text/x-tex"
            "application/x-shellscript"
          ];
          terminal = false;
          type = "Application";
        };
      };
    };

    home.packages = [
      (pkgs.writeShellApplication {
        name = "firenvim-install";
        text = ''
          exec '${config.programs.neovim.finalPackage}/bin/nvim' --headless '+call firenvim#install(0) | q'
        '';
      })
    ];


    # if required, reference the final packaged neovim output
    # config.programs.neovim.finalPackage
    programs.neovim = lib.mkMerge [
      {
        enable = true;
        package = pkgs.neovim-unwrapped;
        defaultEditor = true;
        vimAlias = true;
        viAlias = true;
        withNodeJs = false;
        withPython3 = true;
        withRuby = false;
        initLua = ''
          vim.o.exrc = false
          vim.cmd('source ${vimrc}')

          -- https://neovim.io/doc/user/lua-guide.html#lua-guide
          require('config')
          require('commands')
          require('mapping')

          vim.cmd.colorscheme('kanagawa')
        '';
        #extraLuaConfig = "";
        plugins =
          let
            treesitter-grammars = with pkgs.nvim-treesitter-parsers; [
              nix
              python
              rust
              bash
              nickel
              lua
              yaml
              json
              toml
              diff
              markdown
              markdown_inline
              make
              ledger
              latex
              udev
              hcl
              sql
              xml
              vim
              html
              ini
              jinja
              jinja_inline
              jq
              just
              nu
            ];
            # required for syntax highlighting and folds.
            treesitter-queries = map (p: p.associatedQuery) treesitter-grammars;
          in
          with pkgs.vimPlugins;
          treesitter-grammars ++
          treesitter-queries ++
          [
            nvim-treesitter
            nvim-treesitter-context
            nvim-treesitter-textobjects
            none-ls-nvim
            nvim-web-devicons
            plenary-nvim
            harpoon
            marks-nvim
            {
              plugin = leap-nvim;
              type = "lua";
              config = ''
                vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
                vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
                vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')
              '';
            }
            firenvim
            {
              plugin = pkgs.vimUtils.buildVimPlugin {
                pname = "coq_nvim";
                version = "0-unstable-16-06-26";
                buildInputs = with pkgs.python313Packages; [
                  pynvim-pp
                  pyyaml
                  std2
                ];
                src = pkgs.fetchFromGitHub {
                  owner = "ms-jpq";
                  repo = "coq_nvim";
                  rev = "7911f272700449891cbe79e3f87690c4ac638c91";
                  hash = "sha256-kP+LrA9Rs0Kfx8eTJ0Cpt5Yg/7RDZS8Ujkm7M8D2pHM=";
                };
                meta = {
                  homepage = "https://github.com/ms-jpq/coq_nvim";
                  hydraPlatforms = [ ];
                };
                doCheck = false;
              };
              type = "lua";
            }

            coq-artifacts
            fzf-lua
            nvim-jqx
            {
              plugin = nvim-surround;
              type = "lua";
              config = ''require("nvim-surround").setup({})'';
            }
            {
              plugin = (pkgs.vimUtils.buildVimPlugin {
                pname = "none-ls-extras-nvim";
                version = "main";
                src = pkgs.fetchFromGitHub {
                  owner = "nvimtools";
                  repo = "none-ls-extras.nvim";
                  rev = "167f29529ff1438e673b1792a71aaf79ddd6c74f";
                  hash = "sha256-3Os+DyijgE9gSRX4OwLAWnH24IUvYP8IBgl/HtZUtJU=";
                };
                meta = {
                  homepage = "https://github.com/nvimtools/none-ls-extras.nvim";
                  hydraPlatforms = [ ];
                };
              }).overrideAttrs
                {
                  # required for import smoke test
                  dependencies = [ none-ls-nvim ];
                };
              type = "lua";
            }
            {
              plugin = pkgs.vimUtils.buildVimPlugin {
                pname = "fm-nvim";
                version = "master";
                src = pkgs.fetchFromGitHub {
                  owner = "is0n";
                  repo = "fm-nvim";
                  rev = "8e6a77049330e7c797eb9e63affd75eb796fe75e";
                  hash = "sha256-I29p08P4Wh/LLTDZIQ2TkYy5Kdj0G8loU6k3eFM+iVE=";
                };
                meta = {
                  homepage = "https://github.com/is0n/fm-nvim";
                  license = lib.meta.getLicenseFromSpdxId "GPL-3.0-only";
                  hydraPlatforms = [ ];
                };
              };
              type = "lua";
            }
            {
              plugin = oil-nvim;
              type = "lua";
              config = ''require("oil").setup()'';
            }
            {
              plugin = pkgs.vimUtils.buildVimPlugin {
                pname = "nvim-lspfuzzy";
                version = "main";
                src = pkgs.fetchFromGitHub {
                  owner = "ojroques";
                  repo = "nvim-lspfuzzy";
                  rev = "cd51aecb511d773226d8148124c708e636742457";
                  hash = "sha256-u+Zl9uITueAX/YPA6uuWX7e94VvRqCEq7SGefOxcXBw=";
                };
                meta = {
                  homepage = "https://github.com/ojroques/nvim-lspfuzzy";
                  license = lib.licenses.bsd2;
                  hydraPlatforms = [ ];
                };
              };
              type = "lua";
            }
            fzf-wrapper
            fzf-vim
            {
              plugin = pkgs.vimUtils.buildVimPlugin {
                pname = "registers.nvim";
                version = "main";
                src = pkgs.fetchurl {
                  url = "https://codeberg.org/fosk/registers.nvim/archive/main.tar.gz";
                  hash = "sha256-NhNpiU7F/x3bJ25Cnk9y6UB6ZPEji0a79KZ4MMewq08=";
                };
                meta = {
                  homepage = "https://codeberg.org/fosk/registers.nvim";
                  license = lib.meta.getLicenseFromSpdxId "GPL-3.0-only";
                  hydraPlatforms = [ ];
                };
              };
              type = "lua";
              config = ''require("registers").setup()'';
            }
            {
              plugin = fidget-nvim;
              type = "lua";
              config = ''require("fidget").setup()'';
            }
            {
              plugin = which-key-nvim;
              type = "lua";
              config = ''
                vim.o.timeout = true
                vim.o.timeoutlen = 300
                require("which-key").setup({})
              '';
            }
            {
              plugin = pkgs.vimUtils.buildVimPlugin {
                pname = "yaml.nvim";
                version = "main";
                src = pkgs.fetchFromGitHub {
                  owner = "cuducos";
                  repo = "yaml.nvim";
                  rev = "e70ee49f7aefc79dce020d3ffc3c9447b0c52236";
                  hash = "sha256-NNc5Zb4EYi6L+gd76I/NxIIYgxTvHplEhy03Q9GUAuc=";
                };
                meta = {
                  homepage = "https://github.com/cuducos/yaml.nvim";
                  license = lib.meta.getLicenseFromSpdxId "GPL-3.0-only";
                  hydraPlatforms = [ ];
                };
              };
              type = "lua";
            }
            {
              plugin = nvim-colorizer-lua;
              type = "lua";
              config = ''require("colorizer").setup({})'';
            }
            {
              plugin = mini-comment;
              type = "lua";
              config = ''require("mini.comment").setup()'';
            }
            kanagawa-nvim
            solarized-nvim
            aurora
            indent-blankline-nvim
            vim-fugitive
            {
              plugin = gitsigns-nvim;
              type = "lua";
              config = ''require("gitsigns").setup()'';
            }
            vim-ledger
            vimtex
            vim-toml
            csv-vim
            vim-json
            rust-vim
            salt-vim
            vim-go
            vim-yaml
            vim-just
            vim-hcl
            vim-nickel
            quick-scope
            zk-nvim

            vim-repeat
          ]
        ;
        extraPackages = with pkgs; [
          (python313.withPackages (ps: with ps; [
          ]))
          ueberzugpp
          luaPackages.tree-sitter-cli
          ripgrep
          fd
          fzf
          nushell
        ];
      }

      (lib.mkIf cfg.enableLSP {
        plugins = with pkgs.vimPlugins; [
          nvim-lspconfig
          lsp_signature-nvim
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
            python-lsp-server
          ]))
          # Lua
          lua-language-server
          selene # lua diagnostics
          stylua # lua formatter

          # text markdown
          textlint

          # html
          html-tidy

          # bash, nickel
          topiary # nickel, sh, json fmt
          bash-language-server

          # latex
          biber


          # tools
          yamlfmt # yaml
          jq
          just
          rustfmt

          # Nix
          statix # nix lints, sugg
          nixpkgs-fmt # nix formatter
          nil # nix lsp

          # Shell scripting
          shfmt # bash format
          shellcheck # bash lint

          # JavaScript
          biome # javascript formatter, diagnostics

          # Go
          go

          rust-analyzer

          nls # nickel lsp
          nushell # nu lsp
          vale # prose, markdown, tex,
          textlint # text, markdown formatter
        ];
      })
    ];

  };
}
