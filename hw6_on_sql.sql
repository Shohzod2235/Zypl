-- Задача №1
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    TO_CHAR(i.invoice_date, 'YYYYMM')::INT AS monthkey,
    SUM(i.total) AS total
FROM 
    public.invoice i
JOIN 
    public.customer c ON i.customer_id = c.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, TO_CHAR(i.invoice_date, 'YYYYMM')
ORDER BY 
    c.customer_id, monthkey;


-- 1
WITH monthly_sales AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        TO_CHAR(i.invoice_date, 'YYYYMM')::INT AS monthkey,
        SUM(i.total) AS total
    FROM 
        public.invoice i
    JOIN 
        public.customer c ON i.customer_id = c.customer_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name, TO_CHAR(i.invoice_date, 'YYYYMM')
),
total_monthly_sales AS (
    SELECT 
        monthkey,
        SUM(total) AS total_monthly_sales
    FROM 
        monthly_sales
    GROUP BY 
        monthkey
)
SELECT 
    ms.customer_id,
    ms.full_name,
    ms.monthkey,
    ms.total,
    (ms.total / tms.total_monthly_sales * 100) AS percentage_of_monthly_sales
FROM 
    monthly_sales ms
JOIN 
    total_monthly_sales tms ON ms.monthkey = tms.monthkey
ORDER BY 
    ms.customer_id, ms.monthkey;

-- 3
WITH monthly_sales AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        TO_CHAR(i.invoice_date, 'YYYYMM')::INT AS monthkey,
        SUM(i.total) AS total
    FROM 
        public.invoice i
    JOIN 
        public.customer c ON i.customer_id = c.customer_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name, TO_CHAR(i.invoice_date, 'YYYYMM')
),
total_monthly_sales AS (
    SELECT 
        monthkey,
        SUM(total) AS total_monthly_sales
    FROM 
        monthly_sales
    GROUP BY 
        monthkey
),
cumulative_sales AS (
    SELECT 
        customer_id,
        full_name,
        monthkey,
        total,
        SUM(total) OVER (PARTITION BY customer_id ORDER BY monthkey) AS cumulative_total
    FROM 
        monthly_sales
)
SELECT 
    cs.customer_id,
    cs.full_name,
    cs.monthkey,
    cs.total,
    (cs.total / tms.total_monthly_sales * 100) AS percentage_of_monthly_sales,
    cs.cumulative_total
FROM 
    cumulative_sales cs
JOIN 
    total_monthly_sales tms ON cs.monthkey = tms.monthkey
ORDER BY 
    cs.customer_id, cs.monthkey;


