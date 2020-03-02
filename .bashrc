# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
# yum install -y bash-completion
# source /usr/share/bash-completion/bash_completion
# source <(kubectl completion bash)
export KUBECONFIG=/home/haojin/.kube/config
alias k=kubectl
kubectl config set-context $(kubectl config current-context) --namespace=voidking
