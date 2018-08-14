# Certified Kubernetes Administrator (CKA)

## CentOS 7 - Install cluster from scratch manually

### On the Master

```bash
# Become root
sudo su

# Turn swap off
swapoff -a
vim /etc/fstab # Comment /swap line

# Update the system
yum update -y

# Install Docker
yum intall yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce -y
usermod -aG docker $USER
systemctl enable docker
systemctl start docker

# Add K8S repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Disable SELinux
setenforce 0
vim /etc/selinux/config # Change to SELINUX=permissive

# Install K8S pieces
yum install kubelet kubeadm kubectl -y
systemctl enable kubelet
systemctl start kubelet

# Change networking settings
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Initialize network
kubeadm init --pod-network-cidr=10.244.0.0/16 # Keep the "join" command handy

# Become normal user
exit

# Config file in the home dir
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Configure the master networking with CNI (Cluster network interface) - Flannel:
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml

# See if the Flannel is being used
kubectl get pods --all-namespaces
```

### On the Nodes

Now you can start adding nodes to the cluster. Run this on the cluster(s):

1. Do everything the same on the worker as on the master (Swap, Docker, SELinux, kubectl...) except for the `kubeadm init`.

2. Paste the "join" command copied from the master to the node(s).

Example:

    ```bash
    kubeadm join --token <12345abcde> <172.31.21.55:6443> --discovery-token-ca-cert-hash <sha256:1234567abcdef>
    ```

_Note:_ You might need IPVS (IP Virtual Server) Kernel module(s) when joining the nodes to the master.

Try the following on all of the nodes:

```bash
sudo modprobe -- ip_vs
sudo modprobe -- ip_vs_rr
sudo modprobe -- ip_vs_wrr
sudo modprobe -- ip_vs_sh
sudo modprobe -- nf_conntrack_ipv4
sudo lsmod | grep -e ipvs -e nf_conntrack_ipv4   # To check if it was successful
```

3. Check if the node has been added:

    ```bash
    kubectl get nodes
    ```

### Note: I have prepared `Vagrantfile` for this cluster

* `vagrant up` will spin up three nodes (node1,node2,node3), where node1 is the Kubernetes master.

* Ignore errors, such as `groupadd: group 'docker' already exists` and `No resources found.`.

* Pay attention to the output `node1:   kubeadm join ...` stdout during node1 provisioning.

* Paste the previous `sudo kubeadm join ...` command in node2, node3 - use `vagrant ssh node2`, `vagrant ssh node3`.

* Go back to master - `vagrant ssh node1` and check this command `kubectl get nodes`, you should see similar stdout:

```bash
[vagrant@node1 ~]$ kubectl get nodes
NAME      STATUS    ROLES     AGE       VERSION
node1     Ready     master    00m       v1.11.0
node2     Ready     <none>    00m       v1.11.0
node3     Ready     <none>    00m       v1.11.0
```

* You're now ready to use the cluster.

## Exam Curriculum

### Sheduling

* Use label selectors to schedule Pods. (`=`, `==`, `!=`, `in`, `notin`, `exists`)

  * `env in (prod,devel)` to select pods with the env label set to either prod or devel.

  * `env notin (prod,devel)` to select pods with the env label set to any value other than prod or devel.

  * A selector can also include multiple comma-separated criteria. Resources need to match all of them to match the selector.

  * A Pod is the scheduling unit in Kubernetes, because K8S doesn't deal with individual containers directly. It is a logical collection/group of one or more containers which are always scheduled/co-located together ON THE SAME WORKER NODE and IN THE SAME LINUX NAMESPACE.

  * A Pod is the smallest and simplest Kubernetes object. It is the unit of deployment in Kubernetes, which represents a single instance of the application. A Pod is a logical collection of one or more containers, which: Are scheduled together on the same host, share the same network namespace, mount the same external storage (volumes).

  * Labels are key-value pairs that can be attached to any Kubernetes objects (e.g. Pods). Labels are used to organize and select a subset of objects, based on the requirements in place. Many objects can have the same Label(s). Labels do not provide uniqueness to objects.

  * Labels can also be added to or modified on existing pods: `kubectl label po kubia-manual creation_method=manual`. You need `--overwrite` to change existing label.

  * To list all pods that include the env `label`, whatever it's value is: `kubectl get po -l env`. Negative label selector is recommended to be escaped (`'!env'`) - use single quotes around !env, so the bash shell doesn’t evaluate the exclamation mark.

  * You can constrain a pod to only be able to run on particular nodes or to prefer to run on particular nodes: `nodeSelector`.

  * List all pods in ps output format with more information (such as node name): `k get pods -o wide`. You can tell `kubectl` to display custom columns with the `-o custom-columns` option and sort the resource list with `--sort-by`.

