# Lever

This package models Lever data from [Fivetran's opportunity-endpoint Lever connector](https://fivetran.com/docs/applications/lever). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/lever#schemainformation).

This package aims to help you understand trends in recruiting, interviewing, and hiring at your company, as well as empower recruiting stakeholders with all potentially relevant information about individual opportunities, interviews, and jobs. It achieves this by:
- Enriching the core opportunity, interview, job posting, and requisition tables with relevant pipeline data and metrics
- Integrating the interview table with individual feedback and information regarding the employees involved
- Calculating the velocity of opportunities through each pipeline stage, alongside major job and candidate-related attributes for segmented funnel analysis

## Compatibility (if needed)
> Please be aware the [dbt_lever](https://github.com/fivetran/dbt_lever) and [dbt_lever_source](https://github.com/fivetran/dbt_lever_source) packages will only work with the [Fivetran opportunity-endpoint lever schema](https://fivetran.com/docs/applications/connector/changelog). If your Lever connector was set up prior to this change or is otherwise still using the candidate-endpoint, you will need to fully resync or set up a new Lever connector in order for the Fivetran dbt Lever packages to work.


## Models - transformation package version

This package contains transformation models, designed to work simultaneously with our [Lever source package](https://github.com/fivetran/dbt_lever_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models.

| **model**                | **description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [lever__interview_enhanced](https://github.com/fivetran/dbt_lever/blob/master/models/lever__interview_enhanced.sql)             | Each record represents a piece of feedback (ie a score along a given standard) given by an interviewer to a unique opportunity.  |
| [lever__opportunity_enhanced](https://github.com/fivetran/dbt_lever/blob/master/models/lever__opportunity_enhanced.sql)             | beep beep |
| [lever__posting_enhanced](https://github.com/fivetran/dbt_lever/blob/master/models/lever__posting_enhanced.sql)             | beep beep |
| [lever__requisition_enhanced](https://github.com/fivetran/dbt_lever/blob/master/models/lever__requisition_enhanced.sql)             | beep beep |
| [lever__opportunity_stage_history](https://github.com/fivetran/dbt_lever/blob/master/models/lever__opportunity_stage_history.sql)             | beep beep |


## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration
By default, this package looks for your Lever data in the `lever` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Lever data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    lever_database: your_database_name
    lever_schema: your_schema_name 
```

### Passing Through Custom Requisition Columns
The `REQUISITION` table may have custom columns (all prefixed by `custom_field_`). To pass these columns through to the `lever__requisition_enhanced`model, add the following variable to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
  lever_source:
    lever_requisition_passthrough_columns: ['the', 'list', 'of', 'fields']
```

## Contributions
Don't see a model or specific metric you would have liked to be included? Notice any bugs when installing 
and running the package? If so, we highly encourage and welcome contributions to this package! 
Please create issues or open PRs against `master`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Database Support
This package has been tested on BigQuery, Snowflake and Redshift.
Coming soon -- compatibility with Spark

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [here](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate dbt transformations with Fivetran [here](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
