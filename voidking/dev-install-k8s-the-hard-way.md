---
title: "安装部署K8S集群的艰难之路"
toc: true
date: 2020-04-01 20:00:00
tags:
- docker
- k8s
categories: 
- [专业,运维,docker]
- [专业,运维,k8s]
---

# 前言
[《使用kubeadm安装部署K8S集群》](https://www.voidking.com/dev-kubeadm-install-k8s/)一文中，使用kubeadm安装部署了k8s集群。但是，kubeadm的安装方式太简单了，而cka的要求不止这么简单。因此，我们还需要学习从零开始，一个一个组件安装配置k8s集群的方法，所谓k8s the hard way。

本文的目标是在virtualbox中，搭建一个k8s集群，一个master节点，一个node01节点。

主要参考[kelseyhightower/kubernetes-the-hard-way](https://github.com/kelseyhightower/kubernetes-the-hard-way)和[mmumshad/kubernetes-the-hard-way](https://github.com/mmumshad/kubernetes-the-hard-way)。

<!--more-->

# 准备

- 创建两台centos7虚拟机，master节点1C2G，node01节点1C1G
- 配置网络，master节点IP为192.168.56.150，node01节点的IP为192.168.56.151
- 配置hostname，并且把两个节点的hostname添加到/etc/hosts
- 安装Docker，参考[《Docker入门》](https://www.voidking.com/dev-docker-start/)

# 安装流程
1、安装kubectl

2、创建CA，给每个组件生成TLS证书
TLS证书包括：
ETCD Server Certificate
Kubernetes API Server Certificate
Controller Manager Client Certificate
Scheduler Client Certificate

Service Account Key Pair
Kube Proxy Client Certificate
Kubelet Client Certificates
Admin Client Certificate

3、给每个组件生成k8s配置文件，用于访问apiserver

4、生成数据加密配置和密钥，使集群支持静态加密

5、指定CA和TLS，在master节点启动etcd

6、指定CA和TLS，在master节点启动kube-apiserver、kube-controller-manager、kube-scheduler

7、指定CA和TLS，在node01节点启动kubelet和kube-proxy

8、指定CA和TLS，生成admin用户的配置文件，使用kubectl可以访问集群

9、部署weave，使pod可以获取到IP

10、部署coredns，使svc服务名可以使用

11、Smoke Test和End-to-End Tests

# 实践篇
操作过程太长，具体还是参考前言中的两个 kubernetes-the-hard-way 文档吧。。。


