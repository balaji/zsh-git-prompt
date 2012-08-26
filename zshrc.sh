# To install source this file from your .zshrc file

# Change this to reflect your installation directory
export __GIT_PROMPT_DIR=~/Code/zsh-git-prompt
# Initialize colors.
autoload -U colors
colors

# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U add-zsh-hook

add-zsh-hook chpwd chpwd_update_git_vars
add-zsh-hook precmd precmd_update_git_vars

function precmd_update_git_vars() {
print -rP "%(!.%F{red}.%F{cyan})%n%f@%F{yellow}%m%f%(!.%F{red}.) %{$(pwd|grep --color=always /)%${#PWD}G%} $(git_super_status)"
  update_current_git_vars
}

function chpwd_update_git_vars() {
  update_current_git_vars
}

function update_current_git_vars() {
  unset __CURRENT_GIT_STATUS
  local gitstatus="$__GIT_PROMPT_DIR/gitstatus.py"
  _GIT_STATUS=`python ${gitstatus}`
  __CURRENT_GIT_STATUS=("${(@f)_GIT_STATUS}")
  GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
  GIT_REMOTE=$__CURRENT_GIT_STATUS[2]
  GIT_STAGED=$__CURRENT_GIT_STATUS[3]
  GIT_CONFLICTS=$__CURRENT_GIT_STATUS[4]
  GIT_CHANGED=$__CURRENT_GIT_STATUS[5]
  GIT_UNTRACKED=$__CURRENT_GIT_STATUS[6]
  GIT_CLEAN=$__CURRENT_GIT_STATUS[7]
  GIT_DELETED=$__CURRENT_GIT_STATUS[8]
}

git_super_status() {
  if [ -n "$__CURRENT_GIT_STATUS" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$GIT_BRANCH"
    STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH%{${reset_color}%}"
    if [ -n "$GIT_REMOTE" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_REMOTE$GIT_REMOTE%{${reset_color}%}"
    fi
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
    if [ "$GIT_STAGED" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED%{${reset_color}%}"
    fi
    if [ "$GIT_CONFLICTS" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS%{${reset_color}%}"
    fi
    if [ "$GIT_DELETED" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_DELETED$GIT_DELETED%{${reset_color}%}"
    fi
    if [ "$GIT_CHANGED" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED%{${reset_color}%}"
    fi
    if [ "$GIT_UNTRACKED" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED%{${reset_color}%}"
    fi
    if [ "$GIT_CLEAN" -eq "1" ]; then
      if [ -n "$GIT_REMOTE" ]; then
        STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_CLEAN$GIT_BRANCH$ZSH_THEME_GIT_PROMPT_REMOTE$GIT_REMOTE%{${reset_color}%}"
      else
        STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_CLEAN$GIT_BRANCH%{${reset_color}%}"
        STATUS="$STATUS%{${reset_color}%}"
      fi
    fi
    STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
    echo "$STATUS"
  fi
}

# Default values for the appearance of the prompt. Configure at will.
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[blue]%} +"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[white]%} !"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[yellow]%} ~"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} -"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" ..."
ZSH_THEME_GIT_PROMPT_REMOTE="%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}"
