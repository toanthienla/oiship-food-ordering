-- Insert Admin
INSERT INTO Account (fullName, email, phone, [password], [address], [status], [role])
VALUES (N'Admin', N'oiship.team@gmail.com', '0000000000', 
N'$2a$12$e9o18dZ1tnUqDbCV16syKunM5krYgJSOJVjCX54O1vEJxPVrGwCgK', NULL, 1, 'admin'); -- bcrypt hash for 'admin'

-- Insert Staff Accounts
INSERT INTO Account (fullName, email, phone, [password], [address], [status], [role])
VALUES 
(N'Staff Ingredient', N'ingredient@oiship.com', '0000000001', N'$2a$12$IkgE/bAYXPFAeQvFCnczY.83Tj4Z9tmv6G5kJZANHenpyAg0fOFJO', NULL, 1, 'staff'), -- "ingredient@oiship.com", "ingredientstaff",


(N'Staff Seller', N'seller@oiship.com', '0000000002', N'$2a$12$Cz1HZYwZ8RHPIxxClhY3AejchEReWbwrpV5zjNYip500Mq.QJYtWq', NULL, 1, 'staff'); -- "seller@oiship.com", "sellerstaff",

-- Insert Staff Details
-- Assuming IDs are sequential (admin = 1, inventory staff = 2, seller staff = 3)
INSERT INTO Staff (staffId, staffType)
VALUES 
(2, 'ingredientStaff'),
(3, 'sellerStaff');

-- Insert customers with status = 1 (Acctive account) 
INSERT INTO Account (fullName, email, phone, [password], [address], [status], [role]) 
VALUES 
(N'Nguyễn Văn A', N'a1@example.com', '0911000001', N'$2a$12$u1Y/0k4vsab8FOwHAw6UVuo8RzrZilae4qDGOSH3UFzN8JH6Cdede', N'Q1, HCM', 1, 'customer'), -- bcrypt hash for 'customer'
(N'Lê Thị B', N'b2@example.com', '0911000002', N'$2a$12$u1Y/0k4vsab8FOwHAw6UVuo8RzrZilae4qDGOSH3UFzN8JH6Cdede', N'Q2, HCM', 1, 'customer'),
(N'Trần Văn C', N'c3@example.com', '0911000003', N'$2a$12$u1Y/0k4vsab8FOwHAw6UVuo8RzrZilae4qDGOSH3UFzN8JH6Cdede', N'Q3, HCM', 1, 'customer'),
(N'Phạm Thị D', N'd4@example.com', '0911000004', N'$2a$12$u1Y/0k4vsab8FOwHAw6UVuo8RzrZilae4qDGOSH3UFzN8JH6Cdede', N'Q4, HCM', 1, 'customer'),
(N'Hoàng Văn E', N'e5@example.com', '0911000005', N'$2a$12$u1Y/0k4vsab8FOwHAw6UVuo8RzrZilae4qDGOSH3UFzN8JH6Cdede', N'Q5, HCM', 1, 'customer'),
(N'Đặng Thị F', N'f6@example.com', '0911000006', N'$2a$12$u1Y/0k4vsab8FOwHAw6UVuo8RzrZilae4qDGOSH3UFzN8JH6Cdede', N'Q6, HCM', 1, 'customer'),
(N'Vũ Văn G', N'g7@example.com', '0911000007', N'$2a$12$u1Y/0k4vsab8FOwHAw6UVuo8RzrZilae4qDGOSH3UFzN8JH6Cdede', N'Q7, HCM', 1, 'customer'),
(N'Ngô Thị H', N'h8@example.com', '0911000008', N'$2a$12$u1Y/0k4vsab8FOwHAw6UVuo8RzrZilae4qDGOSH3UFzN8JH6Cdede', N'Q8, HCM', 1, 'customer'),
(N'Bùi Văn I', N'i9@example.com', '0911000009', N'$2a$12$u1Y/0k4vsab8FOwHAw6UVuo8RzrZilae4qDGOSH3UFzN8JH6Cdede', N'Q9, HCM', 1, 'customer'),
(N'Đỗ Thị K', N'k10@example.com', '0911000010', N'$2a$12$u1Y/0k4vsab8FOwHAw6UVuo8RzrZilae4qDGOSH3UFzN8JH6Cdede', N'Tân Bình, HCM', 1, 'customer');