* Understand the role of DaemonSets.

  * Specific type of Pod running on all nodes at all times.

  * Whenever a node is added to the cluster, a Pod from a given DaemonSet is created on it.

  * When the node dies, the respective Pods are garbage collected.

  * If a DaemonSet is deleted, all Pods it created are deleted as well.

  * DaemonSets run only a single pod replica on each node, whereas ReplicaSets scatter them around the whole cluster randomly.

  * Get DaemonSets: `kubectl get ds`

* Understand how resource limits can affect Pod scheduling.

* Understand how to run multiple schedulers and how to configure Pods to use them.

  * Scheduling = assigning pod to a node immediately (not as the term might lead you to believe it will be "schediled")

* Manually schedule a pod without a scheduler.

  * Specifying ports in the pod definition is purely informational. Omitting them has no effect on whether clients can connect to the pod through the port or not.

  * Changing the pod template is like replacing a cookie cutter with another one. It will only affect the cookies you cut out AFTERWARD and will have no effect on the ones you’ve already cut.

* Display scheduler events.

  * `kubectl explain pods`

* Know how to configure the Kubernetes scheduler.

### Logging/Monitoring

* Understand how to monitor all cluster components.

  * `Heapster` is a cluster-wide aggregator of monitoring and event data, which is natively supported on Kubernetes.

  * `Prometheus`, now part of CNCF (Cloud Native Computing Foundation), can also be used to scrape the resource usage from different Kubernetes components and objects.

* Understand how to monitor applications.

* Manage cluster component logs.

  * The most common way to collect the logs is using Elasticsearch, which uses `fluentd` with custom configuration as an agent on the nodes. fluentd is an open source data collector, which is also part of CNCF.

* Manage application logs.

### Application Lifecycle Management

* Understand Deployments and how to perform rolling updates and rollbacks.

  * Deployment objects provide declarative updates to Pods and ReplicaSets. The DeploymentController is part of the master node's controller manager, and it makes sure that the current state always matches the desired state.

  * A rollout is only triggered when we update the Pods Template for a deployment. Operations like scaling the deployment do not trigger the deployment.

  * Odd way of rolling udates when using ReplicationController: `k rolling-update app-v1 app-v2 --image=user/app:v2`.

  * Depoyment's `--record` saves the command in the revision history. The length of the revision history is limited by the `revisionHistoryLimit` property on the Deployment resource.

  * Status of the Deployment rollout: `k rollout status deployment <NAME>`. Default strategy is to perform a rolling update (the strategy is called `RollingUpdate`). The alternative is the `Recreate` strategy, which deletes all the old pods at once and then creates new ones. By default, after the rollout can’t make any progress in 10 minutes, it’s considered as failed.

  * `kubectl patch` command is useful for modifying a single property or a limited number of properties of a resource without having to edit its definition in a text editor.

  * Changing the image of the resource triggering the Depoyment update: `k set image deployment <NAME> nodejs=user/app:v2`.

  * This rolls the Deployment back to the previous revision: `kubectl rollout undo deployment <NAME>`.

  * Display Deployment revision history: `kubectl rollout history deployment <NAME>`.

  * Roll back to the first version/revision: `kubectl rollout undo deployment <NAME> --to-revision=1`.

  * Deployment can also be paused during the rollout process. This allows you to verify that everything is fine with the new version before proceeding with the rest of the rollout: `kubectl rollout pause deployment <NAME>` and then `kubectl rollout resume deployment <NAME>`.

  * `minReadySeconds` property specifies how long a newly created pod should be ready before the pod is treated as available.

