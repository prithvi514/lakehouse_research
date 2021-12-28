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
# from delta.tables import DeltaTable

# jarDir = os.path.join("/opt/spark", "/jars")
# DJars = [os.path.join(jarDir, x) for x in os.listdir(jarDir)]

# Create Spark config for our Kubernetes based cluster manager
sparkConf = SparkConf()
sparkConf.setMaster("k8s://https://kubernetes.default.svc.cluster.local:443")
sparkConf.setAppName("spark")
sparkConf.set("spark.kubernetes.container.image", "spark-hadoop:v3.1.2")
sparkConf.set("spark.kubernetes.namespace", "lakehouse")
sparkConf.set("spark.executor.instances", "1")
sparkConf.set("spark.executor.cores", "1")
sparkConf.set("spark.driver.memory", "512m")
sparkConf.set("spark.executor.memory", "512m")
sparkConf.set("spark.kubernetes.pyspark.pythonVersion", "3")
sparkConf.set("spark.kubernetes.authenticate.driver.serviceAccountName", "spark-sa")
sparkConf.set("spark.kubernetes.authenticate.serviceAccountName", "spark-sa")
sparkConf.set("spark.driver.port", "29413")
sparkConf.set("spark.driver.host", "spark-driver-service.lakehouse.svc.cluster.local")
sparkConf.set("spark.sql.hive.metastore.jars", "/opt/hive/lib/*")
sparkConf.set("spark.hadoop.fs.s3a.endpoint", "s3.us-east-1.amazonaws.com")
sparkConf.set("hive.metastore.uris", "thrift://hms-service.lakehouse.svc.cluster.local:9083")
# sparkConf.set("fs.s3a.access.key", 'KEY')
# sparkConf.set("fs.s3a.secret.key", 'SECRET')
sparkConf.set("fs.s3a.endpoint", "s3.us-east-1.amazonaws.com")
# sparkConf.set("fs.s3a.impl","org.apache.hadoop.fs.s3a.S3AFileSystem")
# sparkConf.set("spark.jars.packages", "org.apache.iceberg:iceberg-spark3-runtime:0.12.0")
# sparkConf.set("spark.sql.catalog.spark_catalog", "org.apache.iceberg.spark.SparkSessionCatalog")
# sparkConf.set("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions")
# sparkConf.set("spark.sql.catalog.spark_catalog.type", "hive")
# sparkConf.set("spark.jars","local:///opt/spark/jars/delta-core_2.12-1.0.0.jar")
# sparkConf.set("spark.jars", ",".join(DJars))
# sparkConf.set("spark.jars.packages", "io.delta:delta-core_2.12:1.0.0")
# sparkConf.set("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
# sparkConf.set("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")
# sparkConf.set("spark.sql.catalogImplementation", "hive")
sparkConf.set("spark.jars.ivy", "/tmp/.ivy")
# Initialize our Spark cluster, this will actually
# generate the worker nodes.
spark = SparkSession.builder.config(conf=sparkConf).enableHiveSupport().getOrCreate()
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

#spark.range(5).write.format("delta").save("s3a://FOLDERNAME/SUB_FOLDER_NAME")
#spark.sql("CREATE TABLE student2 (id INT, name STRING, age INT)")
#spark.sql("show databases").show()
#spark.sql("show databases").show()
#spark.sql("CREATE TABLE student (id INT, name STRING, age INT")
#spark.sql("SET -v").describe()

spark.stop()
```

