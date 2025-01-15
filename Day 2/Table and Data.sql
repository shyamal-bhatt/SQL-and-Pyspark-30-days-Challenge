DROP TABLE IF EXISTS customers;

-- Create the customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    subscription_start DATE,
    subscription_end DATE
);

DROP TABLE IF EXISTS monthly_subscription;

-- Create the monthly_subscription table
CREATE TABLE monthly_subscription (
    month DATE NOT NULL,
    customer_id INT NOT NULL,
    subscription_active TINYINT NOT NULL,
    -- TINYINT is often used in MySQL to store small integer values like 0 or 1.
    PRIMARY KEY (month, customer_id)
);


INSERT INTO customers (customer_id, customer_name, subscription_start, subscription_end)
VALUES
(1, 'Alice', '2024-01-15', '2024-07-10'),
(2, 'Bob',   '2024-02-01', NULL),
(3, 'Carol', '2024-01-25', '2024-03-01'),
(4, 'David', '2024-03-15', NULL),
(5, 'Eva',   '2024-04-12', '2024-06-30'),
(6, 'Frank', '2024-04-25', '2024-05-15'),
(7, 'Gina',  '2024-05-05', NULL),
(8, 'Harry', '2024-05-20', '2024-07-20'),
(9, 'Ivy',   '2024-06-01', NULL),
(10,'John',  '2024-06-15', '2024-06-30');


INSERT INTO monthly_subscription (month, customer_id, subscription_active)
VALUES
('2024-01-01', 1, 1),
('2024-01-01', 3, 1),
('2024-02-01', 1, 1),
('2024-02-01', 2, 1),
('2024-02-01', 3, 1),
('2024-03-01', 1, 1),
('2024-03-01', 2, 1),
('2024-03-01', 3, 1),
('2024-03-01', 4, 1),
('2024-04-01', 1, 1),
('2024-04-01', 2, 1),
('2024-04-01', 4, 1),
('2024-04-01', 5, 1),
('2024-04-01', 6, 1),
('2024-05-01', 1, 1),
('2024-05-01', 2, 1),
('2024-05-01', 4, 1),
('2024-05-01', 5, 1),
('2024-05-01', 6, 1),
('2024-05-01', 7, 1),
('2024-05-01', 8, 1),
('2024-06-01', 1, 1),
('2024-06-01', 2, 1),
('2024-06-01', 4, 1),
('2024-06-01', 5, 1),
('2024-06-01', 7, 1),
('2024-06-01', 8, 1),
('2024-06-01', 9, 1),
('2024-06-01', 10, 1),
('2024-07-01', 2, 1),
('2024-07-01', 4, 1),
('2024-07-01', 7, 1),
('2024-07-01', 9, 1);

