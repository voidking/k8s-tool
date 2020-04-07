建议：在准备CKA、以及考试前都系统做下这些考题
据说，CKA80%的考题都是相似的
考试中，英文考题是可以切换为中文显示，但可能有差异，建议对比着看

1. 考试说明

第一题

2. Set configuration context $ kubectl config use-context k8s 

Monitor the logs of Pod foobar and
Extract log lines corresponding to error file-not-found
Write them to /opt/KULM00201/foobar

Question weight 5%

第二题

3. Set configuration context $ kubectl config use-context k8s

List all PVs sorted by name saving the full kubectl output to /opt/KUCC0010/my_volumes . Use kubectl’s own functionally for sorting the output, and do not manipulate it any further.

Question weight 3%

第三题

4. Set configuration context $ kubectl config use-context k8s

Ensure a single instance of Pod nginx is running on each node of the kubernetes cluster where nginx also represents the image name which has to be used. Do no override any taints currently in place.

Use Daemonsets to complete this task and use ds.kusc00201 as Daemonset name. Question weight 3%

第四题

5. Set configuration context $ kubectl config use-context k8s 

Perform the following tasks

Add an init container to lumpy–koala (Which has been defined in spec file /opt/kucc00100/pod-spec-KUCC00100.yaml)
The init container should create an empty file named /workdir/calm.txt
If /workdir/calm.txt is not detected, the Pod should exit
Once the spec file has been updated with the init container definition, the Pod should be created.

Question weight 7%

第五题

6. Set configuration context $ kubectl config use-context k8s

Create a pod named kucc4 with a single container for each of the following images running inside (there may be between 1 and 4 images specified): nginx + redis + memcached + consul

Question weight: 4%

第六题

7. Set configuration context $ kubectl config use-context k8s 

Schedule a Pod as follows:

Name: nginx-kusc00101
Image: nginx
Node selector: disk=ssd 

Question weight: 2%

第七题

8. Set configuration context $ kubectl config use-context k8s 

Create a deployment as follows

Name: nginx-app
Using container nginx with version 1.10.2-alpine
The deployment should contain 3 replicas

Next, deploy the app with new version 1.13.0-alpine by performing a rolling update and record that update.

Finally, rollback that update to the previous version 1.10.2-alpine 

Question weight: 4%

第八题

9. Set configuration context $ kubectl config use-context k8s

Create and configure the service front-end-service so it’s accessible through NodePort and routes to the existing pod named front-end

Question weight: 4%

第九题

10. Set configuration context $ kubectl config use-context k8s 

Create a Pod as follows:

Name: jenkins
Using image: jenkins
In a new Kubenetes namespace named website-frontend 
Question weight 3%

第十题

11. Set configuration context $ kubectl config use-context k8s 

Create a deployment spec file that will:

Launch 7 replicas of the redis image with the label: app_env_stage=dev
Deployment name: kual00201

Save a copy of this spec file to /opt/KUAL00201/deploy_spec.yaml (or .json)

When you are done, clean up (delete) any new k8s API objects that you produced during this task

Question weight: 3%

第十一题

12. Set configuration context $ kubectl config use-context k8s

Create a file /opt/KUCC00302/kucc00302.txt that lists all pods that implement Service foo in Namespace production.

The format of the file should be one pod name per line.

Question weight: 3%

第十二题

13. Set configuration context $ kubectl config use-context k8s 

Create a Kubernetes Secret as follows:

Name: super-secret
Credential: alice  or username:bob 

Create a Pod named pod-secrets-via-file using the redis image which mounts a secret named super-secret at /secrets

Create a second Pod named pod-secrets-via-env using the redis image, which exports credential as TOPSECRET

Question weight: 9%

第十三题

14. Set configuration context $ kubectl config use-context k8s 

Create a pad as follows:

Name: non-persistent-redis
Container image: redis
Named-volume with name: cache-control
Mount path: /data/redis

It should launch in the pre-prod namespace and the volume MUST NOT be persistent.

Question weight: 4%

第十四题

15. Set configuration context $ kubectl config use-context k8s 

Scale the deployment webserver to 6 pods

Question weight: 1%

第十五题

16. Set configuration context $ kubectl config use-context k8s

Check to see how many nodes are ready (not including nodes tainted NoSchedule) and write the number to /opt/nodenum

Question weight: 2%

第十六题

17. Set configuration context $ kubectl config use-context k8s

From the Pod label name=cpu-utilizer, find pods running high CPU workloads and write the name of the Pod consuming most CPU to the file /opt/cpu.txt (which already exists)

Question weight: 2%

第十七题

18. Set configuration context $ kubectl config use-context k8s 

Create a deployment as follows

Name: nginx-dns
Exposed via a service: nginx-dns
Ensure that the service & pod are accessible via their respective DNS records
The container(s) within any Pod(s) running as a part of this deployment should use the nginx image