* Know various ways to configure applications.

  * Defining ENVIRONMENT variable in the pod definition:

    ```yaml
    env:
      - name: INTERVAL
        value: "30"
    ```

  * Resource for storing configuration data is called a `ConfigMap`.

  * Contents of the map are passed to containers as either environment variables or as files in a volume.

  * Create ConfigMap from the CLI: `k create configmap fortune-config --from-literal=sleep-interval=25`.

  * Create ConfigMap from the coarse-grained config data: `k create configmap my-config --from-file=config-file.conf`.

  * Create ConfigMap from files in a directory: `k create configmap my-config --from-file=/path/to/dir`. Defining specific value:

    ```yaml
    valueFrom:
      configMapKeyRef:
        name: <NAME>
        key: <KEY>
    ```

  * You can expose them all as environment variables by using the `envFrom` attribute, instead of just `env`.

  * If a ConfigMap key isn’t in the proper format, it skips the entry (but it does record an event informing you it skipped it).

  * configMap volume can expose each entry of the ConfigMap as a file:

    ```yaml
    volumes:
      - name: <CONFIG>
        configMap:
          name: <NAME>
    ```

  * You can populate a configMap volume with only part of the ConfigMap’s entries. To define which entries should be exposed as files in a configMap volume, use the volume’s `items` attribute.

  * An additional `subPath` property on the `volumeMount` allows you to mount either a single file or a single directory from the volume instead of mounting the whole volume.

  * By default, the permissions on all files in a configMap volume are set to `0644`.

  * Edit the ConfigMap directly: `k edit configmap <NAME>`

* Know how to scale applications.

  * `kubectl scale deployment <NAME> --replicas=3`

* Understand the primitives necessary to create a self-healing application.

  * Generally, we don't deploy a Pod independently, as it would not be able to re-start itself, if something goes wrong. We always use controllers like ReplicationController(s) and/or ReplicaSet(s) to create and manage Pods.

  * This wil open replication controller's definition YAML in the default editor: `kubectl edit rc <NAME>`.

  * Deleting a replication controller with `--cascade=false` leaves pods unmanaged.

  * ReplicationControllers will eventually be deprecated, you should always create ReplicaSets instead of ReplicationControllers from now on.

  * ReplicaSets aren’t part of the v1 API, but belong to the apps API group and version v1beta2.

  * ReplicaSet operators: `In`, `NotIn`, `Exists`, `DoesNotExist`. If you specify multiple, all of them must match. Each expression must contain a key, an operator, and possibly (depending on the operator) a list of values.

  * To set the initial delay, add the `initialDelaySeconds` property to the liveness probe.

  * Three types of readiness probes exist: `Exec`, `HTTP GET`, `TCP socket`.

  * If you don’t add a readiness probe to your pods, they’ll become service endpoints almost immediately. Unlike liveness probes, if a container fails the readiness check, it won’t be killed or restarted. If a pod’s readiness probe fails, the pod is removed from the Endpoints object. The readiness probe is checked periodically—every 10 seconds by default.

### Cluster Maintenance

* Understand Kubernetes cluster upgrade process.

* Facilitate operating system upgrades.

* Implement backup and restore methodologies.

  * Kubernetes stores all its data in etcd under `/registry`.

  * etcd v3 is using this command instead of `ls`: `etcdctl get /registry --prefix=true`.

  * The API server stores the complete JSON representation of a resource in etcd.

