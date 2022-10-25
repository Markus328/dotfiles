export LANG=en_US.UTF-8

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt nocaseglob
setopt -J

autoload -U compinit && compinit


typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[comment]='fg=blue'
ZVM_TERM=xterm-256color


ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#2222ff,underline"


upfile() {
    for i in "$@" 
    do
        curl -F file=@$i http://0x0.st 
    done 
}
export PATH=$PATH:~/.local/bin
export EDITOR=nvim
export XDG_SESSION_DESKTOP=sway
alias open='xdg-open'
alias l='ls --color=always -all'
alias ls='ls --color=always'
alias btr-cr='sudo btrfs su cr'
alias btr-snap='sudo btrfs su snap'
alias btr-del='sudo btrfs su del'
alias btr-usage='sudo btrfs fi usage /'
alias btr-show='sudo btrfs su show'
alias pupg='sudo pacman -Syu'
alias psearch='sudo pacman -Ss'
alias pinst='sudo pacman -S'
alias pinf='sudo pacman -Si'
alias prem='sudo pacman -Rs'
alias btr-set='sudo btrfs property set'
alias btr-get='sudo btrfs property get'
alias btr-ls='sudo btrfs su l /'
alias ksync='rsync -a /userdata/@dotfiles/keepass/Sync /run/media/markus/Ventoy/KeepassXC/'

bindkey -M viins '^ ' autosuggest-accept
bindkey -M viins '^q' autosuggest-clear
bindkey -M viins '^e' autosuggest-toggle
bindkey -M viins '^\b' autosuggest-execute



### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
zinit for \
light-mode  zsh-users/zsh-autosuggestions \
	light-mode agkozak/agkozak-zsh-theme \
	light-mode zsh-users/zsh-completions \
	light-mode zdharma-continuum/fast-syntax-highlighting \
	light-mode jeffreytse/zsh-vi-mode  

source $HOME/.config/util/mpv/shell_setup.sh



function zvm_after_lazy_keybindings() {
  bindkey -a 'f' undo
  bindkey -a 'u' zvm_enter_insert_i_mode
  bindkey -a 'c' zvm_enter_visual_mode
  bindkey -a 'C' zvm_enter_visual_line_mode
  bindkey -a 'w' vi-replace-chars
  bindkey -a 'x' vi-delete-char
  bindkey -a 'y' vi-backward-char
  bindkey -a 'v' vi-backward-word
  bindkey -a 'V' vi-backward-blank-word
  bindkey -a 'o' vi-forward-char
  bindkey -a 'd' vi-forward-word
  bindkey -a 'D' vi-forward-blank-word
  bindkey -a 'e' up-line-or-history 
  bindkey -a 'n' down-line-or-history 
  bindkey -a 'k' vi-repeat-search 
  bindkey -a 'K' vi-rev-repeat-search 
  bindkey -a 'h' zvm_vi_delete
  bindkey -a 'r' vi-forward-word-end
  bindkey -a 'R' vi-forward-blank-word-end
  bindkey -a '~' vi-end-of-line
  bindkey -a '`' vi-first-non-blank
  bindkey -a '^' zvm_vi_opp_case
  bindkey -M visual 'r' vi-forward-word-end
  bindkey -M visual 'R' vi-forward-blank-word-end
  bindkey -M visual '~' vi-end-of-line
  bindkey -M visual '`' vi-first-non-blank
  bindkey -M visual '^' zvm_vi_opp_case
  bindkey -M visual 'y' vi-backward-char
  bindkey -M visual 'v' vi-backward-word
  bindkey -M visual 'V' vi-backward-blank-word
  bindkey -M visual 'o' vi-forward-char
  bindkey -M visual 'd' vi-forward-word
  bindkey -M visual 'D' vi-forward-blank-word
  bindkey -M visual 'e' up-line 
  bindkey -M visual 'n' down-line
  bindkey -M visual 'w' vi-replace-chars
  bindkey -M visual 'x' vi-delete-char
  bindkey -M visual 'h' zvm_vi_delete
}
### End of Zinit's installer chunk
