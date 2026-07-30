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
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,cp936,gb18030
set virtualedit=block
set autowrite
set autoread
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set termguicolors
set background=dark
colorscheme desert
set number
set cursorline
set relativenumber
set ruler
set nowrap
set showcmd
set wildmenu
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
set lazyredraw
set noundofile
set nobackup
set noswapfile
set timeout
set timeoutlen=300
set hidden
set signcolumn=yes
set splitbelow
set splitright
set completeopt=menuone,noinsert,noselect,preview
set pumheight=15
set pumwidth=30
set mouse=

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
tnoremap <Esc> <C-\><C-n>
tnoremap jk <C-\><C-n>
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l

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
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab textwidth=88 colorcolumn=88
augroup END
augroup close_with_q
  autocmd!
  autocmd FileType help,man,startuptime nnoremap <buffer><silent> q :close<CR>
augroup END
augroup auto_create_dir
  autocmd!
  autocmd BufWritePre * if &buftype == '' && !isdirectory(expand('<afile>:p:h')) | call mkdir(expand('<afile>:p:h'), 'p') | endif
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

" SYNTAX
Plug 'vim-polyglot/vim-polyglot', { 'on': [] }
augroup syntax_polyglot
  autocmd!
  autocmd FileType * call plug#load('vim-polyglot')
        \| autocmd! syntax_polyglot
augroup END

" LINTER
Plug 'dense-analysis/ale', { 'on': [] }
augroup linter_ale
  autocmd!
  autocmd BufReadPost * call plug#load('ale')
        \| autocmd! linter_ale
        \| let g:ale_lint_on_text_changed = 'never'
        \| let g:ale_lint_on_insert_leave = 0
        \| let g:ale_lint_on_save = 1
        \| let g:ale_maximum_file_size = 500000
augroup END

" UI
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
        \| let g:gruvbox_italic = 1
        \| let g:gruvbox_contrast_dark = 'hard'
        \| colorscheme gruvbox
augroup END

Plug 'vim-airline/vim-airline', { 'on': [] }
augroup ui_airline
  autocmd!
  autocmd BufReadPost * call plug#load('vim-airline')
        \| autocmd! ui_airline
        \| set laststatus=2
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
        \| set mouse=
augroup END

Plug 'ntpeters/vim-better-whitespace', { 'on': [] }
augroup ui_better_whitespace
  autocmd!
  autocmd BufReadPost * call plug#load('vim-better-whitespace')
        \| autocmd! ui_better_whitespace
augroup END

Plug 'machakann/vim-highlightedyank', { 'on': [] }
augroup ui_highlightedyank
  autocmd!
  autocmd BufReadPost * call plug#load('vim-highlightedyank')
        \| autocmd! ui_highlightedyank
        \| let g:highlightedyank_highlight_duration = 1000
        \| highlight HighlightedyankRegion cterm=reverse gui=reverse
augroup END

Plug 'ap/vim-css-color', { 'on': [] }
augroup ui_css_color
  autocmd!
  autocmd BufReadPre * call plug#load('vim-css-color')
        \| autocmd! ui_css_color
augroup END

" FORMAT
Plug 'sbdchd/neoformat', { 'on': ['Neoformat'] }
nnoremap <leader>F :Neoformat<CR>

" TOOL
Plug 'tpope/vim-commentary', { 'on': [] }
augroup tool_commentary
  autocmd!
  autocmd BufReadPost * call plug#load('vim-commentary')
        \| autocmd! tool_commentary
augroup END

Plug 'voldikss/vim-floaterm', { 'on': ['FloatermToggle', 'FloatermNew'] }
let g:floaterm_width = 0.92
let g:floaterm_height = 0.88
let g:floaterm_position = 'center'
let g:floaterm_borderchars = ['─', '│', '─', '│', '╭', '╮', '╯', '╰']
let g:floaterm_autoclose = 2
let g:floaterm_autoinsert = 1
let g:floaterm_title = ' === Float Terminal === '
if has('win32') || has('win64')
  let g:floaterm_shell = 'powershell'
else
  let g:floaterm_shell = 'bash'
endif
augroup floaterm_autoclose
  autocmd!
  autocmd User FloatermOpen setlocal nobuflisted
augroup END
nnoremap <leader>Tt :FloatermToggle<CR>
nnoremap <leader>Tn :FloatermNext<CR>
nnoremap <leader>Tp :FloatermPrev<CR>
nnoremap <leader>Tk :FloatermKill<CR>
nnoremap <leader>Tf :FloatermNew<CR>

Plug 'tpope/vim-fugitive', { 'on': ['G', 'Git'] }
nnoremap <leader>G :Git<CR>

