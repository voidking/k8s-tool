---
title: "kubectl常用命令"
toc: true
date: 2019-09-15 20:00:00
tags:
- docker
- k8s
categories: 
- [专业,运维,k8s]
---
# kubectl简介

> Kubectl is a command line interface for running commands against Kubernetes clusters. 

没错，kubectl是一个命令行工具，用来控制K8S集群。kubectl该怎么读？可以参考[HowToPronounce-kubectl](http://www.howtopronounce.cc/kubectl)，小编喜欢读作kubecontrol。

kubectl命令格式为：
```
kubectl [command] [TYPE] [NAME] [flags]
```

更多内容，参考[Overview of kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)。

[《K8S入门篇》](https://www.voidking.com/dev-k8s-start/)一文中，已经学习了kubectl的安装方法，并且使用了一些简单命令。本文整理一下kubectl的常用命令，方便记忆和复习。

<!--more-->


# 常用命令
## 指定配置文件
```
# 指定默认配置文件
export KUBECONFIG=~/.kube/config

# 查看kubectl配置
kubectl config view

# 指定单次运行配置文件
kubectl get deployments --kubeconfig=/root/.kube/config
kubectl get deployments --kubeconfig /root/.kube/config
```

## 使用别名缩写
```
# kubectl缩写为k
alias k="/usr/local/bin/kubectl"
```
建议把配置写入 .bashrc ，登录后别名自动生效。

## 命令自动补全
```
yum install -y bash-completion
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc
echo "source <(kubectl completion bash)" >> ~/.bashrc
```

## 查看资源缩写
```
kubectl describe
kubectl api-resources
```

输出结果为：
```
NAME                              SHORTNAMES   APIGROUP                       NAMESPACED   KIND
bindings                                                                      true         Binding
componentstatuses                 cs                                          false        ComponentStatus
configmaps                        cm                                          true         ConfigMap
endpoints                         ep                                          true         Endpoints
events                            ev                                          true         Event
limitranges                       limits                                      true         LimitRange
namespaces                        ns                                          false        Namespace
nodes                             no                                          false        Node
persistentvolumeclaims            pvc                                         true         PersistentVolumeClaim
persistentvolumes                 pv                                          false        PersistentVolume
pods                              po                                          true         Pod
podtemplates                                                                  true         PodTemplate
replicationcontrollers            rc                                          true         ReplicationController
resourcequotas                    quota                                       true         ResourceQuota
secrets                                                                       true         Secret
serviceaccounts                   sa                                          true         ServiceAccount
services                          svc                                         true         Service
mutatingwebhookconfigurations                  admissionregistration.k8s.io   false        MutatingWebhookConfiguration
validatingwebhookconfigurations                admissionregistration.k8s.io   false        ValidatingWebhookConfiguration
batchreleases                                  alicloud.com                   true         BatchRelease
customresourcedefinitions         crd,crds     apiextensions.k8s.io           false        CustomResourceDefinition
apiservices                                    apiregistration.k8s.io         false        APIService
controllerrevisions                            apps                           true         ControllerRevision
daemonsets                        ds           apps                           true         DaemonSet
deployments                       deploy       apps                           true         Deployment
replicasets                       rs           apps                           true         ReplicaSet
statefulsets                      sts          apps                           true         StatefulSet
tokenreviews                                   authentication.k8s.io          false        TokenReview
localsubjectaccessreviews                      authorization.k8s.io           true         LocalSubjectAccessReview
selfsubjectaccessreviews                       authorization.k8s.io           false        SelfSubjectAccessReview
selfsubjectrulesreviews                        authorization.k8s.io           false        SelfSubjectRulesReview
subjectaccessreviews                           authorization.k8s.io           false        SubjectAccessReview
horizontalpodautoscalers          hpa          autoscaling                    true         HorizontalPodAutoscaler
cronjobs                          cj           batch                          true         CronJob
jobs                                           batch                          true         Job
certificatesigningrequests        csr          certificates.k8s.io            false        CertificateSigningRequest
leases                                         coordination.k8s.io            true         Lease
events                            ev           events.k8s.io                  true         Event
daemonsets                        ds           extensions                     true         DaemonSet
deployments                       deploy       extensions                     true         Deployment
ingresses                         ing          extensions                     true         Ingress
networkpolicies                   netpol       extensions                     true         NetworkPolicy
podsecuritypolicies               psp          extensions                     false        PodSecurityPolicy
replicasets                       rs           extensions                     true         ReplicaSet
globaljobs                        globaljob    jobs.aliyun.com                true         GlobalJob
nodes                                          metrics.k8s.io                 false        NodeMetrics
pods                                           metrics.k8s.io                 true         PodMetrics
ingresses                         ing          networking.k8s.io              true         Ingress
networkpolicies                   netpol       networking.k8s.io              true         NetworkPolicy
runtimeclasses                                 node.k8s.io                    false        RuntimeClass
poddisruptionbudgets              pdb          policy                         true         PodDisruptionBudget
podsecuritypolicies               psp          policy                         false        PodSecurityPolicy
clusterrolebindings                            rbac.authorization.k8s.io      false        ClusterRoleBinding
clusterroles                                   rbac.authorization.k8s.io      false        ClusterRole
rolebindings                                   rbac.authorization.k8s.io      true         RoleBinding
roles                                          rbac.authorization.k8s.io      true         Role
priorityclasses                   pc           scheduling.k8s.io              false        PriorityClass
csidrivers                                     storage.k8s.io                 false        CSIDriver
csinodes                                       storage.k8s.io                 false        CSINode
storageclasses                    sc           storage.k8s.io                 false        StorageClass
volumeattachments                              storage.k8s.io                 false        VolumeAttachment
```

## 查看集群信息
```
# 查看集群信息
kubectl cluster-info
kubectl cluster-info dump

# 查看集群状态
kubectl get cs

# 查看node资源使用
kubectl top node
```

## 查看资源
1、查看集群的所有资源
```
kubectl get all
kubectl get all -o wide
```

2、查看deployment
```
# 查看deployment
kubectl get deploy
kubectl get deploy -n ratel -o wide

# 查看deployment实时变化
kubectl get deploy --watch

# 查看指定deployment
kubectl get deploy/deployment-name
kubectl get deploy deployment-name

# 指定namespace
kubectl get deploy -n voidking

# 根据label选择deployment
kubectl get deploy --selector="name=nginx,type=frontend"

# 查看deployment详细信息
kubectl describe deploy
```
pod、service、node的查看方法和deployment相同。

## 导出yaml或json文件
```
# 导出deployment的yaml文件
kubectl get deploy -o yaml > deploy.yaml

# 导出deployment的json文件
kubectl get deploy -o json > deploy.json

# 导出指定deployment的yaml文件
kubectl get deploy/deployment-name -o yaml > deploy-name.yaml

# 导出指定deployment的json文件
kubectl get deploy/deployment-name -o json > deploy-name.json
```
pod、service、node的yaml/json文件的导出方法和deployment相同。

## node封锁
```
# 封锁node，不允许分配pod
kubectl cordon nodename

# 从指定node驱除pod
kubectl drain nodename --ignore-daemonsets

# 解除node的封锁，允许分配pod
kubectl uncordon nodename
```

## 事件相关
```
# 查看集群事件
kubectl get ev
```

## 故障排查
故障排查的第一步是先给问题分下类。这个问题是什么？Pods，Replication Controller或者Service？
1、Pods排查
```
# 查看pod详细信息
kubectl describe pods ${POD_NAME}

# 查看容器日志
kubectl logs ${POD_NAME} ${CONTAINER_NAME}

# 查看crashed容器日志
kubectl logs --previous ${POD_NAME} ${CONTAINER_NAME}

# 查看运行的容器内部日志
kubectl exec ${POD_NAME} -c ${CONTAINER_NAME} -- cat /var/log/cassandra/system.log

# 查看运行的容器内部日志（pod只有一个容器）
# kubectl exec ${POD_NAME} -- cat /var/log/cassandra/system.log
```

2、Replication Controllers排查
```
# 监控rc相关事件
kubectl describe rc ${CONTROLLER_NAME}
```

3、Services排查
```
# 查看endpoints资源，service选择到了哪些pod和端口
kubectl get endpoints ${SERVICE_NAME}
```

更多内容参考[应用故障排查](https://kubernetes.io/zh/docs/tasks/debug-application-cluster/debug-application/)。

## 自动生成yaml
### pod yaml
生成pod的yaml文件模板：
```
kubectl run vk-pod --image=nginx --generator=run-pod/v1 --dry-run -o yaml
```
生成内容为：
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: vk-pod
  name: vk-pod
spec:
  containers:
  - image: nginx
    name: vk-pod
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

更多内容，参考[Kubernetes kubectl run 命令详解](http://docs.kubernetes.org.cn/468.html)。

### deployment yaml
1、生成deployment的yaml文件模板（历史方法）：
```
kubectl run vk-deploy --image=nginx --dry-run -o yaml
```
会出现提示：
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
因为官方不推荐使用 run-pod/v1 以外的其他生成器，其他生成器不久后就会弃用。更多内容参考[kubectl run](https://kubernetes.io/zh/docs/reference/kubectl/conventions/#kubectl-run)。

2、从已有K8S集群中已有资源中导出yaml模板文件（历史方法）：
```
kubectl get deploy/deployment-name -o yaml --export > deploy-name.yaml
```
也会出现提示：
Flag --export has been deprecated, This flag is deprecated and will be removed in future.
很尴尬，--export 也要弃用了，且用且珍惜吧。

3、生成deployment的yaml文件模板（推荐方法）：
```
kubectl create deployment vk-deploy --image=nginx --dry-run -o yaml
```
生成内容为：
```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: vk-deploy
  name: vk-deploy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: vk-deploy
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: vk-deploy
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
status: {}
```

更多内容，参考[Kubernetes kubectl create deployment 命令详解](http://docs.kubernetes.org.cn/535.html)。

### service yaml
生成service的yaml文件模板（推荐方法）：
```
kubectl create service clusterip vk-svc --tcp="5678:8080" --dry-run -o yaml 
```
生成内容为：
```
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: vk-svc
  name: vk-svc
spec:
  ports:
  - name: 5678-8080
    port: 5678
    protocol: TCP
    targetPort: 8080
  selector:
    app: vk-svc
  type: ClusterIP
status:
  loadBalancer: {}
```

更多内容，参考[Kubernetes kubectl create service 命令详解](http://docs.kubernetes.org.cn/564.html)和[Service](https://kubernetes.io/docs/concepts/services-networking/service/)。

## 编辑yaml
生成了模板，很多字段依然不记得怎么办？比如要添加节点亲和性，那么可以查看相关解释：
```
kubectl explain deployment.spec.template.spec.affinity
kubectl explain deployment.spec.template.spec.affinity.nodeAffinity
...
kubectl explain deployment.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms.matchExpressions
```
然后，根据层级关系和解释编辑yaml文件模板。

## yaml验证
```
kubectl create --validate -f deployment.yaml
```

## 徒手写yaml
首先把yaml文件分成四部分，typeMeta、objectMeta、spec和status，其中status部分可以不写。
typeMeta包括apiVersion和kind；
metadata必填name、namespace、labels；
pod.spec主要填containers的name和image，deployment.spec主要填replicas、selector的matchLabels、template，service.spec主要填selector、ports和type。

## 拷贝文件
```
# 拷贝pod内容到宿主机
kubectl cp podname-564949c96c-m986n:/path/filename .
```