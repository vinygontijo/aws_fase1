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

def list_clusters():
    cluster_id = client.list_clusters(
        ClusterStates=['WAITING']
    )
    return cluster_id['Clusters'][0]['Id']

def terminate_emr_cluster(cid):
    res = client.terminate_job_flows(
        JobFlowIds=[cid]
    )
    return res

def handler(event = None, context = None):
    cid = list_clusters()
    terminate_emr_cluster(cid)

    return "Matou o Cluster"
