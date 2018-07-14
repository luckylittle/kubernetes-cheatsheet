#!/bin/bash

# Deploy using Dashboard/UI example
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

# Deploy using CLI example
kubectl create -f webserver-deploy.yaml
kubectl get replicasets
kubectl get pods
kubectl create -f webserver-svc.yaml
kubectl get services
kubectl describe svc web-service
minikube ip # 192.168.99.100
curl 192.168.99.100:31401
minikube service web-service

# hostPath Volume example
minikube ssh
mkdir -p vol;cd vol
echo "Welcome to Kubernetes" > index.html
pwd # /home/docker/vol
# Uncomment the ### VOLUME section in webserver-deploy.yaml
kubectl create -f webserver-deploy.yaml
kubectl create -f webserver-svc.yaml

# Multi-tier application
kubectl delete deployments webserver
kubectl delete services web-service
kubectl create -f rsvp-db.yaml -f rsvp-db-service.yaml -f rsvp-web.yaml -f rsvp-web-service.yaml
kubectl scale deployment rsvp --replicas=3
