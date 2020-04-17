---
title: "K8S中的RBAC鉴权"
toc: true
date: 2020-03-20 20:00:00
tags:
- docker
- k8s
categories: 
- [专业,运维,docker]
---

# RBAC Authorization
> Role-based access control (RBAC) is a method of regulating access to computer or network resources based on the roles of individual users within your organization.

更多内容，参考[Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)。

[《SSL和TLS》](https://www.voidking.com/dev-ssl-tls/)文中，通过API签名一节，创建了新用户jane，并且给该用户的证书进行签名。现在我们有了jane.crt和jane.key，本文中会配置jane拥有一些k8s集群的管理权限。

<!--more-->

# 角色和绑定
首先，给用户jane配置权限，使其能够创建和查看default空间下的pods。

## 命令实现
1、创建角色
```
kubectl create role --help
kubectl create role developer --resource=pods --verb=list,create
```

2、角色绑定
```
kubectl create rolebinding dev-user-binding --role=developer --user=jane
```

3、验证权限
```
kubectl auth can-i list pods --as jane
kubectl get pods --as jane
```
至此，用户jane的权限配置完成。

## manifest实现
```
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: developer
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list", "create"]

---
kind: RoleBindingapiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dev-user-binding
subjects:
- kind: User
  name: jane
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.iomaster
```

# 集群角色和绑定
以上，给jane授权，是在namespace范围内的。当我们想给jane授权cluster范围的权限时，就需要clusterroles。

比如，我们想给jane授权node相关的权限，可以如下实现。

## 命令实现
1、创建集群角色
```
kubectl create clusterrole node-reader --verb=get,list,watch --resource=nodes
```

2、绑定集群角色
```
kubectl create clusterrolebinding node-reader-binding --user=jane --clusterrole=node-reader
```

## manifest实现
```
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  creationTimestamp: null
  name: node-reader
rules:
- apiGroups:
  - ""
  resources:
  - nodes
  verbs:
  - get
  - list
  - watch

---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  creationTimestamp: null
  name: node-reader-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: node-reader
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: jane
```

## 其他
如果使用clusterrole指定的资源是pods这种namespace级别的资源，该集群角色绑定给jane后会有什么效果？
答：jane对所有namespace中的pods资源拥有clusterrole中定义的操作权限。

# 配置文件
用户jane已经拥有了需要的权限，该怎样访问k8s集群呢？答案是通过kubeconfig文件。

## kubeconfig
1、查看配置
`kubectl config view`
记录当前的server地址。

2、保存ca.crt
```
cat .kube/config | grep certificate-authority-data | awk '{print $2}' | base64 --decode > ca.crt
```

## jane.kubeconfig
1、设置集群参数
```
kubectl config set-cluster kubernetes \
--server="https://172.17.0.69:6443" \
--certificate-authority=/root/ca.crt \
--embed-certs=true \
--kubeconfig=jane.kubeconfig
```
当前目录生成jane.kubeconfig文件。

2、设置客户端认证参数
```
kubectl config set-credentials jane \
--client-certificate=/root/jane.crt \
--client-key=/root/jane.key \
--embed-certs=true \
--kubeconfig=jane.kubeconfig
```

3、设置上下文参数
```
kubectl config set-context jane@kubernetes \
--cluster=kubernetes \
--user=jane \
--namespace=default \
--kubeconfig=jane.kubeconfig
```

4、查看配置
```
cat jane.kubeconfig
kubectl config view --kubeconfig jane.kubeconfig
```

5、设置默认上下文
```
export KUBECONFIG=/root/jane.kubeconfig
kubectl config use-context jane@kubernetes --kubeconfig=jane.kubeconfig
```

6、权限测试
`kubectl get pods`
如果没有配置权限，会输出：
```
Error from server (Forbidden): pods is forbidden: User "jane" cannot list resource "pods" in API group "" in the namespace "default"
```
如果配置好了权限，会输出pod相关信息。

但是，以上权限测试只是在minikube或者[katacoda](https://www.katacoda.com/courses/kubernetes/playground)平台生效。
如果使用[kodekloud](https://kodekloud.com/courses/enrolled/675080)或者阿里云k8s集群，会报错：
```
error: You must be logged in to the server (Unauthorized)
```
研究了四个多小时，才发现是平台的问题，服气了。。。