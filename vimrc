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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=50

" Enable filetype plugins
filetype plugin on

" No filetype automatic indenting
filetype indent off

" No filetype automatic commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" apt-get install vim-youcompleteme
set runtimepath+=/usr/share/vim-youcompleteme

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
" Enable syntax highlighting
syntax enable

" Set color scheme
set background=dark
let g:molokai_original=1
colorscheme molokai
"g:solarized_termcolors=256
"colorscheme solarized

" Highlight the current line and column
set cursorline
"set cursorcolumn

" For colorschemes that don't use reasonable highlight colors
"highlight CursorLine cterm=NONE ctermbg=darkgrey guibg=darkgrey
"highlight CursorColumn cterm=NONE ctermbg=darkgrey guibg=darkgrey

" Create a marker line at 80 columns
highlight ColorColumn cterm=None ctermbg=darkgrey guibg=darkgrey
set colorcolumn=80

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
map j gj
map k gk
map <Up> g<Up>
map <Down> g<Down>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <C-Up> <C-W><Up>
map <C-Down> <C-W><Down>
map <C-Left> <C-W><Left>
map <C-Right> <C-W><Right>

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

func! ChangeTabLen(len)
    exe "set shiftwidth=".a:len
    exe "set tabstop=".a:len
endfunc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle and untoggle spell checking
map <leader>ss :setlocal spell!<CR>

" Toggle line numbers.
nmap <leader>n :set invnumber<CR>

" Reload .vimrc
map <leader>r :source ~/.vimrc<CR>

" Edit .vimrc
map <leader>e :e ~/.vimrc<CR>

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
" => Miscellaneous workarounds
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set-up xterm-style keys sent by tmux with xterm-keys on
if &term =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