-- Insert Categories
INSERT INTO Category (catName, catDescription)
VALUES 
(N'Cơm', N'Món cơm các loại'),
(N'Bún/Phở/Mì', N'Các món nước truyền thống'),
(N'Bánh Mì', N'Món ăn kèm bánh mì'),
(N'Trà sữa', N'Các loại trà sữa và topping'),
(N'Cà phê', N'Thức uống cà phê'),
(N'Cháo/Súp', N'Món cháo, súp dinh dưỡng'),
(N'Gà rán', N'Các món gà chiên giòn'),
(N'Lẩu', N'Món lẩu nóng hổi'),
(N'Các món Cuốn', N'Món cuốn như gỏi cuốn, bò cuốn'),
(N'Nước ép & Sinh tố', N'Thức uống trái cây tươi'),
(N'Bánh Âu Á', N'Bánh ngọt, mặn Á - Âu'),
(N'Ẩm thực quốc tế', N'Món ăn đến từ nhiều nước'),
(N'Ăn vặt', N'Món ăn nhẹ và ăn vặt');

-- Insert Dishes (with NULL image)
-- Assuming category IDs start at 1 and are in the order they were inserted
INSERT INTO Dish (dishName, opCost, interestPercentage, [image], dishDescription, stock, FK_Dish_Category)
VALUES 
(N'Cơm gà xối mỡ', 28000, 25, NULL, N'Cơm gà chiên giòn, nước mắm', 20, 1),
(N'Phở bò tái', 36000, 25, NULL, N'Phở truyền thống với bò tái', 30, 2),
(N'Bánh mì thịt nguội', 16000, 25, NULL, N'Bánh mì kẹp thịt nguội, rau sống', 25, 3),
(N'Trà sữa trân châu đường đen', 32000, 25, NULL, N'Trà sữa ngọt béo kèm trân châu', 40, 4),
(N'Cà phê sữa đá', 16000, 25, NULL, N'Cà phê pha phin với sữa đặc', 50, 5),
(N'Súp cua trứng bắc thảo', 24000, 25, NULL, N'Súp dinh dưỡng, vị thanh', 15, 6),
(N'Gà rán cay Hàn Quốc', 40000, 25, NULL, N'Gà chiên sốt cay kiểu Hàn', 20, 7),
(N'Lẩu thái chua cay', 120000, 25, NULL, N'Lẩu tôm mực kiểu Thái', 10, 8),
(N'Gỏi cuốn tôm thịt', 20000, 25, NULL, N'Gỏi cuốn với nước mắm chấm', 35, 9),
(N'Nước ép cam tươi', 24000, 25, NULL, N'Cam vắt nguyên chất', 30, 10),
(N'Bánh tart trứng', 12000, 25, NULL, N'Bánh mềm, nhân trứng sữa', 20, 11),
(N'Pizza xúc xích', 72000, 25, NULL, N'Món pizza Ý thơm ngon', 12, 12),
(N'Bánh tráng trộn', 16000, 25, NULL, N'Món ăn vặt Sài Gòn đặc trưng', 50, 13), 
(N'Mì xào bò', 36000, 25, NULL, N'Mì xào với thịt bò mềm và rau', 25, 2),
(N'Bún bò Huế', 40000, 25, NULL, N'Món bún đặc trưng miền Trung', 20, 2),
(N'Cơm tấm sườn bì', 36000, 25, NULL, N'Cơm tấm với sườn, bì, chả', 30, 1),
(N'Bánh mì chảo', 28000, 25, NULL, N'Bánh mì chảo nóng với trứng và pate', 15, 3),
(N'Trà sữa thái xanh', 30400, 25, NULL, N'Trà sữa vị trà thái tươi mát', 40, 4),
(N'Cà phê đen đá', 14400, 25, NULL, N'Cà phê truyền thống đậm đà', 50, 5),
(N'Súp hải sản', 32000, 25, NULL, N'Súp thơm ngon với tôm và mực', 18, 6),
(N'Cánh gà chiên nước mắm', 36000, 25, NULL, N'Món cánh gà chiên giòn', 22, 7),
(N'Lẩu nấm chay', 96000, 25, NULL, N'Lẩu nấm thanh đạm phù hợp ăn chay', 12, 8),
(N'Nem cuốn', 16000, 25, NULL, N'Nem cuốn tươi ngon với rau sống', 35, 9),
(N'Sinh tố bơ', 28000, 25, NULL, N'Sinh tố bơ sánh mịn', 25, 10),
(N'Bánh tiramisu', 32000, 25, NULL, N'Bánh mềm, vị cà phê ngọt dịu', 20, 11),
(N'Cơm chiên hải sản', 40000, 25, NULL, N'Cơm chiên tôm mực thơm ngon', 28, 1),
(N'Pizza hải sản', 80000, 25, NULL, N'Pizza topping tôm, mực, phô mai', 10, 12),
(N'Bánh tráng nướng', 20000, 25, NULL, N'Bánh tráng nướng kiểu Đà Lạt', 40, 13),
(N'Bánh mì que', 12000, 25, NULL, N'Món ăn nhẹ tiện lợi', 30, 3),
(N'Mì ý sốt bò bằm', 48000, 25, NULL, N'Món Âu đơn giản, vị béo', 20, 12),
(N'Nước ép dứa', 22400, 25, NULL, N'Nước ép thơm mát, giải nhiệt', 30, 10),
(N'Cháo sườn trứng bắc thảo', 28000, 25, NULL, N'Cháo đặc biệt cho buổi sáng', 15, 6),
(N'Lẩu cá chua cay', 128000, 25, NULL, N'Lẩu với cá và măng chua', 8, 8);

