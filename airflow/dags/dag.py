from airflow.sdk import DAG
from airflow.providers.standard.operators.python import PythonOperator
from airflow.providers.google.cloud.transfers.local_to_gcs import LocalFilesystemToGCSOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from datetime import datetime, timedelta
from pipeline.scripts.py_script import ingestion
import os 

local_file_path = os.environ["LOCAL_FILE_PATH"]
blob = os.environ["GCP_BLOB"]
bucket_name = os.environ["GCP_BUCKET_NAME"]
dataset_name = os.environ["GCP_DATASET_NAME"]
project_id = os.environ["GCP_PROJECT_ID"]
table_name= os.environ["GCP_TABLE_NAME"]

default_args ={
        "depends_on_past": False,
        "retries": 1,
        "retry_delay": timedelta(minutes=5),
}

with DAG(dag_id = "gcp_dag", 
         default_args=default_args,
         description="GCP Data Pipeline",
         schedule="@daily",
         start_date=datetime(2026,1,31),
         catchup=False
) as dag:
    
    store_locally = PythonOperator(
        task_id="store_locally",
        python_callable=ingestion
    )

    upload_file_to_gcs = LocalFilesystemToGCSOperator(
        task_id="upload_file",
        src=local_file_path,
        dst=blob,
        bucket=bucket_name
    )

    gcs_to_bq = GCSToBigQueryOperator(
        task_id="load_to_staging_tables",
        bucket=bucket_name,
        source_objects =[blob],
        destination_project_dataset_table=f"{project_id}.{dataset_name}.{table_name}",
        source_format="CSV",
        skip_leading_rows=1,
        autodetect=True,
        write_disposition="WRITE_TRUNCATE"
    )



    store_locally >> upload_file_to_gcs >> gcs_to_bq