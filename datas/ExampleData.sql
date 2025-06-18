USE Oiship;
GO

-- Insert Admin and Staff into Account
-- Enable IDENTITY_INSERT for Account
SET IDENTITY_INSERT Account ON;

-- Insert Admin
INSERT INTO Account (accountID, fullName, email, [password], role)
VALUES 
    (1, N'Admin', 'oiship.team@gmail.com', '$2a$12$idmLQWYZMvm/xdTYIq5CEO3PulVWC2U4Eivgns3pMhJ3Bsw74hQO2', 'admin');
-- Insert Staff
INSERT INTO Account (accountID, fullName, email, [password], role)
VALUES 
    (2, N'Staff User', 'staff@example.com', '$2a$12$0A7rM0nz6AuoNZx66i6fp.pnEpNR06gjH89Y.hYN8jEbCv9OfGIbi', 'staff');

-- Insert Customer
INSERT INTO Account (accountID, fullName, email, [password], role)
VALUES 
    (3, N'Customer One', 'customer1@example.com', '$2a$12$aaaaaaabbbbbbbbccccccddeeeeeeeffffffffgggggggg', 'customer'),
    (4, N'Customer Two', 'customer2@example.com', '$2a$12$aaaaaaabbbbbbbbccccccddeeeeeeeffffffffgggggggg', 'customer'),
    (5, N'Customer Three', 'customer3@example.com', '$2a$12$aaaaaaabbbbbbbbccccccddeeeeeeeffffffffgggggggg', 'customer');

INSERT INTO Customer (customerID, status, phone, address)
VALUES 
    (3, 1, '0909123123', N'123 Main Street, Hanoi'),
    (4, 1, '0912345678', N'456 Le Loi, Da Nang'),
    (5, 1, '0987654321', N'789 Nguyen Hue, HCMC');


-- Disable IDENTITY_INSERT for Account
SET IDENTITY_INSERT Account OFF;

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

