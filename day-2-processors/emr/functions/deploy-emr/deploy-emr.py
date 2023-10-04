import os
import boto3

aws_access_key_id     = os.getenv("access_key")
aws_secret_access_key = os.getenv("secret_key")
region_name           = os.getenv("REGION_NAME")
cluster_name          = os.getenv("CLUSTER_NAME")

client = boto3.client("emr",
    region_name           = region_name,
    aws_access_key_id     = aws_access_key_id,
    aws_secret_access_key = aws_secret_access_key
)


def handler(event = None, context = None):
    cluster_id = client.run_job_flow(
        Name=cluster_name,
        ServiceRole='EmrDefaultRole',
        JobFlowRole='EmrEc2DefaultRole_profile',
        VisibleToAllUsers=True,
        StepConcurrencyLevel=2,
        LogUri='s3://owshq-trn-cc-bg-aws/emr/emr-logs',
        ReleaseLabel='emr-6.5.0',
        Instances={
            'InstanceGroups': [
                {
                    'Name': 'Master nodes',
                    'Market': 'ON_DEMAND',
                    'InstanceRole': 'MASTER',
                    'InstanceType': 'm5.xlarge',
                    'InstanceCount': 1,
                },
                {
                    'Name': 'Worker nodes',
                    'Market': 'ON_DEMAND',
                    'InstanceRole': 'CORE',
                    'InstanceType': 'm5.xlarge',
                    'InstanceCount': 1,
                }
            ],
            'Ec2KeyName': 'owshq-emr-key-777696598735',
            'KeepJobFlowAliveWhenNoSteps': True,
            'TerminationProtected': False,
            'Ec2SubnetId': 'subnet-0bc0c5d43ddd36523'
        },
        Applications=[
            {'Name': 'Spark'},
            {'Name': 'Hadoop'},
            {'Name': 'Hive'},
            {'Name':'JupyterEnterpriseGateway'},
            {'Name':'Livy'}
            ],
        Configurations=[
            {
            "Classification": "spark-env",
            "Properties": {},
            "Configurations": [{
                "Classification": "export",
                "Properties": {
                    "PYSPARK_PYTHON": "/usr/bin/python3",
                    "PYSPARK_DRIVER_PYTHON": "/usr/bin/python3"
                }
            }]
        },
            {
                "Classification": "spark-hive-site",
                "Properties": {
                    "hive.metastore.client.factory.class": "com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"
                }
            },
            {
                "Classification": "spark-defaults",
                "Properties": {
                    "spark.submit.deployMode": "cluster",
                    "spark.speculation": "false",
                    "spark.sql.adaptive.enabled": "true",
                    "spark.serializer": "org.apache.spark.serializer.KryoSerializer",
                    "spark.driver.extraJavaOptions": 
                      "-XX:+UseG1GC -XX:+UnlockDiagnosticVMOptions -XX:+G1SummarizeConcMark -XX:InitiatingHeapOccupancyPercent=35 -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:OnOutOfMemoryError='kill -9 %p'",
                      "spark.storage.level": "MEMORY_AND_DISK_SER",
                      "spark.rdd.compress": "true",
                      "spark.shuffle.compress": "true",
                      "spark.shuffle.spill.compress": "true"
                }
            },
            {
                "Classification": "spark",
                "Properties": {
                    "maximizeResourceAllocation": "true"
                }
            },
            {
              "Classification": "emrfs-site",
              "Properties": {
                "fs.s3.maxConnections": "1000",
            }
            }
        ],
         AutoTerminationPolicy={
            'IdleTimeout': 3600
        }
    )
    return cluster_id["JobFlowId"]