"--------------------------------------------------------------
"   Plugin and Runtime Management
"--------------------------------------------------------------
"{{{
runtime! debian.vim             " Enable Debian-specific behaviors
runtime! ftplugin/man.vim       " View man pages directly in vim

" Use Pathogen to manage plugins and the runtime path
" apt install vim-pathogen && vim-addon-manager install pathogen
execute pathogen#infect()
"}}}

"--------------------------------------------------------------
"   General Behavior
"--------------------------------------------------------------
"{{{
set nocompatible                " Improved!

filetype plugin indent on       " Enable file type detect and assist

scriptencoding utf-8            " utf-8 all the things
set encoding=utf-8

set history=128                 " Increase number of history lines
set backspace=eol,start,indent  " Intuitive backspace behavior
set hidden                      " Background buffers without saving
set lazyredraw                  " Don't redraw during macros (performance)
set pastetoggle=<F10>           " Toggle between paste and normal modes
set tags=.git/tags;$HOME        " Look for tags in the local repo first,
                                " then recurse back to home
set timeout                     " Timeout on mappings and key codes
set timeoutlen=250              " Shorten time to wait after ESC
set nomodeline                  " For security don't read modelines by default
set nobackup                    " Turn off backups
set writebackup                 " Except temporarily when overwriting a file
set noswapfile                  " Don't use swap files

" Alter 'formatoptions' after every filetype-specific plugin
autocmd FileType * setlocal
    \ formatoptions+=c          " Do auto-wrap comments using textwidth
    \ formatoptions-=r          " Don't insert comment leader on <Enter>
    \ formatoptions+=o          " Do insert comment leader on command
    \ formatoptions+=q          " Do allow gq formatting

" Load modelines on demand
nnoremap <leader>dr :setlocal modeline \| :e<CR>

" Edit and reload .vimrc
nnoremap <leader>re :e ~/.vimrc<CR>
nnoremap <leader>rr :source ~/.vimrc<CR>
"}}}

"--------------------------------------------------------------
"   User Interface
"--------------------------------------------------------------
"{{{
set wildmenu                    " Enhanced command-line completion
set wildmode=longest,list,full  " Display completions like a shell
set wildignore+=*.o,*.a,*.so,   " Don't complete compiled files
set wildignore+=*.pyc,*.pyo,    " Don't complete Python bytecode
set wildignore+=*~,*.bak        " Don't complete backups
set ruler                       " Always show the current position
set scrolloff=3                 " Keep 3 lines above and below the cursor
set foldmethod=marker           " Default to marker folding
set foldenable                  " Turn on folding
set hlsearch                    " Highlight search
set ignorecase                  " Be case insensitive when searching
set incsearch                   " Start search while entering search term
set smartcase                   " Be case sensitive when input has capital
set showmatch                   " Highlight matching brackets
set noerrorbells                " Disable error sounds and indicators
set novisualbell
set t_vb=
set tm=500

" Display relative line numbers in normal mode, absolute in insert
set relativenumber
augroup insert_numbers
    autocmd!
    autocmd InsertEnter * set norelativenumber
    autocmd InsertEnter * set number
augroup END
augroup normal_numbers
    autocmd!
    autocmd InsertLeave * set nonumber
    autocmd InsertLeave * set relativenumber
augroup END
nnoremap <leader>n :setlocal relativenumber! number!<CR>

" Highlight the current line
set cursorline

" Create a marker line at 80 columns and 100+ columns
let &colorcolumn="80,".join(range(100,280),",")
"}}}

"--------------------------------------------------------------
"   Text and Syntax
"--------------------------------------------------------------
"{{{
" Turn on syntax highlighting
syntax enable

set expandtab                   " Use spaces instead of tabs
set tabstop=4                   " 1 tab = 4 spaces
set softtabstop=4
set shiftwidth=4                " Each indentation level is one tab
set smarttab                    " Backspace over 'tabs'
set shiftround                  " Round indents to multiples of 'shiftwidth'

" Toggle tab-to-space expansion
nnoremap <leader>tt :setlocal expandtab!<CR>

