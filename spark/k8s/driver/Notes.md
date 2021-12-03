# Spark driver image with Jupyter installed

## Build docker image
```
docker build -t spark-driver:v3.2.0 .
```

## Create deployment using spark-driver image
```
kubectl apply -f spark-driver.yaml
```

## Port forward to access Jupyter UI
```
kubectl port-forward deployment.apps/my-notebook-deployment 8888:8888
```

## Sample code to launch spark job from Jupyter
### docker image use for executor needs to be built from `common` module
```
import os
from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession
# Create Spark config for our Kubernetes based cluster manager
sparkConf = SparkConf()
sparkConf.setMaster("k8s://https://kubernetes.default.svc.cluster.local:443")
sparkConf.setAppName("spark")
sparkConf.set("spark.kubernetes.container.image", "spark-hadoop:v3.2.0")
sparkConf.set("spark.kubernetes.namespace", "lakehouse")
sparkConf.set("spark.executor.instances", "7")
sparkConf.set("spark.executor.cores", "2")
sparkConf.set("spark.driver.memory", "512m")
sparkConf.set("spark.executor.memory", "512m")
sparkConf.set("spark.kubernetes.pyspark.pythonVersion", "3")
sparkConf.set("spark.kubernetes.authenticate.driver.serviceAccountName", "spark-sa")
sparkConf.set("spark.kubernetes.authenticate.serviceAccountName", "spark-sa")
sparkConf.set("spark.driver.port", "29413")
sparkConf.set("spark.driver.host", "my-notebook-deployment.spark.svc.cluster.local")
# Initialize our Spark cluster, this will actually
# generate the worker nodes.
spark = SparkSession.builder.config(conf=sparkConf).getOrCreate()
sc = spark.sparkContext
```


