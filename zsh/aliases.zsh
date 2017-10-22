alias mkdir="mkdir -p"

alias www="cd ~/Developpement"

### Nginx
alias nginx.start='brew services start nginx'
alias nginx.stop='brew services stop nginx'
alias nginx.restart='nginx.stop && nginx.start'

### PHP-fpm
alias php-fpm.start="brew services start homebrew/php/php72"
alias php-fpm.stop="brew services stop homebrew/php/php72"
alias php-fpm.restart='php-fpm.stop && php-fpm.start'
