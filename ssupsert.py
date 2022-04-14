from dataclasses import field
from matplotlib import axis
import pandas as pd
import pyodbc
import uuid




def upsert(df, table_name, schema_name, connection_str):
    table_type_name = table_name + "_" + str(uuid.uuid4()).replace('-', '')

    # create the table type; get the table field frame back
    table_fields = create_table_type(table_type_name, table_name, schema_name, connection_str)

    merge(df, table_name, schema_name, table_type_name, table_fields, connection_str)

    # delete the table type if it exists 
    delete_table_type(table_type_name, connection_str)





def merge(df, table_name, schema_name, table_type_name, table_fields, connection_str):
    merge_sql = get_merge_sql(table_name, schema_name, table_type_name, table_fields)
    column_names = table_fields[table_fields["is_identity"] == False].sort_values(by=['ColumnId'], ascending=True)["ColumnName"].values
    data = [tuple(x) for x in df[column_names].values]


    conn = pyodbc.connect(connection_str) 

    cursor = conn.cursor()
    cursor.fast_executemany = True
    cursor.executemany(merge_sql, data)
    cursor.commit()
    cursor.close()




def get_merge_sql(table_name, schema_name, table_type_name, table_fields):
    column_names = table_fields[table_fields["is_identity"] == False].sort_values(by=['ColumnId'], ascending=True)["ColumnName"]
    insert_fields = ", ".join(column_names)
    insert_columns = ", ".join(['s.[' + x + ']' for x in column_names.values])

    update_names = table_fields[(table_fields["IsPrimaryKey"] == False) & (table_fields["is_identity"] == False)].sort_values(by=['ColumnId'], ascending=True)["ColumnName"]
    update_fields = ", ".join(['[' + x + '] = s.[' + x + ']' for x in update_names.values])

    primary_names = table_fields[table_fields["IsPrimaryKey"] == True].sort_values(by=['ColumnId'], ascending=True)["ColumnName"]
    primary_fields = " AND ".join(['t.[' + x + '] = s.[' + x + ']' for x in primary_names.values])

    params = ", ".join(['?' for x in column_names.values])

    merge_sql = """
        BEGIN
            DECLARE @{2} {2};
            --select ?, ?, ?;

            INSERT INTO @{2} VALUES({7});

            MERGE INTO [{0}].[{1}] AS T
            USING @{2} AS S
            ON 
                {3}
            WHEN MATCHED THEN UPDATE 
                SET 
                    {4}
            WHEN NOT MATCHED THEN INSERT 
                ({5})
                VALUES(	
                {6}
                );
        END    
    """.format(schema_name, table_name, table_type_name, primary_fields, update_fields, insert_fields, insert_columns, params)

    return merge_sql




def delete_table_type(table_type_name, connection_str):
    sql = """
        IF EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = '{0}')
            DROP TYPE {0};     
    """.format(table_type_name)

    conn = pyodbc.connect(connection_str) 

    cursor = conn.cursor()
    cursor.execute(sql)
    cursor.commit()
    cursor.close()   
    conn.close() 


def create_table_type(table_type_name, table_name, schema_name, connection_str):
    df = get_table_fields(table_name, schema_name, connection_str)

    table_type_sql = get_table_type_sql(df, table_type_name)

    conn = pyodbc.connect(connection_str) 

    cursor = conn.cursor()
    cursor.execute(table_type_sql)
    cursor.commit()
    cursor.close()   
    conn.close() 

    return df
    


def get_table_type_sql(df, table_type_name):
    df["Field_SQL"] = df.apply(get_fields, axis=1)
    # TODO - order fields
    fields = ", ".join(df.sort_values(by=['ColumnId'], ascending=True)['Field_SQL'])
    sql = """
        CREATE TYPE {0} AS TABLE(
            {1}
        )    
    """.format(table_type_name, fields)
    return sql


def get_fields(row):
    field = "[" + row['ColumnName'] + "] " + row['DataType'] + " " + get_size(row) + ("" if row["Is_Nullable"] == 1 else " NOT NULL")
    return field


def get_size(row):
    nchars = ["nchar", "nvarchar"]
    chars = ["char", "varchar"]
    max_lengths = ["binary", "varbinary", "datetimeoffset", "time"]
    empties = ["bigint", "bit", "date", "datetime", "datetime2", "float", "int", "money", "ntext", "real", "smalldatetime", "smallint", "smallmoney", "text", "tinyint", "uniqueidentifier", "xml"]
    numbers = ["decimal", "numeric"]

    if row["DataType"] in nchars:
        return "(" + ("max" if row["Max_length"] == -1 else "{:.0f}".format(row["Max_length"] / 2)) + ")"
    elif row["DataType"] in chars:
        return "(" + ("max" if row["Max_length"] == -1 else "{:.0f}".format(row["Max_length"])) + ")"
    elif row["DataType"] in max_lengths:
        return "(" + str(row["Max_length"]) + ")"
    elif row["DataType"] in empties:
        return ""
    elif row["DataType"] in numbers:
        return "(" + "{:.0f}".format(row["Precision"]) + "," + "{:.0f}".format(row["Scale"]) + ")"
    else:
        raise Exception("type not defined: " + row["DataType"])


def get_table_fields(table_name, schema_name, connection_str):
    """
    Returns a dataframe with the table meta data
    """
    sql = get_table_fields_sql(table_name, schema_name)
    conn = pyodbc.connect(connection_str) 
    df = pd.read_sql(sql, conn)
    conn.close()
    return df


def get_table_fields_sql(table_name, schema_name):
    """
    Get the sql used to get the table meta data
    """
    sql = """
    select  
        t.name TableName,  
        s.name SchemaName,
        c.name ColumnName, 
        y.name DataType, 
        c.Max_length, 
        c.Precision, 
        c.Scale, 
        c.Is_Nullable, 
        c.is_identity,
        case when ic.id is null then 0 
        else 1 
        end IsPrimaryKey, 
        c.column_id ColumnId 
    from  
        sys.tables t 
        join sys.schemas s
        on t.schema_id = s.schema_id
        join sys.columns c 
        on t.object_id = c.object_id 
        join sys.types y 
        on c.system_type_id = y.system_type_id 
        left outer join ( 
            select  
                c.id, 
                c.name 
            from  
                sysindexes i 
                join sysobjects o  
                ON i.id = o.id 
                join sysobjects pk  
                ON i.name = pk.name 
                AND pk.parent_obj = i.id 
                AND pk.xtype = 'PK' 
                join sysindexkeys ik  
                on i.id = ik.id 
                and i.indid = ik.indid 
                join syscolumns c  
                ON ik.id = c.id 
                AND ik.colid = c.colid 
        ) ic 
        on c.object_id = ic.id 
        and c.name = ic.name 
    where  
        t.name = '{}' 
        and s.name = '{}'
        and y.name <> 'sysname'
    order by  
        t.name,  
        c.column_id 
    """.format(table_name, schema_name)

    return sql

