# if not running interactively, don't do anything
[ -z "$PS1" ] && return

# -----------------------------------------------------------------------------
#   HISTORY
# -----------------------------------------------------------------------------

# append to the history file, don't overwrite
shopt -s histappend

# ignore space-starting commands and duplicates
export HISTCONTROL=ignoreboth

# custom history size
export HISTSIZE=1000
export HISTFILESIZE=1000

# timestamp history
export HISTTIMEFORMAT='%F %T '

# -----------------------------------------------------------------------------
#   PATH CONTROL
# -----------------------------------------------------------------------------

# fix my path
export PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"

# -----------------------------------------------------------------------------
#   TERMINAL MANIPULATION
# -----------------------------------------------------------------------------

# boom, vi mode
set -o vi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# gnome-terminal 3.12+ no longer self identifies in COLORTERM (bug? feature?)
if [ -z "$COLORTERM" ] ; then
    parent=`cat /proc/$PPID/cmdline`
    if [ "$parent" != "${parent/gnome-terminal/}" ] ; then
        export COLORTERM=gnome-terminal
    fi
    unset parent
fi

# "fix" terminal identification
if [ "$TERM" != "screen" ] ; then
    case "$COLORTERM" in
        gnome-terminal|xfce4-terminal)
            TERM=xterm-256color
            ;;
        rxvt-xpm)
            TERM=rxvt-256color
            ;;
        # make sure that ssh->tmux tracks terminal capabilities
        '')
            export COLORTERM=$TERM
            ;;
    esac
else
    case "$COLORTERM" in
        gnome-terminal|xfce4-terminal|rxvt-xpm|*256color)
            TERM=screen-256color
            ;;
    esac
fi
export TERM

