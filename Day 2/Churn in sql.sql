-- Count Active Customers at the Start of Each Month
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

-- Calculate Churn Rate
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

