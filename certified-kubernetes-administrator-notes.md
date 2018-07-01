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
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml

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

3. Check if the node has been added:

    ```bash
    kubectl get nodes
    ```

### Note: I have prepared `Vagrantfile` for this cluster
