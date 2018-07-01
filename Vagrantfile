# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Disable 
  config.vm.box_check_update = false

  # Sync time with the local host
  config.vm.provider 'virtualbox' do |vb|
   vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
  end

  # How big is the cluster
  $num_instances = 3

  # Do this with all of the nodes
  (1..$num_instances).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.box = "centos/7"
      node.vm.hostname = "node#{i}"
      ip = "172.31.31.#{i+100}"
      node.vm.network "private_network", ip: ip
      node.vm.network "public_network", bridge: "wlp58s0", auto_config: true
      node.vm.synced_folder ".", "/vagrant", type: "virtualbox"

      node.vm.provider "virtualbox" do |vb|
        vb.memory = "3072"
        vb.cpus = 1
        vb.name = "node#{i}"
      end

    node.vm.provision "shell" do |s|
      s.inline = <<-SHELL
        # change time zone
        cp /usr/share/zoneinfo/Europe/Prague /etc/localtime
        timedatectl set-timezone Europe/Prague

        #rm /etc/yum.repos.d/CentOS-Base.repo
        cp /vagrant/yum/* /etc/yum.repos.d/
        #mv /etc/yum.repos.d/CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
        # using socat to port forward in helm tiller
        # install  kmod and ceph-common for rook
        # yum install -y wget curl
        # enable ntp to sync time

        echo 'sync time'
        systemctl start chronyd
        systemctl enable chronyd

        echo 'disable selinux'
        setenforce 0
        sed -i 's/=enforcing/=permissive/g' /etc/selinux/config

echo 'enable iptable kernel parameter'
cat >> /etc/sysctl.conf <<EOF
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

echo 'set host name resolution'
cat >> /etc/hosts <<EOF
172.31.31.101 node1
172.31.31.102 node2
172.31.31.103 node3
EOF
        cat /etc/hosts

        echo 'set nameserver'
        echo "nameserver 8.8.8.8" > /etc/resolv.conf
        cat /etc/resolv.conf

        echo 'disable swap'
        swapoff -a
        sed -i '/swap/s/^/#/' /etc/fstab
        cat /etc/fstab

        yum install --setopt=obsoletes=0 docker-ce-17.03.1.ce-1.el7.centos docker-ce-selinux-17.03.1.ce-1.el7.centos -y
        groupadd docker
        usermod -aG docker vagrant
        systemctl start docker
        systemctl enable docker

        yum install kubelet kubeadm kubectl -y
        systemctl enable kubelet
        systemctl start kubelet

        #create Docker group if not exists
        # egrep "^docker" /etc/group >& /dev/null
        # if [ $? -ne 0 ]
        # then
        #   groupadd docker
        # fi

        # rm -rf ~/.docker/

      SHELL
      end # Shell provision
    end # VM definition
  end # Each instance

  config.vm.define "node1", primary: true do |master|
    #master.vm.provision :shell, inline: "kubeadm init --pod-network-cidr=10.244.0.0/16"
    master.vm.provision "shell" do |shell|
      shell.inline = <<-SHELL
        kubeadm init --pod-network-cidr=10.244.0.0/16
        su vagrant
        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
        sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
        kubectl get pods --all-namespaces
      SHELL
    end
  end

end # Vagrant configure
