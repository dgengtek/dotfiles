set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" https://neovim.io/doc/user/lua-guide.html#lua-guide
lua require('plugins')
lua require('config')
lua require('mapping')


augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

colorscheme kanagawa
