# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# --------------------------
# Env
# --------------------------

case "`uname`" in
    # OS X
    Darwin)
        if type -t brew > /dev/null 2>&1; then
            if [ -f `brew --prefix`/etc/bash_completion ]; then
                . `brew --prefix`/etc/bash_completion
            fi
        fi

        # brew coreutils - put gnuutils before OSX variants
        if [ -d /usr/local/opt/coreutils/libexec/gnubin ]; then
            export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
            if [ -d /usr/local/opt/coreutils/libexec/gnuman ]; then
                export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
            fi
        fi
        ;;

    # Cygwin
    CYGWIN*)
        echo "CYGWIN!"
        export CYGWIN=nodosfilewarning
        ;;
esac

# --------------------------
# Common Apps - set *_HOME envvars and add to PATH
# --------------------------
[[ -d /usr/java/latest ]] && export JAVA_HOME=/usr/java/latest
[[ `uname` = "Darwin" ]] && export JAVA_HOME=$(/usr/libexec/java_home)
[[ -d /opt/maven/current ]] && export M2_HOME=/opt/maven/current
[[ -d /opt/zookeeper/current ]] && export ZOOKEEPER_HOME=/opt/zookeeper/current
[[ -d /usr/lib/zookeeper ]] && export ZOOKEEPER_HOME=/usr/lib/zookeeper
[[ -d /opt/storm/current ]] && export STORM_HOME=/opt/storm/current
[[ -d /opt/hadoop/current ]] && export HADOOP_HOME=/opt/hadoop/current
[[ -d /usr/lib/hadoop ]] && export HADOOP_PREFIX=/usr/lib/hadoop && unset HADOOP_HOME
[[ -d /usr/lib/hadoop/lib/native ]] && export LD_LIBRARY_PATH=/usr/lib/hadoop/lib/native
[[ -d /opt/accumulo/current ]] && export ACCUMULO_HOME=/opt/accumulo/current
[[ -d /opt/mongodb/current ]] && export MONGODB_HOME=/opt/mongodb/current

# pathmunge copied from Centos /etc/profile
pathmunge() {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            if [ "$2" = "after" ] ; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
    esac
}

[[ -d "$M2_HOME" ]]   && pathmunge $M2_HOME/bin
[[ -d "$JAVA_HOME" ]] && pathmunge $JAVA_HOME/bin
[[ -d "$HOME/bin" ]]  && pathmunge $HOME/bin

[[ -d "$MONGODB_HOME" ]]   && pathmunge $MONGODB_HOME/bin after
[[ -d "$ACCUMULO_HOME" ]]  && pathmunge $ACCUMULO_HOME/bin after
[[ -d "$STORM_HOME" ]]     && pathmunge $STORM_HOME/bin after
[[ -d "$HADOOP_HOME" ]]    && pathmunge $HADOOP_HOME/bin after
[[ -d "$ZOOKEEPER_HOME" ]] && pathmunge $ZOOKEEPER_HOME/bin after

unset -f pathmunge

# Opts
export JAVA_OPTS="-Xms1024m -Xmx3076m"
export MAVEN_OPTS="-Xms1024m -Xmx3076m"

# RVM
[[ -d $HOME/.rvm ]] && RVM_HOME=$HOME/.rvm
[[ -r "$RVM_HOME/scripts/completion" ]] && source "$RVM_HOME/scripts/completion"
[[ -s "$RVM_HOME/scripts/rvm" ]] && source "$RVM_HOME/scripts/rvm"

# Git - OS X brew
[[ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]] && source /usr/local/etc/bash_completion.d/git-prompt.sh
[[ -f /usr/local/etc/bash_completion.d/git-completion.bash ]] && source /usr/local/etc/bash_completion.d/git-completion.bash
# Git - manual fallback (Fedora/CentOS?)
[[ -f ~/.git-prompt.sh ]] && source ~/.git-prompt.sh
[[ -f ~/.git-completion.sh ]] && source ~/.git-completion.sh

if type -t __git_ps1 > /dev/null 2>&1; then
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    # color prompt with Git status (\w for full working dir, \W for basename)
    PS1='\[\e[0m\]\u@\h:\[\e[34m\]\W\[\e[0m\]$(__git_ps1 "(%s)")\$ '
    # same prompt as above, without hostname
    #PS1='\[\e[0m\]\u:\[\e[34m\]\W\[\e[0m\]$(__git_ps1 "(%s)")\$ '
