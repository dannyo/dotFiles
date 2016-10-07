#!/bin/bash
dir=`dirname $0`

# copy dotfiles to user home
cp $dir/.gitconfig ~/.gitconfig
cp $dir/.bash_profile ~/.bash_profile

# source bash profile
. ~/.bash_profile
