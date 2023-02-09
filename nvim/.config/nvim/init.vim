set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" https://neovim.io/doc/user/lua-guide.html#lua-guide
lua require('plugins')
lua require('config')


augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

" coq Keybindings
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"