### Security

* Know how to configure authentication and authorization.

  * Client Certificates
    To enable client certificate authentication, we need to reference a file containing one or more certificate authorities by passing the `--client-ca-file=SOMEFILE` option to the API server. The certificate authorities mentioned in the file would validate the client certificates presented to the API server.

  * Static Token File
    We can pass a file containing pre-defined bearer tokens with the `--token-auth-file=SOMEFILE` option to the API server. Currently, these tokens would last indefinitely, and they cannot be changed without restarting the API server.

  * Bootstrap Tokens
    This feature is currently in an alpha status, and is mostly used for bootstrapping a new Kubernetes cluster.
  
  * Static Password File
    It is similar to Static Token File. We can pass a file containing basic authentication details with the `--basic-auth-file=SOMEFILE` option. These credentials would last indefinitely, and passwords cannot be changed without restarting the API server.

  * Service Account Tokens
    This is an automatically enabled authenticator that uses signed bearer tokens to verify the requests. These tokens get attached to Pods using the ServiceAccount Admission Controller, which allows in-cluster processes to talk to the API server.

  * OpenID Connect Tokens
    OpenID Connect helps us connect with OAuth 2 providers, such as Azure Active Directory, Salesforce, Google, etc., to offload the authentication to external services.

  * Webhook Token Authentication
    With Webhook-based authentication, verification of bearer tokens can be offloaded to a remote service.

  * Keystone Password
    Keystone authentication can be enabled by passing the `--experimental-keystone-url=<AuthURL>` option to the API server, where AuthURL is the Keystone server endpoint.

  * Authenticating Proxy
    If we want to program additional authentication logic, we can use an authenticating proxy.

  At least two methods should be enabled: the service account tokens authenticator and the user authenticator.

  To enable the ABAC authorizer, we would need to start the API server with the `--authorization-mode=ABAC` and `--authorization-policy-file=PolicyFile.json`.

  Kubernetes can offer authorization decisions to some third-party services, start API server with `--authorization-webhook-config-file=SOME_FILENAME`, where SOME_FILENAME is the configuration of the remote authorization service.

  To enable the RBAC authorizer, we would need to start the API server with the `--authorization-mode=RBAC` option.

  Admission control is used to specify granular access control policies, force the policies using different admission controllers, like ResourceQuota, AlwaysAdmit, DefaultStorageClass, etc. To enable `--admission-control=NamespaceLifecycle,ResourceQuota,PodSecurityPolicy,DefaultStorageClass`.

* Understand Kubernetes security primitives.

  * To get the Secret(s): `k get secrets`.

  * Create a secret: `kubectl create secret generic my-password --from-literal=password=mysqlpassword`, another example creates secret from files: `k create secret generic my-secret --from-file=https.key --from-file=https.cert --from-file=foo`.

  * These commands do not reveal the content of the Secret (Opaque): `kubectl get secret my-password`, `kubectl describe secret my-password`. Contents of a Secret’s entries are shown as Base64-encoded strings, whereas those of a ConfigMap are shown in clear text.

  * You can also create Secret using YAML, but it has to be in base64.

  * Maximum size of a Secret is limited to 1MB.

  * `stringData` can be used for non-binary Secret data.

  * Secret volume in the pod example:

    ```yaml
    - name: certs
      secret:
        secretName: my-secret
    ```

  * Secret as ENVIRONMENT variable - referring to a Secret by using `secretKeyRef` instead of `configMapKeyRef`. To be safe, ALWAYS use secret volumes for exposing Secrets.

* Know to configure network policies.

* Create and manage TLS certificates for cluster components.

  * Creating TLS certificate for Ingress: `openssl genrsa -out tls.key 2048 ; openssl req -new -x509 -key tls.key -out tls.cert -days 360 -subj  /CN=kubia.example.com`, then you create the Secret from the two files like this: `kubectl create secret tls tls-secret --cert=tls.cert --key=tls.key`. You can get the certificate signed by creating a `CertificateSigningRequest` (CSR) resource. Approve with: `kubectl certificate approve <name of the CSR>`. 

