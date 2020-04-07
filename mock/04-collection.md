
Questions are not from any actual exam!!!  


Q: Create a secret that has the following username password data:
username=missawesome
password=123kube321
Create a pod running nginx that has access to those data items in a volume mount path at /tmp/secret-volume
log into the nginx pod you created and list the items and cat the output of the data items to a file "credentials.txt"

echo -n 123kube321 | base64
MTIza3ViZTMyMQ==

kubectl create secret generic test-secret --from-literal=username=missawesome --from-literal=password=MTIza3ViZTMyMQ== -o yaml --dry-run > test-secret.yaml



apiVersion: v1
data:
  username: missawesome
  password: MTIza3ViZTMyMQ==
kind: Secret
metadata:
  creationTimestamp: null
  name: test-secret

## create the secret, then create the pod with volume reference to it:

apiVersion: v1
kind: Pod 
metadata:
  creationTimestamp: null
  labels:
    run: secret-pod
  name: secret-pod
spec:
      containers:
      - image: nginx
        name: secret-pod
        volumeMounts:
        - name: secret-volume
          mountPath: /tmp/secret-volume
        resources: {}
      volumes:
      - name: secret-volume
        secret:
          secretName: test-secret
status: {}

### go into the pod, then list the contents of /tmp/secret-volume

kubectl exec -it secret-pod /bin/bash





Q:  Create a job that calculates pi to 2000 decimal points using the container with the image named perl
and the following commands issued to the container:  ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
Once the job has completed, check the logs to and export the result to pi-result.txt.

Solution:

kc job pi2000 --image=perl -o yaml --dry-run > pi2000.yaml

### edit the file, edit the name, remove any ID references and include the command argument under container spec.

        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]


aapiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  name: pi2000
spec:
  template:
    metadata:
      creationTimestamp: null
    spec:
      containers:
      - image: perl
        name: pi2000
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
        resources: {}
      restartPolicy: Never
status: {}


kc -f pi2000.yaml

### get the output from the logs and export them to text file

gl pi2000-xvrpt > pi-result.txt


 
Q. Create a yaml file called nginx-deploy.yaml for a deployment of three replicas of nginx, listening on the container's port 80. 
They should have the labels role=webserver and app=nginx. The deployment should be named nginx-deploy.
Expose the deployment with a load balancer and use a curl statement on the IP address of the load balancer 
to export the output to a file titled output.txt.


Solution:

sudo kubectl run nginx-deploy --labels="role=webserver,app=nginx" --image=nginx --replicas=3 --port=80 -o yaml > nginx-deployment.yaml

### expose the deployment with a loadbalancer type, call it nginx-service

kubectl expose deployment nginx-deploy --type=LoadBalancer --name=nginx-service

### use a curl statement that connects to the IP endpoint of the nginx-service and save the output to a file called output.txt

curl IP > output.txt




Q.  Scale the deployment you just made down to 2 replicas

Solution:

sudo kubectl scale deployment nginx-deploy --replicas=2
 
 
 
Q. Create a pod called "haz-docs" with an nginx image listening on port 80. 
Attach the pod to emptyDir storage, mounted to /tmp in the container. 
Connect to the pod and create a file with zero bytes in the /tmp directory called my-doc.txt. 
 
Solution:

apiVersion: apps/v1beta1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    run: haz-docs
  name: haz-docs
spec:
  replicas: 1
  selector:
    matchLabels:
      run: haz-docs
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: haz-docs
    spec:
      containers:
      - image: nginx
        name: haz-docs
        volumeMounts:
        - mountPath: /tmp
          name: tmpvolume
        ports:
        - containerPort: 80
        resources: {}
      volumes:
      - name: tmpvolume
        emptyDir: {}
status: {}


sudo kubectl exec -it haz-docs-5b49cb4d87-2lm5g /bin/bash

root@haz-docs-5b49cb4d87-2lm5g:/# cd /tmp/
root@haz-docs-5b49cb4d87-2lm5g:/tmp# touch my-doc.txt
root@haz-docs-5b49cb4d87-2lm5g:/tmp# ls 
my-doc.txt

 
Q. Label the worker node of your cluster with rack=qa.

Solution:

sudo kubectl label node texasdave2c.mylabserver.com rack=qa
 
 
Q.  Create a file called counter.yaml in your home directory and paste the following yaml into it:

Solution:

apiVersion: v1
kind: Pod
metadata:
  name: counter
spec:
  containers:
  - name: count
    image: busybox
    args: [/bin/sh, -c, 'i=0; while true; do echo "$i: $(date)"; i=$((i+1)); sleep 1; done']

Start this pod. 
Once its logs exceed a count of 20 (no need to be precise — any time after it has reached 20 is fine), 
save the logs into a file in your home directory called count.result.txt. 
 

