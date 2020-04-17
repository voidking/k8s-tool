---
title: "使用curl访问k8s的apiserver"
toc: true
date: 2020-04-15 20:00:00
tags:
- docker
- k8s
categories: 
- [专业,运维,docker]
- [专业,运维,k8s]
---

# k8s管理工具
普通人管理k8s集群，最常用的工具是kubectl。开发界大佬管理k8s集群，go-client也是一件顺手的工具。
而除了kubectl和go-client，其实还可以使用curl命令。
本文，我们就学习一下怎样使用curl访问k8s的apiserver，实现k8s集群的管理。主要参考[如何使用curl访问k8s的apiserver](https://www.codercto.com/a/89468.html)。

<!--more-->

# 查看pod
需求：使用curl命令，实现 kubectl get pod 同样的效果。

## 获取token
想要使用curl命令访问apiserver，首先要获得一个具有权限的token。

```
kubectl get secrets --all-namespaces | grep admin
kubectl describe secrets admin-token-vmv2c -n kube-system
```
输出结果为：
```
Name:         admin-token-vmv2c
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: admin
              kubernetes.io/service-account.uid: a75b4cdc-e120-11e9-8695-00163e300424

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1419 bytes
namespace:  11 bytes
token:      xxxthisisatokenxxx
```
最后一个字段就是token，那么这个token有哪些权限呢？

## 查看token权限
根据annotations中的key value，可以看到这个secrets绑定了一个service-account(sa)，name为admin。等同于这个token绑定了一个sa，name为admin。

查看admin这个service-account的信息。
```
kubectl get sa --all-namespaces | grep admin
kubectl describe sa admin -n kube-system
```

输出结果为：
```
Name:                admin
Namespace:           kube-system
Labels:              <none>
Annotations:         kubectl.kubernetes.io/last-applied-configuration:
                       {"apiVersion":"v1","kind":"ServiceAccount","metadata":{"annotations":{},"name":"admin","namespace":"kube-system"}}
Image pull secrets:  <none>
Mountable secrets:   admin-token-vmv2c
Tokens:              admin-token-vmv2c
Events:              <none>
```
没有关于admin的权限信息，那么我们再看一下admin绑定了哪些role和clusterrole。

```
kubectl get rolebindings --all-namespaces -oyaml | grep "name: admin" -A10 -B10
kubectl get clusterrolebindings --all-namespaces -oyaml | grep "name: admin" -A10 -B10
```
找到有用信息为：
```
- apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"rbac.authorization.k8s.io/v1beta1","kind":"ClusterRoleBinding","metadata":{"annotations":{},"name":"admin"},"roleRef":{"apiGroup":"rbac.authorization.k8s.io","kind":"ClusterRole","name":"cluster-admin"},"subjects":[{"kind":"ServiceAccount","name":"admin","namespace":"kube-system"}]}
    creationTimestamp: "2019-09-27T12:16:37Z"
    name: admin
    resourceVersion: "1317"
    selfLink: /apis/rbac.authorization.k8s.io/v1/clusterrolebindings/admin
    uid: a75e1ef9-e120-11e9-8695-00163e300424
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: cluster-admin
  subjects:
  - kind: ServiceAccount
    name: admin
    namespace: kube-system
```

可知admin绑定了一个名为cluster-admin的clusterrole，接着查看cluster-admin的权限。

```
kubectl describe clusterrole cluster-admin -n kube-system
```

结果为：
```
Name:         cluster-admin
Labels:       kubernetes.io/bootstrapping=rbac-defaults
Annotations:  rbac.authorization.kubernetes.io/autoupdate: true
PolicyRule:
  Resources  Non-Resource URLs  Resource Names  Verbs
  ---------  -----------------  --------------  -----
  *.*        []                 []              [*]
             [*]                []              [*]
```

cluster-admin这个角色拥有集群的所有权限，因此admin这个sa拥有集群的所有权限。

## 使用token
1、设置token和apiserver作为变量
```
TOKEN=$(kubectl describe secrets $(kubectl get secrets -n kube-system |grep admin |cut -f1 -d ' ') -n kube-system |grep -E '^token' |cut -f2 -d':'|tr -d '\t'|tr -d ' ')
APISERVER=$(kubectl config view |grep server|cut -f 2- -d ":" | tr -d " ")
``` 

2、使用token调用apiserver
```
curl -H "Authorization: Bearer $TOKEN" $APISERVER/ --insecure
curl -H "Authorization: Bearer $TOKEN" $APISERVER/api  --insecure
curl -H "Authorization: Bearer $TOKEN" $APISERVER/api/v1/namespaces/default/pods/  --insecure
```

以上，查看到了default空间下的pod信息，和 kubectl get pod 基本等同。