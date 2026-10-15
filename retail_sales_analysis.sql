
SELECT *
FROM public.online_retail
LIMIT 10;



SELECT
    MIN(invoice_date) AS first_transaction,
    MAX(invoice_date) AS last_transaction
FROM public.online_retail;



SELECT
    COUNT(*) FILTER (WHERE invoice_no IS NULL) AS missing_invoice,
    COUNT(*) FILTER (WHERE stock_code IS NULL) AS missing_stock_code,
    COUNT(*) FILTER (WHERE description IS NULL) AS missing_description,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS missing_quantity,
    COUNT(*) FILTER (WHERE invoice_date IS NULL) AS missing_date,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS missing_price,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer,
    COUNT(*) FILTER (WHERE country IS NULL) AS missing_country
FROM public.online_retail;




SELECT
    COUNT(*) AS duplicate_groups,
    SUM(record_count - 1) AS extra_duplicate_rows
FROM (
    SELECT COUNT(*) AS record_count
    FROM public.online_retail
    GROUP BY
        invoice_no, stock_code, description, quantity,
        invoice_date, unit_price, customer_id, country
    HAVING COUNT(*) > 1
) AS duplicates;




SELECT
    COUNT(*) FILTER (
        WHERE invoice_no LIKE 'C%'
    ) AS cancelled_invoice_rows,
    COUNT(*) FILTER (
        WHERE quantity < 0
    ) AS negative_quantity_rows,
    COUNT(*) FILTER (
        WHERE unit_price <= 0
    ) AS zero_or_negative_price_rows
FROM public.online_retail;




SELECT
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT stock_code) AS unique_products,
    COUNT(DISTINCT country) AS countries
FROM public.online_retail;


SELECT
    COUNT(*) AS duplicate_groups,
    SUM(record_count - 1) AS extra_duplicate_rows
FROM (
    SELECT COUNT(*) AS record_count
    FROM public.online_retail
    GROUP BY
        invoice_no,
        stock_code,
        description,
        quantity,
        invoice_date,
        unit_price,
        customer_id,
        country
    HAVING COUNT(*) > 1
) AS duplicates;



SELECT
    COUNT(*) FILTER (
        WHERE invoice_no LIKE 'C%'
    ) AS cancelled_invoice_rows,
    COUNT(*) FILTER (
        WHERE quantity < 0
    ) AS negative_quantity_rows,
    COUNT(*) FILTER (
        WHERE unit_price <= 0
    ) AS zero_or_negative_price_rows
FROM public.online_retail;

SELECT 
COUNT(DISTINCT customer_id) AS unique_customers,
COUNT(DISTINCT stock_code) AS unique_products,
COUNT(DISTINCT country) AS countries
FROM public.online_retail;




SELECT
    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_ids,
    COUNT(*) FILTER (
        WHERE description IS NULL
    ) AS missing_descriptions,
    COUNT(*) AS total_rows
FROM public.online_retail;



SELECT
    COUNT(*) FILTER (
        WHERE unit_price = 0
    ) AS zero_price_rows,
    COUNT(*) FILTER (
        WHERE unit_price < 0
    ) AS negative_price_rows,
    MIN(unit_price) AS minimum_price,
    MAX(unit_price) AS maximum_price
FROM public.online_retail;


SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    unit_price,
    customer_id
FROM public.online_retail
WHERE invoice_no LIKE 'C%'
LIMIT 10;


SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id
FROM public.online_retail
ORDER BY unit_price DESC
LIMIT 15;



SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    unit_price
FROM public.online_retail
WHERE unit_price <= 0
ORDER BY unit_price
LIMIT 20;



SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    COUNT(*) AS occurrences
FROM public.online_retail
GROUP BY
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC
LIMIT 20;



-- ============================================
-- SECTION 3: STANDARD SALES ANALYSIS VIEW
-- ============================================

CREATE OR REPLACE VIEW standard_sales AS
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    quantity * unit_price AS line_revenue


	
FROM public.online_retail
WHERE invoice_no NOT LIKE 'C%'
  AND quantity > 0
  AND unit_price > 0
  AND description IS NOT NULL
  AND stock_code NOT IN ('AMAZONFEE', 'POST', 'D', 'M', 'B');


SELECT COUNT(*) 
FROM public.online_retail;


SELECT COUNT(*)
FROM public.standard_sales;



SELECT
    ROUND(SUM(line_revenue), 2) AS total_sales_revenue
FROM standard_sales;




-- Monthly sales revenue
SELECT
    DATE_TRUNC('month', invoice_date)::DATE AS sales_month,
    ROUND(SUM(line_revenue), 2) AS monthly_revenue,
    COUNT(DISTINCT invoice_no) AS total_invoices
FROM standard_sales
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY sales_month;




SELECT
    TO_CHAR(sales_month, 'Mon YYYY') AS month,
    monthly_revenue,
    total_invoices
FROM (
    SELECT
        DATE_TRUNC('month', invoice_date)::DATE AS sales_month,
        ROUND(SUM(line_revenue), 2) AS monthly_revenue,
        COUNT(DISTINCT invoice_no) AS total_invoices
    FROM standard_sales
    GROUP BY DATE_TRUNC('month', invoice_date)
) AS monthly_sales
ORDER BY monthly_revenue DESC;





-- Top 10 products by revenue
SELECT
    stock_code,
    description,
    SUM(quantity) AS units_sold,
    ROUND(SUM(line_revenue), 2) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS invoices
FROM standard_sales
GROUP BY stock_code, description
ORDER BY total_revenue DESC
LIMIT 10;




-- Top 10 physical product groups by revenue
SELECT
    stock_code,
    description,
    SUM(quantity) AS units_sold,
    ROUND(SUM(line_revenue), 2) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS invoices
FROM standard_sales
WHERE stock_code NOT IN ('DOT', 'POST', 'D', 'M', 'B', 'AMAZONFEE')
GROUP BY stock_code, description
ORDER BY total_revenue DESC
LIMIT 10;






-- Top 10 customers by revenue
SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS total_invoices,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM standard_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;






-- Revenue by country
SELECT
    country,
    COUNT(DISTINCT invoice_no) AS total_invoices,
    ROUND(SUM(line_revenue), 2) AS total_revenue,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM standard_sales
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;




-- Finalize the standard sales analysis view

CREATE OR REPLACE VIEW standard_sales AS
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    quantity * unit_price AS line_revenue
FROM public.online_retail
WHERE invoice_no NOT LIKE 'C%'
  AND quantity > 0
  AND unit_price > 0
  AND description IS NOT NULL
  AND stock_code NOT IN (
      'DOT', 'AMAZONFEE', 'POST', 'D', 'M', 'B'
  );






  
SELECT
    COUNT(*) AS included_rows,
    ROUND(SUM(line_revenue), 2) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS invoice_count
FROM standard_sales;








