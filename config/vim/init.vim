" References:
" https://github.com/spf13/spf13-vim/tree/3.0
" https://github.com/wsdjeg/SpaceVim
" https://github.com/liuchengxu/space-vim
" https://github.com/amix/vimrc
" https://github.com/wklken/k-vim
" https://github.com/theopn/kickstart.vim
" https://github.com/chenxuan520/vim-fast
" https://github.com/skywind3000/vim

" Options:
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set virtualedit=block
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set notermguicolors
set background=dark
colorscheme desert
set number
set relativenumber
set ruler
set nowrap
set showcmd
set wildmenu
set cursorline
set scrolloff=5
set hlsearch
set incsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set history=1000
set clipboard^=unnamed,unnamedplus
syntax on
filetype plugin indent on

" Keybindings:
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
imap jk <Esc>
cmap jk <Esc>
nnoremap j gj
nnoremap k gk
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
inoremap <C-a> <HOME>
inoremap <C-e> <END>
cnoremap <C-a> <HOME>
cnoremap <C-e> <END>

" AutoCommand:
augroup FileTypeWrap
  autocmd!
  autocmd FileType markdown,text setlocal wrap | nnoremap <buffer> <expr> j (v:count == 0 ? 'gj' : 'j') | nnoremap <buffer> <expr> k (v:count == 0 ? 'gk' : 'k')
augroup END
augroup RestoreCursorPosition
  autocmd!
  autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
augroup END
augroup DisableAutoComment
  autocmd!
  autocmd FileType * setlocal formatoptions-=r formatoptions-=o
augroup END
augroup PythonIndentSettings
  autocmd!
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
augroup END

" Packages:
let data_dir = has('win32') || has('win64') ? '$HOME\vimfiles' : '~/.vim'
if empty(glob(data_dir.'/autoload/plug.vim'))
  if has('win32') || has('win64')
    silent execute '!powershell -Command "New-Item -Path "'.data_dir.' -Name autoload -Type Directory -Force; Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -OutFile '.data_dir.'\autoload\plug.vim"'
  else
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endif
  augroup VimPlugSetup
    autocmd!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif
augroup VimPlugInstall
  autocmd!
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) | PlugInstall --sync | source $MYVIMRC | endif
augroup END

call plug#begin()

Plug 'ryanoasis/vim-devicons', { 'on': [] }
augroup ui_devicons
  autocmd!
  autocmd BufReadPost * call plug#load('vim-devicons')
        \| autocmd! ui_devicons
augroup END

Plug 'morhetz/gruvbox', { 'on': [] }
augroup ui_gruvbox
  autocmd!
  autocmd BufReadPost * call plug#load('gruvbox')
        \| autocmd! ui_gruvbox
        \| colorscheme gruvbox
augroup END

Plug 'vim-airline/vim-airline', { 'on': [] }
augroup ui_airline
  autocmd!
  autocmd BufReadPost * call plug#load('vim-airline')
        \| autocmd! ui_airline
        \| let g:airline_extensions = ['tabline']
        \| let g:airline_highlighting_cache = 1
augroup END

Plug 'airblade/vim-gitgutter', { 'on': [] }
augroup ui_gitgutter
  autocmd!
  autocmd BufReadPost * call plug#load('vim-gitgutter')
        \| autocmd! ui_gitgutter
augroup END

Plug 'itchyny/vim-cursorword', { 'on': [] }
augroup ui_cursorword
  autocmd!
  autocmd BufReadPost * call plug#load('vim-cursorword')
        \| autocmd! ui_cursorword
        \| highlight link CursorWord CursorLine
augroup END

Plug 'wincent/terminus', { 'on': [] }
augroup ui_terminus
  autocmd!
  autocmd BufReadPost * call plug#load('terminus')
        \| autocmd! ui_terminus
augroup END

Plug 'machakann/vim-highlightedyank', { 'on': [] }
augroup ui_highlightedyank
  autocmd!
  autocmd BufReadPost * call plug#load('vim-highlightedyank')
        \| autocmd! ui_highlightedyank
        \| let g:highlightedyank_highlight_duration = 1000
        \| highlight HighlightedyankRegion cterm=reverse gui=reverse
augroup END

Plug 'LunarWatcher/auto-pairs', { 'on': [] }
augroup tool_autopairs
  autocmd!
  autocmd InsertEnter * call plug#load('auto-pairs')
        \| autocmd! tool_autopairs
        \| call autopairs#AutoPairsTryInit()
augroup END

Plug 'luochen1990/rainbow', { 'on': [] }
augroup tool_rainbow
  autocmd!
  autocmd InsertEnter * call plug#load('rainbow')
        \| autocmd! tool_rainbow
        \| call rainbow_main#toggle()
augroup END

Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle'] }
Plug 'liuchengxu/nerdtree-dash', { 'on': ['NERDTreeToggle'] }
nnoremap <leader>tm :NERDTreeToggle<CR>

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim', { 'on': ['Commands', 'Files', 'Buffers', 'Colors', 'Rg', 'Lines', 'BLines', 'History'] }
let g:fzf_layout = { 'down': '17' }
nnoremap <leader><leader> :Commands<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fc :Colors<CR>
nnoremap <leader>fw :Rg 
nnoremap <leader>fs :BLines<CR>
nnoremap <leader>fS :Lines<CR>
nnoremap <leader>fr :History<CR>

Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
let g:which_key_map =  {}
let g:which_key_map.f = { 'name': '+Find' }
let g:which_key_map.f.f = 'files'
let g:which_key_map.f.b = 'buffers'
let g:which_key_map.f.c = 'themes'
let g:which_key_map.f.w = 'words'
let g:which_key_map.f.s = 'lines'
let g:which_key_map.f.S = 'all lines'
let g:which_key_map.f.r = 'recentf'
autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<C-u>WhichKey  ','<CR>

call plug#end()
