autoload -Uz vcs_info
autoload -U colors && colors
setopt promptsubst

zstyle ':vcs_info:*' formats '%b'

env_color="brightwhite"
prompt_color="green"

precmd () {
  vcs_info

  # Check git status and set branch color
  STATUS=$(command git status --porcelain 2> /dev/null | tail -n1)
  if [[ -n $STATUS ]]; then
    local git_branch='%F{red}$vcs_info_msg_0_'
  else
    local git_branch='%F{$prompt_color}$vcs_info_msg_0_'
  fi

  # Virtual Env display
  if [[ -n $VIRTUAL_ENV ]]; then
    local env_name="[$(basename $VIRTUAL_ENV)]"
    local env_display="%F{$env_color}$env_name%{$reset_color%}"
  else
    local env_display=""
  fi

  RPROMPT="[%{$fg[$env_color]%}%D{%H:%M:%S}] ${git_branch}%{$reset_color%}"

   # Prompt with or without full path, no additional space after $env_display
  if [ "$ZSH_CLEAN_PATH_STYLE" = "1" ]; then
    PROMPT="${env_display}%F{$prompt_color}%c%{$reset_color%} "
  else
    PROMPT="${env_display}%F{$prompt_color}%~%{$reset_color%} "
  fi
}

# Reset color after executing command
PS2="%{$reset_color%}> "
