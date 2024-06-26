" use vi improved
set nocompatible
filetype plugin indent on
" coloring
if (&term == "screen" || &term == "screen-bce" || &term == "xterm" || &term == "xterm-256color")
  set t_Co=256
endif
if has('termguicolors')
  set termguicolors
endif

if has("syntax")
  syntax on
endif


" set completeopt=menu,preview
set backupskip+=test,tmp,temp

set encoding=utf-8
set background=dark

" concealing
set conceallevel=2
set concealcursor=c

" use :set list to enable
" use :set nolist to disable
" list chars tab,eol,trail etc
" default eol
" set listchars+=eol:$
" tab char
set listchars+=tab:>-
" trailing space char
set listchars+=trail:-
set listchars+=precedes:<,extends:>

set nojoinspaces

set wrap
set sidescroll=20
set textwidth=0
set wrapmargin=0
set splitbelow
set splitright


set linebreak
set scrolloff=999
set sidescrolloff=999

" expand tab to spaces with '>' and '<'; and if autoindent is on
" insert real tab with ctrl-v<Tab>
set expandtab

" default tabstop
" set tabstop=8
" make tabs appear to be 2 spaces long
set softtabstop=2
" shifts used for '<' '>'
set shiftwidth=2
" set noexpandtab


set showmatch  " Show matching brackets.
set matchtime=2  " Bracket blinking.
"set novisualbell  " No blinking
"set noerrorbells  " No noise.
set laststatus=2  " Always show status line.
set ruler  " Show ruler

" disable mouse
set mouse=

if !has('nvim')
    set ttymouse=
endif
" hide mouse when typing
"set mousehide

" ignore case when all chars are lower
set smartcase
set incsearch

" menu completion with tab in cmd mode
set wildmenu
" matches all
set wildmode=full
" Ignore these files when completing
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**

set viminfo='100,<50,s2048,h
set history=10000

set statusline=
set statusline +=\ %n\ %*            "buffer number
set statusline +=%{&ff}%*            "file format
set statusline +=%y%*                "file type
set statusline +=\ %<%F%*            "full path
set statusline +=\ \ %m%r%w\ %P\ \                      "Modified? Readonly? Top/bot.
set statusline +=%{fugitive#statusline()}
set statusline +=%4l,%v\ %*             "virtual column number
set statusline +=0x%04B\ %*          "character under cursor
set statusline +=%#warningmsg#
set statusline +=%*

" highlight search
set hlsearch

if !has('nvim')
"highlight code longer than 88
highlight OverLength term=bold ctermbg=blue ctermfg=white guibg=blue
highlight StatusLineNC cterm=bold ctermfg=white ctermbg=darkgray
match OverLength /\%89v.\+/
endif

set pastetoggle=<F10>

set number
set relativenumber

if has("unnamedplus")
  " yank into + register, * all
  set clipboard=unnamedplus
else
  " all op into * register
  set clipboard=unnamed
endif


"if has("autocmd")
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  autocmd FileType html setlocal shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType python setlocal shiftwidth=4 softtabstop=4
  autocmd FileType bash setlocal shiftwidth=2 softtabstop=2
  autocmd FileType just setlocal shiftwidth=2 softtabstop=2
  autocmd FileType java setlocal shiftwidth=4 softtabstop=4
  autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType nickel setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType nix setlocal ts=2 sts=2 sw=2 expandtab
"endif

au BufRead,BufNewFile *.adoc,*.asciidoc setfiletype asciidoc
au BufRead,BufNewFile *.sls setfiletype sls
au BufRead,BufNewFile *.nix setfiletype nix
au BufRead,BufNewFile *.ncl setfiletype nickel
au BufRead,BufNewFile *.jinja,*.jinja2,*.j2 setfiletype jinja
au BufRead,BufNewFile *.yaml,*.yml setfiletype yaml
au BufRead,BufNewFile *.toml setfiletype toml
au BufRead,BufNewFile *.rs setfiletype rust
au BufRead,BufNewFile *.csv,*.dat setfiletype csv
au BufRead,BufNewFile justfile setfiletype just


" https://github.com/junegunn/vim-plug
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
" Commands
" Command 	Description
" PlugInstall [name ...] [#threads] 	Install plugins
" PlugUpdate [name ...] [#threads] 	Install or update plugins
" PlugClean[!] 	Remove unlisted plugins (bang version will clean without prompt)
" PlugUpgrade 	Upgrade vim-plug itself
" PlugStatus 	Check the status of plugins
" PlugDiff 	Examine changes from the previous update and the pending changes
" PlugSnapshot[!] [output path] 	Generate script for restoring the current snapshot of the plugins

" for vim
if !has('nvim')
call plug#begin('~/.vim/plugged')
  Plug 'vimwiki/vimwiki'
  Plug 'junegunn/fzf.vim'
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-surround'
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

  Plug 'Valloric/YouCompleteMe'
  " snippets
  Plug 'SirVer/ultisnips'
  " snippets collection
  Plug 'honza/vim-snippets'
" Initialize plugin system
call plug#end()
endif

" reload vim on changes with vimrc
augroup myvimrc
  au!
  au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

if &diff
  highlight DiffAdd cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
  highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
  highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
  highlight DiffText cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red
endif

" quick-scope
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" disable on long lines
" let g:qs_max_chars=89
" for colorschemes, must be set before setting colorschemes
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END

" ultisnips
let g:UltiSnipsExpandTrigger="<c-j>"
" let g:UltiSnipsJumpForwardTrigger="<c-j>"
" let g:UltiSnipsJumpBackwardTrigger="<c-f>"
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" tex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0

" rustfmt
let g:autofmt_autosave = 1

" syntastic
let g:syntastic_asciidoc_asciidoc_exec = "asciidoctor"

if !has('nvim')
" ycm
let g:ycm_server_python_interpreter = '/usr/bin/python3'
let g:ycm_auto_hover = ''
let g:ycm_autoclose_preview_window_after_completion = 1
" for reference
" let g:ycm_key_invoke_completion = '<C-Space>'
" let g:ycm_key_list_stop_completion = ['<C-y>']
" let g:ycm_key_detailed_diagnostics = '<leader>d'
endif


let g:ftplugin_sql_omni_key = '<Leader>sql'

" vimwiki
let g:vimwiki_global_ext = 0
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_url_maxsave = 40
let g:vimwiki_conceallevel = 2
" vimwikitoc
let g:vimwiki_html_header_numbering = 1
let g:vimwiki_html_header_numbering_sym = '.'


let wiki_1 = {}
let wiki_1.path = '~/vimwiki/std/'
let wiki_1.path_html = '~/vimwiki/std/html'
let wiki_1.auto_tags= 1
let wiki_1.auto_toc = 1

let wiki_2 = {}
let wiki_2.path = '~/mnt/private/vimwiki/'
let wiki_2.path_html = '~/mnt/private/vimwiki/html'
let wiki_2.auto_tags= 1
let wiki_2.auto_toc = 1

let g:vimwiki_list = [wiki_1, wiki_2]

" wiki
let g:wiki_root = '~/wiki'
let g:wiki_link_target_type = 'adoc_xref_bracket'
let g:wiki_link_extension = '.adoc'
let g:wiki_filetypes = ['adoc']
let g:wiki_mappings_use_defaults = 'local'
let g:wiki_write_on_nav = 1


function! HLNext (blinktime)
  let target_pat = '\c\%#'.@/
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction

set modeline

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>


if !has('nvim')
" No need for relative numbers in background windows
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set relativenumber
  autocmd WinLeave * set norelativenumber
augroup END
endif " nvim


" get backlinks
function! s:markdown_backlinks()
  call fzf#vim#grep(
    \ "rg --column --line-number --no-heading --color=always --smart-case "
    \ . expand('%:t') , 1,
    \ fzf#vim#with_preview('right:50%:hidden', '?'), 0)
endfunction


function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction


" copy fzf window selection as window of selection
function! s:copy_results(lines)
  let joined_lines = join(a:lines, "\n")
  if len(a:lines) > 1
    let joined_lines .= "\n"
  endif
  let @+ = joined_lines
endfunction


" capture output of a vim command
function! Exec(command)
    redir =>output
    silent exec a:command
    redir END
    return output
endfunction


" TODO: how to paste result without echoing
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-o': ':r !echo',
  \ 'ctrl-n': function('s:copy_results'),
  \ }