Plug 'dstein64/vim-startuptime', { 'on': ['StartupTime'] }
nnoremap <leader>tt :StartupTime<CR>

Plug 'easymotion/vim-easymotion', { 'on': ['<Plug>(easymotion-overwin-line)', '<Plug>(easymotion-overwin-w)', '<Plug>(easymotion-overwin-f2)'] }
nmap <leader>gl <Plug>(easymotion-overwin-line)
nmap <leader>gw <Plug>(easymotion-overwin-w)
nmap <leader>gc <Plug>(easymotion-overwin-f2)

Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle'] }
Plug 'liuchengxu/nerdtree-dash', { 'on': ['NERDTreeToggle'] }
nnoremap <leader>tn :NERDTreeToggle<CR>

Plug 'mbbill/undotree', { 'on': ['UndotreeToggle'] }
nnoremap <leader>tu :UndotreeToggle<CR>

Plug 'liuchengxu/vista.vim', { 'on': ['Vista!!'] }
let g:vista_default_executive = 'vim_lsp'
nnoremap <leader>tv :Vista!!<CR>

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
let g:which_key_map.F = 'Format Code'
let g:which_key_map.g = { 'name': '+Goto' }
let g:which_key_map.g.w = 'words'
let g:which_key_map.g.l = 'lines'
let g:which_key_map.g.c = 'chars'
let g:which_key_map.t = { 'name': '+Toggle' }
let g:which_key_map.t.n = 'Nerd Tree'
let g:which_key_map.t.u = 'Undo Tree'
let g:which_key_map.t.t = 'Startup Time'
let g:which_key_map.T = { 'name': '+Terminal' }
let g:which_key_map.T.t = 'Toggle'
let g:which_key_map.T.n = 'Next'
let g:which_key_map.T.p = 'Previous'
let g:which_key_map.T.k = 'Kill'
let g:which_key_map.T.n = 'new'
autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<C-u>WhichKey  ','<CR>

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': ['go'] }

" COMPLETION
Plug 'prabirshrestha/vim-lsp', { 'on': [] }
Plug 'prabirshrestha/asyncomplete.vim', { 'on': [] }
Plug 'prabirshrestha/asyncomplete-lsp.vim', { 'on': [] }
Plug 'prabirshrestha/asyncomplete-buffer.vim', { 'on': [] }
Plug 'prabirshrestha/asyncomplete-file.vim', { 'on': [] }
Plug 'hrsh7th/vim-vsnip', { 'on': [] }
Plug 'hrsh7th/vim-vsnip-integ', { 'on': [] }
Plug 'mattn/vim-lsp-settings', { 'on': [] }
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction
augroup lsp_install
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
augroup lsp
  autocmd!
  autocmd InsertEnter * call plug#load('asyncomplete.vim', 'asyncomplete-buffer.vim', 'asyncomplete-file.vim', 'vim-lsp', 'asyncomplete-lsp.vim', 'vim-vsnip', 'vim-vsnip-integ', 'vim-lsp-settings')
        \| autocmd! lsp
        \| call asyncomplete#enable_for_buffer()
        \| let g:lsp_diagnostics_enabled = 0
        \| call lsp#enable()
        \| call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({ 'name': 'buffer', 'allowlist': ['*'], 'blocklist': ['go'], 'completor': function('asyncomplete#sources#buffer#completor'), 'config': { 'max_buffer_size': 5000000 } }))
        \| call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({ 'name': 'file', 'allowlist': ['*'], 'priority': 10, 'completor': function('asyncomplete#sources#file#completor') }))
        \| imap <expr> <Tab> pumvisible() ? "\<C-n>" : vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
        \| smap <expr> <Tab> pumvisible() ? "\<C-n>" : vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
        \| imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
        \| smap <expr> <S-Tab> pumvisible() ? "\<C-p>" : vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
        \| inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : "\<CR>"
        \| if executable('clangd') | autocmd User lsp_setup call lsp#register_server({ 'name': 'clangd', 'cmd': { server_info -> ['clangd', '-background-index'] }, 'whitelist': ['c', 'cpp', 'objc', 'objcpp'] }) | endif
augroup END

Plug 'LunarWatcher/auto-pairs', { 'on': [] }
augroup completion_autopairs
  autocmd!
  autocmd InsertEnter * call plug#load('auto-pairs')
        \| autocmd! completion_autopairs
        \| call autopairs#AutoPairsTryInit()
augroup END

Plug 'luochen1990/rainbow', { 'on': [] }
augroup completion_rainbow
  autocmd!
  autocmd InsertEnter * call plug#load('rainbow')
        \| autocmd! completion_rainbow
        \| call rainbow_main#toggle()
augroup END

call plug#end()