-- Insert Ingredients (không có quantity và FK_Ingredient_Dish, thay vào đó dùng FK_Ingredient_Account)
INSERT INTO Ingredient (name, unitCost, FK_Ingredient_Account)
VALUES 
    (N'Gạo', 500, 1),
    (N'Gà chiên', 15000, 1),
    (N'Nước mắm', 2000, 1),
    (N'Hành phi', 1000, 1),
    (N'Bánh phở', 1000, 1),
    (N'Thịt bò tái', 18000, 1),
    (N'Hành lá', 500, 1),
    (N'Gừng', 800, 1),
    (N'Nước dùng bò', 3000, 1),
    (N'Bánh mì', 1500, 1),
    (N'Thịt nguội', 7000, 1),
    (N'Dưa leo', 1500, 1),
    (N'Rau sống', 1000, 1),
    (N'Trà đen', 2000, 1),
    (N'Sữa đặc', 1500, 1),
    (N'Trân châu', 1000, 1),
    (N'Đường đen', 1200, 1),
    (N'Cà phê', 1000, 1),
    (N'Đá viên', 200, 1),
    (N'Thịt cua', 12000, 1),
    (N'Trứng bắc thảo', 7000, 1),
    (N'Ngô non', 2000, 1),
    (N'Bột năng', 500, 1),
    (N'Gà miếng', 15000, 1),
    (N'Sốt cay Hàn', 3000, 1),
    (N'Bột chiên giòn', 1000, 1),
    (N'Tỏi băm', 500, 1),
    (N'Tôm', 10000, 1),
    (N'Mực', 12000, 1),
    (N'Nước lẩu thái', 3000, 1),
    (N'Rau thập cẩm', 4000, 1),
    (N'Nấm', 4000, 1),
    (N'Bánh tráng', 1000, 1),
    (N'Tôm luộc', 8000, 1),
    (N'Thịt luộc', 7000, 1),
    (N'Cam tươi', 3000, 1),
    (N'Đường', 500, 1),
    (N'Trứng gà', 2000, 1),
    (N'Sữa tươi', 1500, 1),
    (N'Bột mì', 1000, 1),
    (N'Bơ', 5000, 1),
    (N'Bột pizza', 3000, 1),
    (N'Xúc xích', 7000, 1),
    (N'Phô mai', 10000, 1),
    (N'Sốt cà', 2000, 1),
    (N'Bánh tráng cắt sợi', 1000, 1),
    (N'Tóp mỡ', 3000, 1),
    (N'Trứng cút', 2000, 1),
    (N'Xoài xanh', 1500, 1),
    (N'Mì trứng', 1500, 1),
    (N'Thịt bò mềm', 18000, 1),
    (N'Rau cải', 1000, 1),
    (N'Nước tương', 800, 1),
    (N'Bún tươi', 1500, 1),
    (N'Thịt bò Huế', 18000, 1),
    (N'Chả Huế', 5000, 1),
    (N'Nước dùng đặc biệt', 3000, 1),
    (N'Cơm tấm', 1500, 1),
    (N'Sườn nướng', 12000, 1),
    (N'Bì heo', 5000, 1),
    (N'Chả trứng', 4000, 1),
    (N'Trứng ốp la', 2000, 1),
    (N'Pate gan', 4000, 1),
    (N'Trà thái xanh', 2000, 1),
    (N'Sữa bột', 1500, 1),
    (N'Cà phê đen', 1000, 1),
    (N'Tôm tươi', 8000, 1),
    (N'Nước dùng', 3000, 1),
    (N'Cánh gà', 12000, 1),
    (N'Nấm rơm', 4000, 1),
    (N'Nấm kim châm', 4000, 1),
    (N'Nước dùng chay', 2000, 1),
    (N'Thịt heo luộc', 7000, 1),
    (N'Bơ', 5000, 1),
    (N'Bánh ladyfinger', 3000, 1),
    (N'Mascarpone', 10000, 1),
    (N'Cà phê', 1000, 1),
    (N'Socola', 5000, 1),
    (N'Cơm trắng', 1000, 1),
    (N'Đế pizza', 3000, 1),
    (N'Hành phi', 1000, 1),
    (N'Chà bông', 3000, 1),
    (N'Bánh mì que', 1200, 1),
    (N'Tương ớt', 800, 1),
    (N'Mì ý', 3000, 1),
    (N'Thịt bò bằm', 10000, 1),
    (N'Phô mai bào', 4000, 1),
    (N'Dứa tươi', 3000, 1),
    (N'Gạo tẻ', 1000, 1),
    (N'Sườn non', 10000, 1),
    (N'Cá', 10000, 1),
    (N'Măng chua', 3000, 1),
    (N'Nước dùng cá', 3000, 1),
    (N'Rau ăn lẩu', 4000, 1);