Q.
Create a new namespace called "cloud9". 
Create a pod running k8s.gcr.io/liveness with a liveliness probe that uses httpGet to 
probe an endpoint path located at /cloud-health on port 8080.  
The httpHeaders are name=Custom-Header and value=Awesome. 
The initial delay is 3 seconds and the period is 3.


 
Q. Create a deployment with two replicas of nginx:1.7.9. 
The container listens on port 80. It should be named "web-dep" and be labeled 
with tier=frontend with an annotation of AppVersion=3.4. 
The containers must be running with the UID of 1000.

Solution:

kubectl run web-dep --labels="tier=frontend" --image=nginx --replicas=2 --port=80 -o yaml > web-dep.yaml

### edit the page to add the annotation in the metadata section:

apiVersion: apps/v1beta1
kind: Deployment
metadata:
  annotations:
    AppVersion: "3.4"
  creationTimestamp: 2019-03-02T18:17:19Z
  generation: 1
  labels:
    tier: frontend

### output the description of the deployment to the file web-dep-description.txt

sudo kubectl describe deploy/web-dep > web-dep-description.txt
 
 
Q. Upgrade the image in use by the web-dep deployment to nginx:1.9.

Solution:

kubectl --record deployment/web-dep set image deployment/web-dep nginx=nginx:1.9.1
 
 
Q. Roll the image in use by the web-dep deployment to the previous version. 
Do not set the version number of the image explicitly for this command.

kubectl rollout history deployment/web-dep

kubectl rollout undo deployment/web-dep
 

 
Q. Expose the web-dep deployment as a service using a NodePort.

Solution:

kubectl expose deployment/web-dep --type=NodePort
 
 
Q.  Configure a DaemonSet to run the image k8s.gcr.io/pause:2.0 in the cluster.
 
Solution:

kubectl run testds --image=k8s.gcr.io/pause:2.0 -o yaml > testds.yaml

then edited it as Daemonset to get it running, you don't do replicas in a daemonset, it runs on all nodes
 
 
 
Q.  Configure the cluster to use 8.8.8.8 and 8.8.4.4 as upstream DNS servers.

Solution:

The answer can be found at:  https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/
 
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-dns
  namespace: kube-system
data:
  stubDomains: |
    {"acme.local": ["1.2.3.4"]}
  upstreamNameservers: |
    ["8.8.8.8", "8.8.4.4"]
 
 
 
Q.  An app inside a container needs the IP address of the web-dep endpoint to be passed to it as an 
environment variable called "ULTIMA". Save the yaml as env-ultima.yaml

Solution:

### get the IP address of the web-dep service

sudo kubectl get svc


apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: ultima-dep
  namespace: default
spec:
  selector:
    matchLabels:
      app: ultima-app
  template:
    metadata:
      labels:
        app: ultima-app
    spec:
      containers:
      - name: pause-pod
        image: k8s.gcr.io/pause:2.0
        env:
        - name: ULTIMA
          value: 55.55.58.23

kc -f env-ultima.yaml
 
Q.  Figure out a way to create a pod with 3 replicas using the the nginx container that can have pods deployed 
on a worker node and the master node if needed.

Solution:

sudo kubectl get nodes

sudo kubectl describe node MASTERNODE

### notice the taint on the master node:

Taints:             node-role.kubernetes.io/master:NoSchedule

### add the toleration to the yaml file

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
      tolerations:
      - key: "node-role.kubernetes.io/master"
        operator: "Equal"
        effect: "NoSchedule"
 

 
Q.  Copy all Kubernetes scheduler logs into a logs directory in your home directory.

Solution:

gp --namespace=kube-system

gl --namespace=kube-system kube-scheduler-ubuntu.local > test-log.txt



Q.  Run the pod below until the counter in exceeds 30, export the log file into a file called counter-log.txt.

Solution:

apiVersion: v1
kind: Pod
metadata:
  name: counter
spec:
  containers:
  - name: count
    image: busybox
    args: [/bin/sh, -c, 'i=0; while true; do echo "$i: $(date)"; echo "$(date) - File - $i" >> /var/www/countlog; i=$((i+1)); sleep 3; done']
 
 
gl POD > counter-log.txt
 
 
 
Q.  Create a yaml file called db-secret.yaml for a secret called db-user-pass.
The secret should have two fields: a username and password. 
The username should be "superadmin" and the password should be "imamazing".

Solution:

echo -n 'superadmin' > ./username.txt
echo -n 'imamazing' > ./password.txt
                 
kc secret generic db-user-pass --from-file=./username.txt --from-file=./password.txt -o yaml > db-secret.yaml

apiVersion: v1
data:
  password.txt: aWhlYXJ0a2l0dGVucw==
  username.txt: YWRtaW4=
kind: Secret
metadata:
  creationTimestamp: 2019-03-03T00:21:16Z
  name: db-user-pass
  namespace: default
  resourceVersion: "30182"
  selfLink: /api/v1/namespaces/default/secrets/db-user-pass
  uid: 42b979da-3d4a-11e9-8f41-06f514f6b3f0