Next, use the utility nslookup to look up the DNS records of the service & pod and write the output to /opt/service.dns and /opt/pod.dns respectively.

Ensure you use the busybox:1.28 image(or earlier) for any testing, an the latest release has an unpstream bug which impacts thd use of nslookup.

Question weight: 7%

第十八题

19. No configuration context change required for this item

Create a snapshot of the etcd instance running at https://127.0.0.1:2379 saving the snapshot to the file path /data/backup/etcd-snapshot.db

The etcd instance is running etcd version 3.1.10

The following TLS certificates/key are supplied for connecting to the server with etcdctl

CA certificate: /opt/KUCM00302/ca.crt
Client certificate: /opt/KUCM00302/etcd-client.crt
Clientkey:/opt/KUCM00302/etcd-client.key 

Question weight: 7%

第十九题

20. Set configuration context $ kubectl config use-context ek8s

Set the node labelled with name=ek8s-node-1 as unavailable and reschedule all the pods running on it.

Question weight: 4%

第二十题

21. Set configuration context $ kubectl config use-context wk8s

A Kubernetes worker node, labelled with name=wk8s-node-0 is in state NotReady . Investigate why this is the case, and perform any appropriate steps to bring the node to a Ready state, ensuring that any changes are made permanent.

Hints:

You can ssh to the failed node using $ ssh wk8s-node-0
You can assume elevated privileges on the node with the following command $ sudo -i Question weight: 4%

第二十一题

22. Set configuration context $ kubectl config use-context wk8s

Configure the kubelet systemd managed service, on the node labelled with name=wk8s-node-1, to launch a Pod containing a single container of image nginx named myservice automatically. Any spec files required should be placed in the /etc/kubernetes/manifests directory on the node.

Hints:

You can ssh to the failed node using $ ssh wk8s-node-1
You can assume elevated privileges on the node with the following command $ sudo -i Question weight: 4%

第二十二题

23. Set configuration context $ kubectl config use-context ik8s

In this task, you will configure a new Node, ik8s-node-0, to join a Kubernetes cluster as follows:

Configure kubelet for automatic certificate rotation and ensure that both server and client CSRs are automatically approved and signed as appropnate via the use of RBAC.
Ensure that the appropriate cluster-info ConfigMap is created and configured appropriately in the correct namespace so that future Nodes can easily join the cluster
Your bootstrap kubeconfig should be created on the new Node at /etc/kubernetes/bootstrap-kubelet.conf (do not remove this file once your Node has successfully joined the cluster)
The appropriate cluster-wide CA certificate is located on the Node at /etc/kubernetes/pki/ca.crt . You should ensure that any automatically issued certificates are installed to the node at /var/lib/kubelet/pki and that the kubeconfig file for kubelet will be rendered at /etc/kubernetes/kubelet.conf upon successful bootstrapping
Use an additional group for bootstrapping Nodes attempting to join the cluster which should be called system:bootstrappers:cka:default-node-token
Solution should start automatically on boot, with the systemd service unit file for kubelet available at /etc/systemd/system/kubelet.service

To test your solution, create the appropriate resources from the spec file located at /opt/…./kube-flannel.yaml This will create the necessary supporting resources as well as the kube-flannel -ds DaemonSet . You should ensure that this DaemonSet is correctly deployed to the single node in the cluster.

Hints:

kubelet is not configured or running on ik8s-master-0 for this task, and you should not attempt to configure it.
You will make use of TLS bootstrapping to complete this task.
You can obtain the IP address of the Kubernetes API server via the following command $ ssh ik8s-node-0 getent hosts ik8s-master-0
The API server is listening on the usual port, 6443/tcp, and will only server TLS requests
The kubelet binary is already installed on ik8s-node-0 at /usr/bin/kubelet . You will not need to deploy kube-proxy to the cluster during this task.
You can ssh to the new worker node using $ ssh ik8s-node-0
You can ssh to the master node with the following command $ ssh ik8s-master-0
No further configuration of control plane services running on ik8s-master-0 is required
You can assume elevated privileges on both nodes with the following command $ sudo -i
Docker is already installed and running on ik8s-node-0

Question weight: 8%

第二十三题

24. Set configuration context $ kubectl config use-context bk8s

Given a partially-functioning Kubenetes cluster, identify symptoms of failure on the cluster. Determine the node, the failing service and take actions to bring up the failed service and restore the health of the cluster. Ensure that any changes are made permanently.

The worker node in this cluster is labelled with name=bk8s-node-0 Hints:

You can ssh to the relevant nodes using $ ssh $(NODE) where $(NODE) is one of bk8s-master-0 or bk8s-node-0
You can assume elevated privileges on any node in the cluster with the following command$ sudo -i

Question weight: 4%

第二十四题

25. Set configuration context $ kubectl config use-context hk8s

Creae a persistent volume with name app-config of capacity 1Gi and access mode ReadWriteOnce. The type of volume is hostPath and its location is /srv/app-config

Question weight: 3%