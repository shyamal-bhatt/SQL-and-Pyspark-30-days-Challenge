WITH RecurringItems AS (
    SELECT 
        i.id AS item_id,
        i.billing_id,
        i.amount,
        DATEDIFF(i.valid_to, i.valid_from) AS days_validity,
        e.exchange_rate,
        b.billing_type,
        b.invoice_date,
        b.currency
    FROM 
        Item i
    JOIN 
        Billing b ON i.billing_id = b.id
    JOIN 
        Exchange e ON b.currency = e.from_currency AND b.invoice_date = e.date
    WHERE 
        i.type = 'recurring' 
        AND '2020-01-28' BETWEEN i.valid_from AND i.valid_to
)
SELECT 
    ROUND(SUM((amount / days_validity) * 365 * exchange_rate), 2) AS ARR_USD
FROM 
    RecurringItems
WHERE 
    billing_type = 'invoice';