" copy to f buffer
" paste with "fp or <c-r>f
autocmd BufLeave * let @f=expand('#')


command! Backlinks call s:markdown_backlinks()
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
command! -nargs=* -bang Tags call RipgrepFzf(':tags:.*' . <q-args>, <bang>0)
command! DateIsoShort :r!date '+\%Y\%m\%dT\%H\%M\%S'
command! DateIso :r!date --iso-8601=seconds
command! -range FormatKomma :<line1>,<line2>s/,[ ]*/, /g
command! ClearSearch let @/=''
command! -range Canonize :<line1>,<line2>!canonize.sh
command! ZettelNeu :DateIsoShort
command! IDDate :DateIsoShort
command! UUID :r!uuidgen
command! Backup execute 'silent !cp % %.bak' | redraw!
command! Restore execute 'silent !mv %.bak %' | redraw!


" mappings
noremap <F3> :Autoformat<CR><CR>
nnoremap <F8> :!%:p<CR>
" select from buffers
nnoremap <F9> :buffers<CR>:buffer<Space>
" stop cr
vnoremap // y/<C-R>"<CR>


if !has('nvim')
" Damian Conway's Die Blinkënmatchen: highlight matches
nnoremap <silent> n n:call HLNext(0.1)<cr>
nnoremap <silent> N N:call HLNext(0.1)<cr>
endif

" sudo overwrite file
cmap w!! w !sudo tee > /dev/null %

" fzf mappings
" https://github.com/zenbro/dotfiles/blob/master/.nvimrc#L151-L187
nnoremap <silent> <leader><space> :Files<CR>
nnoremap <silent> <leader>a :Buffers<CR>
nnoremap <silent> <leader>A :Windows<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>O :Tags<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>/ :execute 'RG ' . input('RG/')<CR>
nnoremap <silent> <leader>. :RG

nnoremap <silent> <leader>gl :Commits<CR>
nnoremap <silent> <leader>ga :BCommits<CR>
nnoremap <silent> <leader>ft :Filetypes<CR>

imap <C-x><C-f> <plug>(fzf-complete-file-ag)
imap <C-x><C-l> <plug>(fzf-complete-line)