type: Opaque


Q.
Create a ConfigMap called web-config that contains the following two entries:
'web_port' set to 'localhost:8080'
'external_url' set to 'reddit.com'
Run a pod called web-config-pod running nginx, expose the configmap settings as environment variables inside the nginx container.

### this has to be done in several steps, first create configmap from literals on command line

sudo kubectl create configmap test-cm --from-literal=web_port='localhost:8080' --from-literal=external_url='reddit.com'

### double check the configmap

sudo kubectl describe cm test-cm

Name:         test-cm
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
external_url:
----
reddit.com
web_port:
----
localhost:8080
Events:  <none>


### create the pod deployment yaml and then edit the file

sudo kubectl run web-config-pod --image=nginx -o yaml > web-config-pod.yaml

## edit the file:

   spec:
      containers:
      - image: nginx
        env:
         - name: WEB_PORT
           valueFrom:
             configMapKeyRef:
               name: test-cm
               key: web_port
         - name: EXTERNAL_URL
           valueFrom:
             configMapKeyRef:
               name: test-cm
               key: external_url
        imagePullPolicy: Always
        name: web-config-pod
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File


## delete the UID references in the file
## delete and then reinstall deployment
vi web-config-pod.yaml
sudo kubectl delete deploy/web-config-pod
sudo kubectl create -f web-config-pod.yaml

## get env vars from nginx pod:

sudo kubectl exec nginx-deploy-868c8d4b79-czc2j env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=nginx-deploy-868c8d4b79-czc2j
EXTERNAL_URL=reddit.com
WEB_PORT=localhost:8080
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
NGINX_VERSION=1.15.9-1~stretch
NJS_VERSION=1.15.9.0.2.8-1~stretch
HOME=/root



Q.  Create a namespace called awsdb in your cluster.  
Create a pod called db-deploy that has one container running mysql image, and one container running nginx:1.7.9
In the same namespace create a pod called nginx-deploy with a single container running the image nginx:1.9.1.  
Export the output of kubectl get pods for the awsdb namespace into a file called "pod-list.txt"

## mysql requires a pv and pvc with the yaml to create them found here:
https://kubernetes.io/docs/tasks/run-application/run-single-instance-stateful-application/#deploy-mysql

## create the deployment yaml
## make sure the workers have the correct file host paths /mnt/data



Q.
Create a pod running k8s.gcr.io/liveness with the following arguments:

    args:
    - /bin/sh
    - -c
    - touch /tmp/healthy; sleep 30; rm -rf /tmp/healthy; sleep 600

and the following commands:

        command:
        - cat
        - /tmp/healthy

with an initial delay of 5 seconds and a probe period of 5 seconds

Output the events of the description showing that the container started and then the health check failed.


Q. This requires having a cluster with 2 worker nodes
Safely remove one node from the cluster.  Print the output of the node status into a file "worker-removed.txt".
Reboot the worker node.  
Print the output of node status showing worker unable to be scheduled to "rebooted-worker.txt"
Now bring the node back into the cluster and schedule several nginx pods to it, print the get pods wide output showing at least 
one pod is on the node you rebooted.



Q. Create a deployment running nginx, mount a volume called "hostvolume" with a container volume mount at /tmp 
and mounted to the host at /data.  If the directory isn't there make sure it is created in the pod spec at run time.
Go into the container and create an empty file called "my-doc.txt" inside the /tmp directory.  On the worker node 
that it was scheduled to, go into the /data directory and output a list of the contents to list-output.txt showing 
the file exists.

apiVersion: apps/v1beta1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    run: haz-docs2
  name: haz-docs2
spec:
  replicas: 1
  selector:
    matchLabels:
      run: haz-docs2
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: haz-docs2
    spec:
      containers:
      - image: nginx
        name: haz-docs2
        volumeMounts:
        - mountPath: /tmp
          name: hostvolume
        ports:
        - containerPort: 80
        resources: {}
      volumes:
      - name: hostvolume
        hostPath: 
          path: /data
          type: DirectoryOrCreate
status: {}



### interesting way to quickly spin up busy box pod and run shell temporarily 
kubectl run -i --tty --image busybox dns-test --restart=Never --rm /bin/sh 

### useful tool sorting output from get objects:


### to get a list of any of the jsonpath objects, just do a kubectl get pods -o json and it will
list them like this, these are the json path items you can get under status:


                }
            }
        ],
        "hostIP": "192.168.0.3",
        "phase": "Running",
        "podIP": "10.244.2.33",
        "qosClass": "BestEffort",
        "startTime": "2019-03-09T22:52:09Z"
    }


use status.phase as example:  kubectl get pods --sort-by=.status.phase


kubectl get pvc --sort-by=.spec.resources.requests.storage

kubectl get namespaces --sort-by=.metadata.name

https://elastisys.com/2018/12/10/backup-kubernetes-how-and-why/

