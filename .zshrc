#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 

# export LANG=en_US.UTF-8
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"
export PATH="/opt/flutter/bin:$PATH"
export ANDROID_HOME=~/Android/Sdk
export PATH=$PATH:$HOME/go/bin

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

ZSH_THEME="oh-my-theme"

## PATHS ##
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh
source "$HOME/.local/bin/env"

# Eval Functions
eval "$(zoxide init zsh)"

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
#plugins=(git)

## Pywal ##
cat ~/.cache/wal/sequences

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# For a full list of active aliases, run `alias`.
## Aliases ##
alias kill='sudo kill -9 $1'
alias rmdir='rm -rf'
alias cwipe='cliphist wipe'
alias pac="sudo pacman -S"
alias wclass="xprop | grep 'CLASS'"
alias syst='systemctl status'
alias syse='systemctl enable'
alias sysd='systemctl disable'
alias syss='systemctl start'
alias cya='shutdown -h now'
alias audio='pavucontrol'
alias up='sudo pacman -Syu'
alias ls='eza --all --header --long --sort=modified $eza_params'
alias la='eza -lbhHigUmuSa@'
alias cd='z'
alias cdi='zi'
alias tree='eza --tree $eza_params'
alias kat='bat'
alias ga='git add .'
alias gad='git add'
alias gc="git commit -m $1"
alias gp='git push'
alias gpl='git pull'
alias ps1='ps -auxwf'
alias psg='ps -ef | grep'
alias dz='aunpack'
alias pacc='sudo pacman -Scc'
alias ipv6on='sudo sysctl net.ipv6.conf.all.disable_ipv6=0'
alias ipv6off='sudo sysctl net.ipv6.conf.all.disable_ipv6=1'
alias nc='netcat'
alias http="python3 -m http.server"
alias hypr="codium ~/.config/hypr/hyprland.conf"
alias zshsrc="codium ~/.zshrc"
alias android-studio='QT_QPA_PLATFORM=xcb android-studio'
alias pacmanff="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias pacinfo="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
alias ff="find . -type f | fzf --multi --preview 'if file --mime-encoding {} | grep -q binary; then strings {} | head -100; else bat --color=always {}; fi' --preview-window 'right:60%'"
alias cron='systemctl --user list-timers'

## Functions ##
function cdl() { clear && z "$1" && ls; }
function cheat() { curl -m 7 "http://cheat.sh/$1"; }
function rmk() { scrub -p dod $1; shred -zun 10 -v $1; }
function walup() { wal -i "$(find ~/Documents/w4llp4p3rs -type f -name '*.jpeg' | shuf -n 1)"; }
function box() { [ -z "$1" ] && echo "Usage: box <HTB_IP>" || sudo ufw allow from "$1" to any && echo "Traffic allowed from $1"; }
function boxd() { [ -z "$1" ] && echo "Usage: boxd <HTB_IP>" || sudo ufw delete allow from "$1" to any && echo "Traffic rule deleted for $1"; }
function randomchar() { < /dev/urandom tr -dc 'A-Za-z0-9' | head -c "$1"; echo; }
function gitssh() { [ -z "$SSH_AUTH_SOCK" ] && eval "$(ssh-agent -s)"; ssh-add -l | grep -q "$(ssh-keygen -lf ~/.ssh/github | awk '{print $2}')" || ssh-add ~/.ssh/github; }
function hu() { hermes update "$@"; ~/.fix-mnemosyne.sh; }

# opencode
export PATH=/home/b0llull0s/.opencode/bin:$PATH

#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 
