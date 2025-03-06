-- 2
SELECT 
    e1.employee_id,
    CONCAT(e1.first_name, ' ', e1.last_name) AS full_name,
    e1.title,
    e1.reports_to AS manager_id,
    CONCAT(e2.first_name, ' ', e2.last_name) AS manager_full_name,
    e2.title AS manager_title
FROM 
    employee e1
LEFT JOIN 
    employee e2 ON e1.reports_to = e2.employee_id;


-- 2
SELECT 
    invoice_id,
    invoice_date,
    TO_CHAR(invoice_date, 'YYYYMM')::INT AS monthkey,
    customer_id,
    total
FROM 
    public.invoice
WHERE 
    EXTRACT(YEAR FROM invoice_date) = 2023
    AND total > (
        SELECT AVG(total)
        FROM public.invoice
        WHERE EXTRACT(YEAR FROM invoice_date) = 2023
    );


-- 3
SELECT 
    invoice.invoice_id,
    invoice.invoice_date,
    TO_CHAR(invoice.invoice_date, 'YYYYMM')::INT AS monthkey,
    invoice.customer_id,
    invoice.total,
    customer.email
FROM 
    public.invoice
JOIN 
    public.customer ON invoice.customer_id = customer.customer_id
WHERE 
    EXTRACT(YEAR FROM invoice.invoice_date) = 2023
    AND invoice.total > (
        SELECT AVG(total)
        FROM public.invoice
        WHERE EXTRACT(YEAR FROM invoice_date) = 2023
    );


-- 4
SELECT 
    invoice.invoice_id,
    invoice.invoice_date,
    TO_CHAR(invoice.invoice_date, 'YYYYMM')::INT AS monthkey,
    invoice.customer_id,
    invoice.total,
    customer.email
FROM 
    public.invoice
JOIN 
    public.customer ON invoice.customer_id = customer.customer_id
WHERE 
    EXTRACT(YEAR FROM invoice.invoice_date) = 2023
    AND invoice.total > (
        SELECT AVG(total)
        FROM public.invoice
        WHERE EXTRACT(YEAR FROM invoice_date) = 2023
    )
    AND customer.email NOT LIKE '%@gmail.com';


-- 5
SELECT 
    invoice_id,
    invoice_date,
    customer_id,
    total,
    (total / total_revenue * 100) AS percentage_of_total_revenue
FROM 
    public.invoice,
    (SELECT SUM(total) AS total_revenue
     FROM public.invoice
     WHERE EXTRACT(YEAR FROM invoice_date) = 2024) AS total_rev
WHERE 
    EXTRACT(YEAR FROM invoice_date) = 2024;

-- 6
-- Вычисление общей выручки за 2024 год и подсчёт выручки по каждому клиенту
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    SUM(i.total) AS customer_revenue,
    (SUM(i.total) / total_rev.total_revenue * 100) AS percentage_of_total_revenue
FROM 
    public.invoice i
JOIN 
    public.customer c ON i.customer_id = c.customer_id
JOIN 
    (SELECT SUM(total) AS total_revenue 
     FROM public.invoice 
     WHERE EXTRACT(YEAR FROM invoice_date) = 2024) AS total_rev ON 1=1
WHERE 
    EXTRACT(YEAR FROM i.invoice_date) = 2024
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email, total_rev.total_revenue
ORDER BY 
    percentage_of_total_revenue DESC;
