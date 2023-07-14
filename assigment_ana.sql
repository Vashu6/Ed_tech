create database assi;
use assi

select * from [dbo].[leads_demo_watched_details]

select * from [dbo].[leads_basic_details]

select * from [dbo].[leads_interaction_details]

select * from [dbo].[leads_reasons_for_no_interest]

select * from [dbo].[sales_managers_assigned_leads_details]

--How many leads are generated monthly?
SELECT
    MONTH(call_done_date) AS Mont,
    COUNT(distinct(lead_id)) AS LeadsGenerated
FROM
    [dbo].[leads_interaction_details]
GROUP BY
    MONTH(call_done_date)
ORDER BY
    Mont;

--Fill NULL to N/A

SELECT
    (COUNT(*) *100.0)  AS ConversionRate
FROM
    [dbo].[leads_demo_watched_details];

UPDATE [dbo].[leads_reasons_for_no_interest]
SET  [reasons_for_not_interested_in_demo]= COALESCE([reasons_for_not_interested_in_demo], 'N/A'),
     [reasons_for_not_interested_to_consider]= COALESCE([reasons_for_not_interested_to_consider], 'N/A'),
     [reasons_for_not_interested_to_convert]= COALESCE([reasons_for_not_interested_to_convert], 'N/A')
WHERE  [reasons_for_not_interested_in_demo] IS NULL OR [reasons_for_not_interested_to_consider] IS NULL OR [reasons_for_not_interested_to_convert] IS NULL;


--What is the conversion rate from leads to enrolled users?
SELECT COUNT(*)*100.0 /(SELECT
    COUNT(*) FROM
    [dbo].[leads_basic_details])
FROM [dbo].[leads_interaction_details]
	where lead_stage='conversion'


---How long does it take for a lead to convert into an enrolled user?

with ct1 as(SELECT
    lead_id,
    DATEDIFF(day, MIN(CASE WHEN lead_stage = 'lead' THEN call_done_date END), MIN(CASE WHEN lead_stage = 'conversion' THEN call_done_date END)) AS ConversionTime
FROM
    [dbo].[leads_interaction_details]
WHERE
    lead_stage IN ('lead', 'conversion')
GROUP BY
    lead_id)

select avg(ConversionTime) as Average_Conversion_day 
from ct1
where ConversionTime is not NULL


---What is the average conversion rate for each team member?
SELECT
    jnr_sm_id,
    count(CASE WHEN lead_stage = 'conversion' THEN call_done_date END)* 100 / count(CASE WHEN lead_stage = 'lead' THEN 1 END) AS ConversionTime
FROM
    [dbo].[leads_interaction_details]
WHERE
    lead_stage IN ('lead', 'conversion')
GROUP BY
    jnr_sm_id
order by jnr_sm_id





