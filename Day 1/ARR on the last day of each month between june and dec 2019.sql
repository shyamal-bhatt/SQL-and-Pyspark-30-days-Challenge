WITH RecurringItems AS (
    SELECT 
        i.id AS item_id,
        i.billing_id,
        i.amount,
        DATEDIFF(i.valid_to, i.valid_from) AS days_validity,
        e.exchange_rate,
        b.billing_type,
        b.invoice_date,
        b.currency,
        LAST_DAY(DATE_ADD('2019-06-01', INTERVAL n.num MONTH)) AS arr_date
    FROM 
        Item i
    JOIN 
        Billing b ON i.billing_id = b.id
    JOIN 
        Exchange e ON b.currency = e.from_currency AND b.invoice_date = e.date
    CROSS JOIN (
        SELECT 0 AS num UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 
        UNION SELECT 4 UNION SELECT 5 UNION SELECT 6
    ) n
    WHERE 
        i.type = 'recurring' 
        AND LAST_DAY(DATE_ADD('2019-06-01', INTERVAL n.num MONTH)) BETWEEN i.valid_from AND i.valid_to
)
SELECT 
    arr_date,
    ROUND(SUM((amount / days_validity) * 365 * exchange_rate), 2) AS ARR_USD
FROM 
    RecurringItems
WHERE 
    billing_type = 'invoice'
GROUP BY 
    arr_date
ORDER BY 
    arr_date;