else
    # color prompt without Git status
    PS1='\[\e[0m\]\u@\h:\[\e[34m\]\W\[\e[0m\]\$ '
    # same prompt as above, without hostname
    #PS1='\[\e[0m\]\u:\[\e[34m\]\W\[\e[0m\]\$ '
fi

# Misc
export EDITOR=vim
export VISUAL=vim
export LESS=Rqi

[[ -z $TMOUT ]] || echo "WARNING: TMOUT=${TMOUT}. 'unset TMOUT' in /etc/profile.d/local.sh and start new terminal."

#bind 'set bind-tty-special-chars off'
#bind '"\ep": history-search-backward'
#bind '"\en": history-search-forward'
#bind '"\C-w": backward-kill-word'

# --------------------------
# History
# --------------------------
# Store 10,000 history entries
export HISTSIZE=10000
# Don't store duplicates
export HISTCONTROL=erasedups

# --------------------------
# Shell Options
# --------------------------
# Don't wait for job termination notification
set -o notify

# Use case-insensitive filename globbing
shopt -s nocaseglob

# Make bash append rather than overwrite history on disk
shopt -s histappend

# When changing directory, small typos can be ignored by bash.
# For example, cd /vr/lg/apaache would find /var/log/apache
shopt -s cdspell

# --------------------------
# Aliases
# --------------------------
alias cp="cp -p"
alias d="dirs"
alias dv="dirs -v"
alias ff="find . -name"
alias grep="grep --color=auto"
alias g=grep
alias h=history
#alias ls="ls -G --color=auto --show-control-chars"
alias ls="ls -G"
alias l="ls -l"
alias la="l -A"
alias lt="l -t"
alias lat="l -At"
alias l1="ls -1"
alias p="pushd"
alias pd="popd"
alias scp="scp -p"
alias scratch="cat > /dev/null"
alias ssh="ssh -AX"
alias tf="tail -n 100 -f"
alias x=exit

alias mvnfull='mvn clean install'
alias mvnquick='mvn clean install -DskipTests=true'
alias mvnfullt='mvnfull -T 2.0C'
alias mvnquickt='mvnquick -T 2.0C'

# --------------------------
# Functions
# --------------------------

# the following find functions skip all .git/.svn/target dirs

# recursive grep
rgrep() {
    find . \( -path "*/.git" -o -path "*/.svn" -o -path "*/target" \) -prune -o \
        -type f -print0 2> /dev/null | \
        xargs -0 grep "${@}"
}
# recursive grep of pom.xml files
pomgrep() {
    find . \( -path "*/.git" -o -path "*/.svn" -o -path "*/target" \) -prune -o \
        -type f -name pom.xml -print0 | \
        xargs -0 grep "${@}"
}
# open-ended find command, must tack on additional expression(s) and end with -print or -print0
findsrc() {
    find . \( -path "*/.git" -o -path "*/.svn" -o -path "*/target" \) -prune -o \
        ${@}
}

start-accumulo() {
    sudo -u hdfs $ACCUMULO_HOME/bin/start-all.sh
}
stop-accumulo() {
    sudo -u hdfs $ACCUMULO_HOME/bin/stop-all.sh
}
# Hadoop 2.x (MR1)
start-hadoop() {
    for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done
    for x in `cd /etc/init.d ; ls hadoop-0.20-mapreduce-*` ; do sudo service $x start ; done
}
stop-hadoop() {
    for x in `cd /etc/init.d ; ls hadoop-0.20-mapreduce-*` ; do sudo service $x stop ; done
    for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x stop ; done
}
# Hadoop 2.x (YARN)
start-hadoop2() {
    for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done
    sudo service hadoop-yarn-resourcemanager start 
    sudo service hadoop-yarn-nodemanager start 
    sudo service hadoop-mapreduce-historyserver start
}
stop-hadoop2() {
    sudo service hadoop-mapreduce-historyserver stop
    sudo service hadoop-yarn-nodemanager stop 
    sudo service hadoop-yarn-resourcemanager stop 
    for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x stop ; done
}
start-zk() {
    sudo service zookeeper-server start
}
stop-zk() {
    sudo service zookeeper-server stop
}

# --------------------------
# Misc
# --------------------------

if [ -f ~/.ssh-agent-init ]; then
    . ~/.ssh-agent-init
fi
if [ -f ~/.go/env ]; then
    . ~/.go/env
fi

# env-specific customizations
if [ -f ~/.bashrc_env ]; then
    . ~/.bashrc_env
fi
