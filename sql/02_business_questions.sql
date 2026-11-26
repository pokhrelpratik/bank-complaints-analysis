--Q1:  Relief rate by bank (banks with 300+ complaints)
select 
	company,
	count(*) as complaints,
	round(avg(CAST(got_relief as float)) * 100,1) as relief_pct,
	round(avg(cast(got_money as float)) * 100,1) as money_pct
from dbo.complaints
group by company
having COUNT(*) >=300
order by relief_pct desc; 

--Q1b: Is Citi really "better" or is it just the product mix?
select 
	company,
	product,
	count(*) as complaints,
	round(avg(cast(got_relief as float))*100,1) as relief_pct
from dbo.complaints
where company in ('CITIBANK, N.A.','JPMORGAN CHASE & CO.','CAPITAL ONE FINANCIAL CORPORATION','BANK OF AMERICA, NATIONAL ASSOCIATION')
group by company, product
order by product, relief_pct desc;

-- Finding Q1: Citibank (44.5%) and Bank of America (38.6%) close complaints with relief far more often than
-- Chase (16.1%) and Capital One (17.0%). Block, Inc. gave relief on 0 of 419 complaints.
-- Q1b: the gap holds within each product (credit card: Citi 45.0% vs Chase 20.9%; checking: 42.8% vs 12.8%),
-- so it is not explained by Citi having more credit card complaints.
-- Limit: complaints are unverified and one-sided; this shows outcomes, not why banks decided them.

--Q2: Complaints and money-back rate by product and issue (100+ complaints)
select 
	product,
	issue,
	count(*) as complaints,
	round(avg(cast(got_money as float)) * 100, 1) as money_pct
from dbo.complaints
group by product, issue
having count(*) >=100
order by money_pct desc;

-- Finding Q2: Credit card fees/interest get money back most often (31.3% of 837 complaints), then disputed
-- purchases (23.5% of 2,060). Likely because a fee or charge is a clear amount the bank can simply reverse.
-- The biggest issue by volume, "Managing an account" (checking, 3,836 complaints), gets money back only 12.8%.
-- Lowest: "Incorrect information on your report" (1.4%) and "Getting a credit card" (3.2%), where there is no charge to refund.

--Q3: Relief rate by Tag group 
select 
	ISNULL(tags,'None') as tag_group,
	count(*) as complaints,
	round(avg(CAST(got_relief as float))*100,1) as relief_pct
from dbo.complaints
group by ISNULL(tags,'None')
order by relief_pct desc;

-- Finding Q3: Relief rates are close across groups: Older American + Servicemember 25.7% (only 210 complaints),
-- Older American 23.6% (931), Servicemember 22.4% (1,261), untagged 22.4% (11,263).
-- The highest group is the smallest, so a few complaints move it 2-3 points: no clear sign of different treatment.

--Q4: Complaints per week, with days counted to spot partial weeks
select 
	DATETRUNC(ISO_WEEK,date_received) as week_start,
	count(*) as complaints,
	count(distinct date_received) as days_in_data,
	round(cast(count(*) as float)/ count(distinct date_received),1) as per_day
from dbo.complaints
group by DATETRUNC(ISO_WEEK,date_received)
order by week_start;

--Q4b: Why is the week of Dec 8 low? (daily counts)
select 
	date_received,
	count(*)	as complaints
from dbo.complaints
where date_received between '2025-12-01' AND '2025-12-20'
group by date_received
order by date_received;

-- Q4 (weekly volume): on hold. Narratives missing on several days (e.g. Dec 11: 5), so volume needs all complaints, not just ones with text.
