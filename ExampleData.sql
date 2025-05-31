-- Insert Admin
INSERT INTO Account (fullName, email, phone, [password], [address], [status], [role])
VALUES (N'Admin', N'oiship.team@gmail.com', '0000000000', 
N'$2a$12$sxxt7Bu2u/tYKPAks5cno.pr1p2oC00KKo8K3RcvUqQP8BXrAp6sW', NULL, 1, 'admin'); -- bcrypt hash for 'admin'

-- Insert Staff Accounts
INSERT INTO Account (fullName, email, phone, [password], [address], [status], [role])
VALUES 
(N'Staff Inventory', N'inventory@oiship.com', '0900000001', N'$2a$12$VCPVGZ3.xad5z0YeaFvSqeGx8ZUbEZW1F8KrJ58dCtTzjhQ7ELbju', NULL, 1, 'staff'), -- "inventory@oiship.com", "inventorystaff",


(N'Staff Seller', N'seller@oiship.com', '0900000002', N'$2a$12$Cz1HZYwZ8RHPIxxClhY3AejchEReWbwrpV5zjNYip500Mq.QJYtWq', NULL, 1, 'staff'); -- "seller@oiship.com", "sellerstaff",

-- Insert Staff Details
-- Assuming IDs are sequential (admin = 1, inventory staff = 2, seller staff = 3)
INSERT INTO Staff (staffId, staffType)
VALUES 
(2, 'inventoryStaff'),
(3, 'sellerStaff');

-- Insert customers with status = 1 (Acctive account) 
INSERT INTO Account (fullName, email, phone, [password], [address], [status], [role]) 
VALUES 
(N'Nguyễn Văn A', N'a1@example.com', '0911000001', N'$2a$12$GCcNEKl50nvhBrIBYdTJVOzymgreoCI52S.PpRYV2F8E7.3lZ9kx2', N'Q1, HCM', 1, 'customer'), -- bcrypt hash for 'customer'
(N'Lê Thị B', N'b2@example.com', '0911000002', N'$2a$12$GCcNEKl50nvhBrIBYdTJVOzymgreoCI52S.PpRYV2F8E7.3lZ9kx2', N'Q2, HCM', 1, 'customer'),
(N'Trần Văn C', N'c3@example.com', '0911000003', N'$2a$12$GCcNEKl50nvhBrIBYdTJVOzymgreoCI52S.PpRYV2F8E7.3lZ9kx2', N'Q3, HCM', 1, 'customer'),
(N'Phạm Thị D', N'd4@example.com', '0911000004', N'$2a$12$GCcNEKl50nvhBrIBYdTJVOzymgreoCI52S.PpRYV2F8E7.3lZ9kx2', N'Q4, HCM', 1, 'customer'),
(N'Hoàng Văn E', N'e5@example.com', '0911000005', N'$2a$12$GCcNEKl50nvhBrIBYdTJVOzymgreoCI52S.PpRYV2F8E7.3lZ9kx2', N'Q5, HCM', 1, 'customer'),
(N'Đặng Thị F', N'f6@example.com', '0911000006', N'$2a$12$GCcNEKl50nvhBrIBYdTJVOzymgreoCI52S.PpRYV2F8E7.3lZ9kx2', N'Q6, HCM', 1, 'customer'),
(N'Vũ Văn G', N'g7@example.com', '0911000007', N'$2a$12$GCcNEKl50nvhBrIBYdTJVOzymgreoCI52S.PpRYV2F8E7.3lZ9kx2', N'Q7, HCM', 1, 'customer'),
(N'Ngô Thị H', N'h8@example.com', '0911000008', N'$2a$12$GCcNEKl50nvhBrIBYdTJVOzymgreoCI52S.PpRYV2F8E7.3lZ9kx2', N'Q8, HCM', 1, 'customer'),
(N'Bùi Văn I', N'i9@example.com', '0911000009', N'$2a$12$GCcNEKl50nvhBrIBYdTJVOzymgreoCI52S.PpRYV2F8E7.3lZ9kx2', N'Q9, HCM', 1, 'customer'),
(N'Đỗ Thị K', N'k10@example.com', '0911000010', N'$2a$12$GCcNEKl50nvhBrIBYdTJVOzymgreoCI52S.PpRYV2F8E7.3lZ9kx2', N'Tân Bình, HCM', 1, 'customer');


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

