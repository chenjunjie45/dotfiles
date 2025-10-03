PATH=$PATH:/Applications/IntelliJ\ IDEA.app/Contents/MacOS GOPROXY=https://proxy.golang.com.cn,direct
export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"

export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
eval "$(/opt/homebrew/bin/brew shellenv)"

#插件
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
#source ~/.zsh/copybuffer.plugin.zsh
#source ~/.zsh/copyfile.plugin.zsh
#source ~/.zsh/zsh-you-should-use/you-should-use.plugin.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
#source ~/.oh-my-zsh/custom/plugins/you-should-use/you-should-use.plugin.zsh
#source ~/.zsh/copypath.plugin.zsh
source ~/.zsh/sudo.plugin.zsh
#[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
plugins=(last-working-dir git vi-mode)

#export httpvi-mode_proxy=127.0.0.1:7890
#export https_proxy=127.0.0.1:7890
export ZSH="$HOME/.oh-my-zsh"
#主题
#ZSH_THEME="af-magic"
#ZSH_THEME="spaceship"
#ZSH_THEME="agnoster"
#ZSH_THEME="astro"
eval "$(starship init zsh)"


#环境变量
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH
PATH=$PATH:~/go/bin
PATH=$PATH:/usr/local/ssh
alias vim="nvim"

export PATH="${HOME}/Library/maven/apache-maven-3.6.3/bin:$PATH"
#export PATH="/Users/chenjunjie/maven/bin:$PATH"
#export all_proxy=socks5://127.0.0.1:7890
source $ZSH/oh-my-zsh.sh

#alias ls='lsd'
#alias l='lsd -l'
#alias ll='lsd -l --date +%Y年%m月%d"日"%H:%M:%S'
alias top='btop'

#history配置
#export HISTTIMEFORMAT='%F %T '
alias his='history -i'

export HISTTIMEFORMAT="%Y-%M-%D %H:%M:%S  "
export HISTSIZE=10000
export HISTFILESIZE=10000
#export HISTFILE=~/.commandline_warrior
PROMPT_COMMAND='history -a'

#fzf
eval "$(fzf --zsh)"
source /opt/homebrew/Cellar/fzf/0.65.2/shell/key-bindings.zsh
# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/.zsh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ----- Bat (better cat) -----

#export BAT_THEME=tokyonight_night

# ---- Eza (better ls) -----

alias ls="eza --icons=always"
alias ll="ls -l"
# ---- TheFuck -----
# thefuck alias
#eval $(thefuck --alias)
#eval $(thefuck --alias fk)

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
eval "$(docker completion zsh)"
eval "$(kubectl completion zsh)"
eval "$(kubecm completion zsh)"
alias cd="z"
#alias tmx="tmux attach -t coding01 || tmux  new -s coding01"
#alias tls="tmux ls"
#alias trm="tmux kill-session -t"
#alias tch="tmux attach"
alias tar="gtar"
#alias cat="bat"
alias q="yazi"
alias g="lazygit"
#alias kitty="kitty @ launch --type=tab"
#export TERM=xterm-256color
export TERM=xterm-kitty

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
copy_pwd() {
  pwd | pbcopy
  echo "当前路径已复制到剪贴板: $(pwd)"
}

export EDITOR="nvim"
export SHELL="/bin/zsh"
export STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"
export XDG_CONFIG_HOME="$HOME/.config"
