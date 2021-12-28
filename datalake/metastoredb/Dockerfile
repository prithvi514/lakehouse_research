ARG java_image_tag=8-jre-slim

FROM openjdk:${java_image_tag}

ARG MYSQL_CONN_VERSION=8.0.26
ARG METASTORE_VERSION=3.0.0

RUN apt-get update && apt-get install -y curl default-mysql-client --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN curl https://dlcdn.apache.org/hive/hive-standalone-metastore-$METASTORE_VERSION/hive-standalone-metastore-$METASTORE_VERSION-bin.tar.gz \
	| tar xvz -C /opt/ \
	&& ln -s /opt/apache-hive-metastore-$METASTORE_VERSION-bin /opt/hive-metastore    