" Shortcut to change tab stop width
func! ChangeTabLen(len)
    exe "set tabstop=".a:len
    exe "set softtabstop=".a:len
    exe "set shiftwidth=".a:len
endfunc

" Select best available (dark) color scheme
set background=dark
let g:molokai_original=1
let g:rehash256=1
let g:solarized_termcolors=256
for scheme in [ 'molokai', 'solarized', 'industry', 'default' ]
    try
        execute 'colorscheme '.scheme
        break
    catch
        continue
    endtry
endfor

" Whitespace visibility on by default, easy toggle off
set listchars=eol:¶,tab:>\ ,trail:~,extends:>,precedes:<
set list
nnoremap <leader>wt :set list!<CR>

" Enable modern shell syntax highlighting
let g:is_posix=1

" Disable Background Color Erase (BCE) so that color schemes
" render properly when inside 256-color tmux and GNU screen.
" http://snk.tuxfamily.org/log/vim-256color-bce.html
if &term =~ '256color'
    set t_ut=
endif
"}}}

"--------------------------------------------------------------
"   Movement
"--------------------------------------------------------------
"{{{
" Jump to the last position when reopening a file
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g'\"" |
    \ endif

" Treat long lines as break lines by default
nnoremap j gj
xnoremap j gj
nnoremap k gk
xnoremap k gk
nnoremap <Up> g<Up>
xnoremap <Up> g<Up>
nnoremap <Down> g<Down>
xnoremap <Down> g<Down>
nnoremap 0 g0
xnoremap 0 g0
nnoremap ^ g^
xnoremap ^ g^
nnoremap $ g$
xnoremap $ g$

nnoremap gj j
xnoremap gj j
nnoremap gk k
xnoremap gk k
nnoremap g<Up> <Up>
xnoremap g<Up> <Up>
nnoremap g<Down> <Down>
xnoremap g<Down> <Down>
nnoremap g0 0
xnoremap g0 0
nnoremap g^ ^
xnoremap g^ ^
nnoremap g$ $
xnoremap g$ $

" Search automatically centers
nnoremap n nzz
nnoremap N Nzz
"}}}

"--------------------------------------------------------------
"   Editing
"--------------------------------------------------------------
"{{{
" Delete trailing whitespace on demand
func! StripTrailingWS()
    %s/\s\+$//e
endfunc

" Toggle and untoggle spell checking
nnoremap <leader>st :setlocal spell!<CR>
"}}}

"--------------------------------------------------------------
"   Plugins
"--------------------------------------------------------------
"{{{
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" Plugin: YouCompleteMe
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" Shortcut declaration jumps
nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR>

" Shortcut definition (i.e. implementation) jumps
nnoremap <leader>ji :YcmCompleter GoToDefinition<CR>

" Expand error messages
nnoremap <leader>dd :YcmShowDetailedDiagnostic<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" Plugin: Syntastic
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" Plugin: UltiSnips
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" Rebind UltiSnips to not conflict with YouCompleteMe
let g:UltiSnipsExpandTrigger='<C-j>'
let g:UltiSnipsListSnippets='<C-e>'
let g:UltiSnipsJumpForwardTrigger='<C-j>'
let g:UltiSnipsJumpBackwardTrigger='<C-k>'

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" Plugin: Vim-Airline
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" Always display the status line
set laststatus=2

" Detect the current insert method
let g:airline_detect_iminsert=1

" Use powerline fonts or correct unicode symbols for status bar
let g:airline_powerline_fonts=0
if !g:airline_powerline_fonts
    if !exists('g:airline_symbols')
        let g:airline_symbols={}
    endif
    "let g:airline_left_sep='▶'
    "let g:airline_right_sep='◀'
    let g:airline_left_sep=''
    let g:airline_right_sep=''
    let g:airline_symbols.linenr='¶'
    let g:airline_symbols.branch='⎇'
    let g:airline_symbols.paste='ρ'
    let g:airline_symbols.whitespace='Ξ'
endif
"}}}

"--------------------------------------------------------------
"   Miscellaneous Workarounds
"--------------------------------------------------------------
"{{{
" Set-up xterm-style keys sent by tmux with xterm-keys on
if &term =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
"}}}

" vim: ts=4:sw=4:et