--Insert ingredient for dishes
INSERT INTO Ingredient (name, quantity, unitCost, FK_Ingredient_Dish)
VALUES
-- Dish 1: Cơm gà xối mỡ
(N'Gạo', 50, 500, 1),
(N'Gà chiên', 20, 15000, 1),
(N'Nước mắm', 30, 2000, 1),
(N'Hành phi', 25, 1000, 1),

-- Dish 2: Phở bò tái
(N'Bánh phở', 50, 1000, 2),
(N'Thịt bò tái', 25, 18000, 2),
(N'Hành lá', 30, 500, 2),
(N'Gừng', 10, 800, 2),
(N'Nước dùng bò', 40, 3000, 2),

-- Dish 3: Bánh mì thịt nguội
(N'Bánh mì', 50, 1500, 3),
(N'Thịt nguội', 30, 7000, 3),
(N'Dưa leo', 20, 1500, 3),
(N'Rau sống', 20, 1000, 3),

-- Dish 4: Trà sữa trân châu đường đen
(N'Trà đen', 30, 2000, 4),
(N'Sữa đặc', 25, 1500, 4),
(N'Trân châu', 40, 1000, 4),
(N'Đường đen', 30, 1200, 4),

-- Dish 5: Cà phê sữa đá
(N'Cà phê', 50, 1000, 5),
(N'Sữa đặc', 40, 1500, 5),
(N'Đá viên', 60, 200, 5),

-- Dish 6: Súp cua trứng bắc thảo
(N'Thịt cua', 20, 12000, 6),
(N'Trứng bắc thảo', 15, 7000, 6),
(N'Ngô non', 20, 2000, 6),
(N'Bột năng', 10, 500, 6),

-- Dish 7: Gà rán cay Hàn Quốc
(N'Gà miếng', 25, 15000, 7),
(N'Sốt cay Hàn', 15, 3000, 7),
(N'Bột chiên giòn', 20, 1000, 7),
(N'Tỏi băm', 20, 500, 7),

-- Dish 8: Lẩu thái chua cay
(N'Tôm', 10, 10000, 8),
(N'Mực', 10, 12000, 8),
(N'Nước lẩu thái', 20, 3000, 8),
(N'Rau thập cẩm', 30, 4000, 8),
(N'Nấm', 20, 4000, 8),

-- Dish 9: Gỏi cuốn tôm thịt
(N'Bánh tráng', 30, 1000, 9),
(N'Tôm luộc', 20, 8000, 9),
(N'Thịt luộc', 20, 7000, 9),
(N'Rau sống', 25, 1000, 9),

-- Dish 10: Nước ép cam tươi
(N'Cam tươi', 40, 3000, 10),
(N'Đường', 20, 500, 10),
(N'Đá viên', 20, 200, 10),

-- Dish 11: Bánh tart trứng
(N'Trứng gà', 30, 2000, 11),
(N'Sữa tươi', 20, 1500, 11),
(N'Bột mì', 25, 1000, 11),
(N'Bơ', 15, 5000, 11),

