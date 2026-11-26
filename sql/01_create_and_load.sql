--create database BankComplaints;
--Go
use BankComplaints;
Go

--bulk insert dbo.complaints
--from 'C:\SQLData\bank_clean.csv'
--with (
--	format = 'CSV',
--	firstrow = 2,
--	FIELDQUOTE  = '"',
--	rowterminator = '0x0d0a',
--	CODEPAGE = '65001',
--	TABLOCK
--);

Select count(*) as total_rows

from dbo.complaints

SELECT
    COUNT(*) - COUNT(tags)                    AS tags_null,
    COUNT(*) - COUNT(company_public_response) AS public_response_null,
    COUNT(*) - COUNT(state)                   AS state_null,
    COUNT(*) - COUNT(sub_issue)               AS sub_issue_null,
    COUNT(*) - COUNT(company)                 AS company_null,
    COUNT(*) - COUNT(narrative)               AS narrative_null
FROM dbo.complaints;

select min(date_received) as first_day,
    max(date_received) as last_day
from dbo.complaints

select max(len(narrative)) as longest
from dbo.complaints

select top 5 complaint_id, date_received,company, issue,got_relief

from dbo.complaints

