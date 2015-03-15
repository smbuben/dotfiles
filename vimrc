" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
" NOTE: This sets 'nocompatible'.
runtime! debian.vim

" apt install vim-pathogen && vim-addon-manager install pathogen
execute pathogen#infect()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=100

" Enable filetype plugins
filetype plugin on

" No filetype automatic indenting
filetype indent off

" No filetype automatic commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on the Wild menu
set wildmenu

" Display completed items the same way as the shell
set wildmode=longest,list,full

" Ignore compiled files
set wildignore=*.o,*.pyc,*~

"Always show current position
set ruler

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors, Fonts, and Appearance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set encoding to allow symbols
set encoding=utf-8

" Enable syntax highlighting
syntax enable

" Set color scheme
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

" Highlight the current line and column
set cursorline
"set cursorcolumn

" Create a marker line at 80 columns and 100+ columns
let &colorcolumn="80,".join(range(100,320),",")

" Display invisible characters
set listchars=eol:$,tab:>\ ,trail:~,extends:>,precedes:<
set list

" Disable Background Color Erase (BCE) so that color schemes
" render properly when inside 256-color tmux and GNU screen.
" http://snk.tuxfamily.org/log/vim-256color-bce.html
if &term =~ '256color'
    set t_ut=
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backups off (this is what version control is for)
set nobackup
set writebackup
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Jump to the last position when reopening a file.
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g'\"" |
    \ endif

" Treat long lines as break lines
noremap j gj
noremap k gk
noremap <Up> g<Up>
noremap <Down> g<Down>
noremap 0 g0
noremap ^ g^
noremap $ g$

" Smart way to move between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
nnoremap <C-Up> <C-W><Up>
nnoremap <C-Down> <C-W><Down>
nnoremap <C-Left> <C-W><Left>
nnoremap <C-Right> <C-W><Right>

" Search automatically centers
nnoremap n nzz
nnoremap N Nzz

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find trailing whitespace
func! FindTrailingWS()
    /\s\+$
endfunc

" Delete trailing whitespace on save
func! StripTrailingWS()
    %s/\s\+$//e
endfunc

" Enable automatic white space stripping for certain file types
"autocmd BufWrite *.py :call StripTrailingWS()

" Easy change tab length
func! ChangeTabLen(len)
    exe "set shiftwidth=".a:len
    exe "set tabstop=".a:len
endfunc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle and untoggle spell checking
nnoremap <leader>ss :setlocal spell!<CR>

" Toggle line numbers.
nnoremap <leader>n :set invrelativenumber<CR>
nnoremap <leader>m :set invnumber<CR>

" Reload .vimrc
nnoremap <leader>r :source ~/.vimrc<CR>

" Edit .vimrc
nnoremap <leader>e :e ~/.vimrc<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ctags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Recurse from the current directory backwards to find the tags
set tags=./tags;/

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YouCompleteMe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shortcut declaration jumps
nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR>

" Shortcut definition (i.e. implementation) jumps
nnoremap <leader>ji :YcmCompleter GoToDefinition<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim-Airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Miscellaneous workarounds
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set-up xterm-style keys sent by tmux with xterm-keys on
if &term =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
