local function build_keymap_set(mode)
  return function(lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local imap = build_keymap_set("i")
local nmap = build_keymap_set("n")

-- coq Keybindings
imap('<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
imap('<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
imap('<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
imap('<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })
-- coq defaults
-- imap('<bs>', [[pumvisible() ? "<c-e><bs>"  : "<bs>"]], { expr = true, noremap = true })
-- imap('<cr>', [[pumvisible() ? (complete_info().selected == -1 ? "<c-e><cr>" : "<c-y>") : "<cr>"]], { expr = true, noremap = true })


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
nmap('<space>e', vim.diagnostic.open_float)
nmap('[d', vim.diagnostic.goto_prev)
nmap(']d', vim.diagnostic.goto_next)
nmap('<space>q', vim.diagnostic.setloclist)


vim.keymap.set({ "n", "v", "i" }, "<C-t><C-f>",
  function() require("fzf-lua").complete_path() end,
  { silent = true, desc = "Fuzzy complete path"
})

-- function get_buffer()
--   local selected_buffer = require("fzf-lua").buffers()
--   vim.cmd("topleft vnew" .. selected_buffer)
-- end

nmap("<space>kr", function() require "fzf-lua".lsp_references() end)
nmap("<space>kd", function() require "fzf-lua".lsp_document_diagnostics() end)
nmap("<space>kD", function() require "fzf-lua".lsp_workspace_diagnostics() end)
nmap("<space>ka", function() require "fzf-lua".lsp_code_actions() end)
nmap("<space>ks", function() require "fzf-lua".lsp_document_symbols() end)
nmap("<space>kS", function() require "fzf-lua".lsp_workspace_symbols() end)

nmap("<space>ss", function() require("fzf-lua").live_grep() end)
nmap("<space>sS", function() require("fzf-lua").live_grep_glob() end)
nmap("<space>sw", function() require("fzf-lua").grep_cword() end)

nmap("<space>ff", function() require("fzf-lua").files() end)
nmap("<space>fh", function() require("fzf-lua").help_tags() end)
nmap("<space>ss", function() require("fzf-lua").live_grep() end)
nmap("<space>sS", function() require("fzf-lua").live_grep_glob() end)
nmap("<space>sw", function() require("fzf-lua").grep_cword() end)
nmap("<space>sb", function() require("fzf-lua").grep_curbuf() end)
nmap("<space>;",  function() require("fzf-lua").buffers() end)
nmap("<space>gc", function() require("fzf-lua").git_commits() end)
nmap("<space>gC", function() require("fzf-lua").git_bcommits() end)

-- splitting windows and buffers
nmap('<leader>sw<left>', ":topleft vnew<CR>")
nmap('<leader>sw<right>', ":botright vnew<CR>")
nmap('<leader>sw<up>', ":topleft new<CR>")
nmap('<leader>sw<down>', ":botright new<CR>")

-- nmap('<leader>swb<left>', get_buffer)
-- nmap('<leader>swb<right>', ":botright vnew<CR>")
-- nmap('<leader>swb<up>', ":topleft new<CR>")
-- nmap('<leader>swb<down>', ":botright new<CR>")

nmap('<leader>s<left>', ":leftabove vnew<CR>")
nmap('<leader>s<right>', ":rightbelow vnew<CR>")
nmap('<leader>s<up>', ":leftabove new<CR>")
nmap('<leader>s<down>', ":rightbelow new<CR>")

-- nmap('<leader>sb<left>', ":leftabove vnew<CR>")
-- nmap('<leader>sb<right>', ":rightbelow vnew<CR>")
-- nmap('<leader>sb<up>', ":leftabove new<CR>")
-- nmap('<leader>sb<down>', ":rightbelow new<CR>")

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
    nmap('gD', vim.lsp.buf.declaration, opts)
    nmap('gd', vim.lsp.buf.definition, opts)
    nmap('K', vim.lsp.buf.hover, opts)
    nmap('gi', vim.lsp.buf.implementation, opts)
    nmap('<C-k>', vim.lsp.buf.signature_help, opts)
    nmap('<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    nmap('<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    nmap('<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    nmap('<space>D', vim.lsp.buf.type_definition, opts)
    nmap('<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    nmap('gr', vim.lsp.buf.references, opts)
    nmap('<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
