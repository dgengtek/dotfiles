local remap = vim.api.nvim_set_keymap

-- https://github.com/lukas-reineke/indent-blankline.nvim
vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]

require("nu").setup {
    use_lsp_features = true, -- requires https://github.com/jose-elias-alvarez/null-ls.nvim
    -- lsp_feature: all_cmd_names is the source for the cmd name completion.
    -- It can be
    --  * a string, which is interpreted as a shell command and the returned list is the source for completions (requires plenary.nvim)
    --  * a list, which is the direct source for completions (e.G. all_cmd_names = {"echo", "to csv", ...})
    --  * a function, returning a list of strings and the return value is used as the source for completions
    all_cmd_names = [[nu -c 'help commands | get name | str join "\n"']]
}
require("indent_blankline").setup {
    char = "",
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
    },
    space_char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
    },
    show_trailing_blankline_indent = false,
}

require('fm-nvim').setup{
      -- Path to broot config
      -- broot_conf = vim.fn.stdpath("data") .. "/site/pack/packer/start/fm-nvim/assets/broot_conf.hjson"
      broot_conf = vim.fn.expand("\"$HOME/.config/broot/conf.hjson;$HOME/.config/broot/select.toml\"")
}

require'marks'.setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions.
  -- higher values will have better performance but may cause visual lag,
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world",
    -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
    -- defaults to false.
    annotate = false,
  },
  mappings = {}
}

vim.g.coq_settings = {
  keymap = {
    recommended = false,
  },
  auto_start = "shut-up",
}


-- TODO fix keybindings for autocompletion
-- set manual completion keybind control+space
-- set abort keybind ctrl+c or ctrl+y
-- set accept keybind ctrl+j
-- coq Keybindings
remap('i', '<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
remap('i', '<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
remap('i', '<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
remap('i', '<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

-- https://github.com/windwp/nvim-autopairs
-- fix for autopairs with coq completion menu
-- skip it, if you use another global object
local npairs = require('nvim-autopairs')
npairs.setup({ map_bs = false, map_cr = false })
_G.MUtils= {}

MUtils.CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return npairs.esc('<c-y>')
    else
      return npairs.esc('<c-e>') .. npairs.autopairs_cr()
    end
  else
    return npairs.autopairs_cr()
  end
end
remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return npairs.esc('<c-e>') .. npairs.autopairs_bs()
  else
    return npairs.autopairs_bs()
  end
end
remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })


local coq = require "coq"
-- require('lspconfig').yamlls.setup(coq.lsp_ensure_capabilities())
-- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
require('lspconfig').pylsp.setup(coq.lsp_ensure_capabilities({
  settings = {
    pylsp = {
      plugins = {
        flake8 = {
          enabled = false
        },
        pyflakes = {
          enabled = false
        },
      }
    }
  }
}))
require('lspconfig').rust_analyzer.setup(coq.lsp_ensure_capabilities())

require('lspfuzzy').setup {}


-- " 1. Modify your config
-- " 2. Restart nvim
-- " 3. Run this command:
-- :KanagawaCompile
require("kanagawa").setup({
  overrides = function(colors) -- add/modify highlights
        colors = {
          Visual = { bg = "#605439" }
        }
        return colors
  end,
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
null_ls.setup({
    -- format on save
    -- you can reuse a shared lspconfig on_attach callback here
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    vim.lsp.buf.format({ bufnr = bufnr })
                    -- vim.lsp.buf.formatting_sync()
                end,
            })
        end
    end,
    -- TODO install sources
    sources = {
    --     null_ls.builtins.completion.spell,
    --     -- tags
    --     null_ls.builtins.completion.tags,
    --     -- make files
    --     null_ls.builtins.diagnostics.checkmake,
    --     -- latex
    --     null_ls.builtins.diagnostics.chktex,
    --     -- dot files
    --     null_ls.builtins.diagnostics.dotenv_linter,
    --     null_ls.builtins.diagnostics.luacheck,
    --     null_ls.builtins.diagnostics.markdownlint,
    --     null_ls.builtins.diagnostics.pycodestyle,
    --     -- python
    --     -- null_ls.builtins.diagnostics.flake8,
    --     -- python linter
          null_ls.builtins.diagnostics.ruff,
    --     -- shell linter
          null_ls.builtins.diagnostics.shellcheck,
    --     -- json, yaml
    --     null_ls.builtins.diagnostics.spectral,
          -- yamlls seems broken, autocompleting in insert mode
          -- null_ls.builtins.diagnostics.yamllint,
    --     -- javascript
    --     -- null_ls.builtins.diagnostics.standardjs,
    --     null_ls.builtins.diagnostics.cspell,
    --     -- sql
    --     -- null_ls.builtins.diagnostics.sqlfluff,
    --     null_ls.builtins.diagnostics.stylelint,
    --     -- html
    --     -- null_ls.builtins.diagnostics.tidy,
    --     null_ls.builtins.code_actions.cspell,
    --     -- openapi
    --     -- null_ls.builtins.diagnostics.vacuum,
    --     null_ls.builtins.formatting.stylua,
    --     null_ls.builtins.diagnostics.eslint,
    --     null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.yamlfmt,
    --     -- python code formatter
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.jq,
    -- null_ls.builtins.formatting.dprint,
        null_ls.builtins.formatting.just,
        -- null_ls.builtins.formatting.ruff,
        -- rust format
        null_ls.builtins.formatting.rustfmt,
        -- shell format
        null_ls.builtins.formatting.shfmt,
        --  NF{print s $0; s=""; next} {s=s ORS}'
        null_ls.builtins.formatting.trim_newlines,
        -- '{ sub(/[ \t]+$/, ""); print }'
        null_ls.builtins.formatting.trim_whitespace,
        -- todo sort and update in place
        --null_ls.builtins.formatting.yq.with({
          --args = { "sort_keys(..)", "$FILENAME" }
        -- }),
    },
})


vim.diagnostic.config({
  -- virtual_text = true,
  virtual_text = {
    source = "always",  -- Or "if_many"
    prefix = '●', -- Could be '■', '▎', 'x'
  },
  -- severity_sort = false,
  severity_sort = true,
  -- float = {
  --   source = "always",  -- Or "if_many"
  -- },
  -- signs = true,
  -- underline = true,
  -- update_in_insert = false,
  update_in_insert = true,
})

local callback = function()
    vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(client)
            return client.name == "null-ls"
        end
    })
end,

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