* Work with images securely.

  * To run a pod, which uses an image from the private repository, you need to do two things: Create a Secret (`docker-registry` type of secret) holding the credentials for the Docker registry. Reference that Secret in the `imagePullSecrets` field of the pod manifest, e.g. `k create secret docker-registry mydockerhubsecret --docker-username=myusername --docker-password=mypassword --docker-email=my.email@provider.com`.

* Define security contexts.

* Secure persistent key value store.

* Work with role-based access control.

### Storage

* Understand persistent volumes and know how to create them.

  * Volume is essentially a directory backed by a storage medium. The storage medium and its content are determined by the Volume Type.

  * Volume is created when the pod is started and is destroyed when the pod is deleted.

  * Volume is attached to a Pod and shared among the containers of that Pod. The Volume has the same life span as the Pod, and it outlives the containers of the Pod - this allows data to be preserved across container restarts.

  * Types:
  
    * `emptyDir`: An empty Volume is created for the Pod as soon as it is scheduled on the worker node. An emptyDir volume is especially useful for sharing files between containers running in the same pod. The Volume's life is tightly coupled with the Pod. If the Pod dies, the content of emptyDir is deleted forever. The emptyDir is created on the actual disk of the worker node hosting your pod (you can tell Kubernetes to create the emptyDir on a tmpfs filesystem - in memory instead of on disk. To do this, set the emptyDir’s `medium` to `Memory`).

    * `gitRepo`: volume is an emptyDir volume initially populated with the contents of a Git repository.

    * `hostPath`: With the hostPath Volume Type, we can share a directory from the host to the Pod. If the Pod dies, the content of the Volume is still available on the host. hostPath volume points to a specific file or directory on the node’s filesystem.

    * `gcePersistentDisk`: With the gcePersistentDisk Volume Type, we can mount a Google Compute Engine (GCE) persistent disk into a Pod.

    * `awsElasticBlockStore`: With the awsElasticBlockStore Volume Type, we can mount an AWS EBS Volume into a Pod.

    * `nfs`: With nfs, we can mount an NFS share into a Pod.

      ```yaml
      volumes:
        - name: mongodb-data
          nfs:
            server: 1.2.3.4
            path: /some/path
      ```

    * `iscsi`: With iscsi, we can mount an iSCSI share into a Pod.

    * `secret`: With the secret Volume Type, we can pass sensitive information, such as passwords, to Pods.

    * `persistentVolumeClaim`: We can attach a PersistentVolume to a Pod using a persistentVolumeClaim.

* Understand access modes for volumes.

* Understand persistent volume claims primitive.

  * A `PersistentVolume` is a network-attached storage in the cluster, which is provisioned by the administrator and consumed by pods through `PersistentVolumeClaims`.

  * PersistenVolume(s): `k get pv`

  * PersistentVolumes, like cluster Nodes, don’t belong to any namespace, unlike pods and PersistentVolumeClaims.

  * PersistentVolumeClaim(s): `k get pvc`

  * PersistentVolume resources are cluster-scoped and thus cannot be created in a specific namespace, but PersistentVolumeClaims can only be created in a specific namespace. They can then only be used by pods in the SAME namespace.

  * Reference the PersistentVolumeClaim by name inside the pod’s volume (yes, the PersistentVolumeClaim, NOT the PersistentVolume directly!).

  * Retain the volume and it's content after it is released from it's claim: `persistentVolumeReclaimPolicy: Retain`.

  * `Recycle` reclaim policy deletes the volume’s contents and makes the volume available to be claimed again.

  * PersistentVolumes can be dynamically provisioned based on the StorageClass resource: `k get sc`. StorageClass resource specifies which provisioner should be used for provisioning the PersistentVolume when a PersistentVolumeClaim requests this StorageClass.

  * The default storage class is what’s used to dynamically provision a PersistentVolume if the PersistentVolumeClaim doesn’t explicitly say which storage class to use.

  * A StorageClass contains pre-defined provisioners and parameters to create a PersistentVolume. Using PersistentVolumeClaims, a user sends the request for dynamic PersistentVolume creation, which gets wired to the StorageClass resource. Specifying an empty string as the storage class name ensures the PersistentVolumeClaim binds to a pre-provisioned PersistentVolume instead of dynamically provisioning a new one.

  * A PersistentVolumeClaim (PVC) is a request for storage by a user. Once a suitable PersistentVolume is found, it is bound to a PersistentVolumeClaim. After a successful bound, the PersistentVolumeClaim resource can be used in a Pod. Once a user finishes its work, the attached PersistentVolumes can be released. The underlying PersistentVolumes can then be reclaimed and recycled for future usage.

