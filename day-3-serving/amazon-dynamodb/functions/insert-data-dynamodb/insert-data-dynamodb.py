import boto3
import os
import awswrangler as wr

aws_access_key_id     = os.getenv("access_key")
aws_secret_access_key = os.getenv("secret_key")
region_name           = os.getenv("REGION_NAME")

client = boto3.client("s3",
    region_name           = region_name,
    aws_access_key_id     = aws_access_key_id,
    aws_secret_access_key = aws_secret_access_key
)

dynamodb = boto3.resource('dynamodb',
    region_name           = region_name,
    aws_access_key_id     = aws_access_key_id,
    aws_secret_access_key = aws_secret_access_key
)


def put_items(table, df):
    print("DynamoDB put_items called")
    with table.batch_writer() as batch:
        for i, row in df.iterrows():
            batch.put_item(Item=row.to_dict())
        print("DynamoDB put_items completed")


def handler(event = None, context = None):
    df_c = wr.s3.read_parquet(
            path=f's3://owshq-gold-layer-dev-777696598735/delivery/customers/',
            path_suffix  =  ".snappy.parquet"
            )       
    df_c['nascimento'] = df_c['nascimento'].astype(str)
    df_c = df_c.drop_duplicates(subset = ["id"],keep='last')
    df_c = df_c.dropna()

    df_cf = wr.s3.read_parquet(
            path=f's3://owshq-gold-layer-dev-777696598735/delivery/customer_flights/',
            path_suffix  =  ".snappy.parquet"
            )  
    df_cf['nascimento'] = df_cf['nascimento'].astype(str)
    df_cf = df_cf.dropna(subset=['aeroporto', 'linha_aerea'])
    df_cf = df_cf.drop_duplicates(subset = ["id"],keep='last')

    for table, df in {"customers":df_c,"customer_flights":df_cf}.items():

        dynamodb_table = dynamodb.create_table(
            TableName=table,
            KeySchema=[
                {
                    'AttributeName': 'id',
                    'KeyType': 'HASH'  # Partition key
                },
            
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'id',
                    'AttributeType': 'N'
                },

            ],
            BillingMode='PAY_PER_REQUEST'
        )

        dynamodb_table.wait_until_exists()

        put_items(dynamodb_table,df)


handler()