# Kubernetes
![Kubernetes](https://www.shapeblue.com/wp-content/uploads/2020/12/Kubernetes-logo.png)

```shell
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && chmod +x kubectl && mkdir -p ~/.local/bin && mv ./kubectl ~/.local/bin/kubectl
```

### Test version
```shell
kubectl version --client
```
### Minikube install
```shell
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mkdir -p /usr/local/bin/ && sudo install minikube /usr/local/bin/
```

### Minikube version
```shell
minikube version
```

### Test Minikube
```shell
minikube start --vm-driver=docker
```

### Minikube Dashboard activation
```shell
minikube dashboard
```

### Show all nodes
```shell
kubectl get nodes
```

### Show all
```shell
kubectl show all
```

### Create from a file
```shell
kubectl create Exercise\ Files/03_04/helloworld.yaml
kubectl get all
kubectl expose deployment helloworld --type=NodePort
minikube service helloworld
```

### Terminate app
```shell
kubectl get deployment
kubectl get service
```

### Add,Change, Delete labels
```shell
kubectl create -f Exercise\ Files/04_01_Adding_labels_to_the_app/helloworld-pod-with-labels.yml
kubectl get pods
kubectl get pods --show-labels
kubectl label pod/helloworld app=helloworld --overwrite
kubectl get pods --show-labels
kubectl label pod/helloworld app-
kubectl get pods --show-labels
```

### Search due labels
```shell
kubectl create -f Exercise\ Files/04_01_Adding_labels_to_the_app/sample-infrastructure-with-labels.yml
kubectl get pods --selector env=production
kubectl get pods --selector env=production,application_type=ui --show-labels
kubectl get pods  --selector env!=production --show-labels
kubectl get pods  -l 'release-version in (1.0,2.0)'
kubectl get pods  -l 'release-version notin (1.0,2.0)'
```

### Delete pods by label
```shell
 kubectl delete pods -l env=staging
```

### Show replicas
```shell
kubectl get replicaset 
```

### Show deployments
```shell
kubectl get deployments
```

### Application health check
```shell
kubectl create -f Exercise\ Files/04_03_Application_health_checks/helloworld-with-bad-readiness-probe.yaml
kubectl describe pod/helloworld-deployment-with-bad-readiness-probe-d9dc4cb64-mmgf7

 kubectl create -f Exercise\ Files/04_03_Application_health_checks/helloworld-with-bad-liveness-probe.yaml
 kubectl get deployments
 kubectl get pods
 kubectl describe po/helloworld-deployment-with-bad-liveness-probe-75c4b9f8c9-9zh7x
```

### Handling applications upgrades
```shell
 kubectl create -f Exercise\ Files/04_04_Rolling_updates/helloworld-black.yaml --record
 minikube service navbar-service
 kubectl set image deployment/navbar-deployment helloworld=karthequian/helloworlds:blue
```

### Rollback changes
```shell
 kubectl set image deployment/navbar-deployment helloworld=karthequian/helloworlds:red
 kubectl rollout history deployment/navbar-deployment
 kubectl rollout undo deployment/navbar-deployment
```

### Inspect
```shell
kubectl logs navbar-deployment-5fcc764854-wr69n
```

### Enter to the pod
```shell
kubectl exec -it  navbar-deployment-5fcc764854-wr69n /bin/bash
```