INSERT INTO Billing (id, billing_type, invoice_date, currency) VALUES
(1, 'invoice', '2019-01-15', 'usd'),
(2, 'invoice', '2019-01-15', 'cad'),
(3, 'credit_note', '2019-03-15', 'cad'),
(4, 'invoice', '2019-03-15', 'eur'),
(5, 'invoice', '2019-04-01', 'eur'),
(6, 'credit_note', '2019-04-18', 'eur'),
(7, 'invoice', '2019-04-18', 'usd'),
(8, 'invoice', '2019-05-27', 'usd');

INSERT INTO Item (id, billing_id, product, amount, type, valid_from, valid_to) VALUES
(1, 1, 'product1', 11500, 'recurring', '2019-01-15', '2019-12-31'),
(2, 1, 'product2', 5000, 'one_shot', NULL, NULL),
(3, 2, 'product3', 7893, 'recurring', '2019-01-15', '2020-01-14'),
(4, 2, 'product4', 16000, 'recurring', '2019-01-15', '2020-01-14'),
(5, 3, 'product3', 7893, 'recurring', '2019-01-15', '2020-01-14'),
(6, 3, 'product4', 16000, 'recurring', '2019-01-15', '2020-01-14'),
(7, 4, 'product1', 12350, 'recurring', '2019-03-15', '2019-12-31'),
(8, 5, 'product2', 5500, 'one_shot', NULL, NULL),
(9, 5, 'product3', 9000, 'recurring', '2019-04-01', '2020-03-31'),
(10, 5, 'product4', 14321, 'recurring', '2019-04-01', '2020-03-31'),
(11, 6, 'product2', 5500, 'one_shot', NULL, NULL),
(12, 6, 'product3', 9000, 'recurring', '2019-04-01', '2020-03-31'),
(13, 6, 'product4', 14321, 'recurring', '2019-04-01', '2020-03-31'),
(14, 7, 'product2', 4050, 'one_shot', NULL, NULL),
(15, 8, 'product6', 9000, 'one_shot', NULL, NULL);

INSERT INTO Exchange (date, from_currency, to_currency, exchange_rate) VALUES
('2019-01-15', 'cad', 'usd', 1.332),
('2019-01-15', 'eur', 'usd', 0.978),
('2019-01-15', 'usd', 'usd', 1),
('2019-03-15', 'cad', 'usd', 1.402),
('2019-03-15', 'eur', 'usd', 0.911),
('2019-03-15', 'usd', 'usd', 1),
('2019-04-01', 'cad', 'usd', 1.360),
('2019-04-01', 'eur', 'usd', 0.947),
('2019-04-01', 'usd', 'usd', 1),
('2019-04-18', 'cad', 'usd', 1.319),
('2019-04-18', 'eur', 'usd', 0.966),
('2019-04-18', 'usd', 'usd', 1),
('2019-05-27', 'cad', 'usd', 1.388),
('2019-05-27', 'eur', 'usd', 0.932),
('2019-05-27', 'usd', 'usd', 1);