-- Insert Meals (with NULL image)
-- Assuming category IDs start at 1 and are in the order they were inserted
INSERT INTO Meal (mealName, price, [image], mealDescription, stock, FK_Meal_Category)
VALUES 
(N'Cơm gà xối mỡ', 35000, NULL, N'Cơm gà chiên giòn, nước mắm', 20, 1),
(N'Phở bò tái', 45000, NULL, N'Phở truyền thống với bò tái', 30, 2),
(N'Bánh mì thịt nguội', 20000, NULL, N'Bánh mì kẹp thịt nguội, rau sống', 25, 3),
(N'Trà sữa trân châu đường đen', 40000, NULL, N'Trà sữa ngọt béo kèm trân châu', 40, 4),
(N'Cà phê sữa đá', 20000, NULL, N'Cà phê pha phin với sữa đặc', 50, 5),
(N'Súp cua trứng bắc thảo', 30000, NULL, N'Súp dinh dưỡng, vị thanh', 15, 6),
(N'Gà rán cay Hàn Quốc', 50000, NULL, N'Gà chiên sốt cay kiểu Hàn', 20, 7),
(N'Lẩu thái chua cay', 150000, NULL, N'Lẩu tôm mực kiểu Thái', 10, 8),
(N'Gỏi cuốn tôm thịt', 25000, NULL, N'Gỏi cuốn với nước mắm chấm', 35, 9),
(N'Nước ép cam tươi', 30000, NULL, N'Cam vắt nguyên chất', 30, 10),
(N'Bánh tart trứng', 15000, NULL, N'Bánh mềm, nhân trứng sữa', 20, 11),
(N'Pizza xúc xích', 90000, NULL, N'Món pizza Ý thơm ngon', 12, 12),
(N'Bánh tráng trộn', 20000, NULL, N'Món ăn vặt Sài Gòn đặc trưng', 50, 13), 
(N'Mì xào bò', 45000, NULL, N'Mì xào với thịt bò mềm và rau', 25, 2),
(N'Bún bò Huế', 50000, NULL, N'Món bún đặc trưng miền Trung', 20, 2),
(N'Cơm tấm sườn bì', 45000, NULL, N'Cơm tấm với sườn, bì, chả', 30, 1),
(N'Bánh mì chảo', 35000, NULL, N'Bánh mì chảo nóng với trứng và pate', 15, 3),
(N'Trà sữa thái xanh', 38000, NULL, N'Trà sữa vị trà thái tươi mát', 40, 4),
(N'Cà phê đen đá', 18000, NULL, N'Cà phê truyền thống đậm đà', 50, 5),
(N'Súp hải sản', 40000, NULL, N'Súp thơm ngon với tôm và mực', 18, 6),
(N'Cánh gà chiên nước mắm', 45000, NULL, N'Món cánh gà chiên giòn', 22, 7),
(N'Lẩu nấm chay', 120000, NULL, N'Lẩu nấm thanh đạm phù hợp ăn chay', 12, 8),
(N'Nem cuốn', 20000, NULL, N'Nem cuốn tươi ngon với rau sống', 35, 9),
(N'Sinh tố bơ', 35000, NULL, N'Sinh tố bơ sánh mịn', 25, 10),
(N'Bánh tiramisu', 40000, NULL, N'Bánh mềm, vị cà phê ngọt dịu', 20, 11),
(N'Cơm chiên hải sản', 50000, NULL, N'Cơm chiên tôm mực thơm ngon', 28, 1),
(N'Pizza hải sản', 100000, NULL, N'Pizza topping tôm, mực, phô mai', 10, 12),
(N'Bánh tráng nướng', 25000, NULL, N'Bánh tráng nướng kiểu Đà Lạt', 40, 13),
(N'Bánh mì que', 15000, NULL, N'Món ăn nhẹ tiện lợi', 30, 3),
(N'Mì ý sốt bò bằm', 60000, NULL, N'Món Âu đơn giản, vị béo', 20, 12),
(N'Nước ép dứa', 28000, NULL, N'Nước ép thơm mát, giải nhiệt', 30, 10),
(N'Cháo sườn trứng bắc thảo', 35000, NULL, N'Cháo đặc biệt cho buổi sáng', 15, 6),
(N'Lẩu cá chua cay', 160000, NULL, N'Lẩu với cá và măng chua', 8, 8);

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



--xóa tất cả account 
DELETE FROM Staff WHERE staffId IN (2, 3);
DELETE FROM Account
WHERE role = 'staff';
DELETE FROM Account;
DBCC CHECKIDENT ('Account', RESEED, 0);