-- Insert DishIngredient (mối quan hệ n-n giữa Dish và Ingredient)
INSERT INTO DishIngredient (dishID, ingredientID, quantity)
VALUES 
    -- Dish 1: Cơm gà xối mỡ
    (1, 1, 0.5),  -- Gạo
    (1, 2, 0.2),  -- Gà chiên
    (1, 3, 0.3),  -- Nước mắm
    (1, 4, 0.25), -- Hành phi

    -- Dish 2: Phở bò tái
    (2, 5, 0.5),  -- Bánh phở
    (2, 6, 0.25), -- Thịt bò tái
    (2, 7, 0.3),  -- Hành lá
    (2, 8, 0.1),  -- Gừng
    (2, 9, 0.4),  -- Nước dùng bò

    -- Dish 3: Bánh mì thịt nguội
    (3, 10, 0.5), -- Bánh mì
    (3, 11, 0.3), -- Thịt nguội
    (3, 12, 0.2), -- Dưa leo
    (3, 13, 0.2), -- Rau sống

    -- Dish 4: Trà sữa trân châu đường đen
    (4, 14, 0.3), -- Trà đen
    (4, 15, 0.25), -- Sữa đặc
    (4, 16, 0.4),  -- Trân châu
    (4, 17, 0.3),  -- Đường đen

    -- Dish 5: Cà phê sữa đá
    (5, 18, 0.5), -- Cà phê
    (5, 15, 0.4), -- Sữa đặc
    (5, 19, 0.6), -- Đá viên

    -- Dish 6: Súp cua trứng bắc thảo
    (6, 20, 0.2), -- Thịt cua
    (6, 21, 0.15), -- Trứng bắc thảo
    (6, 22, 0.2),  -- Ngô non
    (6, 23, 0.1),  -- Bột năng

    -- Dish 7: Gà rán cay Hàn Quốc
    (7, 24, 0.25), -- Gà miếng
    (7, 25, 0.15), -- Sốt cay Hàn
    (7, 26, 0.2),  -- Bột chiên giòn
    (7, 27, 0.2),  -- Tỏi băm

    -- Dish 8: Lẩu thái chua cay
    (8, 28, 0.1),  -- Tôm
    (8, 29, 0.1),  -- Mực
    (8, 30, 0.2),  -- Nước lẩu thái
    (8, 31, 0.3),  -- Rau thập cẩm
    (8, 32, 0.2),  -- Nấm

    -- Dish 9: Gỏi cuốn tôm thịt
    (9, 33, 0.3),  -- Bánh tráng
    (9, 34, 0.2),  -- Tôm luộc
    (9, 35, 0.2),  -- Thịt luộc
    (9, 13, 0.25), -- Rau sống

    -- Dish 10: Nước ép cam tươi
    (10, 36, 0.4), -- Cam tươi
    (10, 37, 0.2), -- Đường
    (10, 19, 0.2), -- Đá viên

    -- (Tiếp tục cho các dish khác, ví dụ)
    (11, 38, 0.3), -- Trứng gà
    (11, 39, 0.2), -- Sữa tươi
    (11, 40, 0.25), -- Bột mì
    (11, 41, 0.15), -- Bơ

    (12, 42, 0.2), -- Bột pizza
    (12, 43, 0.2), -- Xúc xích
    (12, 44, 0.15), -- Phô mai
    (12, 45, 0.2),  -- Sốt cà

    (13, 46, 0.3), -- Bánh tráng cắt sợi
    (13, 47, 0.2), -- Tóp mỡ
    (13, 48, 0.25), -- Trứng cút
    (13, 49, 0.2),  -- Xoài xanh

    -- (Thêm các dish còn lại tương tự, chỉ liệt kê một phần để minh họa)
    (14, 50, 0.3), -- Mì trứng
    (14, 51, 0.2), -- Thịt bò mềm
    (14, 52, 0.25), -- Rau cải
    (14, 53, 0.2),  -- Nước tương

    (15, 54, 0.3), -- Bún tươi
    (15, 55, 0.25), -- Thịt bò Huế
    (15, 56, 0.2),  -- Chả Huế
    (15, 57, 0.25), -- Nước dùng đặc biệt

    -- (Tiếp tục cho các dish từ 16 đến 33 tương tự, bạn có thể bổ sung đầy đủ)
    -- Ví dụ Dish 16
    (16, 58, 0.4), -- Cơm tấm
    (16, 59, 0.25), -- Sườn nướng
    (16, 60, 0.2),  -- Bì heo
    (16, 61, 0.2);  -- Chả trứng

