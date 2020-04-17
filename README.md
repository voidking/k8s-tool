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

# 创建用户并授权
1、生成证书
```
openssl genrsa -out jane.key 2048
openssl req -new -key jane.key -subj  "/CN=jane" -out jane.csr
cat jane.csr | base64
```

2、签名
```
# edit jane-csr.yaml
kubectl apply -f jane-csr.yaml
kubectl get csr 
kubectl certificate approve jane
kubectl get csr jane -o yaml
```

3、创建角色，绑定角色
```
kubectl create role --help
kubectl create role developer --resource=pods --verb=list,create
kubectl create rolebinding dev-user-binding --role=developer --user=jane

# or edit developer-role.yaml
kubectl apply -f developer-role.yaml
```

4、权限验证
```
kubectl auth can-i list pods --as jane
kubectl get pods --as jane
```

5、生成kubeconfig
```
kubectl config view
cat .kube/config | grep certificate-authority-data | awk '{print $2}' | base64 --decode > ca.crt

kubectl config set-cluster kubernetes \
--server="https://172.17.0.69:6443" \
--certificate-authority=/root/ca.crt \
--embed-certs=true \
--kubeconfig=jane.kubeconfig

kubectl config set-credentials jane \
--client-certificate=/root/jane.crt \
--client-key=/root/jane.key \
--embed-certs=true \
--kubeconfig=jane.kubeconfig

kubectl config set-context jane@kubernetes \
--cluster=kubernetes \
--user=jane \
--namespace=default \
--kubeconfig=jane.kubeconfig
```

6、使用新的kubeconfig
```
cat jane.kubeconfig
kubectl config view --kubeconfig jane.kubeconfig
export KUBECONFIG=/root/jane.kubeconfig
kubectl config use-context jane@kubernetes --kubeconfig=jane.kubeconfig
kubectl get pods
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
# 查看pem证书
openssl x509 -in cert.pem -text -noout

# 查看der证书
openssl x509 -in cert.der -inform der -text -noout

# pem to der
openssl x509 -in cert.crt -outform der -out cert.der

# der to pem
openssl x509 -in cert.crt -inform der -outform pem -out cert.pem
```

# install k8s
https://github.com/kelseyhightower/kubernetes-the-hard-way

https://github.com/mmumshad/kubernetes-the-hard-way