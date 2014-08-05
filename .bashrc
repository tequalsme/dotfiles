# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
if [ -f ~/.bashrc_${USER} ]; then
    . ~/.bashrc_${USER}
fi

# Homebrew / OS X
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi
export PATH=/usr/local/git/bin:/usr/local/bin:/usr/local/sbin:$PATH
