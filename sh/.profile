# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

. ~/.myconf/sh/funcs

############################################################################

export LC_ALL="en_US.UTF-8"
export EDITOR=vim

# set TERM if not in tmux
if [[ $TERM != screen-256color ]]; then
    export TERM=xterm-256color
fi

export _PROMPT_VARS=(IP PORT)

export GOPATH=$HOME/go
exportPATH "$GOPATH/bin"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    exportPATH "$HOME/bin"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
    exportPATH "$HOME/.local/bin"
fi

#exportLIBRARY_PATH    "$HOME/ida-6.9"
#exportLD_LIBRARY_PATH "$HOME/ida-6.9"

############################################################################

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
