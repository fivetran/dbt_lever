
# Lever dbt Package ([Docs](https://fivetran.github.io/dbt_lever/))

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_lever/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/dbt/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

## What does this dbt package do?
- Produces modeled tables that leverage Lever data from [Fivetran's connector](https://fivetran.com/docs/applications/lever) in the format described by [this ERD](https://fivetran.com/docs/applications/lever#schemainformation).
> NOTE: If your Lever connection was created [prior to July 2020](https://fivetran.com/docs/applications/lever/changelog) or still uses the Candidate endpoint, you must fully re-sync your connection or set up a new connection to use Fivetran's Lever dbt packages.

- Enables you to understand trends in recruiting, interviewing, and hiring at your company. It also provides recruiting stakeholders with information about individual opportunities, interviews, and jobs. It achieves this by:
    - Enriching the core opportunity, interview, job posting, and requisition tables with relevant pipeline data and metrics
    - Integrating the interview table with reviewer information and feedback
    - Calculating the velocity of opportunities through each pipeline stage, along with major job- and candidate-related attributes for segmented funnel analysis
- Generates a comprehensive data dictionary of your source and modeled Lever data through the [dbt docs site](https://fivetran.github.io/dbt_lever/#!/overview).

<!--section=“lever_transformation_model"-->
The following table provides a detailed list of all tables materialized within this package by default.
> TIP: See more details about these tables in the package's [dbt docs site](https://fivetran.github.io/dbt_lever/#!/overview?g_v=1).

| **Table**                | **Description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [lever__interview_enhanced](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__interview_enhanced)             | Each record represents a score that an interviewer gives to a unique interviewee. Includes data around the employees involved in this interview/opportunity, the interview feedback score standards, whether the opportunity advanced past this interview, how long the opportunity had been open at the time of the interview, and the opportunity source. |
| [lever__opportunity_enhanced](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__opportunity_enhanced)             | Each record represents a unique opportunity, enhanced with data about its associated job posting, requisition, application, origins, tags, resume links, contact information, current pipeline stage, offer status, and the position that the candidate applied for. Also includes interview metrics and how early the candidate applied relative to other candidates. |
| [lever__posting_enhanced](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__posting_enhanced)             | Each record represents a unique job posting, enriched with metrics about submitted applications, total and open opportunities, interviews conducted, and associated requisitions. Also includes the job posting's tags and hiring manager. |
| [lever__requisition_enhanced](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__requisition_enhanced)             | Each record represents a unique job requisition, enriched with information about the requisition's hiring manager, owner, offers extended, and associated job postings. |
| [lever__opportunity_stage_history](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__opportunity_stage_history)             | Each record represents a stage that an opportunity has advanced to. Includes data about the time spent in each stage, the application source, the hiring manager, and the opportunity's owner, as well as the job's team, location, and department. |

### Materialized Models
Each Quickstart transformation job run materializes 53 models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.
<!--section-end-->

## How do I use the dbt package?

### Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Lever connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

### Step 2: Install the package
Include the following lever package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/lever
    version: [">=1.1.0", "<1.2.0"]
```

> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/lever_source` in your `packages.yml` since this package has been deprecated.

### Step 3: Define database and schema variables

#### Option A: Single connection
By default, this package runs using your [destination](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile) and the `lever` schema. If this is not where your Lever data is (for example, if your Lever schema is named `lever_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
  lever:
    lever_database: your_database_name
    lever_schema: your_schema_name
```

#### Option B: Union multiple connections
If you have multiple Lever connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. For each source table, the package will union all of the data together and pass the unioned table into the transformations. The `source_relation` column in each model indicates the origin of each record.

To use this functionality, you will need to set the `lever_sources` variable in your root `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
  lever:
    lever_sources:
      - database: connection_1_destination_name # Required
        schema: connection_1_schema_name # Required
        name: connection_1_source_name # Required only if following the step in the following subsection

      - database: connection_2_destination_name
        schema: connection_2_schema_name
        name: connection_2_source_name
```

##### Recommended: Incorporate unioned sources into DAG
> *If you are running the package through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore), the below step is necessary in order to synchronize model runs with your Lever connections. Alternatively, you may choose to run the package through Fivetran [Quickstart](https://fivetran.com/docs/transformations/quickstart), which would create separate sets of models for each Lever source rather than one set of unioned models.*

By default, this package defines one single-connection source, called `lever`, which will be disabled if you are unioning multiple connections. This means that your DAG will not include your Lever sources, though the package will run successfully.

To properly incorporate all of your Lever connections into your project's DAG:
1. Define each of your sources in a `.yml` file in your project. Utilize the following template for the `source`-level configurations, and, **most importantly**, copy and paste the table and column-level definitions from the package's `src_lever.yml` [file](https://github.com/fivetran/dbt_lever/blob/main/models/staging/src_lever.yml).

```yml
# a .yml file in your root project

version: 2

sources:
  - name: <name> # ex: Should match name in lever_sources
    schema: <schema_name>
    database: <database_name>
    loader: fivetran
    config:
      loaded_at_field: _fivetran_synced
      freshness: # feel free to adjust to your liking
        warn_after: {count: 72, period: hour}
        error_after: {count: 168, period: hour}

    tables: # copy and paste from lever/models/staging/src_lever.yml - see https://support.atlassian.com/bitbucket-cloud/docs/yaml-anchors/ for how to use anchors to only do so once
```

> **Note**: If there are source tables you do not have (see [Step 4](#step-4-disable-models-for-non-existent-sources)), you may still include them, as long as you have set the right variables to `False`.

2. Set the `has_defined_sources` variable (scoped to the `lever` package) to `True`, like such:
```yml
# dbt_project.yml
vars:
  lever:
    has_defined_sources: true
```

### Step 4: Disable models for non-existent sources
Your Lever connection might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Lever or have actively excluded some tables from your syncs. To disable the corresponding functionality in the package, you must set the relevant config variables to `false`. By default, all variables are set to `true`. Alter variables for only the tables you want to disable:

```yml
# dbt_project.yml
...
config-version: 2

vars:
    lever_using_requisitions: false # Disable if you do not have the requisition table, or if you do not want requisition related metrics reported
    lever_using_posting_tag: false # disable if you do not have (or want) the postings tag table
```
### (Optional) Step 5: Additional configurations

<details open><summary>Expand/collapse configurations</summary>

#### Passing Through Custom Requisition Columns
If you choose to include requisitions, the `REQUISITION` table may also have custom columns (all prefixed by `custom_field_`). To pass these columns through to the [enhanced requisition model](https://github.com/fivetran/dbt_lever/blob/master/models/lever__requisition_enhanced.sql), add the following variable to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    lever_requisition_passthrough_columns: ['the', 'list', 'of', 'fields']
```

#### Change the build schema
By default, this package builds the Lever staging models within a schema titled (`<target_schema>` + `_stg_lever`) and your Lever modeling models within a schema titled (`<target_schema>` + `_lever`) in your destination. If this is not where you would like your Lever data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    lever:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_lever/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    lever_<default_source_table_name>_identifier: your_table_name 
```

### Leveraging Legacy Connector Table Names
For Fivetran Lever connections created on or after July 27, 2024, the `USER` and `INTERVIEWER_USER` source tables have been renamed to `USERS` and `INTERVIEW_USER`, respectively. This package now prioritizes the `USERS` and `INTERVIEW_USER` tables if available, falling back to `USER` and `INTERVIEWER_USER` if not.

If you have both tables in your schema and would like to specify this package to leverage the `USER` and/or `INTERVIEWER_USER` tables, you can set the variables `lever__using_users` and/or `lever__using_interview_user` to false in your `dbt_project.yml`.

```yml
vars:
    lever__using_users: false # Default is true to use USERS. Set to false to use USER.
    lever__using_interview_user: false # Default is true to use INTERVIEW_USER. Set to false to use INTERVIEWER_USER.
```

</details>

### (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]
```
## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/lever/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_lever/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_lever/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
