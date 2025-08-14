{{
    fivetran_utils.union_data(
        table_identifier='users' if var('lever__using_users', lever.does_table_exist('users')) else 'user', 
        database_variable='lever_database', 
        schema_variable='lever_schema', 
        default_database=target.database,
        default_schema='lever',
        default_variable='users' if var('lever__using_users', lever.does_table_exist('users')) else 'user',
        union_schema_variable='lever_union_schemas',
        union_database_variable='lever_union_databases'
    )
}}