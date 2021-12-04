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
### docker image `spark-hadoop:v3.2.0` use for executor needs to be built before executing this
### driver host `<service_name>.<namespace>.svc.cluster.local`
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
sparkConf.set("spark.executor.instances", "2")
sparkConf.set("spark.executor.cores", "1")
sparkConf.set("spark.driver.memory", "512m")
sparkConf.set("spark.executor.memory", "512m")
sparkConf.set("spark.kubernetes.pyspark.pythonVersion", "3")
sparkConf.set("spark.kubernetes.authenticate.driver.serviceAccountName", "spark-sa")
sparkConf.set("spark.kubernetes.authenticate.serviceAccountName", "spark-sa")
sparkConf.set("spark.driver.port", "29413")
sparkConf.set("spark.driver.host", "spark-driver-service.lakehouse.svc.cluster.local")
# Initialize our Spark cluster, this will actually
# generate the worker nodes.
spark = SparkSession.builder.config(conf=sparkConf).getOrCreate()
sc = spark.sparkContext

## example
data = [('James','','Smith','1991-04-01','M',3000),
  ('Michael','Rose','','2000-05-19','M',4000),
  ('Robert','','Williams','1978-09-05','M',4000),
  ('Maria','Anne','Jones','1967-12-01','F',4000),
  ('Jen','Mary','Brown','1980-02-17','F',-1)
]

columns = ["firstname","middlename","lastname","dob","gender","salary"]
df = spark.createDataFrame(data=data, schema = columns)
df.show()

spark.stop()
```


