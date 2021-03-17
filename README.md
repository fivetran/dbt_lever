# Lever [(docs)](https://pensive-murdock-e1bb8a.netlify.app/#!/overview)

This package models Lever data from [Fivetran's Opportunity endpoint connector](https://fivetran.com/docs/applications/lever). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/lever#schemainformation).
> NOTE: If your Lever connector was created [prior to July 2020](https://fivetran.com/docs/applications/lever/changelog) or still uses the Candidate endpoint, you must fully re-sync your connector or set up a new connector to use Fivetran's Lever dbt packages.

This package enables you to understand trends in recruiting, interviewing, and hiring at your company. It also provides recruiting stakeholders with information about individual opportunities, interviews, and jobs. It achieves this by:
- Enriching the core opportunity, interview, job posting, and requisition tables with relevant pipeline data and metrics
- Integrating the interview table with reviewer information and feedback
- Calculating the velocity of opportunities through each pipeline stage, along with major job- and candidate-related attributes for segmented funnel analysis

## Models

This package contains transformation models, designed to work simultaneously with our [Lever source package](https://github.com/fivetran/dbt_lever_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models.

| **model**                | **description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [lever__interview_enhanced](https://github.com/fivetran/dbt_lever/blob/master/models/lever__interview_enhanced.sql)             | Each record represents a score that an interviewer gives to a unique interviewee. Includes data around the employees involved in this interview/opportunity, the interview feedback score standards, whether the opportunity advanced past this interview, how long the opportunity had been open at the time of the interview, and the opportunity source. |
| [lever__opportunity_enhanced](https://github.com/fivetran/dbt_lever/blob/master/models/lever__opportunity_enhanced.sql)             | Each record represents a unique opportunity, enhanced with data about its associated job posting, requisition, application, origins, tags, resume links, contact information, current pipeline stage, offer status, and the position that the candidate applied for. Also includes interview metrics and how early the candidate applied relative to other candidates. |
| [lever__posting_enhanced](https://github.com/fivetran/dbt_lever/blob/master/models/lever__posting_enhanced.sql)             | Each record represents a unique job posting, enriched with metrics about submitted applications, total and open opportunities, interviews conducted, and associated requisitions. Also includes the job posting's tags and hiring manager. |
| [lever__requisition_enhanced](https://github.com/fivetran/dbt_lever/blob/master/models/lever__requisition_enhanced.sql)             | Each record represents a unique job requisition, enriched with information about the requisition's hiring manager, owner, offers extended, and associated job postings. |
| [lever__opportunity_stage_history](https://github.com/fivetran/dbt_lever/blob/master/models/lever__opportunity_stage_history.sql)             | Each record represents a stage that an opportunity has advanced to. Includes data about the time spent in each stage, the application source, the hiring manager, and the opportunity's owner, as well as the job's team, location, and department. |

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

### Disabling Models
Your Lever connector might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Lever or have actively excluded some tables from your syncs. To disable the corresponding functionality in the package, you must set the relevant config variables to `false`. By default, all variables are set to `true`. Alter variables for only the tables you want to disable:

```yml
# dbt_project.yml
...
config-version: 2

vars:
    lever_using_requisitions: false # Disable if you do not have the requisition table, or if you do not want requisition related metrics reported
    lever_using_posting_tag: false # disable if you do not have (or want) the postings tag table
```

### Passing Through Custom Requisition Columns
If you choose to include requisitions, the `REQUISITION` table may also have custom columns (all prefixed by `custom_field_`). To pass these columns through to the [enhanced requisition model](https://github.com/fivetran/dbt_lever/blob/master/models/lever__requisition_enhanced.sql), add the following variable to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    lever_requisition_passthrough_columns: ['the', 'list', 'of', 'fields']
```

## Contributions
Don't see a model or specific metric you would have liked to be included? Notice any bugs when installing 
and running the package? If so, we highly encourage and welcome contributions to this package! 
Please create issues or open PRs against `master`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Database Support
This package has been tested on BigQuery, Snowflake and Redshift.

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
