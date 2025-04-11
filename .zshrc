HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

alias vim="nvim"
alias ls="ls -la"
alias repos="cd ~/repos"
alias fzf="fzf | xargs nvim"
eval "$(starship init zsh)"

export GTK_THEME=Adwaita-dark

if [[ "$(tty)" == '/dev/tty1' ]]; then
exec startx
fi

# Created by `pipx` on 2024-09-01 06:09:13
export PATH="$PATH:/home/daniel/.local/bin"
export PATH="$PATH:/home/daniel/.dotnet/tools"
