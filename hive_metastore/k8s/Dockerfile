ARG java_image_tag=11-jre-slim

FROM openjdk:${java_image_tag}

ARG HADOOP_VERSION=3.3.1
ARG METASTORE_VERSION=3.0.0
ARG MYSQL_CONN_VERSION=8.0.26

RUN apt-get update && apt-get install -y curl --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*


RUN curl https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz \
	| tar xvz -C /opt/  \
	&& ln -s /opt/hadoop-$HADOOP_VERSION /opt/hadoop \
	&& rm -r /opt/hadoop/share/doc 

RUN ln -s /opt/hadoop/share/hadoop/tools/lib/hadoop-aws-$HADOOP_VERSION.jar /opt/hadoop/share/hadoop/common/lib/ && \
    ln -s /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.901.jar /opt/hadoop/share/hadoop/common/lib/

ENV HADOOP_HOME="/opt/hadoop"
ENV PATH="/opt/spark/bin:/opt/hadoop/bin:${PATH}"

RUN curl https://dlcdn.apache.org/hive/hive-standalone-metastore-$METASTORE_VERSION/hive-standalone-metastore-$METASTORE_VERSION-bin.tar.gz \
	| tar xvz -C /opt/ \
	&& ln -s /opt/apache-hive-metastore-$METASTORE_VERSION-bin /opt/hive-metastore

RUN curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_CONN_VERSION.tar.gz \
	| tar xvz -C /opt/ \
	&& ln -s /opt/mysql-connector-java-$MYSQL_CONN_VERSION/mysql-connector-java-$MYSQL_CONN_VERSION.jar /opt/hadoop/share/hadoop/common/lib/ \
	&& ln -s /opt/mysql-connector-java-$MYSQL_CONN_VERSION/mysql-connector-java-$MYSQL_CONN_VERSION.jar /opt/hive-metastore/lib/ 

ADD metastore-site.xml /opt/hive-metastore/conf/
#ADD core-site.xml /opt/hadoop/etc/hadoop/