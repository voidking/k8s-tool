---
title: "使用kubeadm升级K8S集群"
toc: true
date: 2020-03-08 20:00:00
tags:
- docker
- k8s
categories: 
- [专业,运维,docker]
---

# K8S组件版本说明
k8s集群中的常见组件包括：
A类：kube-apiserver
B类：controller-manager、kube-scheduler
C类：kubelet、kube-proxy
D类：etcd cluster、CoreDNS
E类：kubectl

组件的版本号一般表示为 major.minor.patch，比如v1.10.3。其中，A类组件是主要组件，以它为版本基准。比如，A类组件版本的minor号为x，那么B类组件版本必须为x或者x-1，C类组件版本必须为x、x-1或者x-2，E类组件版本必须为x、x-1或者x+1。而D类组件，和A类组件不是同一版本体系，版本兼容情况需要查看文档。整理成表格如下：

| 组件类别 | minor版本 | 组件 |
| ----- | ----- | ----- |
| A类 | x | kube-apiserver |
| B类 | x、x-1 | controller-manager、kube-scheduler |
| C类 | x、x-1、x-2 | kubelet、kube-proxy |
| E类 | x、x-1、x+1 | kubectl |
| D类 | 查看文档 | etcd cluster、CoreDNS |

本文学习使用kubeadm进行k8s集群的升级。

<!--more-->

# 升级顺序
推荐的升级方法，是根据minor版本号逐级进行升级。比如v1.10.0想要升级到v1.13.0，不应该直接升级到v1.13.0，而是应该v1.10.0->v1.11.0->v1.12.0->v1.13.0。

升级顺序一般为：
1、升级kubeadm
2、升级master node
3、升级worker node
4、升级kubelet

# 升级操作
以v1.11.0升级v1.12.0为例。

## master节点
1、查看升级帮助
`kubeadm upgrade plan`

2、升级kubeadm
```
apt-get upgrade -y kubeadm=1.12.0-00
# or
apt install kubeadm=1.12.0-00
```

3、升级k8s的AB类组件
```
kubeadm upgrade apply v1.12.0
```
此时使用kubectl get nodes，看到的version依然是v1.11.0，因为这里显示的是kubelet的版本，而不是kube-apiserver的版本。

4、升级master节点的kubelet
```
apt install kubelet=1.12.0-00
systemctl restart kubelet
```

## worker节点
1、驱逐worker节点的pods，封锁节点
```
kubectl drain node-1
kubectl cordon node-1
```

2、升级kubeadm和kubectl
```
apt-get install kubeadm=1.12.0-00
apt-get install kubelet=1.12.0-00
kubeadm upgrade node config --kubelet-version v1.12.0
systemctl restart kubelet
```

3、解除节点封锁
`kubectl uncordon node-1`