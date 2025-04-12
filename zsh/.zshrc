# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise
eval "$(mise activate zsh)"

# makefile
alias mk='make -j'
alias remake='make fclean && make -j'

# git
alias g='git'
alias ga='git add'
## add
alias gap='git add -p'
alias ga.='git add .'
## commit
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
## merge
alias gm='git merge'
alias gms='git merge --squash'
## checkout
alias gco='git switch'
alias gcb='git switch -c'
alias gsw='git switch'
alias gsc='git switch -c'
## status
alias gs='git status -sb'
alias gstt='git status -uno'
## stash
alias gst='git stash -u'
alias gsp='git stash pop'
alias gsl='git stash list'
alias gsc='git stash clear'
## branch
alias gbr='git branch'
## push
alias gps='git push'
## pull
alias gpl='git pull'
## fetch
alias gf='git fetch'
## revert
alias grv='git revert'
## reset
alias grs='git reset'
alias grss='git reset --soft'
alias grsm='git reset --mixed'
alias grsh='git reset --hard'
## log
alias gl='git log'
alias glg='git log --graph --abbrev-commit --date=iso '
alias glo='git log --oneline'
## cherry-pick
alias gcp='git cherry-pick'
## history
alias ghi='git history'

# terminal
cdls ()
{
    \cd "$@" && ls
}
alias cd="cdls"

# ls
export LSCOLORS=gxfxcxdxbxegedabagacad
alias ls='ls --color=auto -GF'
alias ll='ls -alhF'
alias la='ls -a'

## diff
alias diff='colordiff -u'

# mkdir
alias mkdir='mkdir -p'

# cd
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'

alias grep="grep --color=auto"
alias tree='tree -C'

alias c='pbcopy'

alias pwdc='pwd | tr -d "\n" | pbcopy'

# edit
alias zshrc='vi ~/.zshrc'
alias reload='source ~/.zshrc'

# safety
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# mysql
alias ms='mysql.server'
alias mss='mysql.server start'

# docker
alias d='docker'
alias dp='docker ps'
alias di='docker images'
alias drm='docker system prune'

# docker compose
alias dc='docker compose'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcudb='docker compose up -d --build'
alias dcd='docker compose down'
alias dcs='docker compose start'
alias dce='docker compose end'
alias dcr='docker compose restart'
alias dcl='docker compose logs'
alias dcp='docker compose ps'

# php
alias ci='composer install'
alias cu='composer update'
alias pa='php artisan'
alias pas='php artisan serve'
alias par='php artisan route:list'
alias pam='php artisan migrate'
alias pamr='php artisan migrate:rollback'
alias pac='php artisan config:clear && php artisan cache:clear && php artisan view:clear'
alias pamf='php artisan migrate:fresh'
alias pams='php artisan migrate --seed'
alias pamfs='php artisan migrate:fresh --seed'

# sail
alias sail='./vendor/bin/sail'

# npm
alias ni='npm install'
alias nu='npm update'
alias ns='npm start'
alias nrb='npm run build'
alias nrd='npm run dev'
alias nrt='npm run test'

# pnpm
alias pi='pnpm install'
alias pu='pnpm update'
alias ps='pnpm start'
alias prb='pnpm run build'
alias prd='pnpm run dev'
alias prt='pnpm run test'

# flutter
alias fpg='flutter pub get'
alias fr='flutter run'
alias fc='flutter clean'

# python
alias py='python3'
