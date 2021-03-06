# .bash_profile

# get aliases and functions
# --------------------------------------------------------------------------------
if [[ -f ~/.bashrc ]]; then
  . ~/.bashrc
fi

# ant settings
# --------------------------------------------------------------------------------
if [[ -f ~/.antrc ]]; then
  . ~/.antrc
fi

# paths
# --------------------------------------------------------------------------------
export JUNIT_HOME=/Developer-3.2.6/junit4.8.2
export CLASSPATH=$JUNIT_HOME/junit-4.8.2.jar:$JUNIT_HOME
#export PATH=$HOME/.local/bin:$HOME/.local/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin
#export MANPATH=$HOME/.local/share/man:/usr/local/share/man
export PATH=$HOME/.local/bin:$HOME/.local/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin$(cat /etc/paths.d/* | sed 's/^/:/g' | tr -d '\n'):~/bin
export MANPATH=$HOME/.local/share/man:/usr/local/share/man:/usr/share/man$(cat /etc/paths.d/* | sed 's/^/:/g' | tr -d '\n')

PATH="$PATH:$JUNIT_HOME"
PATH="$PATH:/usr/local/mysql/bin:/opt/local/bin"
PATH="$PATH:/Applications/SenchaSDKTools-1.1"
PATH="$PATH:/Applications/SenchaSDKTools-1.1/command"
PATH="$PATH:/Applications/SenchaSDKTools-1.1/appbuilder"
PATH="$PATH:/Applications/SenchaSDKTools-1.1/jsbuilder"

MANPATH=$MANPATH:/opt/local/share/man
INFOPATH=$INFOPATH:/opt/local/share/info

# stack size (64MB)
# --------------------------------------------------------------------------------
ulimit -s 64000

# bash completion
# --------------------------------------------------------------------------------
if [[ -f /opt/local/etc/bash_completion ]]; then
  . /opt/local/etc/bash_completion
elif [[ -f ~/.bash_completion ]]; then
  source ~/.bash_completion
fi

# git tab completion
# --------------------------------------------------------------------------------
if [[ -f ~/git-completion.bash ]]; then
  source ~/git-completion.bash
fi

# git colors fix
export LESS="-erX"

# add rvm
# --------------------------------------------------------------------------------
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# history
# ------------------------------------------------------------------------------
export HISTCONTROL="erasedupes"
export HISTFILESIZE=409600
export HISTIGNORE='history:&:ls:ll:la:[bf]g:h:exit:clear'
export HISTSIZE=100000

# grep colors
# ------------------------------------------------------------------------------
[[ "$TERM" != 'dumb' ]] && {
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="37;45"
}

# editor
# --------------------------------------------------------------------------------
if [[ $platform == 'linux' ]]; then
  export EDITOR='gvim -f'
elif [[ $platform == 'mac' ]]; then
  export EDITOR='/usr/local/bin/vim'
fi

# termcap colors
# ------------------------------------------------------------------------------
[[ "$TERM" != 'dumb' ]] && {
export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_so=$'\E[00;47;30m' # begin standout-mode
export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[01;32m' # begin underline
}

[[ -s ~/nvm/nvm.sh ]] && source ~/nvm/nvm.sh

# rbmh aliases and functions
# --------------------------------------------------------------------------------
if [[ -f ~/.bashrc_rbmh ]]; then
  . ~/.bashrc_rbmh
fi

