local function build_keymap_set(mode)
	return function(lhs, rhs, opts)
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

local imap = build_keymap_set("i")
local nmap = build_keymap_set("n")
local vmap = build_keymap_set("v")

-- coq Keybindings
imap("<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true, desc = "abort coq" })
imap("<c-c>", [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true, desc = "abort coq" })
imap("<tab>", [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true, desc = "select next" })
imap("<s-tab>", [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true, desc = "select previous" })
-- coq defaults
-- imap('<bs>', [[pumvisible() ? "<c-e><bs>"  : "<bs>"]], { expr = true, noremap = true })
-- imap('<cr>', [[pumvisible() ? (complete_info().selected == -1 ? "<c-e><cr>" : "<c-y>") : "<cr>"]], { expr = true, noremap = true })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
nmap("<space>e", vim.diagnostic.open_float, { desc = "open diagnostic" })
nmap("[d", vim.diagnostic.goto_prev, { desc = "previouy diagnostic" })
nmap("]d", vim.diagnostic.goto_next, { desc = "next diagnostic" })
nmap("<space>q", vim.diagnostic.setloclist, { desc = "set diagnostic loclist" })

vim.keymap.set({ "n", "v", "i" }, "<C-t><C-f>", function()
	require("fzf-lua").complete_path()
end, { silent = true, desc = "Fuzzy complete path" })

-- function get_buffer()
--   local selected_buffer = require("fzf-lua").buffers()
--   vim.cmd("topleft vnew" .. selected_buffer)
-- end

nmap("<space>kr", function()
	require("fzf-lua").lsp_references()
end, { desc = "select LSP references" })
nmap("<space>kd", function()
	require("fzf-lua").lsp_document_diagnostics()
end, { desc = "select LSP document diagnostics" })
nmap("<space>kD", function()
	require("fzf-lua").lsp_workspace_diagnostics()
end, { desc = "select LSP workspace diagnostics" })
nmap("<space>ka", function()
	require("fzf-lua").lsp_code_actions()
end, { desc = "select LSP code actions" })
nmap("<space>ks", function()
	require("fzf-lua").lsp_document_symbols()
end, { desc = "select LSP document symbols" })
nmap("<space>kS", function()
	require("fzf-lua").lsp_workspace_symbols()
end, { desc = "select LSP workspace symbols" })

nmap("<space>ss", function()
	require("fzf-lua").live_grep()
end, { desc = "live grep" })
nmap("<space>sS", function()
	require("fzf-lua").live_grep_glob()
end, { desc = "live grep globbing" })
nmap("<space>sw", function()
	require("fzf-lua").grep_cword()
end, { desc = "grep cword" })
nmap("<space>sb", function()
	require("fzf-lua").grep_curbuf()
end, { desc = "grep current buffer" })

nmap("<space>t", function()
	require("fzf-lua").tabs()
end, { desc = "select tabs" })
nmap("<space>b", function()
	require("fzf-lua").buffers()
end, { desc = "select buffers" })

nmap("<space>ff", function()
	require("fzf-lua").files()
end, { desc = "select files" })
nmap("<space>fq", function()
	require("fzf-lua").quickfix()
end, { desc = "select quickfix" })
nmap("<space>fl", function()
	require("fzf-lua").loclist()
end, { desc = "select loclist" })
nmap("<space>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "select help tags" })
nmap("<space>gc", function()
	require("fzf-lua").git_commits()
end, { desc = "select from git commits" })
nmap("<space>gC", function()
	require("fzf-lua").git_bcommits()
end, { desc = "select commits of this buffer" })

nmap("<space>hc", function()
	require("fzf-lua").command_history()
end, { desc = "search command history" })
nmap("<space>hs", function()
	require("fzf-lua").search_history()
end, { desc = "search history" })
nmap("<space>hr", function()
	require("fzf-lua").registers()
end, { desc = "select register" })
nmap("<space>hm", function()
	require("fzf-lua").marks()
end, { desc = "select mark" })
nmap("<space>hj", function()
	require("fzf-lua").jumps()
end, { desc = "select jumps" })
nmap("<space>hk", function()
	require("fzf-lua").keymaps()
end, { desc = "search keymap" })
nmap("<space>ha", function()
	require("fzf-lua").autocmds()
end, { desc = "search autocmd" })

-- splitting windows and buffers
-- uses full height or width
nmap("<leader>sw<left>", ":topleft vnew<CR>", { desc = "split full height left" })
nmap("<leader>sw<right>", ":botright vnew<CR>", { desc = "split full height right" })
nmap("<leader>sw<up>", ":topleft new<CR>", { desc = "split full width up" })
nmap("<leader>sw<down>", ":botright new<CR>", { desc = "split full width bot" })

-- nmap('<leader>swb<left>', get_buffer)
-- nmap('<leader>swb<right>', ":botright vnew<CR>")
-- nmap('<leader>swb<up>', ":topleft new<CR>")
-- nmap('<leader>swb<down>', ":botright new<CR>")

-- uses only the height or width of current buffer
nmap("<leader>s<left>", ":leftabove vnew<CR>", { desc = "split curr width left" })
nmap("<leader>s<right>", ":rightbelow vnew<CR>", { desc = "split curr width right" })
nmap("<leader>s<up>", ":leftabove new<CR>", { desc = "split curr height up" })
nmap("<leader>s<down>", ":rightbelow new<CR>", { desc = "split curr height up" })

-- nmap('<leader>sb<left>', ":leftabove vnew<CR>")
-- nmap('<leader>sb<right>', ":rightbelow vnew<CR>")
-- nmap('<leader>sb<up>', ":leftabove new<CR>")
-- nmap('<leader>sb<down>', ":rightbelow new<CR>")

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local function gen_opts(desc)
			return { buffer = ev.buf, desc = desc }
		end
		nmap("gD", vim.lsp.buf.declaration, gen_opts("goto declaration"))
		nmap("gd", vim.lsp.buf.definition, gen_opts("goto definition"))
		nmap("K", vim.lsp.buf.hover, gen_opts("display hover window"))
		nmap("gi", vim.lsp.buf.implementation, gen_opts("goto implementation"))
		nmap("<C-k>", vim.lsp.buf.signature_help, gen_opts("display signature help"))
		nmap("<space>wa", vim.lsp.buf.add_workspace_folder, gen_opts("add worksapce folder"))
		nmap("<space>wr", vim.lsp.buf.remove_workspace_folder, gen_opts("remove workspace folder"))
		nmap("<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, gen_opts("list workspace folders"))
		nmap("<space>D", vim.lsp.buf.type_definition, gen_opts("goto type definition"))
		nmap("<space>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "rename" })
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, gen_opts("code action"))
		nmap("gr", vim.lsp.buf.references, gen_opts("show references"))
		nmap("<space>f", function()
			vim.lsp.buf.format({ async = true })
		end, gen_opts("format current buffer"))
	end,
})

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "FugitiveIndex",
	command = "nmap <buffer> dt :Gtabedit <Plug><cfile><Bar>Gdiffsplit<CR>",
})

-- https://github.com/mickael-menu/zk-nvim
nmap(
	"<leader>zn",
	"<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
	{ noremap = true, silent = false, desc = "create new zettel" }
)
nmap(
	"<leader>zo",
	"<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
	{ noremap = true, silent = false, desc = "open notes" }
)
nmap("<leader>zt", "<Cmd>ZkTags<CR>", { noremap = true, silent = false, desc = "open notes with the selected tags" })
nmap(
	"<leader>zf",
	"<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
	{ noremap = true, silent = false, desc = "search notes" }
)
vmap("<leader>zf", ":'<,'>ZkMatch<CR>", { noremap = true, silent = false, desc = "search notes from visual selection" })
