import pandas as pd
import dask.dataframe as dd
import psutil
import sqlalchemy

from geonature.utils.env import DB

from ..wrappers import checker
from ..logs import logger
from ..transform.utils import remove_temp_columns


@checker("Extracted (from DB table to Dask dataframe)")
def extract(table_name, schema_name, column_names, index_col, id):

    # create empty dataframe as model for importing data from sql table to dask dataframe
    # (for meta argument in read_sql_table method)
    empty_df = pd.DataFrame(columns=column_names, dtype="object")
    empty_df[index_col] = pd.to_numeric(empty_df[index_col], errors="coerce")

    # get number of cores to set npartitions:
    ncores = psutil.cpu_count(logical=False)
    logger.warning("ncores used by Dask = %s", ncores)

    # set dask dataframe index
    index_dask = sqlalchemy.sql.column(index_col).label("gn_id")
    query = """
    ALTER TABLE {schema_name}.{table_name}
    ALTER {index_col} TYPE integer
    USING {index_col}::integer;
    """
    try:
        DB.session.execute(
            query.format(
                schema_name=schema_name, table_name=table_name, index_col=index_col
            )
        )
        DB.session.commit()
    except Exception as e:
        DB.session.rollback()

    # get user table row data as a dask dataframe
    df = dd.read_sql_table(
        table=table_name,
        index_col=index_dask,
        uri=str(DB.engine.url),
        schema=schema_name,
        # bytes_per_chunk=100000000,
        npartitions=1,
    )

    return df
