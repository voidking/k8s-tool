# k8s-tool
k8s tool for cka，including shell scripts and yaml files.

# generate yaml
```
# pod
kubectl run vk-pod --image=nginx --generator=run-pod/v1 --dry-run -o yaml

# deployment
kubectl create deployment vk-deploy --image=nginx --dry-run -o yaml

# service
kubectl create service clusterip vk-svc --tcp="5678:8080" --dry-run -o yaml 

# configmap
kubectl create configmap special-config --from-literal=special.how=very --from-literal=special.type=charm

# secret
kubectl create secret generic db-user-pass --from-literal=username=voidking --from-literal=password='vkpassword'
```

# expose service
```
kubectl expose deployment deployment-name --port=6789 --target-port=80
```

# csr
1、签名
```
openssl genrsa -out voidking.key 2048
openssl req -new -key voidking.key -subj  "/CN=voidking" -out voidking.csr
cat voidking.csr | base64

kubectl apply -f voidking-csr.yaml
kubectl get csr 
kubectl certificate approve voidking
kubectl get csr voidking -o yaml
```

2、查看证书详细信息
```
openssl x509 -in file-path.crt -text -noout
```

# secret for registry
1、创建registry secret
```
kubectl create secret docker-registry private-reg-cred --docker-username=dock_user --docker-password=dock_password --docker-server=myprivateregistry.com:5000 --docker-email=dock_user@myprivateregistry.com
```

2、在pod yaml中使用secret
```
apiVersion: v1
kind: Pod
metadata:
  name: private-reg
spec:
  containers:
  - name: private-reg-container
    image: <your-private-image>
  imagePullSecrets:
  - name: private-reg-cred
```

# install weave
```
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```

# upgrade
## master
```
kubeadm upgrade plan
apt install kubeadm=1.12.0-00
kubeadm upgrade apply v1.12.0
apt install kubelet=1.12.0-00
systemctl restart kubelet
```

## node01
```
kubectl drain node01
kubectl cordon node01

apt-get install kubeadm=1.12.0-00
apt-get install kubelet=1.12.0-00
kubeadm upgrade node config --kubelet-version v1.12.0
systemctl restart kubelet

kubectl uncordon node01
```

# etcd
## backup
```
kubectl describe pod etcd-master -n kube-system

ETCDCTL_API=3 etcdctl \
--endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /tmp/snapshot-pre-boot.db
```

## restore
1、execute command
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

2、vim /etc/kubernetes/manifests/etcd.yaml
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

## status
```
HOST_1=10.240.0.17
HOST_2=10.240.0.18
HOST_3=10.240.0.19
ENDPOINTS=$HOST_1:2379,$HOST_2:2379,$HOST_3:2379
etcdctl --endpoints=$ENDPOINTS member list
etcdctl --write-out=table --endpoints=$ENDPOINTS endpoint status
etcdctl --endpoints=$ENDPOINTS endpoint health
```

# curl apiserver
```
curl -H "Authorization: Bearer $TOKEN" $APISERVER/api/v1/namespaces/default/pods/  --insecure
```

# cert transport

```
# pem to der
openssl x509 -in cert.crt -outform der -out cert.der
# der to pem
openssl x509 -in cert.crt -inform der -outform pem -out cert.pem
```

# install k8s
https://github.com/kelseyhightower/kubernetes-the-hard-way

https://github.com/mmumshad/kubernetes-the-hard-way