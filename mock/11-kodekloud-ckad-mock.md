# Lightning Lab - 1
## Q1
Create a Persistent Volume called log-volume. It should make use of a storage class name manual. It should use RWX as the access mode and have a size of 1Gi. The volume should use the hostPath /opt/volume/nginx

Next, create a PVC called log-claim requesting a minimum of 200Mi of storage. This PVC should bind to log-volume.

Mount this in a pod called logger at the location /var/www/nginx. This pod should use the image nginx:alpine.

Tips:
log-volume created with correct parameters?

## Q2
We have deployed a new pod called secure-pod and a service called secure-service. Incoming or Outgoing connections to this pod are not working.
Troubleshoot why this is happening.

Make sure that incoming connection from the pod webapp-color are successful.


Important: Don't delete any current objects deployed.

Tips:
Important: Don't Alter Existing Objects!
Connectivity working?

## Q3
Create a pod called time-check in the dvl1987 namespace. This pod should run a container called time-check that uses the busybox image.
1. Create a config map called time-config with the data TIME_FREQ=10 in the same namespace.
2. The time-check container should run the command: while true; do date; sleep $TIME_FREQ;done and write the result to the location /opt/time/time-check.log.
3. The path /opt/time on the pod should mount a volume that lasts the lifetime of this pod.

Tips:
Pod `time-check` configured correctly?

## Q4
Create a new deployment called nginx-deploy, with one signle container called nginx, image nginx:1.16 and 4 replicas. The deployment should use RollingUpdate strategy with maxSurge=1, and maxUnavailable=2.
Next upgrade the deployment to version 1.17 using rolling update.
Finally, once all pods are updated, undo the update and go back to the previous version.

Tips:
Deployment created correctly?
Was the deployment created with nginx:1.16?
Was it upgraded to 1.17?
Deployment rolled back to 1.16?

## Q5
Create a redis deployment with the following parameters:
Name of the deployment should be redis using the redis:alpine image. It should have exactly 1 replica.
The container should request for .2 CPU. It should use the label app=redis.
It should mount exactly 2 volumes:
Make sure that the pod is scheduled on master node.


a. An Empty directory volume called data at path /redis-master-data.
b. A configmap volume called redis-config at path /redis-master.
c.The container should expose the port 6379.


The configmap has already been created.

Tips:
Deployment created correctly?

# Lightning Lab - 2
## Q1
We have deployed a few pods in this cluster in various namespaces. Inspect them and identify the pod which is not in a Ready state. Troubleshoot and fix the issue.

Next, add a check to restart the container on the same pod if the command ls /var/www/html/file_check fails. This check should start after a delay of 10 seconds and run every 60 seconds.


You may delete and recreate the object. Ignore the warnings from the probe.

Tips:
Task completed correctly?

## Q2
Create a cronjob called dice that runs every one minute. Use the Pod template located at /root/throw-a-dice. The image throw-dice randomly returns a value between 1 and 6. The result of 6 is considered success and all others are failure.
The job should be non-parallel and complete the task once. Use a backoffLimit of 25.
If the task is not completed within 20 seconds the job should fail and pods should be terminated.


You don't have to wait for the job completion. As long as the cronjob has been created as per the requirements.

Tips:
Cronjob created correctly?

## Q3
Create a pod called my-busybox in the dev2406 namespace using the busybox image. The container should be called secret and should sleep for 3600 seconds.

The container should mount a read-only secret volume called secret-volume at the path /etc/secret-volume. The secret being mounted has already been created for you and is called dotfile-secret.

Make sure that the pod is scheduled on master and no other node in the cluster.

Tips:
Pod created correctly?

## Q4
Create a single ingress resource called ingress-vh-routing. The resource should route HTTP traffic to multiple hostnames as specified below:

The service video-service should be accessible on http://watch.ecom-store.com:30093/video

The service apparels-service should be accessible on http://apparels.ecom-store.com:30093/wear


Here 30093 is the port used by the Ingress Controller

Tips:
Ingress resource configured correctly?

## Q5
A pod called dev-pod-dind-878516 has been deployed in the default namespace. Inspect the logs for the container called log-x and redirect the warnings to /opt/dind-878516_logs.txt on the master node

Tips:
Redirect warnings to file



# Mock Exam - 1
## Q1
Deploy a pod named nginx-448839 using the nginx:alpine image.


Once done, click on the Next Question button in the top right corner of this panel. You may navigate back and forth freely between all questions. Once done with all questions, click on End Exam. Your work will be validated at the end and score shown. Good Luck!

Tips:
Name: nginx-448839
Image: nginx:alpine

## Q2
Create a namespace named apx-z993845

Tips:
Namespace: apx-z993845

## Q3
Create a new Deployment named httpd-frontend with 3 replicas using image httpd:2.4-alpine

Tips:
Name: httpd-frontend
Replicas: 3
Image: httpd:2.4-alpine

## Q4
Deploy a messaging pod using the redis:alpine image with the labels set to tier=msg.

Tips:
Pod Name: messaging
Image: redis:alpine
Labels: tier=msg

## Q5
A replicaset rs-d33393 is created. However the pods are not coming up. Identify and fix the issue.

Once fixed, ensure the ReplicaSet has 4 Ready replicas.

Tips:
Replicas: 4

## Q6
Create a service messaging-service to expose the redis deployment in the marketing namespace within the cluster on port 6379.

Use imperative commands

Tips:
Service: messaging-service
Port: 6379
Use the right type of Service
Use the right labels

