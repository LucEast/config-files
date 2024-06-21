# Alias für kubectl
alias k=kubectl

# Autokomplettierung für kubectl
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
source <(kubectl completion zsh)
compdef k=kubectl

# Alias für das Wechseln des Kontexts
alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'

# Alias für das Setzen des Namespaces
alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f2 ; } ; f'
