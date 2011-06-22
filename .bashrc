set -o notify
shopt -s nocaseglob
shopt -s histappend
shopt -s cdspell
export HISTCONTROL="ignoredups"

if [ -f ~/.bashrc_tim ]; then
    . ~/.bashrc_tim
fi
if [ -f ~/.bash_alias ]; then
    . ~/.bash_alias
fi

# default prompt of : user@host and current dir
#PS1='[\[\e[0m\]\u@\h \[\e[34m\]\W\[\e[0m\]] \$ '

# git prompt
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

