# Directory Lists
alias l='ls'
alias sl='ls'
alias lls='ls'
alias ll='ls -lh'
alias la='ls -lah'
alias lt='ls -larth'
alias dw='find . -type f'
alias ff='find . -name'

# Filesystem Movement
alias ccd='cd'
alias cdd='cd'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias back='cd -'
alias b='cd -'
alias dl='cd ~/Downloads'

# File Display
alias more='less'
alias mo='less'
alias lless='less'
alias lles='less'
alias les='less'
alias lesss='less'

# Searching
alias grp='grep'
alias grpe='grep'
alias grepi='grep -i'
alias grepr='grep -R'
alias grepir='grep -i -R'
alias grepri='grep -i -R'

# History
alias r='fc -s'
alias hgrep='history | grep'

# Processes
alias psef='ps -ef'
alias pscg='ps xawf -eo pid,user,cgroup,args'
alias psgrep='ps -ef | grep'

# Miscellaneous
alias unmount='umount'
alias df='df -h'
alias tm='tmux'
alias netstat46='netstat -anpA inet -A inet6'

# Security Workarounds
# disable LESSOPEN for default less (http://seclists.org/oss-sec/2014/q4/769)
alias less='less -L'
# force strings -a (http://seclists.org/fulldisclosure/2014/Oct/112)
alias strings='strings -a'
