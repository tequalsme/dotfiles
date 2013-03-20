# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
export JAVA_HOME=/usr/java/latest

export M2_HOME=/opt/maven/current
export M2=$M2_HOME/bin
export MAVEN_OPTS="-Xms512m -Xmx1024m"

export PATH=$PATH:$HOME/bin:$M2

set -o notify
shopt -s nocaseglob
shopt -s histappend
shopt -s cdspell
export HISTCONTROL=erasedups;
export HISTSIZE=10000

if [ -f ~/.bashrc_tim ]; then
    . ~/.bashrc_tim
fi
if [ -f ~/.bash_alias ]; then
    . ~/.bash_alias
fi

# git prompt if possible
if type -t __git_ps1 > /dev/null 2>&1; then
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
else
    # default prompt (user@host and current dir)
    PS1='[\[\e[0m\]\u@\h \[\e[34m\]\W\[\e[0m\]] \$ '
fi

