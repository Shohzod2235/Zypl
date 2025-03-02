/*
Имя:  Шахзод
Фамилия: Машрабов
Описание задачи: 
- Создать многострочный комментарий с вашей информацией
- Выполнить запросы для получения данных из различных таблиц базы данных
- Сохранить результаты выполнения запросов в файл hw1_on_sql.sql
*/

-- 2
SELECT name, genre_id
FROM public.track;

-- 3
SELECT 
    name AS song, 
    unit_price AS price, 
    composer AS author
FROM 
    public.track;

-- 4
SELECT 
    name AS song, 
    (milliseconds / 60000.0) AS duration_minutes
FROM 
    public.track
ORDER BY 
    duration_minutes DESC;

-- 5
SELECT 
    name, 
    genre_id
FROM 
    public.track
LIMIT 15;

-- 6
SELECT *
FROM public.track
OFFSET 49;

-- 7
SELECT name
FROM public.track
WHERE bytes > 100 * 1048576;

-- 8
SELECT name, composer
FROM public.track
WHERE composer != 'U2'
ORDER BY track_id
OFFSET 9 ROWS
FETCH NEXT 11 ROWS ONLY;






