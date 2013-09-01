# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
if [ -f ~/.bashrc_${USER} ]; then
    . ~/.bashrc_${USER}
fi
