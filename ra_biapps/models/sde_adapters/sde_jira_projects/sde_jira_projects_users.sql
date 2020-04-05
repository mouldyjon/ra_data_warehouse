with users as (SELECT
  *
  FROM (
  SELECT
    'jira_projects'               as source,
    concat('jira-',key)           as user_id,
    displayname                   as user_name  ,
    emailaddress                  as user_email,
    cast(null as boolean)         as user_is_contractor,
    case when emailaddress like '%@rittmananalytics.com%' or emailaddress like '%mjr-analytics.com%' then true else false end as user_is_staff,
    cast(null as int64)           as user_weekly_capacity,
    cast(null as string)          as user_phone,
    cast(null as int64)           as user_default_hourly_rate,
    cast(null as int64)           as user_cost_rate,
    active                        as user_is_active,
    cast(null as timestamp)       as user_created_ts,
    cast(null as timestamp)       as user_last_modified_ts,
    _sdc_batched_at,
    MAX(_sdc_batched_at) OVER (PARTITION BY key ORDER BY _sdc_batched_at RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_sdc_batched_at
  FROM
    {{ source('jira', 'users') }})
WHERE
  _sdc_batched_at = max_sdc_batched_at)
select u.* except (_sdc_batched_at, max_sdc_batched_at)
from users u
where user_id not like '%addon%'