# dbt_lever v0.7.0
[PR #21](https://github.com/fivetran/dbt_lever/pull/21) includes the following updates:
## Features
- For Fivetran Lever connectors created on or after July 27, 2024, the `USER` and `INTERVIEWER_USER` source tables have been renamed to `USERS` and `INTERVIEW_USER`, respectively. This package now prioritizes the `USERS` and `INTERVIEW_USER` tables if available, falling back to `USER` and `INTERVIEWER_USER` if not.
  - To continue using the `USER` and/or `INTERVIEWER_USER` tables, set the variables `lever__using_users` and/or `lever__using_interview_user` to false in your `dbt_project.yml`.
  - For more information, refer to the [July 2024 connector release notes](https://fivetran.com/docs/connectors/applications/lever/changelog#july2024) and the related [README section](https://github.com/fivetran/dbt_lever/blob/main/README.md##leveraging-legacy-connector-table-names).

- Introduced the ability to union source data from multiple Lever connectors. For more details, see the related [README section](https://github.com/fivetran/dbt_lever/blob/main/README.md#union-multiple-connectors).

## Bug fixes
- Fixed an issue where the dbt package would error due to a missing `CONTACT_LINK` source table for users without source data, even though it was enabled in the Fivetran Connector. A null-filled table will now be generated in such cases.

## Under the hood
- In the source package, updated temporary models to union source data using the `fivetran_utils.union_data` macro.
- Added the `source_relation` column in each staging model to identify the origin of each field, utilizing the `fivetran_utils.source_relation` macro.
- Updated tests to include the new `source_relation` column.
- Included the `source_relation` column in all joins and window function partition clauses in the transform package.

# dbt_lever v0.6.0
## 🎉 Feature Update 🎉
- PostgreSQL and Databricks compatibility! ([#18](https://github.com/fivetran/dbt_lever/pull/18))

## 🚘 Under the Hood 🚘
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([#16](https://github.com/fivetran/dbt_lever/pull/16))
- Updated the pull request [templates](/.github). ([#16](https://github.com/fivetran/dbt_lever/pull/16))

# dbt_lever v0.5.0

## 🚨 Breaking Changes 🚨:
[PR #14](https://github.com/fivetran/dbt_lever/pull/14) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_lever v0.4.0
## 🎉 Documentation and Feature Updates
- Updated README documentation updates for easier navigation and setup of the dbt package. ([#13](https://github.com/fivetran/dbt_lever/pull/13))
- Included `lever_[source_table_name]_identifier` variable within the Lever source package for additional flexibility within the package when source tables are named differently. ([#13](https://github.com/fivetran/dbt_lever/pull/13))
# dbt_lever v0.3.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_lever_source`. Additionally, the latest `dbt_lever_source` package has a dependency on the latest `dbt_fivetran_utils`. Further, the latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_lever v0.1.0 -> v0.2.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!
