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
    echo "${BRANCH} ${STAT}"
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
    echo "${bits}"
  else
    echo ""
  fi
}

function determine_branch_color() {
  GREEN="\[\033[32m\]"
  RED="\[\033[31m\]"
  YELLOW="\[\033[33m\]"
  LIGHT_GRAY="\[\033[37m\]"
  STATUS=`parse_git_dirty`
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
