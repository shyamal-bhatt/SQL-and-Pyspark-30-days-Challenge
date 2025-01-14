CREATE TABLE Billing (
    id INT AUTO_INCREMENT PRIMARY KEY,
    billing_type ENUM('invoice', 'credit_note') NOT NULL,
    invoice_date DATE NOT NULL,
    currency VARCHAR(3) NOT NULL
);

CREATE TABLE Item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    billing_id INT NOT NULL,
    product VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    type ENUM('recurring', 'one_shot') NOT NULL,
    valid_from DATE DEFAULT NULL,
    valid_to DATE DEFAULT NULL,
    FOREIGN KEY (billing_id) REFERENCES Billing(id) ON DELETE CASCADE
);

CREATE TABLE Exchange (
    date DATE NOT NULL,
    from_currency VARCHAR(3) NOT NULL,
    to_currency VARCHAR(3) NOT NULL,
    exchange_rate DECIMAL(10, 5) NOT NULL,
    PRIMARY KEY (date, from_currency, to_currency)
);
