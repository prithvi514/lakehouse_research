# Spark-k8s-operator


## Build docker image
```
eval $(minikube docker-env)
docker build -f docker/Dockerfile -t spark-hadoop:3.2.0 ./docker
```

## Create Service Account, Role and RoleBinding
```
kubectl apply -f spark-rbac.yml
```

## Install operator Helm chart
```
  helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator

  helm install spark-operator spark-operator/spark-operator --namespace lakehouse --set sparkJobNamespace=lakehouse
```

## Run Spark job
```
kubectl apply -f spark-pi.yml
```