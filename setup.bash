#!/bin/bash

# Setup a new directory with files from this repository,
# backing up/overwriting/skipping existing files as specified by user input.

set -e

SCRIPT=$(readlink -f $0)
SRC_DIR=`dirname $SCRIPT`
DEST_DIR=$HOME
DATA_DIR=/data

if [ "$1" == "--help" -o "$1" == "-h" -o "$1" == "-?" ]; then
  echo "Usage: $0 [args]"
  echo "Setup a new directory with files from this repository,"
  echo "backing up/overwriting/skipping existing files as specified by user input."
  echo "  --copy/-c    - copy files instead of soft-linking"
  echo "  --help/-h/-? - display this message"
  exit 1
elif [ "$1" == "--copy" -o "$1" == "-c" ]; then
  copy=true
fi

link_file() {
  ln -s $1 $2
  echo "linked $1 to $2"
}
copy_file() {
  cp -pr $1 $2
  echo "copied $1 to $2"
}
install_file() {
  if [ "$copy" == "true" ]; then
    copy_file $1 $2
  else
    link_file $1 $2
  fi
}

check_install() {
  src=$1
  dst=$2
  if [ -f "$dst" ] || [ -d "$dst" ]; then
    overwrite=false
    backup=false
    skip=false
    if [ "$overwrite_all" == "false" -a "$backup_all" == "false" -a "$skip_all" == "false" ]; then
      echo "[$dst] already esists, what do you want to do?"
      read -e -p "[s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all? " -n 1 action
      case "$action" in
        o) overwrite=true ;;
        O) overwrite_all=true ;;
        b) backup=true ;;
        B) backup_all=true ;;
        s) skip=true ;;
        S) skip_all=true ;;
        *) ;;
      esac
    fi

    if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]; then
      rm -rf $dst
      echo "removed $dst"
    fi
    if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]; then
      mv $dst $dst\.backup
      echo "moved $dst to $dst.backup"
    fi
    if [ "$skip" == "false" ] || [ "$skip_all" == "false" ]; then
      install_file $src $dst
    else
      echo "skipped $src"
    fi
  else
    install_file $src $dst
  fi
}

overwrite_all=false
backup_all=false
skip_all=false

check_install $SRC_DIR/.bashrc       $DEST_DIR/.bashrc
check_install $SRC_DIR/.bashrc_$USER $DEST_DIR/.bashrc_$USER
check_install $SRC_DIR/bin           $DEST_DIR/bin
check_install $SRC_DIR/.gitconfig    $DEST_DIR/.gitconfig
check_install $SRC_DIR/.gitignore    $DEST_DIR/.gitignore
check_install $SRC_DIR/.go           $DEST_DIR/.go
check_install $SRC_DIR/.inputrc      $DEST_DIR/.inputrc
#check_install $SRC_DIR/.mavenrc      $DEST_DIR/.mavenrc
check_install $SRC_DIR/.vimrc        $DEST_DIR/.vimrc

mkdir -p $DEST_DIR/.ssh        && check_install $SRC_DIR/.ssh/config         $DEST_DIR/.ssh/config
#mkdir -p $DEST_DIR/.subversion && check_install $SRC_DIR/.subversion/servers $DEST_DIR/.subversion/servers

# link typically large directories somewhere other than the home partition
#mkdir -p $HOME/Downloads && mv $HOME/Downloads $DATA_DIR      && ln -s $DATA_DIR/Downloads $HOME/Downloads
#mkdir -p $HOME/.ivy2     && mv $HOME/.ivy2     $DATA_DIR/ivy2 && ln -s $DATA_DIR/ivy2      $HOME/.ivy2
#mkdir -p $HOME/.m2       && mv $HOME/.m2       $DATA_DIR/m2   && ln -s $DATA_DIR/m2        $HOME/.m2
#mkdir -p $HOME/src       && mv $HOME/src       $DATA_DIR      && ln -s $DATA_DIR/src       $HOME/src

unset link_file
unset copy_file
unset install_file
unset check_install
