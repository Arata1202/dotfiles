# terminal
alias cd="cdls"
cdls ()
{
    \cd "$@" && ls -a
}

# git
alias ga.='git add .'
alias gcm='git commit -m'
alias push='git push'
alias pull='git pull'
alias grv='git revert'
alias gc='git cherry-pick'
alias stash='git stash'
alias gbr='git branch'
alias ghi='git history'

# flutter
alias fpg='flutter pub get'
alias fr='flutter run'
alias fc='flutter clean'

# php
alias ci='composer install'
alias cu='composer update'
alias pas='php artisan serve'
alias pam='php artisan migrate'
alias pamf='php artisan migrate:fresh'
alias pamfs='php artisan migrate:fresh --seed'

# sail
alias sail='./vendor/bin/sail'

# docker
alias dp='docker ps'
alias dcu='docker-compose up'
alias dcd='docker-compose down'

#npm
alias ni='npm install'
alias nu='npm update'
alias ns='npm start'
alias nrb='npm run build'
alias nrd='npm run dev'
alias nrt='npm run test'

#pnpm
alias pi='pnpm install'
alias pu='pnpm update'
alias ps='pnpm start'
alias prb='pnpm run build'
alias prd='pnpm run dev'
alias prt='pnpm run test'

# python
alias py='python3'

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code-insiders --locate-shell-integration-path zsh)"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
