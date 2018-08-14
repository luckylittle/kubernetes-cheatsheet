# CKA exam beta testing

There will be 32 questions, 4 hours, 8 clusters, 10 topics.

Tip: Create an alias for all kubelet commands e.g:
alias kg=’kubectl get’
alias kc=’kubectl create -f’

## Preparation

Q: Create a Job that run 60 time with 2 jobs running in parallel
https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/

Q: Find which Pod is taking max CPU
Use `kubectl top` to find CPU usage per pod

Q: List all PersistentVolumes sorted by their name
Use `kubectl get pv --sort-by=` <- this problem is buggy & also by default kubectl give the output sorted by name.

Q: Create a NetworkPolicy to allow connect to port 8080 by busybox pod only
https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/
Make sure to use `apiVersion: extensions/v1beta1` which works on both 1.6 and 1.7

Q: fixing broken nodes, see
https://kubernetes.io/docs/concepts/architecture/nodes/

Q: etcd backup, see
https://kubernetes.io/docs/getting-started-guides/ubuntu/backups/
https://www.mirantis.com/blog/everything-you-ever-wanted-to-know-about-using-etcd-with-kubernetes-v1-6-but-were-afraid-to-ask/

Q: TLS bootstrapping, see
https://kubernetes.io/docs/admin/kubelet-tls-bootstrapping/
https://github.com/cloudflare/cfssl

Q: You have a Container with a volume mount. Add a init container that creates an empty file in the volume.
https://kubernetes.io/docs/concepts/workloads/pods/init-containers/


Q: Create a Pod with non-persistent volume in QA namespace
Create a Pod with EmptyDir and in the YAML file add namespace: qa

Q:  Setting up K8s master components with a binaries/from tar balls:

Also, convert CRT to PEM: openssl x509 -in abc.crt -out abc.pem
- https://gist.github.com/mhausenblas/0e09c448517669ef5ece157fd4a5dc4b
- https://kubernetes.io/docs/getting-started-guides/scratch/
- http://alexander.holbreich.org/kubernetes-on-ubuntu/ maybe dashboard?
- https://kubernetes.io/docs/getting-started-guides/binary_release/
- http://kamalmarhubi.com/blog/2015/09/06/kubernetes-from-the-ground-up-the-api-server/  

Q: Find the error message with the string “Some-error message here”.
https://kubernetes.io/docs/concepts/cluster-administration/logging/ see kubectl logs and /var/log for system services

Q 17: Create an Ingress resource, Ingress controller and a Service that resolves to cs.rocks.ch.

First, create controller and default backend
 ```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress/master/controllers/nginx/examples/default-backend.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress/master/examples/deployment/nginx/nginx-ingress-controller.yaml
```

Second, create service and expose
 ```
kubectl run ingress-pod --image=nginx --port 80
kubectl expose deployment ingress-pod --port=80 --target-port=80 --type=NodePort
```

Create the ingress
 ```
cat <<EOF >ingress-cka.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-service
spec:
  rules:
  - host: "cs.rocks.ch"
    http:
      paths:
      - backend:
          serviceName: ingress-pod
          servicePort: 80
EOF
```

To test, run a curl pod
```
kubectl run -i --tty client --image=tutum/curl
curl -I -L --resolve cs.rocks.ch:80:10.240.0.5 http://cs.rocks.ch/
```

Q: Run a Jenkins Pod on a specified node only.
https://kubernetes.io/docs/tasks/administer-cluster/static-pod/
Create the Pod manifest at the specified location and then edit the systemd service file for kubelet(/etc/systemd/system/kubelet.service) to include `--pod-manifest-path=/specified/path`. Once done restart the service.