-- 4
WITH monthly_sales AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        TO_CHAR(i.invoice_date, 'YYYYMM')::INT AS monthkey,
        SUM(i.total) AS total
    FROM 
        public.invoice i
    JOIN 
        public.customer c ON i.customer_id = c.customer_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name, TO_CHAR(i.invoice_date, 'YYYYMM')
),
total_monthly_sales AS (
    SELECT 
        monthkey,
        SUM(total) AS total_monthly_sales
    FROM 
        monthly_sales
    GROUP BY 
        monthkey
),
cumulative_sales AS (
    SELECT 
        customer_id,
        full_name,
        monthkey,
        total,
        SUM(total) OVER (PARTITION BY customer_id ORDER BY monthkey) AS cumulative_total
    FROM 
        monthly_sales
),
moving_average AS (
    SELECT 
        customer_id,
        full_name,
        monthkey,
        total,
        cumulative_total,
        AVG(total) OVER (PARTITION BY customer_id ORDER BY monthkey ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_average_3_months
    FROM 
        cumulative_sales
)
SELECT 
    ma.customer_id,
    ma.full_name,
    ma.monthkey,
    ma.total,
    (ma.total / tms.total_monthly_sales * 100) AS percentage_of_monthly_sales,
    ma.cumulative_total,
    ma.moving_average_3_months,
    ma.total - LAG(ma.total, 1) OVER (PARTITION BY ma.customer_id ORDER BY ma.monthkey) AS difference_from_previous_month
FROM 
    moving_average ma
JOIN 
    total_monthly_sales tms ON ma.monthkey = tms.monthkey
ORDER BY 
    ma.customer_id, ma.monthkey;


-- 5
WITH monthly_sales AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        TO_CHAR(i.invoice_date, 'YYYYMM')::INT AS monthkey,
        SUM(i.total) AS total
    FROM 
        public.invoice i
    JOIN 
        public.customer c ON i.customer_id = c.customer_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name, TO_CHAR(i.invoice_date, 'YYYYMM')
),
total_monthly_sales AS (
    SELECT 
        monthkey,
        SUM(total) AS total_monthly_sales
    FROM 
        monthly_sales
    GROUP BY 
        monthkey
),
cumulative_sales AS (
    SELECT 
        customer_id,
        full_name,
        monthkey,
        total,
        SUM(total) OVER (PARTITION BY customer_id ORDER BY monthkey) AS cumulative_total
    FROM 
        monthly_sales
),
moving_average AS (
    SELECT 
        customer_id,
        full_name,
        monthkey,
        total,
        cumulative_total,
        AVG(total) OVER (PARTITION BY customer_id ORDER BY monthkey ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_average_3_months
    FROM 
        cumulative_sales
)
SELECT 
    ma.customer_id,
    ma.full_name,
    ma.monthkey,
    ma.total,
    (ma.total / tms.total_monthly_sales * 100) AS percentage_of_monthly_sales,
    ma.cumulative_total,
    ma.moving_average_3_months,
    ma.total - LAG(ma.total, 1) OVER (PARTITION BY ma.customer_id ORDER BY ma.monthkey) AS difference_from_previous_month
FROM 
    moving_average ma
JOIN 
    total_monthly_sales tms ON ma.monthkey = tms.monthkey
ORDER BY 
    ma.customer_id, ma.monthkey;


-- Задача №2

-- 1
WITH album_sales AS (
    SELECT 
        a.album_id,
        a.title AS album_title,
        ar.name AS artist_name,
        EXTRACT(YEAR FROM i.invoice_date) AS year,
        COUNT(il.track_id) AS track_sales_count
    FROM 
        public.invoice_line il
    JOIN 
        public.invoice i ON il.invoice_id = i.invoice_id
    JOIN 
        public.track t ON il.track_id = t.track_id
    JOIN 
        public.album a ON t.album_id = a.album_id
    JOIN 
        public.artist ar ON a.artist_id = ar.artist_id
    GROUP BY 
        a.album_id, a.title, ar.name, year
),
ranked_album_sales AS (
    SELECT 
        album_sales.*,
        ROW_NUMBER() OVER (PARTITION BY album_sales.year ORDER BY album_sales.track_sales_count DESC) AS rank
    FROM 
        album_sales
)
SELECT 
    year,
    album_title,
    artist_name,
    track_sales_count
FROM 
    ranked_album_sales
WHERE 
    rank <= 3
ORDER BY 
    year, rank;


-- Задача №3
WITH employee_client_count AS (
    SELECT 
        e.employee_id,
        e.first_name || ' ' || e.last_name AS full_name,
        COUNT(c.customer_id) AS client_count
    FROM 
        public.employee e
    LEFT JOIN 
        public.customer c ON e.employee_id = c.support_rep_id
    GROUP BY 
        e.employee_id, e.first_name, e.last_name
),
total_clients AS (
    SELECT COUNT(*) AS total_client_count
    FROM public.customer
)
SELECT 
    ecc.employee_id,
    ecc.full_name,
    ecc.client_count,
    (ecc.client_count / tc.total_client_count::FLOAT * 100) AS percentage_of_total_clients
FROM 
    employee_client_count ecc,
    total_clients tc
ORDER BY 
    ecc.client_count DESC;


-- Задача №4
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    MIN(i.invoice_date) AS first_purchase_date,
    MAX(i.invoice_date) AS last_purchase_date,
    DATE_PART('year', AGE(MAX(i.invoice_date), MIN(i.invoice_date))) AS years_difference
FROM 
    public.invoice i
JOIN 
    public.customer c ON i.customer_id = c.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    c.customer_id;


-- 