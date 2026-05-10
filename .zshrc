# Presentation
echo
fastfetch
echo

# --- History Configuration ---
HISTFILE=~/.cache/.zsh_history    # Location of the history file
HISTSIZE=100000            # Max lines in memory
SAVEHIST=100000            # Max lines in the file
setopt SHARE_HISTORY       # Share history between sessions
setopt APPEND_HISTORY      # Append to history file, don't replace it
setopt INC_APPEND_HISTORY  # Add commands immediately to history file
setopt HIST_IGNORE_SPACE   # Don't record commands starting with space
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first

export LANG=pt_BR.UTF-8
# Binds
bindkey "^[[3~" delete-char # Deleta o caractere
bindkey "^[[H" beginning-of-line # Home para ir para o inicio da linha
bindkey "^[[F" end-of-line # End para ir para o fim da linha
bindkey "^H" backward-kill-word # CTRL + BACKSPACE, deleta a palavra inteira do fim para o inicio
bindkey "^[[3;5~" kill-word # CTRL + DELETE, deleta a palavra inteira do inicio para o fim
bindkey "^[[1;5D" backward-word # CTRL + <-, para movimentar para a esquerda
bindkey "^[[1;5C" forward-word # CTRL + ->, para a direita

# Alias
alias update='sudo pacman -Syu'
alias v='nvim'
alias update='sudo pacman -Syu'
alias pinstall='sudo pacman -S'

# Functions
# Connect Wifi
wifi(){
  if [ -z "$1" ]; then
    echo "  Usage: wifi [options]"
    echo "    wifi <name> <password>"
    echo "    "
    echo "    Options:"
    echo "      -l, --list  List all available networks"
    return 1
  fi

  # list all wifi
  if [ $1 = "-l" ] || [ $1 = "--list" ]; then
    nmcli -f IN-USE,SSID,SIGNAL dev wifi list
    return 0
  fi

  nmcli dev wifi connect "$1" password "$2"
}

# Git add, commit and push
gacp() {
  if [ -z "$1" ]; then
    echo "Usage: gacp <commit message>"
    return 1
  fi
  git add .
  git commit -m "$1"

  # Verifica se existe algum remote
  if ! git remote | grep -q .; then
    echo "⚠️ Commit feito, mas nenhum remote configurado. Push ignorado."
    return 0
  fi

  # Verifica upstream da branch
  if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
    echo "⚠️ Sem upstream. Fazendo push com --set-upstream"
    git push --set-upstream origin "$(git branch --show-current)"
  else
    git push
  fi
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