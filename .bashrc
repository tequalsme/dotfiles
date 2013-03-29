# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
if [ -f ~/.bashrc_tim ]; then
    . ~/.bashrc_tim
fi
if [ -f ~/.bash_alias ]; then
    . ~/.bash_alias
fi
