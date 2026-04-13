# Aliases
alias l='eza -lag --icons'
alias ls='eza --icons'
alias ll='eza -l --icons'
alias la='eza -la --icons'
alias lt='eza --tree --level=2 --icons'
alias lta='eza --tree --level=2 -a --icons'
alias py 'python'
alias pn 'pnpm'
alias n 'nvim'
alias activate 'eval (poetry env activate)'
alias c 'code .'
alias grub-update 'sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias sr 'source ~/.config/fish/config.fish'
alias cat 'bat'
alias df 'df -h'
alias du 'du -h'
alias mkdir 'mkdir -p'
alias cp 'cp -iv'
alias mv 'mv -iv'
alias rm 'rm -iv'
alias grep 'grep --color=auto'
alias ports 'lsof -i -P -n | grep LISTEN'
alias myip 'curl -s ifconfig.me'
alias weather 'curl -s wttr.in/?format=3'

# ripgrep
alias rga 'rg --hidden --no-ignore'

# fd
alias fda 'fd --hidden --no-ignore'

# fzf-powered helpers
alias fzp 'fzf --preview "bat --color=always --style=numbers {}"'

# lazygit / lazydocker
alias lg 'lazygit'
alias ld 'lazydocker'

# AI CLI agents
alias oc 'opencode'
alias ai 'opencode'
alias cpe 'gh copilot explain'
alias cps 'gh copilot suggest'

# git shortcuts
alias g 'git'
alias gs 'git status -sb'
alias ga 'git add'
alias gaa 'git add -A'
alias gc 'git commit'
alias gcm 'git commit -m'
alias gca 'git commit --amend'
alias gp 'git push'
alias gpf 'git push --force-with-lease'
alias gl 'git pull'
alias gd 'git diff'
alias gds 'git diff --staged'
alias glog 'git log --oneline --graph --decorate -20'
alias gco 'git checkout'
alias gsw 'git switch'
alias gbr 'git branch'
alias gst 'git stash'
alias gstp 'git stash pop'

# GitHub CLI
alias prc 'gh pr create'
alias prv 'gh pr view --web'
alias prl 'gh pr list'

# jq / yq
alias jqc 'jq -C . | less -R'

# httpie
alias https 'http --verify=yes'

# hyperfine
alias bench 'hyperfine --warmup 3'

# dust / duf
alias dua 'dust -r'
alias dfp 'duf --only local'

# tldr
alias h 'tldr'

# User abbreviations
abbr ytmp3 'yt-dlp --extract-audio --audio-format mp3'

# Set locales
set -gx LC_ALL en_US.UTF-8  

# Greeting
set fish_greeting

# Editor / pager defaults for development workflows
set -gx VISUAL $EDITOR
set -gx PAGER less
set -gx LESS '-FRX'

# fzf
if command -q fzf
    fzf --fish | source
end

# Use delta as default git pager
set -gx GIT_PAGER delta

# bat theme
set -gx BAT_THEME "Catppuccin Mocha"

# fzf defaults — use fd, preview with bat
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
set -gx FZF_DEFAULT_OPTS '--height 40% --border --layout=reverse'

# Prompt is defined in functions/fish_prompt.fish
