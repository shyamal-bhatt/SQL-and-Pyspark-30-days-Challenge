# **Problem Statement and Questions**

## **Problem Statement**
The task is to calculate the **Annual Recurring Revenue (ARR)** for a SaaS company. ARR is an important financial metric representing the annualized revenue generated from recurring (subscription-based) products. It provides a snapshot of recurring revenues at a precise moment in time.

### Key Details:
1. **ARR Formula**:
   The ARR is calculated using the simplified formula:
   
   $\text{ARR} = \left( \frac{\text{Recurring Amount of Invoice}}{\text{Days of Validity of Invoice}} \right) \times 365
   \$
   
2. **Guidelines**:
   - Include **only recurring items** in the ARR calculation (ignore one-shot products).
   - Convert all amounts to **USD** using the exchange rate on the invoice date.
   - **Credit Notes** are invoices with negative amounts and must be included in the calculation.
   - The ARR is a **snapshot** at a specific moment in time.

### Questions Asked:
1. Calculate the ARR on **January 28, 2020**.
2. Calculate the ARR for the **last day of each month** between June and December 2019 (inclusive) in a single query.

---

# **Solution Explanation**

The solution involves writing SQL queries to calculate the ARR as per the formula. Below are the detailed steps:

## **Step-by-Step Explanation**

### 1. **Understand the Schema**
   - **Billing Table**: Contains invoice information, including `billing_type`, `invoice_date`, and `currency`.
   - **Item Table**: Contains product details, including `amount`, `type` (recurring or one-shot), and validity period (`valid_from`, `valid_to`).
   - **Exchange Table**: Contains exchange rates for converting currencies to USD for a specific `date`.

### 2. **Filter Relevant Data**
   - Select **recurring items** (`type = 'recurring'`) that are **valid** for the specified date(s):
     - Validity is checked using:
       \[
       \text{valid\_from} \leq \text{date} \leq \text{valid\_to}
       \]

### 3. **Join Tables**
   - Join the `Item`, `Billing`, and `Exchange` tables to associate:
     - `billing_id` in `Item` with `id` in `Billing`.
     - `currency` in `Billing` with `from_currency` in `Exchange` on the `invoice_date`.

### 4. **Calculate Days of Validity**
   - Compute the number of valid days for each recurring item:
     \[
     \text{Days Validity} = \text{valid\_to} - \text{valid\_from}
     \]

### 5. **Apply ARR Formula**
   - For each recurring item, calculate ARR in USD:
     \[
     \text{ARR (USD)} = \left( \frac{\text{amount}}{\text{Days Validity}} \right) \times 365 \times \text{exchange\_rate}
     \]

### 6. **Aggregate ARR**
   - Sum the ARR values of all valid recurring items for:
     - A single snapshot date (`2020-01-28`).
     - Each last day of the month from June to December 2019.

---

## **SQL Queries**

### Query 1: ARR on January 28, 2020
```sql
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
```

### Query 2: ARR on the last day of each month between june and dec 2019
```sql
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
```
