{{
    lever.lever_union_connections(
        connection_dictionary='lever_sources',
        single_source_name='lever',
        single_table_name='users' if var('lever__using_users', lever.does_table_exist('users')) else 'user'
    )
}}