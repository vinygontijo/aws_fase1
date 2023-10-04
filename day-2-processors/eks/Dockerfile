# get image from spark-operator repository 
# https://googlecloudplatform.github.io/spark-on-k8s-operator
ARG SPARK_VERSION=v3.1.1-hadoop3
FROM gcr.io/spark-operator/spark-py:${SPARK_VERSION}
LABEL org.opencontainers.image.authors="carlos.barbosa@a3data.com.br"
LABEL EMAIL carlos.barbosa@a3data.com.br

# using root user
USER root:root

# create the directory that will store the spark jobs
RUN mkdir -p /app

# copy spark jobs local to image
COPY ./job/* /app/

# copy jars files
COPY ./jars/* /opt/spark/jars

# pip install
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir delta-spark==1.0.0 \
                               boto3==1.24.11

# set python3
ENV PYSPARK_PYTHON=/usr/bin/python3

# set main work directory
WORKDIR /app