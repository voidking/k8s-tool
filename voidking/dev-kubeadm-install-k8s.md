---
title: "使用kubeadm安装部署K8S集群"
toc: true
date: 2020-03-16 20:00:00
tags:
- docker
- k8s
categories: 
- [专业,运维,docker]
---

# kubeadm简介
[《使用kubeadm升级K8S集群》](https://www.voidking.com/dev-kubeadm-upgrade/)一文中，了解了k8s集群中常见组件，并且使用kubeadm对k8s集群进行了升级。本文中，会学习使用kubeadm安装部署k8s集群。

> Kubeadm is a tool built to provide kubeadm init and kubeadm join as best-practice “fast paths” for creating Kubernetes clusters.

更多内容，参考[Overview of kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm/)和[Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)。

<!--more-->

# 安装流程
目标：搭建一个k8s集群，包括master和node01两个节点，节点系统为ubuntu16.04.2。

1、环境准备。

2、在两个节点上安装kubeadm。

3、使用kubeadm初始化节点。

4、安装网络插件。

5、验证安装。

# 环境准备

1、配置主机名

2、配置IP地址

3、参考[Letting iptables see bridged traffic](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#letting-iptables-see-bridged-traffic)，配置iptables

```
# ensure legacy binaries are installed
sudo apt-get install -y iptables arptables ebtables

# switch to legacy versions
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy

# Letting iptables see bridged traffic
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```

4、参考[Docker入门](https://www.voidking.com/dev-docker-start/)，安装Docker

# 安装kubeadm
参考[Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)。

1、确认系统版本
`cat /etc/os-release`

2、执行安装kubeadm、kubelet和kubectl（两个节点都要执行）
```
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

3、查看kubelet版本
`kubelet --version`

# 初始化节点
参考[Installing kubeadm on your hosts](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#installing-kubeadm-on-your-hosts)。

## master
1、测试与gcr.io的连接
`kubeadm config images pull`

2、执行初始化
`kubeadm init`
完成后，屏幕输出会提示创建配置文件，以及添加worker node的join命令，记录下来。

3、创建配置文件
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

PS：如果忘记了添加worker node的join命令，可以重新生成。
```
kubeadm token create --help
kubeadm token create --print-join-command
```
生成新的join命令后，之前的join命令同样可以使用。


## node01
1、使用join命令，添加node01节点到集群
```
kubeadm join 172.17.0.53:6443 --token b09bi7.ob6evvc11a8jt1ie \
    --discovery-token-ca-cert-hash sha256:8abadf8f2eb81301060af3ac6002959714ccf79aaf853546445a2fd6a0265001
```

2、验证结果
在master节点执行：
`kubectl get nodes`
可以看到master节点和node01节点，都是NotReady的状态。

# 安装网络插件
参考[Installing a Pod network add-on](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network)，本文中选择安装weave。（以下命令都是在master节点执行。）

1、安装weave
```
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```

2、验证结果
`kubectl get nodes -w`
等待一会，可以看到master节点和node01节点，变化为Ready的状态，nice。

以上，k8s集群安装部署完成。

# 验证安装
## 手动验证
```
kubectl get nodes
kubectl get pods --all-namespaces
service kube-apiserver status
service kube-controller-manager status
service kube-scheduler status
service kubelet status
service kube-proxy status
```

```
kubectl run nginx
kubectl get pods
kubectl scale --replicas=3 deploy/nginx
kubectl get pods
kubectl expose deployment nginx --port=80 --type=NodePort
kubectl get service
curl http://node01:31850
```

## test-infra
源码地址：[kubernetes/test-infra](https://github.com/kubernetes/test-infra)

1、拉取源码
`go get -u k8s.io/test-infra/kubetest`

2、执行kubetest
```
kubetest --extract=v1.11.3
cd kubernetes
export KUBE_MASTER_IP="172.17.0.53:6443"
export KUBE_MASTER=kube-master
kubetest --test --provider=skeleton > testout.txt
kubetest --test --provider=skeleton --test_args="ginkgo.focus=Secrets" > testout.txt
cat testout.txt
```

## Smoke Test
按照[Smoke Test](https://github.com/mmumshad/kubernetes-the-hard-way/blob/master/docs/15-smoke-test.md)文档操作一遍。

## sonobuoy
官网地址：[sonobuoy](https://sonobuoy.io/)
源码地址：[vmware-tanzu/sonobuoy](https://github.com/vmware-tanzu/sonobuoy)