USE Oiship;
GO

INSERT INTO [Order] (amount, orderStatus, paymentStatus, orderCreatedAt, orderUpdatedAt, FK_Order_Voucher, FK_Order_Customer)
VALUES 
    -- Order 1: Cơm gà xối mỡ (2 phần), dùng voucher SELLER10
    (70000, 0, 0, '2025-06-14 10:00:00', '2025-06-14 10:00:00', 1, 3), -- Pending, Unpaid
    -- Order 2: Phở bò tái (2 phần)
    (90000, 1, 1, '2025-06-13 12:30:00', '2025-06-13 13:00:00', NULL, 3), -- Confirmed, Paid
    -- Order 3: Lẩu thái chua cay (1 phần), dùng voucher FREESHIP
    (150000, 3, 1, '2025-06-12 15:45:00', '2025-06-12 16:30:00', 3, 4), -- Out for Delivery, Paid
    -- Order 4: Pizza hải sản (2 phần), dùng voucher COMBO50
    (200000, 4, 1, '2025-06-11 09:15:00', '2025-06-11 11:00:00', 4, 4), -- Delivered, Paid
    -- Order 5: Bánh tráng trộn (3 phần)
    (60000, 5, 2, '2025-06-10 14:20:00', '2025-06-10 15:00:00', NULL, 5), -- Cancelled, Refunded
    -- Order 6: Trà sữa trân châu (2 phần), dùng voucher COFFEELOVER
    (80000, 2, 1, '2025-06-14 11:30:00', '2025-06-14 12:00:00', 6, 3), -- Preparing, Paid
    -- Order 7: Bánh mì thịt nguội (3 phần)
    (60000, 6, 0, '2025-06-13 09:00:00', '2025-06-13 09:30:00', NULL, 5), -- Failed, Unpaid
    -- Order 8: Gỏi cuốn tôm thịt (4 phần), dùng voucher NEWUSER
    (100000, 1, 1, '2025-06-12 13:15:00', '2025-06-12 13:45:00', 10, 4), -- Confirmed, Paid
    -- Order 9: Nước ép cam tươi (3 phần)
    (90000, 4, 1, '2025-06-11 16:00:00', '2025-06-11 17:30:00', NULL, 3), -- Delivered, Paid
    -- Order 10: Gà rán cay Hàn Quốc (2 phần), dùng voucher THAI15
    (100000, 3, 1, '2025-06-10 18:00:00', '2025-06-10 19:00:00', 5, 5); -- Out for Delivery, Paid


INSERT INTO OrderDetail (quantity, FK_OD_Order, FK_OD_Dish)
VALUES 
    -- Order 1: Cơm gà xối mỡ (DishID = 1, opCost = 28000, interest = 25% -> 35000/phần)
    (2, 1, 1), -- 2 phần x 35000 = 70000
    -- Order 2: Phở bò tái (DishID = 2, opCost = 36000, interest = 25% -> 45000/phần)
    (2, 2, 2), -- 2 phần x 45000 = 90000
    -- Order 3: Lẩu thái chua cay (DishID = 8, opCost = 120000, interest = 25% -> 150000/phần)
    (1, 3, 8), -- 1 phần x 150000 = 150000
    -- Order 4: Pizza hải sản (DishID = 12, opCost = 72000, interest = 25% -> 90000/phần)
    (2, 4, 12), -- 2 phần x 90000 = 180000 (sau khi áp voucher COMBO50 = 200000)
    -- Order 5: Bánh tráng trộn (DishID = 13, opCost = 16000, interest = 25% -> 20000/phần)
    (3, 5, 13), -- 3 phần x 20000 = 60000
    -- Order 6: Trà sữa trân châu (DishID = 4, opCost = 32000, interest = 25% -> 40000/phần)
    (2, 6, 4), -- 2 phần x 40000 = 80000
    -- Order 7: Bánh mì thịt nguội (DishID = 3, opCost = 16000, interest = 25% -> 20000/phần)
    (3, 7, 3), -- 3 phần x 20000 = 60000
    -- Order 8: Gỏi cuốn tôm thịt (DishID = 9, opCost = 20000, interest = 25% -> 25000/phần)
    (4, 8, 9), -- 4 phần x 25000 = 100000
    -- Order 9: Nước ép cam tươi (DishID = 10, opCost = 24000, interest = 25% -> 30000/phần)
    (3, 9, 10), -- 3 phần x 30000 = 90000
    -- Order 10: Gà rán cay Hàn Quốc (DishID = 7, opCost = 40000, interest = 25% -> 50000/phần)
    (2, 10, 7); -- 2 phần x 50000 = 100000

INSERT INTO Review (rating, comment, reviewCreatedAt, FK_Review_OrderDetail, FK_Review_Customer)
VALUES 
(5, N'Rất ngon, giao hàng nhanh!', GETDATE(), 3, 3),
(4, N'Vị ổn nhưng hơi nguội.', GETDATE(), 4, 4),
(3, N'Tạm ổn, không quá đặc sắc.', GETDATE(), 5, 3),
(2, N'Món ăn không giống hình.', GETDATE(), 6, 4),
(5, N'Tuyệt vời, sẽ đặt lại lần nữa!', GETDATE(), 7, 3);