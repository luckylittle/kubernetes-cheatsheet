#!/bin/bash

# Deploy using Dashboard/UI
minikube start
export BROWSER=google-chrome # Because of `ERROR:browser_gpu_channel_host_factory.cc(119)] Failed to launch GPU process`
minikube dashboard
# Manually add 3 `webserver` Pods of `nginx:alpine`
kubectl get deployments
kubectl get replicasets
kubectl get pods
kubectl describe pod webserver-74b684cccd-vmqdv
kubectl get pods -L k8s-app,pod-template-hash
kubectl delete deployments webserver

# Deploy using CLI
kubectl create -f webserver-deploy.yaml
kubectl get replicasets
kubectl get pods
kubectl create -f webserver-svc.yaml
kubectl get services
kubectl describe svc web-service
minikube ip # 192.168.99.100
curl 192.168.99.100:31401
minikube service web-service
