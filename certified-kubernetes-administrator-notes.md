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

  * A Pod is the scheduling unit in Kubernetes. It is a logical collection of one or more containers which are always scheduled together.

  * A Pod is the smallest and simplest Kubernetes object. It is the unit of deployment in Kubernetes, which represents a single instance of the application. A Pod is a logical collection of one or more containers, which: Are scheduled together on the same host, share the same network namespace, mount the same external storage (volumes).

  * Labels are key-value pairs that can be attached to any Kubernetes objects (e.g. Pods). Labels are used to organize and select a subset of objects, based on the requirements in place. Many objects can have the same Label(s). Labels do not provide uniqueness to objects.

* Understand the role of DaemonSets.

* Understand how resource limits can affect Pod scheduling.

* Understand how to run multiple schedulers and how to configure Pods to use them.

* Manually schedule a pod without a scheduler.

* Display scheduler events.

* Know how to configure the Kubernetes scheduler.

### Logging/Monitoring

* Understand how to monitor all cluster components.

* Understand how to monitor applications.

* Manage cluster component logs.

* Manage application logs.

### Application Lifecycle Management

* Understand Deployments and how to perform rolling updates and rollbacks.

  * Deployment objects provide declarative updates to Pods and ReplicaSets. The DeploymentController is part of the master node's controller manager, and it makes sure that the current state always matches the desired state.

  * A rollout is only triggered when we update the Pods Template for a deployment. Operations like scaling the deployment do not trigger the deployment.

* Know various ways to configure applications.

* Know how to scale applications.

  * `kubectl scale deployment <NAME> --replicas=3`

* Understand the primitives necessary to create a self-healing application.

  * Generally, we don't deploy a Pod independently, as it would not be able to re-start itself, if something goes wrong. We always use controllers like ReplicationController(s) and/or ReplicaSet(s) to create and manage Pods.

### Cluster Maintenance

* Understand Kubernetes cluster upgrade process.

* Facilitate operating system upgrades.

* Implement backup and restore methodologies.

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

* Know to configure network policies.

* Create and manage TLS certificates for cluster components.

* Work with images securely.

* Define security contexts.

* Secure persistent key value store.

* Work with role-based access control.

### Storage

* Understand persistent volumes and know how to create them.

  * A Volume is essentially a directory backed by a storage medium. The storage medium and its content are determined by the Volume Type.

  * Volume is attached to a Pod and shared among the containers of that Pod. The Volume has the same life span as the Pod, and it outlives the containers of the Pod - this allows data to be preserved across container restarts.

  * Types:
  
    * emptyDir: An empty Volume is created for the Pod as soon as it is scheduled on the worker node. The Volume's life is tightly coupled with the Pod. If the Pod dies, the content of emptyDir is deleted forever.

    * hostPath: With the hostPath Volume Type, we can share a directory from the host to the Pod. If the Pod dies, the content of the Volume is still available on the host.

    * gcePersistentDisk: With the gcePersistentDisk Volume Type, we can mount a Google Compute Engine (GCE) persistent disk into a Pod.

    * awsElasticBlockStore: With the awsElasticBlockStore Volume Type, we can mount an AWS EBS Volume into a Pod.

    * nfs: With nfs, we can mount an NFS share into a Pod.

    * iscsi: With iscsi, we can mount an iSCSI share into a Pod.

    * secret: With the secret Volume Type, we can pass sensitive information, such as passwords, to Pods.

    * persistentVolumeClaim: We can attach a PersistentVolume to a Pod using a persistentVolumeClaim.

* Understand access modes for volumes.

* Understand persistent volume claims primitive.

  * A Persistent Volume is a network-attached storage in the cluster, which is provisioned by the administrator.

  * PersistentVolumes can be dynamically provisioned based on the StorageClass resource.

  * A StorageClass contains pre-defined provisioners and parameters to create a PersistentVolume. Using PersistentVolumeClaims, a user sends the request for dynamic PersistentVolume creation, which gets wired to the StorageClass resource.

  * A PersistentVolumeClaim (PVC) is a request for storage by a user. Once a suitable PersistentVolume is found, it is bound to a PersistentVolumeClaim. After a successful bound, the PersistentVolumeClaim resource can be used in a Pod. Once a user finishes its work, the attached PersistentVolumes can be released. The underlying PersistentVolumes can then be reclaimed and recycled for future usage.

* Understand Kubernetes storage objects.

* Know how to configure applications with persistent storage.

### Troubleshooting

* Troubleshoot application failure.

* Troubleshoot control plane failure.

* Troubleshoot worker node failure.

* Troubleshoot networking.

### Core Concepts

* Understand the Kubernetes API primitives.

  * `kubectl proxy`, dahsboard will be available on http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/kubernetes-dashboard:/proxy/#!/overview?namespace=default
    API paths/endpoints will be visible via `curl 127.0.0.1:8001`

  * Without `kubectl proxy`, you have to:

    ```bash
    TOKEN=$(kubectl describe secret -n kube-system $(kubectl get secrets -n kube-system | grep default | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d '\t' | tr -d " ")
    APISERVER=$(kubectl config view | grep https | cut -f 2- -d ":" | tr -d " ")
    curl $APISERVER --header "Authorization: Bearer $TOKEN" --insecure
    ```

* Understand the Kubernetes cluster architecture.

* Understand Services and other network primitives.

  * Service logically groups Pods and a policy to access them. Pods are ephemeral in nature, so if the Pod dies, new Pod will be created with new, unknown IP address.

  * Two methods of discovering the service are supported - ENV and DNS.

  * ServiceType specifies if: it is only accessible within the cluster (ClusterIP), is accessible from within the cluster and the external world (NodePort), or maps to an external entity which resides outside the cluster (LoadBalancer).

### Networking

* Understand the networking configuration on the cluster nodes.

* Understand Pod networking concepts.

  * Inside a Pod, containers share the network namespaces, so that they can reach to each other via localhost.

  * If we have numerous users whom we would like to organize into teams/projects, we can partition the Kubernetes cluster into sub-clusters using Namespaces. The names of the resources/objects created inside a Namespace are unique, but not across Namespaces:

  `kubectl get namespaces`

* Understand service networking.

* Deploy and configure network load balancer.

* Know how to use Ingress rules.

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
