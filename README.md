<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_lever/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="Fivetran-Release"
        href="https://fivetran.com/docs/getting-started/core-concepts#releasephases">
        <img src="https://img.shields.io/badge/Fivetran Release Phase-_Beta-orange.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.0.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Lever Transformation dbt Package ([Docs](https://fivetran.github.io/dbt_lever/))
# 📣 What does this dbt package do?
- Produces modeled tables that leverage Lever data from [Fivetran's connector](https://fivetran.com/docs/applications/lever) in the format described by [this ERD](https://fivetran.com/docs/applications/lever#schemainformation) and builds off the output of our [Lever source package](https://github.com/fivetran/dbt_lever_source).
> NOTE: If your Lever connector was created [prior to July 2020](https://fivetran.com/docs/applications/lever/changelog) or still uses the Candidate endpoint, you must fully re-sync your connector or set up a new connector to use Fivetran's Lever dbt packages.

This package enables you to understand trends in recruiting, interviewing, and hiring at your company. It also provides recruiting stakeholders with information about individual opportunities, interviews, and jobs. It achieves this by:
- Enriching the core opportunity, interview, job posting, and requisition tables with relevant pipeline data and metrics
- Integrating the interview table with reviewer information and feedback
- Calculating the velocity of opportunities through each pipeline stage, along with major job- and candidate-related attributes for segmented funnel analysis

The following table provides a detailed list of all models materialized within this package by default. 
> TIP: See more details about these models in the package's [dbt docs site](https://fivetran.github.io/dbt_lever/#!/overview?g_v=1&g_e=seeds).


| **model**                | **description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [lever__interview_enhanced](https://github.com/fivetran/dbt_lever/blob/master/models/lever__interview_enhanced.sql)             | Each record represents a score that an interviewer gives to a unique interviewee. Includes data around the employees involved in this interview/opportunity, the interview feedback score standards, whether the opportunity advanced past this interview, how long the opportunity had been open at the time of the interview, and the opportunity source. |
| [lever__opportunity_enhanced](https://github.com/fivetran/dbt_lever/blob/master/models/lever__opportunity_enhanced.sql)             | Each record represents a unique opportunity, enhanced with data about its associated job posting, requisition, application, origins, tags, resume links, contact information, current pipeline stage, offer status, and the position that the candidate applied for. Also includes interview metrics and how early the candidate applied relative to other candidates. |
| [lever__posting_enhanced](https://github.com/fivetran/dbt_lever/blob/master/models/lever__posting_enhanced.sql)             | Each record represents a unique job posting, enriched with metrics about submitted applications, total and open opportunities, interviews conducted, and associated requisitions. Also includes the job posting's tags and hiring manager. |
| [lever__requisition_enhanced](https://github.com/fivetran/dbt_lever/blob/master/models/lever__requisition_enhanced.sql)             | Each record represents a unique job requisition, enriched with information about the requisition's hiring manager, owner, offers extended, and associated job postings. |
| [lever__opportunity_stage_history](https://github.com/fivetran/dbt_lever/blob/master/models/lever__opportunity_stage_history.sql)             | Each record represents a stage that an opportunity has advanced to. Includes data about the time spent in each stage, the application source, the hiring manager, and the opportunity's owner, as well as the job's team, location, and department. |

# 🎯 How do I use the dbt package?

## Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Lever connector syncing data into your destination.
- A **BigQuery**, **Snowflake**, or **Redshift** destination.

## Step 2: Install the package
Include the following lever_source package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/lever
    version: [">=0.4.0", "<0.5.0"]
```
## Step 3: Define database and schema variables
By default, this package runs using your destination and the `lever` schema. If this is not where your Lever data is (for example, if your Lever schema is named `lever_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    lever_database: your_database_name
    lever_schema: your_schema_name 
```
## Step 4: Disable models for non-existent sources
Your Lever connector might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Lever or have actively excluded some tables from your syncs. To disable the corresponding functionality in the package, you must set the relevant config variables to `false`. By default, all variables are set to `true`. Alter variables for only the tables you want to disable:

```yml
# dbt_project.yml
...
config-version: 2

vars:
    lever_using_requisitions: false # Disable if you do not have the requisition table, or if you do not want requisition related metrics reported
    lever_using_posting_tag: false # disable if you do not have (or want) the postings tag table
```
## (Optional) Step 6: Additional configurations

<details><summary>Expand for configurations</summary>

### Passing Through Custom Requisition Columns
If you choose to include requisitions, the `REQUISITION` table may also have custom columns (all prefixed by `custom_field_`). To pass these columns through to the [enhanced requisition model](https://github.com/fivetran/dbt_lever/blob/master/models/lever__requisition_enhanced.sql), add the following variable to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    lever_requisition_passthrough_columns: ['the', 'list', 'of', 'fields']
```

### Change the build schema
By default, this package builds the Lever staging models within a schema titled (`<target_schema>` + `_stg_lever`) and your Lever modeling models within a schema titled (`<target_schema>` + `_lever`) in your destination. If this is not where you would like your Lever data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    lever_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
    lever:
      +schema: my_new_schema_name # leave blank for just the target_schema
```
    
### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_lever/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    lever_<default_source_table_name>_identifier: your_table_name 
```
</details>

## (Optional) Step 7: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>
    
Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
</details>

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: fivetran/lever_source
      version: [">=0.4.0", "<0.5.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.3.0", "<0.4.0"]

    - package: dbt-labs/dbt_utils
      version: [">=0.8.0", "<0.9.0"]
```
# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/lever/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_lever/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package!

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_lever/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [on Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com.

