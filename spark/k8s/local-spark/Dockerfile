ARG java_image_tag=11-jre-slim

FROM openjdk:${java_image_tag}

ARG spark_uid=185


# define spark and hadoop versions
ENV SPARK_VERSION=3.1.2
ENV HADOOP_VERSION=3.2.2
ARG HADOOP_SPARK_VERSION=3.2


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	    apt-utils \
        build-essential \
        curl \
        git \
        tini \
        libpng-dev \
        libfreetype6-dev \
        pkg-config \
        python3 \
        python3-dev \
        python3-distutils \
        software-properties-common \
        sudo \
        tar \
        unzip \
        wget \
        libc6 \
        libpam-modules \
        krb5-user \
        libnss3 \
        procps \
        vim && \
    apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*   

RUN rm /bin/sh && ln -sv /bin/bash /bin/sh

# Get the latest pip3
RUN wget -q https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && rm -f get-pip.py


# download and install hadoop
# RUN mkdir -p /opt && \
#     cd /opt && \
#     curl http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | \
#         tar -zx hadoop-${HADOOP_VERSION}/lib/native && \
#     ln -s hadoop-${HADOOP_VERSION} hadoop

RUN curl https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz \
	| tar xvz -C /opt/  \
	&& ln -s /opt/hadoop-$HADOOP_VERSION /opt/hadoop \
	&& rm -r /opt/hadoop/share/doc 

RUN ln -s /opt/hadoop/share/hadoop/tools/lib/hadoop-aws-$HADOOP_VERSION.jar /opt/hadoop/share/hadoop/common/lib/ && \
    ln -s /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.901.jar /opt/hadoop/share/hadoop/common/lib/

# download and install spark
RUN mkdir -p /opt && \
    cd /opt && \
    curl http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION}.tgz | \
        tar -zx && \
    ln -s spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION} spark

# Copy aws jars to Spark
RUN cp /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.563.jar /opt/spark/jars/
RUN cp /opt/hadoop/share/hadoop/tools/lib/hadoop-aws-3.2.2.jar /opt/spark/jars/

 # download and install hive
 RUN mkdir -p /opt && \
     cd /opt && \
     curl https://dlcdn.apache.org/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz | tar -zx && \
     ln -s apache-hive-3.1.2-bin hive  
     
#Iceberg jars
RUN cd /opt/spark/jars && \
    curl https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark3-runtime/0.12.0/iceberg-spark3-runtime-0.12.0.jar --output iceberg-spark3-runtime-0.12.0.jar && \
    chmod 777 iceberg-spark3-runtime-0.12.0.jar

# Delta jars
RUN cd /opt/spark/jars && \
    curl https://repo1.maven.org/maven2/io/delta/delta-core_2.12/1.0.0/delta-core_2.12-1.0.0.jar --output delta-core_2.12-1.0.0.jar && \
    chmod 777 delta-core_2.12-1.0.0.jar

# install pyspark
RUN pip3 install pyspark==3.1.2

# Exception in thread "main" java.lang.NoSuchMethodError: com.google.common.base.Preconditions.checkArgument(ZLjava/lang/String;Ljava/lang/Object;)
RUN mv /opt/hive/lib/guava-19.0.jar /tmp
RUN cp /opt/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar /opt/hive/lib/

# Required spark configuration for local user access
ENV SPARK_HOME=/opt/spark
ENV HADOOP_HOME=/opt/hadoop
ENV HIVE_HOME=/opt/hive
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3
ENV PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/spark/bin:/opt/spark/jars/

ADD entrypoint.sh /opt/
RUN chmod a+x /opt/entrypoint.sh

RUN echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su
RUN chgrp root /etc/passwd
RUN chmod ug+rw /etc/passwd

# Configuration files
# Configuration files
ADD core-site.xml /opt/hadoop/etc/hadoop/
ADD core-site.xml /opt/spark/conf/
ADD spark-defaults.conf /opt/spark/conf/
ADD hive-site.xml /opt/spark/conf/

ENTRYPOINT [ "/opt/entrypoint.sh" ]

# Specify the User that the actual main process will run as
# USER ${spark_uid}