## Q7
Update the environment variable on the pod webapp-color to use a green background

Tips:
Pod Name: webapp-color
Label Name: webapp-color
Env: APP_COLOR=green

## Q8
Create a new ConfigMap named cm-3392845. Use the spec given on the right.

Tips:
ConfigName Name: cm-3392845
Data: DB_NAME=SQL3322
Data: DB_HOST=sql322.mycompany.com
Data: DB_PORT=3306

## Q9
Create a new Secret named db-secret-xxdf with the data given(on the right).

Tips:
Secret Name: db-secret-xxdf
Secret 1: DB_Host=sql01
Secret 2: DB_User=root
Secret 3: DB_Password=password123

## Q10
Update pod app-sec-kff3345 to run as Root user and with the SYS_TIME capability.

Tips:
Pod Name: app-sec-kff3345
Image Name: ubuntu
SecurityContext: Capability SYS_TIME

## Q11
Export the logs of the e-com-1123 pod to the file /opt/outputs/e-com-1123.logs

It is in a different namespace. Identify the namespace first.

Tips:
Task Completed

## Q12
Create a Persistent Volume with the given specification.

Tips:
Volume Name: pv-analytics
Storage: 100Mi
Access modes: ReadWriteMany
Host Path: /pv/data-analytics

## Q13
Create a redis deployment using the image redis:alpine with 1 replica and label app=redis. Expose it via a ClusterIP service called redis on port 6379. Create a new Ingress Type NetworkPolicy called redis-access which allows only the pods with label access=redis to access the deployment.

Tips:
Image: redis:alpine
Deployment created correctly?
Service created correctly?
Network Policy allows the correct pods?
Network Policy applied on the correct pods?

## Q14
Create a Pod called sega with two containers:

Container 1: Name tails with image busybox and command: sleep 3600.
Container 2: Name sonic with image nginx and Environment variable: NGINX_PORT with the value 8080.

Tips:
Container Sonic has the correct ENV name
Container Sonic has the correct ENV value
Container tails created correctly?

# Mock Exam - 2
## Q1
Create a deployment called my-webapp with image: nginx, label tier:frontend and 2 replicas. Expose the deployment as a NodePort service with name front-end-service , port: 80 and NodePort: 30083

Tips:
Deployment my-webapp created?
image: nginx
Replicas = 2 ?
service front-end-service created?
service Type created correctly?
Correct node Port used?

## Q2
Add a taint to the node node01 of the cluster. Use the specification below:

key:app_type, value:alpha and effect:NoSchedule
Create a pod called alpha, image:redis with toleration to node01

Tips:
node01 with the correct taint?
Pod alpha has the correct toleration?

## Q3
Apply a label app_type=beta to node node02. Create a new deployment called beta-apps with image:nginx and replicas:3. Set Node Affinity to the deployment to place the PODs on node02 only

NodeAffinity: requiredDuringSchedulingIgnoredDuringExecution

Tips:
node02 has the correct labels?
Deployment beta-apps: NodeAffinity set to requiredDuringSchedulingIgnoredDuringExecution ?
Deployment beta-apps has correct Key for NodeAffinity?
Deployment beta-apps has correct Value for NodeAffinity?
Deployment beta-apps has pods running only on node02?
Deployment beta-apps has 3 pods running?

## Q4
Create a new Ingress Resource for the service: my-video-service to be made available at the URL: http://ckad-mock-exam-solution.com:30093/video.

Create an ingress resource with host: ckad-mock-exam-solution.com
path:/video
Once set up, curl test of the URL from the nodes should be successful / HTTP 200

Tips:
Ingress resource configured correct and accessible via http://ckad-mock-exam-solution.com:30093/video

## Q5
We have deployed a new pod called pod-with-rprobe. This Pod has an initial delay before it is Ready. Update the newly created pod pod-with-rprobe with a readinessProbe using the given spec

httpGet path: /ready
httpGet port: 8080

Tips:
readinessProbe with the correct httpGet path?
readinessProbe with the correct httpGet port?

## Q6
Create a new pod called nginx1401 in the default namespace with the image nginx. Add a livenessProbe to the container to restart it if the command ls /var/www/html/probe fails. This check should start after a delay of 10 seconds and run every 60 seconds.

You may delete and recreate the object. Ignore the warnings from the probe.

Tips:
Pod created correctly with the livenessProbe?

## Q7
Create a job called whalesay with image docker/whalesay and command "cowsay I am going to ace CKAD!".
completions: 10
backoffLimit: 6
restartPolicy: Never

This simple job runs the popular cowsay game that was modifed by docker…

Tips:
Job "whalsay" uses correct image?
Job "whalesay" configured with completions = 10?
Job "whalesay" with backoffLimit = 6
Job run's the command "cowsay I am going to ace CKAD!"?
Job "whalesay" completed successfully?

## Q8
Create a pod called multi-pod with two containers.
Container 1: name: jupiter, image: nginx
Container 2: europa, image: busybox
command: sleep 4800

Environment Variables: Container 1: type: planet

Container 2: type: moon

Tips:
Pod Name: multi-pod
Container 1: jupiter
Container 2: europa
Container europa commands set correctly?
Container 1 Environment Value Set
Container 2 Environment Value Set

## Q9
Create a PersistentVolume called custom-volume with size: 50MiB reclaim policy:retain, Access Modes: ReadWriteMany and hostPath: /opt/data

Tips:
PV custom-volume created?
custom-volume uses the correct access mode?
PV custom-volume has the correct storage capacity?
PV custom-volume has the correct host path?