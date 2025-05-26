-- ExampleData_Ver2.0.sql

USE Oiship
GO

INSERT INTO Account (
	account_name,
	email,
	phone,
	[password],
	[status],
	[role]
)
VALUES (
	N'Admin',
	N'oiship.team@gmail.com',
	'0000000000',
	N'$2a$12$sxxt7Bu2u/tYKPAks5cno.pr1p2oC00KKo8K3RcvUqQP8BXrAp6sW', -- bcrypt hash for 'admin'
	N'active',
	N'Admin'
);

INSERT INTO Discount (
    discount_code,
    discount_description,
    discount_type,
    amount,
    min_order_value,
    start_date,
    end_date,
    usage_limit
) VALUES (
    N'WELCOME100',
    N'Welcome new customers - get 100K off',
    'fixed',
    100000.00,
    150000.00,
    '2025-01-01',
    '2025-12-31',
    1000
);


INSERT INTO Discount (
    discount_code,
    discount_description,
    discount_type,
    amount,
    max_discount_value,
    min_order_value,
    start_date,
    end_date,
    usage_limit
) VALUES (
    N'SUMMER2025',
    N'Summer Sale 2025 - 20% off, max 50K',
    'percentage',
    20.00,
    50000.00,
    200000.00,
    '2025-06-01',
    '2025-08-31',
    500
);

