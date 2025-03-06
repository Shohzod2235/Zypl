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
