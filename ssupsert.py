# TODO
#   - add validations (all table names in dataframe, etc)
#   - define custom exceptions (validation, etc)
#   - improve error handling (database operations, etc)

import pandas as pd
import pyodbc

def upsert(df, table_name, schema_name, connection_str):
    """
    Performs an upsert to a SQL Server data table using data 
    from a pandas dataframe.
    """
    ups = SSUpsert(table_name, schema_name, connection_str)
    ups.upsert(df)


class SSUpsert:
    """
    Performs an upsert to a SQL Server data table using data 
    from a pandas dataframe.
    """
    NCHARS = ["nchar", "nvarchar"]
    CHARS = ["char", "varchar"]
    MAX_LENGTHS = ["binary", "varbinary", "datetimeoffset", "time"]
    EMPTIES = ["bigint", "bit", "date", "datetime", "datetime2", "float", "int", "money", "ntext", "real", "smalldatetime", "smallint", "smallmoney", "text", "tinyint", "uniqueidentifier", "xml"]
    NUMBERS = ["decimal", "numeric"]

    def __init__(self, table_name, schema_name, connection_str):
        self.table_name = table_name
        self.schema_name = schema_name
        self.connection_str = connection_str


    def upsert(self, df):
        """
        Performs the upsert using the data from dataframe 
        """

        # get a frame with the SQL Server table meta data
        table_fields = self.__get_table_fields()

        # perform the merge upsert 
        self.__merge(df, table_fields)


    def __merge(self, df, table_fields):
        """
        Executes the merge upsert with the data from the dataframe
        """

        merge_sql = self.__get_merge_sql(table_fields)
        # column_names = table_fields[table_fields["is_identity"] == False].sort_values(by=['ColumnId'], ascending=True)["ColumnName"].values
        column_names = table_fields.sort_values(by=['ColumnId'], ascending=True)["ColumnName"].values
        data = [tuple(x) for x in df[column_names].values]

        # TODO - improve this
        try:
            conn = pyodbc.connect(self.connection_str) 

            cursor = conn.cursor()
            cursor.fast_executemany = True
            cursor.executemany(merge_sql, data)
            cursor.commit()        
        except Exception as ex:
            raise
        finally:
            try: cursor.close()
            except: pass
            try: conn.close()
            except: pass


    def __get_merge_sql(self, table_fields):
        """
        Returns the SQL for the merge statement that performs the upsert
        """

        column_names = table_fields[table_fields["is_identity"] == False].sort_values(by=['ColumnId'], ascending=True)["ColumnName"]
        insert_fields = ", ".join(column_names)
        insert_columns = ", ".join(['s.[' + x + ']' for x in column_names.values])

        update_names = table_fields[(table_fields["IsPrimaryKey"] == False) & (table_fields["is_identity"] == False)].sort_values(by=['ColumnId'], ascending=True)["ColumnName"]
        update_fields = ", ".join(['[' + x + '] = s.[' + x + ']' for x in update_names.values])

        primary_names = table_fields[table_fields["IsPrimaryKey"] == True].sort_values(by=['ColumnId'], ascending=True)["ColumnName"]
        primary_fields = " AND ".join(['t.[' + x + '] = s.[' + x + ']' for x in primary_names.values])

        params = ", ".join(['?' for x in table_fields.values])
        # params = ", ".join(['?' for x in column_names.values])

        fields_sql = self.__get_table_vars_fields_sql(table_fields)

        table_var_name = "tbl"

        merge_sql = """
            BEGIN
                DECLARE @{2} table (
                    {8}
                );

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
        """.format(self.schema_name, self.table_name, table_var_name, primary_fields, update_fields, insert_fields, insert_columns, params, fields_sql)

        return merge_sql


    def __get_table_vars_fields_sql(self, df):
        """
        Returns the SQL used to create the table type variable
        """

        df["Field_SQL"] = df.apply(self.__get_row_ddl, axis=1)

        sql = ", ".join(df.sort_values(by=['ColumnId'], ascending=True)['Field_SQL'])

        return sql


    def __get_row_ddl(self, row):
        """
        Returns the SQL DDL for a row
        """
        field = "[" + row['ColumnName'] + "] " + row['DataType'] + " " + self.__get_row_size(row) + ("" if row["Is_Nullable"] == 1 else " NOT NULL")
        return field


    def __get_row_size(self, row):
        """
        Returns size part of the SQL DDL for a row
        """
        if row["DataType"] in self.NCHARS:
            return "(" + ("max" if row["Max_length"] == -1 else "{:.0f}".format(row["Max_length"] / 2)) + ")"
        elif row["DataType"] in self.CHARS:
            return "(" + ("max" if row["Max_length"] == -1 else "{:.0f}".format(row["Max_length"])) + ")"
        elif row["DataType"] in self.MAX_LENGTHS:
            return "(" + str(row["Max_length"]) + ")"
        elif row["DataType"] in self.EMPTIES:
            return ""
        elif row["DataType"] in self.NUMBERS:
            return "(" + "{:.0f}".format(row["Precision"]) + "," + "{:.0f}".format(row["Scale"]) + ")"
        else:
            raise Exception("type not defined: " + row["DataType"])


    def __get_table_fields(self):
        """
        Returns a dataframe with the table meta data
        """

        # TODO - improve this
        try:
            sql = self.__get_table_fields_sql()
            conn = pyodbc.connect(self.connection_str) 
            df = pd.read_sql(sql, conn)
        except Exception as ex:
            raise
        finally:
            try: conn.close()
            except: pass

        return df


    def __get_table_fields_sql(self):
        """
        Returns the sql used to get the table meta data
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
        """.format(self.table_name, self.schema_name)

        return sql
