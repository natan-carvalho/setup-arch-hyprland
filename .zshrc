# Binds
bindkey "^[[3~" delete-char # Deleta o caractere
bindkey "^[[H" beginning-of-line # Home para ir para o inicio da linha
bindkey "^[[F" end-of-line # End para ir para o fim da linha
bindkey "^H" backward-kill-word # CTRL + BACKSPACE, deleta a palavra inteira do fim para o inicio
bindkey "^[[3;5~" kill-word # CTRL + DELETE, deleta a palavra inteira do inicio para o fim
bindkey "^[[1;5D" backward-word # CTRL + <-, para movimentar para a esquerda
bindkey "^[[1;5C" forward-word # CTRL + ->, para a direita

# Alias
alias wifihome='nmcli dev wifi connect wylly password "STC4H7osW*dG"'
alias update='sudo pacman -Syu'
alias v='nvim'

# Functions
# Connect Wifi
wifi(){
  if [ -z "$1" ]; then
    echo "Usage: wifi <name> <password>"
    return 1
  fi

  nmcli dev wifi connect "$1" password "$2"
}

# Plugins
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]; then
  source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Fzf
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# Starship Prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
