-- 1
CREATE SCHEMA store;
SET search_path TO store;

-- 2
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(260),
    address TEXT
);

-- 3
INSERT INTO customers (customer_name, email, address)
SELECT 
    first_name || ' ' || last_name AS customer_name,
    email,
    country || ' ' || state || ' ' || city || ' ' || address AS address
FROM chinook.customer;

-- 4
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC NOT NULL
);

-- 5
INSERT INTO products (product_name, price) VALUES
('Ноутбук Lenovo Thinkpad', 12000),
('Мышь для компьютера, беспроводная', 90),
('Подставка для ноутбука', 300),
('Шнур электрический для ПК', 160);

-- 6
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT DEFAULT 1 NOT NULL
);

-- 7
INSERT INTO sales (customer_id, product_id, quantity) VALUES
(3, 4, 1),
(56, 2, 3),
(11, 2, 1),
(31, 2, 1),
(24, 2, 3),
(27, 2, 1),
(37, 3, 2),
(35, 1, 2),
(21, 1, 2),
(31, 2, 2),
(15, 1, 1),
(29, 2, 1),
(12, 2, 1);

-- 8
ALTER TABLE sales ADD COLUMN discount NUMERIC;
UPDATE sales SET discount = 0.2 WHERE product_id = 1;

-- 9
CREATE VIEW v_usa_customers AS
SELECT * FROM customers
WHERE address LIKE '%USA%';
