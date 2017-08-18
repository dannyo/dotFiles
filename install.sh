#!/bin/bash
dir=`dirname $0`

# copy dotfiles to user home
cp $dir/.bashrc ~/.bashrc
cp $dir/.gitconfig ~/.gitconfig
cp $dir/.bash_profile ~/.bash_profile
cp $dir/git-completion.bash ~/git-completion.bash
cp $dir/.tmux.conf ~/.tmux.conf

# create symlink for .ssh from Dropbox
ln -sf ~/Dropbox/.ssh/ ~/.ssh

# source bash profile
. ~/.bash_profile