* Understand Kubernetes storage objects.

* Know how to configure applications with persistent storage.

### Troubleshooting

* Troubleshoot application failure.

  * `kubectl explain pod.spec`.

  * `kubectl logs <POD>`.

  * If there are multiple containers in the pod, this is how you get the logs (-c): `kubectl logs <POD> -c <CONTAINER>`.

  * See the previously terminated container's logs: `kubectl logs <POD> --previous`.

  * Exit code `137` signals that the process was killed by an external signal (exit code is 128 + 9 (`SIGKILL`). Likewise, exit code `143` corresponds to 128 + 15 (`SIGTERM`).

* Troubleshoot control plane failure.

  * `kubectl get componentstatuses`.

* Troubleshoot worker node failure.

  * `kubectl get pods --watch`.

  * `kubectl get events --watch`.

* Troubleshoot networking.

### Core Concepts

* Understand the Kubernetes API primitives.

  * `kubectl proxy`, then dahsboard will be available on http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/kubernetes-dashboard:/proxy/#!/overview?namespace=default
    API paths/endpoints will be visible via `curl 127.0.0.1:8001`

  * Without `kubectl proxy`, you have to:

    ```bash
    TOKEN=$(kubectl describe secret -n kube-system $(kubectl get secrets -n kube-system | grep default | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d '\t' | tr -d " ")
    APISERVER=$(kubectl config view | grep https | cut -f 2- -d ":" | tr -d " ")
    curl $APISERVER --header "Authorization: Bearer $TOKEN" --insecure
    ```

  * Simple Kubernetes run example: `kubectl run <NAME> --image=<USER>/<IMAGE> --port=<NUMBER> --generator=run/v1` (this creates a ReplicationController instead of Deplyment).

  * For multiple constructs in one file, `List` object is the same as three-dash line (`---`) delimited YAML.

  * Communicating with pods through API server: `<apiServerHost>:<port>/api/v1/namespaces/default/pods/<name>/proxy/<path>`

* Understand the Kubernetes cluster architecture.

* Understand Services and other network primitives.

  * Service logically groups Pods and a policy to access them. Pods are ephemeral in nature, so if the Pod dies, new Pod will be created with new, unknown IP address. A Kubernetes Service is a resource you create to make a single, constant point of entry to a group of pods providing the same service.

  * Two methods of discovering the service are supported - ENV and DNS.

  * ServiceType specifies if: it is only accessible within the cluster (ClusterIP), is accessible from within the cluster and the external world (NodePort), or maps to an external entity which resides outside the cluster (LoadBalancer).

  * When a service is created, it gets a static IP, which never changes during the lifetime of the service.

  * Get services: `k get svc`.

  * Simple Kubernetes service example: `kubectl expose rc <NAME> --type=LoadBalancer --name=<LB_NAME>` (this exposes ReplicationController).

  * cURL service from within the pod: `kubectl exec <pod> -- curl -s http://<cluster ip>` - double dash signals end of command options for kubectl. Everything after '--' is what gets executed inside the pod, e.g. `kubectl exec kubia-7nog1 -- curl -s http://10.111.249.153`. The `kubectl attach` command is similar to `kubectl exec`, but it attaches to the main process running in the container instead of running an additional one.

  * If you want all requests made by a certain client to be redirected to the same pod every time, you can set the service’s `sessionAffinity` property to `ClientIP` (instead of `None`, which is the default).

  * The Endpoints object needs to have the same name as the service and contain the list of target IP addresses and ports for the service. To get all the endpoints of service: `k get ep <SVC>`.

  * To create a service that serves as an alias for an external service, you create a Service resource with the `type` field set to `ExternalName`.

  * `NodePort` service can be accessed not only through the service’s internal cluster IP, but also through any node’s IP and the reserved node port.

  * If a service definition includes `externalTrafficPolicy: local` setting and an external connection is opened through the service’s node port, the service proxy will choose a locally running pod.

  * Setting the `clusterIP` field in a service spec to `None` makes the service headless, as Kubernetes won’t assign it a cluster IP through which clients could connect to the pods backing it. With headless services, because DNS returns the pods’ IPs, clients connect directly to the pods, instead of through the service proxy.

  * Kubernetes creates SRV records to point to the hostnames of the pods backing a headless service.

  * To tell K8s you want all pods added to a service, regardless of the pod’s readiness status, you must add the following annotation to the service:

    ```yaml
    kind: Service
    metadata:
      annotations:
        service.alpha.kubernetes.io/tolerate-unready-endpoints: "true"
    ```

  * You can change a Service’s pod selector with the `kubectl set selector` command.

### Networking

* Understand the networking configuration on the cluster nodes.

  * Forward your machine’s local port 8888 to port 8080 of your `kubia-manual` pod: `kubectl port-forward kubia-manual 8888:8080`.

* Understand Pod networking concepts.

  * Inside a Pod, containers share the network namespaces, so that they can reach to each other via localhost.

  * If we have numerous users whom we would like to organize into teams/projects, we can partition the Kubernetes cluster into sub-clusters using Namespaces. The names of the resources/objects created inside a Namespace are unique, but not across Namespaces:

  * List namespaces: `kubectl get namespaces`.

  * Create the namespace like this: `kubectl create namespace custom-namespace`.

  * Specifying non-defaut namespace when creatng resource: `kubectl create -f kubia-manual.yaml -n custom-namespace`. If you don’t specify the namespace, kubectl performs the action in the default namespace configured in the current kubectl context.

  * Deleting namespace - the pods will be deleted along with the namespace automatically: `kubectl delete all --all`.

* Understand service networking.

* Deploy and configure network load balancer.

* Know how to use Ingress rules.

  * An Ingress is a collection of rules that allow inbound connections to reach the cluster Services.

  * Ingress configures a Layer 7 HTTP load balancer for Services. An Ingress Controller is an application which watches the Master Node's API server for changes in the Ingress resources and updates the Layer 7 Load Balancer accordingly. GCE L7 Load Balancer and Nginx Ingress Controller are examples of Ingress Controllers.

  * Ingresses operate at the application layer of the network stack (HTTP) and can provide features such as cookie-based session affinity and the like, which services can’t.

  * `k get ingresses`

  * Instead of deleting the Ingress and re-creating it from the new file, you can invoke `kubectl apply -f kubia-ingress-tls.yaml`, which updates the Ingress resource with what’s specified in the file.

* Know how to configure and use the cluster DNS.

* Understand CNI.

### Installation, Configuration & Validation

* Design a Kubernetes cluster.

* Install Kubernetes masters and nodes, including the use of TLS bootstrapping.

* Configure secure cluster communications.

* Configure a Highly-Available Kubernetes cluster.

* Know where to get the Kubernetes release binaries.

* Provision underlying infrastructure to deploy a Kubernetes cluster.

* Choose a network solution.

* Choose your Kubernetes infrastructure configuration.

* Run end-to-end tests on your cluster.

* Analyse end-to-end tests results.

* Run Node end-to-end tests.

---

## Outside of the exam curriculum

### Annotations

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: webserver
  annotations:
    description: Deployment based PoC dates 2nd June'2017
```

```bash
$ kubectl describe deployment webserver
Name:                webserver
Namespace:           default
CreationTimestamp:   Sat, 03 Jun 2017 05:10:38 +0530
Labels:              app=webserver
Annotations:         deployment.kubernetes.io/revision=1
                     description=Deployment based PoC dates 2nd June'2017
```

### Job

* A Job creates one or more Pods to perform a given task.

* The Job object takes the responsibility of Pod failures.

* It makes sure that the given task is completed successfully.

* Once the task is over, all the Pods are terminated automatically.

* Starting with the Kubernetes 1.4 release, we can also perform Jobs at specified times/dates, such as cron jobs.

* In the event of a failure of the process itself (when the process returns an error exit code), the Job can be configured to either restart the container or not. Set the restart policy to either `OnFailure` or `Never`.

* Show all jobs: `k get jobs` and/or `kubectl get po -a` - completed Jobs aren't shown by default.

* If you need a Job to run more than once, you set `completions` to how many times you want the Job’s pod to run.

* Specify how many pods are allowed to run in parallel with the `parallelism` Job spec property, `kubectl scale job multi-completion-batch-job --replicas 3`.

* A pod’s time can be limited by setting the `activeDeadlineSeconds` property in the pod spec.

### Quota Management

* Use the `ResourceQuota` object, which provides constraints that limit aggregate resource consumption per Namespace.

* `Compute Resource Quota` (CPU, memory, ...) that can be requested in the Namespace.

* `Storage Resource Quota` (PersistentVolumeClaims, requests.storage, ...) that can be requested.

* `Object Count Quota` Restrict the number of objects of a given type (pods, ConfigMaps, PersistentVolumeClaims, ReplicationControllers, Services, Secrets, ...).

### StatefulSet

* Used for applications which require a unique identity, such as name, network identifications, strict ordering, etc. For example, `MySQL cluster`, `etcd cluster`.

* Provides identity and guaranteed ordering of deployment and scaling to Pods.

* Specifically tailored to applications where instances of the application must be treated as non-fungible individuals, with each one having a stable name and state. `StatefulSets` were initially called `PetSets`.

### Custom resources

* Resource is an API endpoint which stores a collection of API objects.

* To make a resource declarative, we must create and install a custom controller, which can interpret the resource structure and perform the required actions.

* Custom Resource Definitions (CRDs)

* API Aggregation

### Helm

* To deploy an application, we use different Kubernetes manifests/constructs, such as Deployments, Services, Volume Claims, Ingress, etc. Sometimes, it can be tiresome to deploy them one by one.

* We can bundle all those manifests after templatizing them into a well-defined format, along with other metadata. Such a bundle is referred to as `Chart`.

* Helm is a package manager (analogous to yum and apt) for Kubernetes, which can install/update/delete those Charts in the Kubernetes cluster.

* A client is called `helm`, which runs on your workstation.

* A server called `tiller`, which runs inside your Kubernetes cluster.

* The client helm connects to the server tiller to manage Charts.

### downwardAPI

* Exposing additional metadata through ENV or Volume. You need to specify each metadata field explicitly if you want to have it exposed to the process, e.g.:

  ```yaml
  - name: downward
    downwardAPI:
      items:
      - path: "podName"                 # Name of the pod will be saved to the file 'podName'
        fieldRef:
        fieldPath: metadata.name
  ```

---

_Last updated: Tue Aug 14 20:25:31 CEST 2018_
