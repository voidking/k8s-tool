---
title: "K8S集群中etcd备份和恢复"
toc: true
date: 2020-03-08 22:00:00
tags:
- docker
- k8s
categories: 
- [专业,运维,docker]
---

# 前言
就像备份数据库一样，很多时候，我们也想对k8s资源配置进行备份。
```
kubectl get all --all-namespaces -o yaml > all-deploy-services.yaml
```
上面的方法，可以实现对k8s资源配置的备份。但是更好的办法，是对etcd进行备份。本文就学习一下k8s中etcd的备份和恢复方法。

<!--more-->

# etcd集群状态

```
HOST_1=10.240.0.17
HOST_2=10.240.0.18
HOST_3=10.240.0.19
ENDPOINTS=$HOST_1:2379,$HOST_2:2379,$HOST_3:2379
etcdctl --endpoints=$ENDPOINTS member list
etcdctl --write-out=table --endpoints=$ENDPOINTS endpoint status
etcdctl --endpoints=$ENDPOINTS endpoint health
```

# 备份
1、查看配置
```
kubectl describe pod etcd-master -n kube-system | grep Command -i -A 20
```
看到Command字段为：
```
Command:
  etcd
  --advertise-client-urls=https://172.17.0.10:2379
  --cert-file=/etc/kubernetes/pki/etcd/server.crt
  --client-cert-auth=true
  --data-dir=/var/lib/etcd
  --initial-advertise-peer-urls=https://172.17.0.10:2380
  --initial-cluster=master=https://172.17.0.10:2380
  --key-file=/etc/kubernetes/pki/etcd/server.key
  --listen-client-urls=https://127.0.0.1:2379,https://172.17.0.10:2379
  --listen-metrics-urls=http://127.0.0.1:2381
  --listen-peer-urls=https://172.17.0.10:2380
  --name=master
  --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
  --peer-client-cert-auth=true
  --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
  --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
  --snapshot-count=10000
  --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
```

或者查看/etc/kubernetes/manifests/etcd.yaml。

2、执行备份
```
ETCDCTL_API=3 etcdctl \
--endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /tmp/snapshot-pre-boot.db
```

3、查看备份
```
ETCDCTL_API=3 etcdctl \
--endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot status /tmp/snapshot-pre-boot.db -w table
```

# 恢复
1、恢复etcd数据
```
ETCDCTL_API=3 etcdctl \
--endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
--initial-cluster=master=https://127.0.0.1:2380 \
--initial-cluster-token etcd-cluster-1 \
--initial-advertise-peer-urls=https://127.0.0.1:2380 \
--name=master \
--data-dir /var/lib/etcd-from-backup \
snapshot restore /tmp/snapshot-pre-boot.db
```

2、修改etcd.yaml
`vim /etc/kubernetes/manifests/etcd.yaml`，如下修改：
```
# Update --data-dir to use new target location
--data-dir=/var/lib/etcd-from-backup

# Update new initial-cluster-token to specify new cluster
--initial-cluster-token=etcd-cluster-1

# Update volumes and volume mounts to point to new path
    volumeMounts:
    - mountPath: /var/lib/etcd-from-backup
      name: etcd-data
    - mountPath: /etc/kubernetes/pki/etcd
      name: etcd-certs
  hostNetwork: true
  priorityClassName: system-cluster-critical
  volumes:
  - hostPath:
      path: /var/lib/etcd-from-backup
      type: DirectoryOrCreate
    name: etcd-data
  - hostPath:
      path: /etc/kubernetes/pki/etcd
      type: DirectoryOrCreate
    name: etcd-certs
```