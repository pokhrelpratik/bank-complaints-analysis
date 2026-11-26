# Bank Complaints Analysis (CFPB, Nov–Dec 2025)

**Status:** in progress. Done: data cleaning (pandas), SQL analysis, Power BI dashboard. Next: AI classification of complaint narratives (Q5).

## Data
- Source: CFPB Consumer Complaint Database narratives archive (FOIA reading room)
- Filter: Credit card + Checking or savings account, with narrative → 13,665 complaints
- Note: CFPB stopped publishing narratives on Aug 14, 2026. Narratives are unverified, consumer-side accounts.

## Business questions

1. Which banks (300+ complaints) resolve complaints with relief most and least often?
   - Metric: relief % (got_relief) by company, banks with 300+ complaints only
   - Who cares: a bank's complaints team benchmarking against competitors

2. Which issues drive credit card vs checking complaints, and which issues most often end with money back?
   - Metric: complaint count and money-relief % (got_money) by product and issue
   - Who cares: a product owner deciding which problem to fix first

3. Do Servicemember and Older American complaints get relief at the same rate as everyone else?
   - Metric: relief % by tag group (none / Servicemember / Older American / both)
   - Who cares: a compliance team checking fair treatment of protected groups

4. How does complaint volume change week by week over Nov–Dec 2025, and which banks spike during the holiday season?
   - Metric: weekly complaint count, overall and by company
   - Who cares: an operations manager planning complaint-team staffing

5. What are customers actually complaining about inside "Managing an account", the biggest and vaguest issue?
   - Metric: share of narratives in each AI-assigned category (fraud/scam, frozen or closed account, fees, access/login, other),
     plus the AI's accuracy against 200 complaints I labelled by hand
   - Who cares: a risk or fraud team who can't act on a label as broad as "managing an account"

## Data cleaning log
| Step | Rows in | Rows out | Why |
|---|---|---|---|
| Load Nov–Dec 2025 archive | — | 1,009,132 | Aug 2026 file had 1 narrative (CFPB stopped publishing) |
| Keep credit card + checking/savings with narrative | 1,009,132 | 13,665 | Questions are about banks; AI part needs text |
| Duplicate Complaint IDs | 13,665 | 13,665 | 0 found |
| Missing values | 13,665 | 13,665 | Tags blank = not tagged; others not used or small; no rows dropped |

## Data quality issue found
Daily narrative counts drop to near zero on several weekdays (e.g. Dec 11: 5, Dec 12: 7, Dec 17: 12),
while total complaints filed those days stay normal (~600/day). The CFPB did not publish narratives
for those days. Weekly volume trends from this dataset are therefore unreliable.
- Q4 (weekly volume): on hold. Volume needs all complaints (with or without narrative), not just ones with text.

## Findings

![Power BI dashboard](charts/dashboard.png)

1. **Citibank and Bank of America close complaints with relief 2-3x as often as Chase and Capital One**
   (44.5% and 38.6% vs 16.1% and 17.0%). The gap holds within each product (credit card: Citi 45.0% vs Chase 20.9%;
   checking: 42.8% vs 12.8%), so it is not a product-mix effect. Block, Inc. gave relief on 0 of 419 complaints.
2. **Credit card fees and interest get money back most often (31.3%)**, then disputed purchases (23.5%).
   A fee is a clear amount a bank can reverse. The largest issue, "Managing an account" (3,836 complaints),
   gets money back only 12.8%.
3. **Servicemember and Older American complaints get relief at about the same rate as everyone else (22-26%).**
   The highest group (Older American + Servicemember, 25.7%) has only 210 complaints, so the gap is within noise.

**Limits:** complaints are unverified, consumer-side accounts and only include people who chose to publish a narrative.
Results describe complaint outcomes, not overall bank quality or why each decision was made.
