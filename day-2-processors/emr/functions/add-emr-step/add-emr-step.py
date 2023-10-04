import boto3
import os

aws_access_key_id     = os.getenv("access_key")
aws_secret_access_key = os.getenv("secret_key")
region_name           = os.getenv("REGION_NAME")
cluster_name          = os.getenv("CLUSTER_NAME")

client = boto3.client("emr",
    region_name           = region_name,
    aws_access_key_id     = aws_access_key_id,
    aws_secret_access_key = aws_secret_access_key
)

bucket = 'owshq-scripts-dev-777696598735'
def list_clusters():
        cluster_id = client.list_clusters(
            ClusterStates=['WAITING']
        )
            
        return cluster_id['Clusters'][0]['Id'] 

def emr_process_delta(cid: str):        
    big_tables = client.add_job_flow_steps(JobFlowId=cid,
        Steps=[{'Name': 'owshq etl processing emr',
                'ActionOnFailure': 'CONTINUE',
                'HadoopJarStep': {
                    'Jar': 'command-runner.jar',
                    'Args': [
                                'spark-submit',
                                '--master', 'yarn',
                                '--deploy-mode', 'cluster',
                                '--conf', 'spark.dynamicAllocation.enabled=true',
                                '--conf', 'spark.shuffle.service.enabled=true',
                                f's3://{bucket}/job/etl.py',
                                '--py-files', 
                                        f's3://{bucket}/job/DeltaProcessing.py',
                                        f's3://{bucket}/job/variables.py'
                    ]
                }
        }]
    )

    return big_tables['StepIds'][0]

def handler(event = None, context = None):
    cid = list_clusters()
    emr_process_delta(cid)

