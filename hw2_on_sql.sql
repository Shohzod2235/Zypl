-- 1. Вернуть дату самой первой и самой последней покупки из таблицы invoice
SELECT MIN(invoice_date) AS first_purchase, MAX(invoice_date) AS last_purchase
FROM public.invoice;

-- 2. Вернуть размер среднего чека для покупок из США
SELECT AVG(total) AS average_check
FROM public.invoice
WHERE billing_country = 'USA';

-- 3. Вернуть список городов, в которых имеется более одного клиента
SELECT city, COUNT(*) AS customer_count
FROM public.customer
GROUP BY city
HAVING COUNT(*) > 1;

-- 4. Вытащить список телефонных номеров из таблицы customer, не содержащих скобок
SELECT phone
FROM public.customer
WHERE phone NOT LIKE '%(%';

-- 5. Изменить текст 'lorem ipsum' так, чтобы только первая буква первого слова была в верхнем регистре, а всё остальное в нижнем
SELECT INITCAP('lorem') || ' ' || LOWER('IPSUM') AS formatted_text;

-- 6. Вытащить список названий песен из таблицы track, которые содержат слово 'run'
SELECT name
FROM public.track
WHERE name ILIKE '%run%';

-- 7. Вытащить список клиентов с почтовым ящиком в 'gmail'
SELECT email
FROM public.customer
WHERE email ILIKE '%@gmail.com';

-- 8. Найти произведение с самым длинным названием из таблицы track
SELECT name
FROM public.track
ORDER BY LENGTH(name) DESC
LIMIT 1;

-- 9. Посчитать общую сумму продаж за 2021 год в разбивке по месяцам
SELECT EXTRACT(MONTH FROM invoice_date) AS month_id, SUM(total) AS sales_sum
FROM public.invoice
WHERE EXTRACT(YEAR FROM invoice_date) = 2021
GROUP BY month_id
ORDER BY month_id;

-- 10. Добавить название месяца к предыдущему запросу
SELECT 
    EXTRACT(MONTH FROM invoice_date) AS month_id, 
    TO_CHAR(invoice_date, 'Month') AS month_name, 
    SUM(total) AS sales_sum
FROM public.invoice
WHERE EXTRACT(YEAR FROM invoice_date) = 2021
GROUP BY month_id, month_name
ORDER BY month_id;

-- 11. Вытащить список 3 самых возрастных сотрудников компании
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    birth_date, 
    DATE_PART('year', AGE(birth_date)) AS age_now
FROM public.employee
ORDER BY birth_date
LIMIT 3;

-- 12. Посчитать, каков будет средний возраст сотрудников через 3 года и 4 месяца
SELECT AVG(DATE_PART('year', AGE(birth_date, CURRENT_DATE + INTERVAL '3 years 4 months'))) AS avg_age
FROM public.employee;

-- 13. Посчитать сумму продаж в разбивке по годам и странам, оставить только строки где сумма продажи больше 20
SELECT 
    EXTRACT(YEAR FROM invoice_date) AS year, 
    billing_country, 
    SUM(total) AS sales_sum
FROM public.invoice
GROUP BY year, billing_country
HAVING SUM(total) > 20
ORDER BY year ASC, sales_sum DESC;
