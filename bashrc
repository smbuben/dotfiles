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
export HISTSIZE=999
export HISTFILESIZE=999

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

# "fix" terminal identification
if [ "$TERM" != "screen" ] ; then
    case "$COLORTERM" in
        gnome-terminal|xfce4-terminal)
            TERM=xterm-256color
            ;;
        rxvt-xpm)
            TERM=rxvt-256color
            ;;
    esac
else
    case "$COLORTERM" in
        gnome-terminal|xfce4-terminal|rxvt-xpm)
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
BLACK='\e[1;30m'
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
MAGENTA='\e[1;35m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'

function __make_truncated_pwd()
{
    local maxlen=32
    local prelen=7
    local truncpwd="${PWD/#$HOME/\~}"
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
            /^Changes to be committed:$/        {r=r "+"}\
            /^Changes not staged for commit:$/  {r=r "!"}\
            /^Untracked files:$/                {r=r "?"}\
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
    local sepcolor=$BLACK
    local histcolor=$BLACK
    local usercolor=$GREEN
    if [ "$USER" = "root" ] ; then
        usercolor=$RED
    fi
    local hostcolor=$BLUE
    local pathcolor=$WHITE
    local vcscolor=$MAGENTA
    local termcolor=$NOCOLOR
    PS1=""
    __add_to_prompt $histcolor "\!"
    __add_to_prompt $usercolor "\u" $sepcolor ":"
    __add_to_prompt $hostcolor "\h" $sepcolor "@"
    __add_to_prompt $pathcolor "$(__make_truncated_pwd)" $sepcolor ":"
    local gitstatus=$(__make_git_status)
    if [ -n "$gitstatus" ] ; then
        __add_to_prompt $vcscolor "$gitstatus" $sepcolor ":"
    fi
    PS1="\[$sepcolor\][$PS1\[$sepcolor\]]"
    __add_to_prompt $usercolor "\\$"
    __add_to_prompt $termcolor " "
}

function __set_simple_prompt()
{
    PS1='\u@\h:\w\$ '
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
        __set_simple_prompt
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
