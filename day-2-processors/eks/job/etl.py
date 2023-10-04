from delta.tables import *
from DeltaProcessing import DeltaProcessing
from variables import bronze_dict, silver_dict, gold_list, gold_dict

if __name__ == "__main__":
    delta = DeltaProcessing(landing_zone_bucket = "owshq-landing-zone-dev-777696598735", 
                            bronze_bucket = "owshq-bronze-layer-dev-777696598735",
                            silver_bucket = "owshq-silver-layer-dev-777696598735",
                            gold_bucket= "owshq-gold-layer-dev-777696598735")

    for table_name, columns in bronze_dict.items():
        delta.write_to_bronze(
                                prefix = f"mysql/owshqmysql/{table_name}",
                                format = "parquet",
                                cols = [*columns])

    for table_name, query in silver_dict.items():
        delta.write_to_silver(
                                prefix = f"mysql/owshqmysql/{table_name}",
                                sql = query,      
                                upsert = False)

    for table_name, query in gold_dict.items():
        delta.write_to_gold(
                                prefix_list = gold_list,
                                prefix = f"delivery/{table_name}",
                                sql = query,
                                upsert = False)
