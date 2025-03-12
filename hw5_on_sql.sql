-- 1
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    COUNT(c.customer_id) AS customer_count
FROM 
    public.employee e
LEFT JOIN 
    public.customer c ON e.employee_id = c.support_rep_id
GROUP BY 
    e.employee_id, e.first_name, e.last_name
ORDER BY 
    customer_count DESC;


SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    COUNT(c.customer_id) AS customer_count
FROM 
    public.employee e
LEFT JOIN 
    public.customer c ON e.employee_id = c.support_rep_id
GROUP BY 
    e.employee_id, e.first_name, e.last_name
ORDER BY 
    customer_count DESC;


-- 2
SELECT 
    a.title AS album_title,
    ar.name AS artist_name
FROM 
    public.album a
JOIN 
    public.artist ar ON a.artist_id = ar.artist_id
WHERE 
    a.album_id NOT IN (
        SELECT DISTINCT t.album_id
        FROM public.invoice_line il
        JOIN public.track t ON il.track_id = t.track_id
    );


-- 3
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name
FROM 
    public.employee e
WHERE 
    e.employee_id NOT IN (
        SELECT DISTINCT reports_to
        FROM public.employee
        WHERE reports_to IS NOT NULL
    );


-- 4
SELECT 
    t.track_id,
    t.name AS track_name
FROM 
    public.track t
JOIN 
    public.invoice_line il ON t.track_id = il.track_id
JOIN 
    public.invoice i ON il.invoice_id = i.invoice_id
WHERE 
    i.billing_country = 'USA'
    AND t.track_id IN (
        SELECT DISTINCT il2.track_id
        FROM public.invoice_line il2
        JOIN public.invoice i2 ON il2.invoice_id = i2.invoice_id
        WHERE i2.billing_country = 'Canada'
    );


-- 5
SELECT 
    t.track_id,
    t.name AS track_name
FROM 
    public.track t
JOIN 
    public.invoice_line il ON t.track_id = il.track_id
JOIN 
    public.invoice i ON il.invoice_id = i.invoice_id
WHERE 
    i.billing_country = 'Canada'
    AND t.track_id NOT IN (
        SELECT DISTINCT il2.track_id
        FROM public.invoice_line il2
        JOIN public.invoice i2 ON il2.invoice_id = i2.invoice_id
        WHERE i2.billing_country = 'USA'
    );

