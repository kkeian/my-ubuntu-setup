# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Define color codes to substitute
LIGHT_BLUE="\[\033[36m\]"
ORANGE="\[\033[38;5;166m\]"
PURPLE="\[\033[35m\]"

# enable bash-completion (installed via homebrew)
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# get current branch in git repo
function parse_git_branch() {
  BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ ! "${BRANCH}" == "" ]
  then
    STAT=`parse_git_dirty`
    echo "${BRANCH}${STAT}"
  else
    echo ""
  fi
}

# get current status of git repo
function parse_git_dirty() {
  status=`git status 2>&1 | tee`
  dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
  untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
  ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
  newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
  renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
  deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
  bits=''
  if [ "${renamed}" == "0" ]; then
    bits=">"
  fi
  if [ "${ahead}" == "0" ]; then
    bits="*"
  fi
  if [ "${newfile}" == "0" ]; then
    bits="+"
  fi
  if [ "${untracked}" == "0" ]; then
    bits="?"
  fi
  if [ "${deleted}" == "0" ]; then
    bits="x"
  fi
  if [ "${dirty}" == "0" ]; then
    bits="!"
  fi
  if [ ! "${bits}" == "" ]; then
    echo " ${bits}"
  else
    echo ""
  fi
}

function determine_branch_color() {
  local GREEN="\[\033[32m\]"
  local RED="\[\033[31m\]"
  local YELLOW="\[\033[33m\]"
  local LIGHT_GRAY="\[\033[37m\]"
  local STATUS=`parse_git_dirty`
  local color=''
  if [ "${STATUS}" == ">" ]; then
    color="${ORANGE}"
  fi
  if [ "${STATUS}" == "*" ]; then
    color="${YELLOW}"
  fi
  if [ "${STATUS}" == "+" ]; then
    color="${RED}"
  fi
  if [ "${STATUS}" == "?" ]; then
    color="${RED}"
  fi
  if [ "${STATUS}" == "x" ]; then
    color="${RED}"
  fi
  if [ "${STATUS}" == "!" ]; then
    color="${RED}"
  fi
  if [ ! "$color" == "" ]; then
    echo "$color"
  else
    echo "${GREEN}"
  fi
}
# Test edit

export PS1="${LIGHT_BLUE}\`git config user.name\` ${ORANGE}\W\[\e[m\] ${PURPLE}[$(determine_branch_color)\`parse_git_branch\`${PURPLE}] \[\e[m\]"
