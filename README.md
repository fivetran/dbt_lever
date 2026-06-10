<!--section="lever_transformation_model"-->
# Lever dbt Package

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
- dbt Core™ supported versions
  - `>=1.3.0, <3.0.0`

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
| [lever__interview_enhanced](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__interview_enhanced) | Tracks individual interview feedback scores with data on interviewers, candidates, and opportunity progression to evaluate interview quality and hiring decisions. <br></br>**Example Analytics Questions:**<ul><li>Which interviewers provide the highest or lowest average feedback scores?</li><li>How do interview scores correlate with opportunities advancing to the next stage?</li><li>What is the average time between opportunity creation and interview occurrence?</li></ul>|
| [lever__opportunity_enhanced](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__opportunity_enhanced) | Provides comprehensive candidate opportunity data including pipeline stage, offer status, job posting details, interview metrics, and application timing to manage the hiring process end-to-end. <br></br>**Example Analytics Questions:**<ul><li>Which opportunities are currently in offer stage and what is their source?</li><li>How early did candidates with accepted offers apply compared to those with declined or no offers?</li><li>What is the average number of interviews per opportunity by job posting?</li></ul>|
| [lever__posting_enhanced](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__posting_enhanced) | Summarizes job posting performance with metrics on applications, opportunities, interviews, and requisitions to understand hiring demand and posting effectiveness. <br></br>**Example Analytics Questions:**<ul><li>Which job postings generate the most applications and opportunities?</li><li>What is the ratio of open to total opportunities by posting?</li><li>How many interviews have been conducted per job posting?</li></ul>|
| [lever__requisition_enhanced](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__requisition_enhanced) | Tracks job requisitions with hiring manager information, offers extended, and associated postings to monitor headcount planning and hiring progress. <br></br>**Example Analytics Questions:**<ul><li>Which requisitions have the most offers extended relative to headcount allocated?</li><li>How many job postings are associated with each requisition?</li><li>Who are the hiring managers and owners for each requisition?</li></ul>|
| [lever__opportunity_stage_history](https://fivetran.github.io/dbt_lever/#!/model/model.lever.lever__opportunity_stage_history) | Chronicles opportunity progression through hiring stages with time-in-stage metrics, source attribution, and team assignments to identify pipeline bottlenecks and hiring velocity. <br></br>**Example Analytics Questions:**<ul><li>What is the average time opportunities spend in each hiring stage?</li><li>Which stages have the highest drop-off rates?</li><li>How does time-to-hire vary by opportunity source, team, or location?</li></ul>|

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.

---

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Lever connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/data-models/quickstart-management).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_lever/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Install the package
Include the following lever package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/lever
    version: [">=1.3.0", "<1.4.0"]
```

> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/lever_source` in your `packages.yml` since this package has been deprecated.

### Define database and schema variables
#### Option A: Single connection
By default, this package runs using your destination and the `lever` schema. If this is not where your Lever data is (for example, if your Lever schema is named `lever_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    lever_database: your_destination_name
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

> Previous versions of this package employed two separate, mutually exclusive variables for unioning: `lever_union_schemas` and `lever_union_databases`. While these variables are still supported, `lever_sources` is the recommended variable to configure.

#### Optional: Incorporate unioned sources into DAG

If you use [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore) and are unioning multiple Lever connections, you can define your sources in a property `.yml` file, [using this as a template](https://github.com/fivetran/dbt_lever/blob/main/models/staging/src_lever.yml). Set the variable `has_defined_sources: true` under the Lever namespace in your `dbt_project.yml`. Otherwise, your Lever connections won't appear in your DAG. See the `union_connections` macro [documentation](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#optional-union-connections-defined-sources-configuration) for full configuration details.

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

#### Source casing for case-sensitive destinations
By default, the package applies case-insensitive comparisons when resolving `source_relation` values. If your destination is case-sensitive and you want downstream transformations to respect the exact casing of your source database and schema names, set the following variable:

```yml
vars:
    fivetran_using_source_casing: true
```

</details>

### (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt/setup-guide#transformationsfordbtcoresetupguide).
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