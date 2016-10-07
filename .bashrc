# .bashrc

# --------------------------------------------------------------------------------
# options
# --------------------------------------------------------------------------------
set -o ignoreeof          # Stop CTRL+D from logging me out.
set -o noclobber          # Prevent overwriting files with >.
set -o notify             # Notify of job termination.

shopt -s cdspell          # Spell check path
shopt -s checkhash        # Check program exists before executing.
shopt -s checkwinsize     # Wrap lines correctly after resizing terminal.
shopt -s cmdhist          # Remember multiline commands in history.
shopt -s extglob          # Use extended pattern matching.
shopt -s histappend       # Append to the history file.
shopt -s histreedit       # Allow re-editing of a failed substitution.
shopt -s histverify       # Don't execute retrieved history immediately; allow editing.
shopt -s lithist          # Don't reformat multi-line cmd into one line with semicolons.

# history
export HISTCONTROL=ignoredups

# bash
bind "set completion-ignore-case on"
bind "set bell-style none"
bind "set show-all-if-ambiguous on"

# --------------------------------------------------------------------------------
# platform
# --------------------------------------------------------------------------------
platform='unkown'
unamestr=`uname`

if [[ "$unamestr" == "Linux" ]]; then
  platform='linux'
elif [[ "$unamestr" == "Darwin" ]]; then
  platform='mac'
fi

[[ "$TERM" != 'dumb' ]] && use_color='true' || use_color='false'
[[ "$use_color" == 'true' ]] && {
[[ "$(which dircolors)" ]] && use_color_gnu='true' || use_color_bsd='true'
}

# --------------------------------------------------------------------------------
# aliases
# --------------------------------------------------------------------------------

# alias = list all aliases
# cd = navigate home
# cd - = navigate to previous folder

#navigation
alias ..='cd ..'
alias ...='cd .. ; cd ..'
alias cdd='cd -'            # go to previous directory

# sudo
alias s='sudo'
alias svisudo='sudo visudo' # edit the sudoers file

# delete
alias rm='rm -i'
alias rf='rm -f'
alias rr='rm -f -r'
alias srm='sudo rm -i'
alias srf='sudo rm -f'
alias srr='sudo rm -f -r'

# copy move
alias cp='cp -i'
alias cr='cp -iR'
alias mv='mv -i'
alias scp='sudo cp -i'
alias scr='sudo cp -iR'
alias smv='sudo mv -i'

# ls family
alias la='ls -hAF'                # show all files
alias lA='ls -lhAFT'              # show all files (extended)
alias la1='ls -hAF */'            # show all files and folders with first level contents
alias lA1='ls -lhAFT */'          # show all files and folders with first level contents (extended)
alias la2='ls -hAF */*/'          # show all files and folders with second level contents
alias lA2='ls -lhAFT */*/'        # show all files and folders with second level contents (extended)

alias ll='ls -F'                  # show files
alias lL='ls -lhFT'               # show files (extended)
alias ll1='ls -F */'              # show files and folders with first level contents
alias lL1='ls -lhFT */'           # show files and folders with first level contents (extended)
alias ll2='ls -F */*/'            # show files and folders with second level contents
alias lL2='ls -lhFT */*/'         # show files and folders with second level contents (extended)

alias lz='ls -lhS'                # show files sorted by size
alias lZ='ls -lhSA'               # show all files sorted by size

alias lt='ls -lht'                 # show files sorted by time (most recent first)
alias lT='ls -lhtA'                # show all files sorted by time (most recent first)

alias lr='ls -lhR'                # show files recursive
alias lR='ls -lhRA'               # show files recursive (include hidden)

alias lf='ls -l | grep -v "^d"'   # show only files
alias lF='ls -Al | grep -v "^d"'  # show only files (include hidden)

alias ldir='ls -l | grep "^d"'    # show only directories
alias lDir='ls -Al | grep "^d"'   # show only directories (include hidden)

# paths
alias print-path='echo -e ${PATH//:/\\n}'
alias print-libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

# curl
alias get='curl -C - -O'

# add colors for filetype recognition
[[ "$use_color_gnu" == 'true' ]] && alias ls='ls -hF --group-directories-first --color=auto'
[[ "$use_color_bsd" == 'true' ]] && alias ls='ls -G -F'

# mkdir make intermediate directories
alias mkdir='mkdir -p'

# grep / find
alias g='grep -i'
alias f='find . -iname'

# make a symbolic link
alias lk='ln -s'

# list the size of all folders and files
alias ducks='du -cks * | sort -rn|head -11'

# system log
alias systail='tail -f /var/log/system.log'

# show most used commands
alias profileme="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

# disk usage
alias df='df -h'

# tar
alias untar='tar -xvzf'
alias suntar='sudo tar -xvzf'

# jar (view jar contents)
alias vjar='jar -tvf'