-- Insert Vouchers (without FK_Voucher_Account, sẽ thêm sau nếu cần)
INSERT INTO Voucher (code, voucherDescription, discountType, discount, maxDiscountValue, minOrderValue, startDate, endDate, usageLimit, active)
VALUES 
    ('SELLER10', N'Giảm 10% cho đơn từ 100k', '%', 10.0, 30000, 100000, GETDATE(), DATEADD(DAY, 30, GETDATE()), 100, 1),
    ('SELLER20K', N'Giảm 20K cho đơn từ 150k', 'VND', 20000, 20000, 150000, GETDATE(), DATEADD(DAY, 30, GETDATE()), 50, 1),
    ('FREESHIP', N'Miễn phí ship cho đơn từ 80k', 'VND', 15000, 15000, 80000, GETDATE(), DATEADD(DAY, 15, GETDATE()), 200, 1),
    ('COMBO50', N'Giảm 50K cho đơn combo từ 250k', 'VND', 50000, 50000, 250000, GETDATE(), DATEADD(DAY, 20, GETDATE()), 30, 1),
    ('THAI15', N'Giảm 15% cho món Thái', '%', 15.0, 40000, 120000, GETDATE(), DATEADD(DAY, 25, GETDATE()), 70, 1),
    ('COFFEELOVER', N'Giảm 25K cho đơn cà phê từ 100k', 'VND', 25000, 25000, 100000, GETDATE(), DATEADD(DAY, 10, GETDATE()), 80, 1),
    ('NOODLE10', N'Giảm 10% cho các món mì - đơn từ 90k', '%', 10.0, 20000, 90000, GETDATE(), DATEADD(DAY, 20, GETDATE()), 60, 1),
    ('OISHIPWEEKEND', N'Cuối tuần rộn ràng - giảm 30K đơn từ 200k', 'VND', 30000, 30000, 200000, GETDATE(), DATEADD(DAY, 5, GETDATE()), 40, 1),
    ('LUNCHDEAL', N'Ưu đãi bữa trưa - giảm 20K đơn từ 120k', 'VND', 20000, 20000, 120000, GETDATE(), DATEADD(DAY, 14, GETDATE()), 100, 1),
    ('NEWUSER', N'Dành cho khách mới - giảm 15% tối đa 50K', '%', 15.0, 50000, 0, GETDATE(), DATEADD(DAY, 30, GETDATE()), 150, 1);

-- Insert Notifications
INSERT INTO Notification (notTitle, notDescription, FK_Notification_Account)
VALUES 
('System Maintenance', 'The system will be down for maintenance from 10 PM to 12 AM.', 1),
('New Feature Released', 'We have added a new dashboard analytics tool. Check it out!', 1),
('Voucher Update', 'A new voucher worth 50K VND has been added to your account.', 1),
('Holiday Announcement', 'We will be closed for Tet holiday from Feb 8 to Feb 14.', 1),
('Security Reminder', 'Please update your password every 90 days to keep your account secure.', 1);

-- Insert Contact Requests
INSERT INTO Contact ([subject], [message], FK_Contact_Customer)
VALUES
(N'Late Delivery', N'My order arrived 30 minutes late. Please improve delivery times.', 3),
(N'Wrong Order', N'I received the wrong dish. I ordered chicken but got beef.', 4),
(N'Service Feedback', N'The delivery person was very polite and helpful. Good job!', 5),
(N'App Bug', N'The app crashes when I try to view my order history.', 3),
(N'Suggestion', N'Can you add more vegan options to the menu?', 4);

-- Optional: Verify data
SELECT accountID, fullName, email, [password], role, createAt
FROM [Account]
WHERE role IN ('admin', 'staff');

SELECT catID, catName, catDescription
FROM Category;

SELECT dishID, dishName, opCost, interestPercentage, dishDescription, stock, FK_Dish_Category
FROM Dish;

SELECT ingredientID, name, unitCost, FK_Ingredient_Account
FROM Ingredient;

SELECT dishID, ingredientID, quantity
FROM DishIngredient;

SELECT voucherID, code, voucherDescription, discount, maxDiscountValue, minOrderValue, startDate, endDate, usageLimit, active
FROM Voucher;