-- Dish 12: Pizza xúc xích
(N'Bột pizza', 20, 3000, 12),
(N'Xúc xích', 20, 7000, 12),
(N'Phô mai', 15, 10000, 12),
(N'Sốt cà', 20, 2000, 12),

-- Dish 13: Bánh tráng trộn
(N'Bánh tráng cắt sợi', 30, 1000, 13),
(N'Tóp mỡ', 20, 3000, 13),
(N'Trứng cút', 25, 2000, 13),
(N'Xoài xanh', 20, 1500, 13),

-- Dish 14: Mì xào bò
(N'Mì trứng', 30, 1500, 14),
(N'Thịt bò mềm', 20, 18000, 14),
(N'Rau cải', 25, 1000, 14),
(N'Nước tương', 20, 800, 14),

-- Dish 15: Bún bò Huế
(N'Bún tươi', 30, 1500, 15),
(N'Thịt bò Huế', 25, 18000, 15),
(N'Chả Huế', 20, 5000, 15),
(N'Nước dùng đặc biệt', 25, 3000, 15),

-- Dish 16: Cơm tấm sườn bì
(N'Cơm tấm', 40, 1500, 16),
(N'Sườn nướng', 25, 12000, 16),
(N'Bì heo', 20, 5000, 16),
(N'Chả trứng', 20, 4000, 16),

-- Dish 17: Bánh mì chảo
(N'Bánh mì', 30, 1500, 17),
(N'Trứng ốp la', 25, 2000, 17),
(N'Pate gan', 20, 4000, 17),
(N'Xúc xích', 20, 7000, 17),

-- Dish 18: Trà sữa thái xanh
(N'Trà thái xanh', 30, 2000, 18),
(N'Sữa bột', 20, 1500, 18),
(N'Trân châu', 30, 1000, 18),
(N'Đường', 20, 500, 18),

-- Dish 19: Cà phê đen đá
(N'Cà phê đen', 40, 1000, 19),
(N'Đường', 20, 500, 19),
(N'Đá viên', 30, 200, 19),

-- Dish 20: Súp hải sản
(N'Tôm tươi', 20, 8000, 20),
(N'Mực', 15, 9000, 20),
(N'Nước dùng', 25, 3000, 20),
(N'Ngô non', 20, 1500, 20),

-- Dish 21: Cánh gà chiên nước mắm
(N'Cánh gà', 25, 12000, 21),
(N'Nước mắm', 20, 2000, 21),
(N'Tỏi băm', 20, 500, 21),
(N'Bột chiên giòn', 20, 1000, 21),

-- Dish 22: Lẩu nấm chay
(N'Nấm rơm', 20, 4000, 22),
(N'Nấm kim châm', 20, 4000, 22),
(N'Rau cải', 30, 1500, 22),
(N'Nước dùng chay', 20, 2000, 22),

-- Dish 23: Nem cuốn
(N'Bánh tráng', 25, 1000, 23),
(N'Thịt heo luộc', 20, 7000, 23),
(N'Rau sống', 25, 1000, 23),
(N'Bún tươi', 25, 1500, 23),

-- Dish 24: Sinh tố bơ
(N'Bơ', 30, 5000, 24),
(N'Sữa đặc', 20, 1500, 24),
(N'Đá viên', 20, 200, 24),

-- Dish 25: Bánh tiramisu
(N'Bánh ladyfinger', 20, 3000, 25),
(N'Mascarpone', 15, 10000, 25),
(N'Cà phê', 10, 1000, 25),
(N'Socola', 15, 5000, 25),

-- Dish 26: Cơm chiên hải sản
(N'Cơm trắng', 40, 1000, 26),
(N'Tôm', 20, 9000, 26),
(N'Mực', 15, 8000, 26),
(N'Trứng', 20, 2000, 26),

-- Dish 27: Pizza hải sản
(N'Đế pizza', 15, 3000, 27),
(N'Tôm', 15, 8000, 27),
(N'Mực', 15, 9000, 27),
(N'Phô mai', 15, 10000, 27),

-- Dish 28: Bánh tráng nướng
(N'Bánh tráng', 25, 1000, 28),
(N'Trứng cút', 20, 1500, 28),
(N'Hành phi', 15, 1000, 28),
(N'Chà bông', 10, 3000, 28),

