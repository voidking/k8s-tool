# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export KUBECONFIG=/home/haojin/.kube/config
kubectl config set-context $(kubectl config current-context) --namespace=voidking
alias k="kubectl"
alias kg="kubectl get"
alias kd="kubectl describe"

# yum install -y bash-completion
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
complete -F __start_kubectl k
