-- Execute per each table to dont have conflict!!!

-- Orders
INSERT INTO [Order] (amount, orderStatus, paymentStatus, orderCreatedAt, orderUpdatedAt, FK_Order_Voucher, FK_Order_Customer)
VALUES 
    (60000, 4, 1, '2025-06-13 12:00:00', '2025-06-13 12:45:00', NULL, 3),  -- Delivered
    (85000, 2, 1, '2025-06-13 15:00:00', '2025-06-13 15:30:00', 1, 4),     -- Preparing
    (99000, 5, 0, '2025-06-12 11:00:00', '2025-06-12 11:10:00', NULL, 5);  -- Cancelled

-- OrderDetails
INSERT INTO OrderDetail (quantity, FK_OD_Order, FK_OD_Dish)
VALUES
(1, 4, 1), -- Phở bò for Order 4
(2, 5, 2), -- 2x Cơm gà for Order 5
(1, 6, 3); -- Pizza for Order 6

-- Payment records for Order 4 and 5
INSERT INTO Payment (transactionCode, bankName, paymentTime, isConfirmed, FK_Payment_Order, FK_Notification_Account)
VALUES
('TXN111111', 'BIDV', '2025-06-13 12:15:00', 1, 4, 3), -- Order 4 by customerID 3
('TXN222222', 'Agribank', '2025-06-13 15:05:00', 1, 5, 4); -- Order 5 by customerID 4
-- Order 6 (cancelled) has no payment

-- Only delivered orders can be reviewed (orderStatus = 4)
-- Order 4 was delivered (belongs to customerID 3)
INSERT INTO Review (rating, comment, reviewCreatedAt, FK_Review_OrderDetail, FK_Review_Customer)
VALUES
(4, N'Phở bò thơm ngon, nước dùng đậm đà.', '2025-06-13 13:00:00', 4, 3);

-- Optional: Verify data
SELECT accountID, fullName, email, [password], role, createAt
FROM [Account]
WHERE role IN ('admin', 'staff');