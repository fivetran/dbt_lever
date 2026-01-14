<!--section="lever_transformation_model"-->
# Lever dbt Package

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_lever/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0,_<3.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/data-models/quickstart-management#quickstartmanagement/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

This dbt package transforms data from Fivetran's Lever connector into analytics-ready tables.

## Resources

- Number of materialized models¹: 53
- Connector documentation
  - [Lever connector documentation](https://fivetran.com/docs/connectors/applications/lever)
  - [Lever ERD](https://fivetran.com/docs/connectors/applications/lever#schemainformation)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_lever)
  - [dbt Docs](https://fivetran.github.io/dbt_lever/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_lever/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_lever/blob/main/CHANGELOG.md)

## What does this dbt package do?
This package enables you to understand trends in recruiting, interviewing, and hiring at your company. It creates enriched models with metrics focused on opportunities, interviews, job postings, and requisitions.

> NOTE: If your Lever connection was created [prior to July 2020](https://fivetran.com/docs/applications/lever/changelog) or still uses the Candidate endpoint, you must fully re-sync your connection or set up a new connection to use Fivetran's Lever dbt packages.

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_lever
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [lever__interview_enhanced](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__interview_enhanced) | Tracks individual interview feedback scores with data on interviewers, candidates, and opportunity progression to evaluate interview quality and hiring decisions. <br></br>**Example Analytics Questions:**<ul><li>Which interviewers provide the highest or lowest average feedback scores?</li><li>How do interview scores correlate with opportunities advancing to the next stage?</li><li>What is the average time an opportunity was open before the interview occurred?</li></ul>|
| [lever__opportunity_enhanced](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__opportunity_enhanced) | Provides comprehensive candidate opportunity data including pipeline stage, offer status, job posting details, interview metrics, and application timing to manage the hiring process end-to-end. <br></br>**Example Analytics Questions:**<ul><li>Which opportunities are currently in offer stage and what is their source?</li><li>How early did successful hires apply compared to unsuccessful candidates?</li><li>What is the average number of interviews per opportunity by job posting?</li></ul>|
| [lever__posting_enhanced](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__posting_enhanced) | Summarizes job posting performance with metrics on applications, opportunities, interviews, and requisitions to understand hiring demand and posting effectiveness. <br></br>**Example Analytics Questions:**<ul><li>Which job postings generate the most applications and opportunities?</li><li>What is the ratio of open to total opportunities by posting?</li><li>How many interviews have been conducted per job posting?</li></ul>|
| [lever__requisition_enhanced](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__requisition_enhanced) | Tracks job requisitions with hiring manager information, offers extended, and associated postings to monitor headcount planning and hiring progress. <br></br>**Example Analytics Questions:**<ul><li>Which requisitions have the most offers extended and highest fill rates?</li><li>How many job postings are associated with each requisition?</li><li>Who are the hiring managers and owners for each requisition?</li></ul>|
| [lever__opportunity_stage_history](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__opportunity_stage_history) | Chronicles opportunity progression through hiring stages with time-in-stage metrics, source attribution, and team assignments to identify pipeline bottlenecks and hiring velocity. <br></br>**Example Analytics Questions:**<ul><li>What is the average time opportunities spend in each hiring stage?</li><li>Which stages have the highest drop-off rates?</li><li>How does time-to-hire vary by opportunity source, team, or location?</li></ul>|

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.

---

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Lever connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/data-models/quickstart-management#quickstartmanagement).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_lever/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Install the package
Include the following lever package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/lever
    version: [">=1.2.0", "<1.3.0"]
```

> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/lever_source` in your `packages.yml` since this package has been deprecated.

### Define database and schema variables
By default, this package runs using your destination and the `lever` schema. If this is not where your Lever data is (for example, if your Lever schema is named `lever_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    lever_database: your_database_name
    lever_schema: your_schema_name 
```

### Disable models for non-existent sources
Your Lever connection might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Lever or have actively excluded some tables from your syncs. To disable the corresponding functionality in the package, you must set the relevant config variables to `false`. By default, all variables are set to `true`. Alter variables for only the tables you want to disable:

```yml
# dbt_project.yml
...
config-version: 2

vars:
    lever_using_requisitions: false # Disable if you do not have the requisition table, or if you do not want requisition related metrics reported
    lever_using_posting_tag: false # disable if you do not have (or want) the postings tag table
```
### (Optional) Additional configurations

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

### Union multiple connections
If you have multiple lever connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `lever_union_schemas` OR `lever_union_databases` variables (cannot do both) in your root `dbt_project.yml` file:

```yml
vars:
    lever_union_schemas: ['lever_usa','lever_canada'] # use this if the data is in different schemas/datasets of the same database/project
    lever_union_databases: ['lever_usa','lever_canada'] # use this if the data is in different databases/projects but uses the same schema name
```
Please be aware that the native `src_lever.yml` connection set up in the package will not function when the union schema/database feature is utilized. Although the data will be correctly combined, you will not observe the sources linked to the package models in the Directed Acyclic Graph (DAG). This happens because the package includes only one defined `src_lever.yml`.

To connect your multiple schema/database sources to the package models, follow the steps outlined in the [Union Data Defined Sources Configuration](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#union_data-source) section of the Fivetran Utils documentation for the union_data macro. This will ensure a proper configuration and correct visualization of connections in the DAG.

</details>

### (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/data-models/quickstart-management#quickstartmanagement). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/data-models/quickstart-management#quickstartmanagement#setupguide).
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
<!--section="lever_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/lever/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_lever/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

<!--section-end-->

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_lever/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).