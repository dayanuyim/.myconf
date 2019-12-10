#!/usr/bin/env bash
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
fi

if uname -a | grep -q Darwin; then
    alias ls='gls --color=auto --time-style="+%F|%T"'
else
    alias ls='ls --color=auto --time-style="+%F|%T"'
fi

alias la='ls -A'
alias l.='ls -d .!(|.)'

alias ll='ls -lF'
alias lla='ls -lFA'
alias ll.='ls -lFd .!(|.)'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias screen='screen -U -h 20000'
alias tmux='tmux -u'
alias cp='cp -i'
alias ff='realpath'
alias google-chrome='google-chrome -allow-file-access-from-files'
alias gcc-vul='gcc -O0 -m32 -fno-stack-protector -no-pie -mpreferred-stack-boundary=2 -z execstack'
alias vim='vim -p'
alias readelf='readelf -W'