-- Dish 29: Bánh mì que
(N'Bánh mì que', 30, 1200, 29),
(N'Pate', 20, 4000, 29),
(N'Tương ớt', 15, 800, 29),

-- Dish 30: Mì ý sốt bò bằm
(N'Mì ý', 25, 3000, 30),
(N'Thịt bò bằm', 20, 10000, 30),
(N'Sốt cà', 20, 2000, 30),
(N'Phô mai bào', 15, 4000, 30),

-- Dish 31: Nước ép dứa
(N'Dứa tươi', 30, 3000, 31),
(N'Đường', 15, 500, 31),
(N'Đá viên', 20, 200, 31),

-- Dish 32: Cháo sườn trứng bắc thảo
(N'Gạo tẻ', 30, 1000, 32),
(N'Sườn non', 20, 10000, 32),
(N'Trứng bắc thảo', 10, 7000, 32),

-- Dish 33: Lẩu cá chua cay
(N'Cá', 15, 10000, 33),
(N'Măng chua', 15, 3000, 33),
(N'Nước dùng cá', 20, 3000, 33),
(N'Rau ăn lẩu', 25, 4000, 33);

-- Insert Vouchers created by seller staff (staffId = 3) --sellerStaff
INSERT INTO Voucher (code, voucherDescription, discount, maxDiscountValue, minOrderValue, startDate, endDate, usageLimit, active, FK_Voucher_Staff)
VALUES 
('SELLER10', N'Giảm 10% cho đơn từ 100k', 10.0, 30000, 100000, GETDATE(), DATEADD(DAY, 30, GETDATE()), 100, 1, 3),
('SELLER20K', N'Giảm 20K cho đơn từ 150k', 20000, 20000, 150000, GETDATE(), DATEADD(DAY, 30, GETDATE()), 50, 1, 3),
('FREESHIP', N'Miễn phí ship cho đơn từ 80k', 15000, 15000, 80000, GETDATE(), DATEADD(DAY, 15, GETDATE()), 200, 1, 3),
('COMBO50', N'Giảm 50K cho đơn combo từ 250k', 50000, 50000, 250000, GETDATE(), DATEADD(DAY, 20, GETDATE()), 30, 1, 3),
('THAI15', N'Giảm 15% cho món Thái', 15.0, 40000, 120000, GETDATE(), DATEADD(DAY, 25, GETDATE()), 70, 1, 3),
('COFFEELOVER', N'Giảm 25K cho đơn cà phê từ 100k', 25000, 25000, 100000, GETDATE(), DATEADD(DAY, 10, GETDATE()), 80, 1, 3),
('NOODLE10', N'Giảm 10% cho các món mì - đơn từ 90k', 10.0, 20000, 90000, GETDATE(), DATEADD(DAY, 20, GETDATE()), 60, 1, 3),
('OISHIPWEEKEND', N'Cuối tuần rộn ràng - giảm 30K đơn từ 200k', 30000, 30000, 200000, GETDATE(), DATEADD(DAY, 5, GETDATE()), 40, 1, 3),
('LUNCHDEAL', N'Ưu đãi bữa trưa - giảm 20K đơn từ 120k', 20000, 20000, 120000, GETDATE(), DATEADD(DAY, 14, GETDATE()), 100, 1, 3),
('NEWUSER', N'Dành cho khách mới - giảm 15% tối đa 50K', 15.0, 50000, 0, GETDATE(), DATEADD(DAY, 30, GETDATE()), 150, 1, 3);

-- Lọc theo email
SELECT * FROM Account
WHERE role = 'customer'

-- Lọc theo accountID
SELECT * FROM Account
WHERE role = 'customer' AND accountID = ?;

-- Show ra bản phân loại từng account
SELECT 
    A.*, 
    S.staffType,
    CASE 
        WHEN A.role = 'admin' THEN 'Admin'
        WHEN A.role = 'customer' THEN 'Customer'
        WHEN A.role = 'staff' THEN 'Staff'
    END AS RoleName
FROM Account A
LEFT JOIN Staff S ON A.accountID = S.staffId;



--Xóa tất cả account 
DELETE FROM Staff WHERE staffId IN (2, 3);
DELETE FROM Account
WHERE role = 'staff';
DELETE FROM Account;
DBCC CHECKIDENT ('Account', RESEED, 0);
