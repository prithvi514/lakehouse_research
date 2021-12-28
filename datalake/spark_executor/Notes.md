# Using K8s Master as Scheduler

## Build docker image
```
eval $(minikube docker-env)
docker build -f docker/Dockerfile -t spark-hadoop:3.2.0 ./docker
```

## Create Service Account, Role and RoleBinding
```
kubectl apply -f spark-rbac.yml
```

## Get master URL of k8s cluster
```
kubectl cluster-info
```

## Executing Spark Submit
### Assumes spark-submit is available in local machine. Use `spark_driver` approach if that is not the case
```
./spark-submit  \
--deploy-mode cluster \
--master k8s://https://192.168.64.2:8443 \
--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark-sa \
--name spark-pi \
--conf spark.executor.instances=5  \
--conf spark.kubernetes.driver.container.image=spark-hadoop:3.2.0  \
--conf spark.kubernetes.executor.container.image=spark-hadoop:3.2.0 \ 
local:///opt/spark/examples/src/main/python/pi.py
```
