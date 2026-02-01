import pandas as pd 
import os
from pandas import DataFrame

def ingestion():
    """Function that returns a DF"""
    prefix = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/'
    df = pd.read_csv(prefix + 'yellow_tripdata_2021-01.csv.gz', nrows=1000000)
    print(df.count())
    print(df.head())

    # get enviornment variable from /opt/airflow/airflow.env
    output_path = os.environ["LOCAL_FILE_PATH"]
    # output_path = "/home/anthony/dev/wk2_de_zoomcamp/data/airflow_data.csv"
    df.to_csv(output_path, index=False)
    print(f"Wrote file to: {output_path}")

def main():
    ingestion()

if __name__ == "__main__":
    main()