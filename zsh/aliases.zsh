alias mkdir="mkdir -p"

alias www="cd ~/Developpement"

### Nginx
alias nginx.start='brew services start nginx'
alias nginx.stop='brew services stop nginx'
alias nginx.restart='nginx.stop && nginx.start'

### PHP-fpm
alias php-fpm.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php56.plist"
alias php-fpm.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.php56.plist"
alias php-fpm.restart='php-fpm.stop && php-fpm.start'
