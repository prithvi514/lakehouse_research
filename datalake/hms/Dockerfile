ARG java_image_tag=8-jre-slim

FROM openjdk:${java_image_tag}

ARG HADOOP_VERSION=3.2.2
ARG METASTORE_VERSION=3.0.0
ARG MYSQL_CONN_VERSION=8.0.26

RUN apt-get update && apt-get install -y curl default-mysql-client --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*


RUN curl https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz \
	| tar xvz -C /opt/  \
	&& ln -s /opt/hadoop-$HADOOP_VERSION /opt/hadoop \
	&& rm -r /opt/hadoop/share/doc 

RUN curl https://dlcdn.apache.org/hive/hive-standalone-metastore-$METASTORE_VERSION/hive-standalone-metastore-$METASTORE_VERSION-bin.tar.gz \
	| tar xvz -C /opt/ \
	&& ln -s /opt/apache-hive-metastore-$METASTORE_VERSION-bin /opt/hive-metastore

RUN curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_CONN_VERSION.tar.gz \
	| tar xvz -C /opt/ \
	&& ln -s /opt/mysql-connector-java-$MYSQL_CONN_VERSION/mysql-connector-java-$MYSQL_CONN_VERSION.jar /opt/hadoop/share/hadoop/common/lib/ \
	&& ln -s /opt/mysql-connector-java-$MYSQL_CONN_VERSION/mysql-connector-java-$MYSQL_CONN_VERSION.jar /opt/hive-metastore/lib/ 

# Exception in thread "main" java.lang.NoSuchMethodError: com.google.common.base.Preconditions.checkArgument(ZLjava/lang/String;Ljava/lang/Object;)
RUN mv /opt/hive-metastore/lib/guava-19.0.jar /tmp
RUN cp /opt/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar /opt/hive-metastore/lib/

# ENV variables
ENV HADOOP_HOME=/opt/hadoop
ENV HIVE_HOME=/opt/hive-metastore
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop/
ENV PATH="/opt/hadoop/bin:${PATH}"

#Config files
ADD metastore-site.xml /opt/hive-metastore/conf/
ADD core-site.xml /opt/hadoop/etc/hadoop/

# https://stackoverflow.com/questions/64625111/aws-eks-spark-3-0-hadoop-3-2-error-noclassdeffounderror-com-amazonaws-servic/64625374#64625374
RUN cd /opt/hadoop/share/hadoop/tools/lib/ && \
	mv aws-java-sdk-bundle-1.11.563.jar /tmp && \
	curl https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.874/aws-java-sdk-bundle-1.11.874.jar --output aws-java-sdk-bundle-1.11.874.jar

RUN ln -s /opt/hadoop/share/hadoop/tools/lib/hadoop-aws-$HADOOP_VERSION.jar /opt/hadoop/share/hadoop/common/lib/ && \
    ln -s /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.874.jar /opt/hadoop/share/hadoop/common/lib/

# Copy aws jars to Hive
RUN cp /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.874.jar /opt/hive-metastore/lib/
RUN cp /opt/hadoop/share/hadoop/tools/lib/hadoop-aws-3.2.2.jar /opt/hive-metastore/lib/	