# enable color support of ls and also add handy aliases
[ -f $HOME/.dircolors ] && dircolors=$HOME/.dircolors
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b $dircolors`"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
unset dircolors

# -----------------------------------------------------------------------------
#   PROMPT
# -----------------------------------------------------------------------------

NOCOLOR='\e[0m'

BLACK='\e[0;30m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
MAGENTA='\e[0;35m'
CYAN='\e[0;36m'
WHITE='\e[0;37m'

BLACK_BD='\e[1;30m'
RED_BD='\e[1;31m'
GREEN_BD='\e[1;32m'
YELLOW_BD='\e[1;33m'
BLUE_BD='\e[1;34m'
MAGENTA_BD='\e[1;35m'
CYAN_BD='\e[1;36m'
WHITE_BD='\e[1;37m'

function __make_truncated_pwd()
{
    local maxlen=32
    local prelen=7
    local tilde='~'
    local truncpwd="${PWD/#$HOME/$tilde}"
    if [ ${#truncpwd} -gt $maxlen ] ; then
        truncpwd="${truncpwd:0:$prelen}..${truncpwd:$((${#truncpwd}-$maxlen+$prelen)):$(($maxlen-$prelen))}"
    fi
    echo $truncpwd
}

function __make_git_status()
{
    local info branch flags
    info="$(git status 2>/dev/null)"
    [ $? -ne 0 ] && return
    branch="$(git branch | grep "^*" | cut -d " " -f 2)"
    if [ -z "$branch" ] ; then
        branch="(init)"
    fi
    flags="$(
        echo "$info" | awk 'BEGIN {r=""} \
            /^(# )?Changes to be committed:$/        {r=r "+"} \
            /^(# )?Changes not staged for commit:$/  {r=r "!"} \
            /^(# )?Untracked files:$/                {r=r "?"} \
            END {print r}'
    )"
    echo $branch$flags
}

function __add_to_prompt()
{
    # arguments: color, item, (optional) separator color, (optional) separator
    if [ -n "$4" ] ; then
        PS1="$PS1\[$3\]$4"
    fi
    PS1="$PS1\[$1\]$2"
}

function __set_prompt()
{
    local sepcolor histcolor usercolor hostcolor pathcolor vcscolor
    case "$TERM" in
        *256color)
            sepcolor='\e[38;05;242m'
            histcolor='\e[38;05;66m'
            usercolor='\e[38;05;46m'
            if [ "$USER" = "root" ] ; then
                usercolor='\e[38;05;160m'
            fi
            hostcolor='\e[38;05;33m'
            pathcolor='\e[38;05;255m'
            vcscolor='\e[38;05;127m'
            ;;
        *)
            sepcolor=$NOCOLOR
            histcolor=$NOCOLOR
            usercolor=$GREEN
            if [ "$USER" = "root" ] ; then
                usercolor=$RED
            fi
            hostcolor=$BLUE
            pathcolor=$WHITE
            vcscolor=$MAGENTA
            ;;
    esac
    PS1=""
    __add_to_prompt $histcolor "\!"
    __add_to_prompt $usercolor "\u" $sepcolor ":"
    __add_to_prompt $hostcolor "\h" $sepcolor "@"
    __add_to_prompt $pathcolor "$(__make_truncated_pwd)" $sepcolor ":"
    local gitstatus=$(__make_git_status)
    if [ -n "$gitstatus" ] ; then
        __add_to_prompt $vcscolor "$gitstatus" $sepcolor ":"
    fi
    PS1="\[$sepcolor\]($PS1\[$sepcolor\])"
    __add_to_prompt $usercolor "\\$"
    __add_to_prompt $NOCOLOR "\n"
}

function __set_titlebar()
{
    echo -ne "\033]0;${USER}@${HOSTNAME}: $(__make_truncated_pwd)\007"
}

case "$TERM" in
    xterm*|rxvt*|screen*)
        __set_prompt
        PROMPT_COMMAND='__set_prompt; __set_titlebar'
        ;;
    *)
        PS1='[\u@\h:\w]\$ '
        ;;
esac

# -----------------------------------------------------------------------------
#   ENVIRONMENT VARIABLES
# -----------------------------------------------------------------------------

# set some useful environment variables
EDITOR=`which vim`
if [ $? -ne 0 ] ; then
    EDITOR=`which vi`
fi
export EDITOR

# tab-completion in the python shell (https://jedi.jedidjah.ch/en/latest/)
# automatically installed as part of vim-youcompleteme
export PYTHONSTARTUP="$(python -m jedi repl)"

# -----------------------------------------------------------------------------
#   USEFUL FUNCTIONS
# -----------------------------------------------------------------------------

function up()
{
    local count=$1
    if [ -z "$count" ] ; then
        count=1
    fi
    local parents="."
    for i in $(seq 1 $count) ; do
        parents="$parents/.."
    done
    cd $parents
}

function infl()
{
    [ ! -f $1 ] && return
    case $1 in
        *.tar.bz2)  tar xjf $1      ;;
        *.tar.gz)   tar xzf $1      ;;
        *.bz2)      bunzip2 $1      ;;
        *.gz)       gunzip $1       ;;
        *.tar)      tar xf $1       ;;
        *.tbz2)     tar xjf $1      ;;
        *.tgz)      tar xzf $1      ;;
        *.zip)      unzip $1        ;;
        *.rar)      rar x $1        ;;
        *.Z)        uncompress $1   ;;
        *.7z)       7z x $1         ;;
    esac
}

function extip()
{
    wget -q -O - http://checkip.dyndns.org \
        | grep -o -E '[0-9].+[0-9]+.[0-9]+.[0-9]+'
}

function man()
{
    env LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;38;5;75m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[38;5;255m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[04;38;5;144m' \
    man "$@"
}

# -----------------------------------------------------------------------------
#   OTHER SHELL MODIFIER FILES
# -----------------------------------------------------------------------------

# enable my aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable extended completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# -----------------------------------------------------------------------------
#   MISCELLANEOUS
# -----------------------------------------------------------------------------

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
