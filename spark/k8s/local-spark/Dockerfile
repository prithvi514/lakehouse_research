ARG java_image_tag=11-jre-slim

FROM openjdk:${java_image_tag}

ARG spark_uid=185


# define spark and hadoop versions
ENV SPARK_VERSION=3.2.0
ENV HADOOP_VERSION=3.3.1
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
RUN mkdir -p /opt && \
    cd /opt && \
    curl http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | \
        tar -zx hadoop-${HADOOP_VERSION}/lib/native && \
    ln -s hadoop-${HADOOP_VERSION} hadoop

# download and install spark
RUN mkdir -p /opt && \
    cd /opt && \
    curl http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION}.tgz | \
        tar -zx && \
    ln -s spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION} spark

# install pyspark
RUN pip3 install --upgrade pyspark

# Required spark configuration for local user access
ENV SPARK_HOME=/opt/spark
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3

ADD entrypoint.sh /opt/
RUN chmod a+x /opt/entrypoint.sh

RUN echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su
RUN chgrp root /etc/passwd
RUN chmod ug+rw /etc/passwd


ENTRYPOINT [ "/opt/entrypoint.sh" ]

# Specify the User that the actual main process will run as
USER ${spark_uid}