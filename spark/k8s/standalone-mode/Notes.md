# Launch Spark shell on K8s

## Build images
```
eval $(minikube docker-env)
docker build -f docker/Dockerfile -t spark-hadoop:3.2.0 ./docker
```

## Deploy Master
```
kubectl apply -f spark-master.yml
```

## Deploy Workers
```
kubectl apply -f spark-worker.yml
```

## Enable and Deploy Ingress
```
minikube addons enable ingress
kubectl apply -f minikube-ingress.yml
```

## Run the PySpark shell from the the master container
```
kubectl exec spark-master-dbc47bc9-t6v84 -it -- \
    pyspark --conf spark.driver.bindAddress=<internal IP of master pod> --conf spark.driver.host=<internal ip of master pod>
```