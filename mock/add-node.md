Set configuration context $ kubectl config use-context ik8s
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