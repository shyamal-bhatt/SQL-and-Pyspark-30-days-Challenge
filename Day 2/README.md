# 🚀 Day 2 of the 30-Day SQL and PySpark Challenge: Let’s Measure Churn! 🎯

Welcome to **Day 2** of the challenge! Today’s problem is all about understanding customer behavior by calculating the **monthly churn rate** for a subscription-based video streaming service, **StreamBee**. This is a critical metric for subscription-based businesses, helping them gauge customer retention and identify areas for improvement.

---

## **Business Scenario**

**StreamBee** provides a subscription-based video streaming service. They want to measure their **monthly churn rate** to better understand customer behavior and improve retention strategies.  

A customer is considered **churned** if they cancel (or their subscription ends) in a specific month and do not renew at any time during or immediately after that month.

You’ve been provided with the following datasets:

1. **`customers` table**: Contains customer information, including their subscription start and end dates.  
   - Columns: `customer_id`, `signup_date`, `churn_date`

2. **`monthly_subscription` table**: Tracks which customers had an active subscription in a specific month.  
   - Columns: `customer_id`, `month`

---

## **Tasks**

1. **Identify Active Customers at the Start of Each Month**  
   - For each month in the data, calculate the total number of customers who had an active subscription at the start of the month.  
   - An active customer is defined as someone who:
     - Subscribed before the month started and:
     - Either has no churn date or a churn date after the start of the month.

2. **Calculate Monthly Churn Rate**  
   - For each month, calculate the churn rate using the formula:  
$\large Churn Rate = \frac{Number of churned customers in month}{Number of customers at the start of the month} * 100\%$

---

## **Key Considerations**

- **Definition of Churn**:  
  A customer is considered churned if they were active at the start of a month but do not have an active subscription in the next month.  
  This could mean their subscription ended, and they did not renew.

- **Handling Edge Cases**:  
  - Customers with no `churn_date` should be considered active.  
  - If a customer churns and re-subscribes in the same month, they are **not** considered churned for that month.

- **SQL vs. PySpark**:  
  - Write a query to calculate churn using **SQL**.  
  - Create an equivalent solution using **PySpark** in Databricks to handle larger datasets efficiently.

---

### SQL Code Explanation for Churn Rate Calculation

#### 1. **Count Active Customers at the Start of Each Month**

```sql
SELECT 
    month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM 
    monthly_subscription
WHERE 
    subscription_active = 1
GROUP BY 
    month
ORDER BY 
    month;
```

**Purpose:** This query counts the number of distinct active customers at the beginning of each month.

**Explanation:**

* We select the `month` and the `customer_id` columns.
* The `COUNT(DISTINCT customer_id)` function is used to count unique active customers.
* The `WHERE subscription_active = 1` ensures that we only consider customers who were active during the month.
* The `GROUP BY` month groups the results by each month.
* `ORDER BY` month sorts the results by the month.

---

#### 2. Calculate Churn Rate

```sql
WITH active_customers_per_month AS (
    SELECT 
        month,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM 
        monthly_subscription
    WHERE 
        subscription_active = 1
    GROUP BY 
        month
),
churned_customers AS (
    SELECT 
        ms1.month AS current_month,
        ms2.month AS last_month,
        ms1.customer_id
    FROM 
        monthly_subscription ms1
    LEFT JOIN 
        monthly_subscription ms2 
        ON ms1.customer_id = ms2.customer_id 
        AND ms1.month = DATE_ADD(ms2.month, INTERVAL 1 MONTH)
    WHERE 
        ms2.customer_id IS NULL
),
churn_count_per_month AS (
    SELECT 
        current_month AS month,
        COUNT(DISTINCT customer_id) AS churned_customers
    FROM 
        churned_customers
    GROUP BY 
        current_month
)
SELECT 
    acpm.month,
    acpm.active_customers,
    cpm.churned_customers,
    ROUND((cpm.churned_customers * 100.0 / acpm.active_customers), 2) AS churn_rate
FROM 
    active_customers_per_month acpm
LEFT JOIN 
    churn_count_per_month cpm
    ON acpm.month = cpm.month
ORDER BY 
    acpm.month;
```

**Purpose:** This query calculates the churn rate for each month, which is the percentage of churned customers compared to the active customers at the start of the month.

**Explanation:**

1. **Active Customers per Month:**

* The `active_customers_per_month` CTE counts the active customers at the start of each month (using `COUNT(DISTINCT customer_id)` for each month).

2. **Churned Customers:**

* The `churned_customers` CTE identifies customers who were active in the previous month but not the current month using the same logic as in the churn identification query.

3. **Count Churned Customers per Month:**

* The `churn_count_per_month` CTE calculates the total number of churned customers for each month.

4. **Final Calculation:**

* The main query combines the active customer count (acpm) and churned customer count (cpm) using a `LEFT JOIN`.
* The churn rate is calculated by dividing the number of churned customers by the number of active customers at the start of the month and multiplying by 100 to get the percentage.
* The `ROUND` function is used to format the churn rate to two decimal places.

**Result:** The results are ordered by month, showing the active customers, churned customers, and churn rate for each month.