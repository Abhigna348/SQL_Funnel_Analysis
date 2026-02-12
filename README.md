# SQL_Funnel_Analysis

This project analyzes a 30-day user journey and revenue funnel using Google BigQuery. It provides insights into user behavior, conversion rates, revenue per user, and the efficiency of different traffic sources.

---

## Project Objective

The goal of this project is to understand the e-commerce sales funnel, identify bottlenecks in user conversion, and evaluate revenue metrics across users and traffic sources. Key objectives include:

- Measuring user progression through the sales funnel.
- Calculating conversion rates at each stage.
- Analyzing funnel performance by traffic source.
- Evaluating time-to-conversion for users.
- Assessing revenue generation and efficiency per user and per order.

---

## Sales Funnel Stages

1. **Page View** – Users who visit the website.  
2. **Add to Cart** – Users who add a product to the cart.  
3. **Checkout Start** – Users who begin the checkout process.  
4. **Payment Info** – Users who enter payment information.  
5. **Purchase** – Users who complete a purchase.

---

## SQL Queries

All SQL scripts are stored in the `queries/` folder:

- **`funnel_stages.sql`**: Computes total users at each stage of the sales funnel.  
- **`funnel_conversion_rates.sql`**: Calculates conversion rates between funnel stages and overall conversion.  
- **`funnel_source.sql`**: Analyzes funnel performance by traffic source (views, carts, purchases, conversion rates).  
- **`user_journey.sql`**: Computes average time (in minutes) from view → cart → purchase for converted users.  
- **`funnel_revenue.sql`**: Aggregates total viewers, buyers, revenue, and orders; calculates revenue per buyer, per order, and per visitor.

---

## Key Metrics

- **Stage-wise counts**: Users at each stage of the funnel.  
- **Conversion rates**: Between each stage and overall.  
- **Source-level analysis**: Traffic source performance for cart and purchase conversion.  
- **Time to conversion**: Average minutes from first page view to purchase.  
- **Revenue metrics**:  
  - Revenue per buyer  
  - Revenue per order  
  - Revenue per visitor  

---

##  Insights

| Metric | Value |
|--------|-------|
| Total Viewers | 3040 |
| Total Buyers | 492 |
| Total Orders | 492 |
| Total Revenue | $52,560 |
| Revenue per Buyer | $106.8|
| Revenue per Order | $106.8 |
| Revenue per Visitor | $17.28 |
| Avg View → Cart Time | 11.23 mins |
| Avg Cart → Purchase Time | 13.24 mins |
| Avg Total Journey | 24.47 mins |
| Overall Conversion Rate | 16% |


---

## Tools Used

- **Google BigQuery** – Data storage and SQL analytics.  
- **SQL** – Data querying and aggregation.

---


