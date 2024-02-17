HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

alias vim="nvim"
eval "$(starship init zsh)"

export FZF_DEFAULT_COMMAND='find .'

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
