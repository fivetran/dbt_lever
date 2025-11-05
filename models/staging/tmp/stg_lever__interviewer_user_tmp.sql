{{
    lever.lever_union_connections(
        connection_dictionary='lever_sources',
        single_source_name='lever',
        single_table_name='interview_user' if var('lever__using_interview_user', lever.does_table_exist('interview_user')) else 'interviewer_user'
    )
}}