# sudo unzip
alias sunzip='sudo unzip'
alias sbunzip2='sudo bunzip2'

# execute permissions
alias exusr='chmod u+x'    # current user
alias exall='chmod ugo+x'  # all users

# version
alias ver='cat /etc/redhat-release'

# list all colors
#alias colors="set | egrep '^COLOR_\w*'"

# --------------------------------------------------------------------------------
# bookmarks
# --------------------------------------------------------------------------------
# save bookmarks to folders
# save x = bookmarks the current directory as x
# cd x = navigates to the bookmarked path
# smarks = displays all bookmarks
# cmarks = clears all bookmarks
if [ ! -f ~/.dirs ]; then  # if doesn't exist, create it
  touch ~/.dirs
fi

alias smarks='cat ~/.dirs'
alias cmarks='rm -f ~/.dirs; touch ~/.dirs'
save (){
  command sed "/!$/d" ~/.dirs > ~/.dirs1; \mv ~/.dirs1 ~/.dirs; echo "$@"=\"`pwd`\" >> ~/.dirs; source ~/.dirs ; 
}
source ~/.dirs  # Initialization for the above 'save' facility: source the .sdirs file
shopt -s cdable_vars # set the bash option so that no '$' is required when using the above facility
source ~/.profile

# --------------------------------------------------------------------------------
# prompt: show git branch and status
# --------------------------------------------------------------------------------
function _git_prompt() {
    local git_status="`git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local branch_color=$COLOR_BLUE
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local branch_color=$COLOR_PURPLE
        else
            local branch_color=$COLOR_RED
        fi
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
        else
            # Detached HEAD.  (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null ||
                echo HEAD`)"
        fi
        echo -n '\['"$COLOR_BLUE"'\](''\['"$branch_color"'\]'"$branch"'\['"$COLOR_BLUE"'\])'
    fi
}
function _prompt_command() {
    PS1="\[${COLOR_BROWN}\]\w `_git_prompt`\[${COLOR_RED}\]> \[${COLOR_NC}\]"
}
PROMPT_COMMAND=_prompt_command

# --------------------------------------------------------------------------------
# colors
# --------------------------------------------------------------------------------

# Black       0;30     Dark Gray     1;30
# Blue        0;34     Light Blue    1;34
# Green       0;32     Light Green   1;32
# Cyan        0;36     Light Cyan    1;36
# Red         0;31     Light Red     1;31
# Purple      0;35     Light Purple  1;35
# Brown       0;33     Yellow        1;33
# Light Gray  0;37     White         1;37

#export CLICOLOR=1
#export TERM=xterm-color

[[ "$use_color_gnu" == 'true' ]] && eval $(dircolors $HOME/.dir_colors)
[[ "$use_color_gnu" == 'true' ]] && export LS_COLORS='di=0;36:fi=0;37:ln=0;35:pi=5:so=5:bd=5:cd=5:or=31:mi=1:ex=0;31:*.rb=90'
[[ "$use_color_bsd" == 'true' ]] && export CLICOLOR=1
[[ "$use_color_bsd" == 'true' ]] && export LSCOLORS=Gxfxcxdxbxegedabagacad

export COLOR_NC='\033[0m' # No Color
export COLOR_WHITE='\033[1;37m'
export COLOR_BLACK='\033[0;30m'
export COLOR_BLUE='\033[0;34m'
export COLOR_LIGHT_BLUE='\033[1;34m'
export COLOR_GREEN='\033[0;32m'
export COLOR_LIGHT_GREEN='\033[1;32m'
export COLOR_CYAN='\033[0;36m'
export COLOR_LIGHT_CYAN='\033[1;36m'
export COLOR_RED='\033[0;31m'
export COLOR_LIGHT_RED='\033[1;31m'
export COLOR_PURPLE='\033[0;35m'
export COLOR_LIGHT_PURPLE='\033[1;35m'
export COLOR_BROWN='\033[0;33m'
export COLOR_YELLOW='\033[1;33m'
export COLOR_GRAY='\033[1;30m'
export COLOR_LIGHT_GRAY='\033[0;37m'

export COLOR_BG_NC='\033[49m'
export COLOR_BG_LIGHT_GRAY='\033[47m'
export COLOR_BG_PURPLE='\033[45m'
export COLOR_BG_RED='\033[41m'
export COLOR_BG_GREEN='\033[42m'
export COLOR_BG_YELLOW='\033[43m'
export COLOR_BG_BLUE='\033[44m'
export COLOR_BG_CYAN='\033[46m'

echo -e "${COLOR_RED}kernel info: " `uname -smr`
echo -e "${COLOR_BROWN}`bash --version`"
echo -ne "${COLOR_GREEN}uptime: "; uptime
echo -ne "${COLOR_GREEN}server time is: "; date
echo -ne "${COLOR_NC}"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
