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

# Install python3 infrastructure
COPY requirements.txt .
RUN pip3 --no-cache-dir install -r requirements.txt && rm -f requirements.txt

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
RUN cp /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.901.jar /opt/spark/jars/
RUN cp /opt/hadoop/share/hadoop/tools/lib/hadoop-aws-3.3.1.jar /opt/spark/jars/

# install pyspark
RUN pip3 install --upgrade pyspark

RUN jupyter notebook --generate-config
RUN sed -i -E 's,^#\s*c.NotebookApp.terminado_settings.*,c.NotebookApp.terminado_settings = {"shell_command" : ["\/bin\/bash"]},g' ~/.jupyter/jupyter_notebook_config.py

# Setup password authentication so we don't have to remember tokens (password: "jupyter")
RUN echo "{ \"NotebookApp\": { \"password\": \"sha1:ad16e87de314:a02efac10ccd7ead24e845f438b2b87fe8bc2d0f\" } }" >> ~/.jupyter/jupyter_notebook_config.json
RUN mkdir -p ~/.ipython/profile_default
RUN echo "c.TerminalInteractiveShell.editing_mode = 'vi'" >> ~/.ipython/profile_default/ipython_config.py

# Required spark configuration for local user access
ENV SPARK_HOME=/opt/spark
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3
ENV PYTHONPATH=/opt/spark/python:/opt/spark/python/lib/py4j-0.10.9.2-src.zip
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/spark/bin

# Configuration files
ADD core-site.xml /opt/hadoop/etc/hadoop/
ADD core-site.xml /opt/spark/conf/
ADD spark-defaults.conf /opt/spark/conf/
ADD hive-site.xml /opt/spark/conf

EXPOSE 4040 4041 8080 8888

CMD ["lab", "--no-browser", "--allow-root", "--ip=0.0.0.0", "--port=8888"]
ENTRYPOINT ["/usr/local/bin/jupyter"]
