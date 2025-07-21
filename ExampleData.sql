USE Oiship;
GO

-- Insert Accounts (consolidated to avoid duplicates)
INSERT INTO [Account] (fullName, email, [password], role, createAt, status)
VALUES 
    (N'Admin User', N'oiship.team@gmail.com', '$2a$12$LbQahNHNjDNd3N8QsEIVee/mh4TceoYZJNQoPD1x5aPzN9Zih/pAe', N'admin', '2025-06-18 13:00:00', 1),
    (N'Staff User 1', N'staff1@example.com', '$2a$12$0A7rM0nz6AuoNZx66i6fp.pnEpNR06gjH89Y.hYN8jEbCv9OfGIbi', N'staff', '2025-06-18 15:39:00', 1),
    (N'Staff User 2', N'staff2@example.com', '$2a$12$0A7rM0nz6AuoNZx66i6fp.pnEpNR06gjH89Y.hYN8jEbCv9OfGIbi', N'staff', '2025-06-18 15:39:00', 1),
    (N'Staff User 3', N'staff3@example.com', '$2a$12$9kL5mPx7jK8Qv2w3n4r6uO5pQrT8yZ9xLmNoPqR1vW2xY3zA7bCde', N'staff', '2025-06-18 15:52:00', 1),
    (N'Staff User 4', N'staff4@example.com', '$2a$12$QwErTyUiOp9kLmNoPqR1vW2xY3zA7bCde5jK8Qv2w3n4r6uO', N'staff', '2025-06-18 15:52:00', 1),
    (N'Customer 1', N'customer1@example.com', '$2a$12$LmNoPqR1vW2xY3zA7bCde5jK8Qv2w3n4r6uO5pQrT8yZ9xLm', N'customer', '2025-06-18 15:52:00', 1),
    (N'Customer 2', N'customer2@example.com', '$2a$12$Y3zA7bCde5jK8Qv2w3n4r6uO5pQrT8yZ9xLmNoPqR1vW2xY3', N'customer', '2025-06-18 15:52:00', 1),
    (N'Customer 3', N'customer3@example.com', '$2a$12$5jK8Qv2w3n4r6uO5pQrT8yZ9xLmNoPqR1vW2xY3zA7bCde5j', N'customer', '2025-06-18 15:52:00', 1),
    (N'Customer 4', N'customer4@example.com', '$2a$12$R1vW2xY3zA7bCde5jK8Qv2w3n4r6uO5pQrT8yZ9xLmNoPqR', N'customer', '2025-06-18 15:52:00', 1),
    (N'Customer 5', N'customer5@example.com', '$2a$12$zA7bCde5jK8Qv2w3n4r6uO5pQrT8yZ9xLmNoPqR1vW2xY3zA', N'customer', '2025-06-18 15:52:00', 1),
    (N'Customer 6', N'customer6@example.com', '$2a$12$8Qv2w3n4r6uO5pQrT8yZ9xLmNoPqR1vW2xY3zA7bCde5jK8Q', N'customer', '2025-06-18 15:52:00', 1),
    (N'Customer 7', N'customer7@example.com', '$2a$12$n4r6uO5pQrT8yZ9xLmNoPqR1vW2xY3zA7bCde5jK8Qv2w3n4', N'customer', '2025-06-18 15:52:00', 1),
    (N'Customer 8', N'customer8@example.com', '$2a$12$T8yZ9xLmNoPqR1vW2xY3zA7bCde5jK8Qv2w3n4r6uO5pQrT', N'customer', '2025-06-18 15:52:00', 1),
    (N'Customer 9', N'customer9@example.com', '$2a$12$NoPqR1vW2xY3zA7bCde5jK8Qv2w3n4r6uO5pQrT8yZ9xLmN', N'customer', '2025-06-18 15:52:00', 1),
    (N'Customer 10', N'customer10@example.com', '$2a$12$xY3zA7bCde5jK8Qv2w3n4r6uO5pQrT8yZ9xLmNoPqR1vW2x', N'customer', '2025-06-18 15:52:00', 1);

-- Insert Customers (corresponding to accountID 6 to 15)
INSERT INTO Customer (customerID, phone, address)
VALUES 
    (6, '0901111000', N'123 Đường Láng, Hà Nội'),
    (7, '0901111001', N'456 Nguyễn Trãi, TP.HCM'),
    (8, '0901111002', N'789 CMT8, Đà Nẵng'),
    (9, '0901111003', N'101 Hùng Vương, Huế'),
    (10, '0901111004', N'202 Lê Lợi, Vinh'),
    (11, '0901111005', N'303 Phạm Văn Đồng, Cần Thơ'),
    (12, '0901111006', N'404 Trường Chinh, Quảng Ngãi'),
    (13, '0901111007', N'505 Điện Biên Phủ, Hải Phòng'),
    (14, '0901111008', N'606 Võ Thị Sáu, Biên Hòa'),
    (15, '0901111009', N'707 Trần Hưng Đạo, Nha Trang');

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

-- Insert Dishes
INSERT INTO Dish (dishName, opCost, interestPercentage, [image], dishDescription, stock, isAvailable, FK_Dish_Category)
VALUES 
    (N'Cơm gà xối mỡ', 28000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385058/dishes/cach-lam-com-ga-chien-xoi-mo-ngon-da-vang-gion-rum-dom-gian-avt-1200x676.jpg.jpg', N'Cơm gà chiên giòn, nước mắm', 20, 1, 1),
    (N'Phở bò tái', 36000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384800/dishes/OIP.jpg.jpg', N'Phở truyền thống với bò tái', 30, 1, 2),
    (N'Bánh mì thịt nguội', 16000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750035552/dishes/download.jpg.jpg', N'Bánh mì kẹp thịt nguội, rau sống', 25, 1, 3),
    (N'Trà sữa trân châu đường đen', 32000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385726/dishes/R.jpg.jpg', N'Trà sữa ngọt béo kèm trân châu', 40, 1, 4),
    (N'Cà phê sữa đá', 16000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384941/dishes/OIP%20%281%29.jpg.jpg', N'Cà phê pha phin với sữa đặc', 50, 1, 5),
    (N'Súp cua trứng bắc thảo', 24000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384885/dishes/Sup.jpg.jpg', N'Súp dinh dưỡng, vị thanh', 15, 1, 6),
    (N'Gà rán cay Hàn Quốc', 40000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385113/dishes/287c6cc2-836a-4106-88b1-d0325ef3e7ad.jpg.jpg', N'Gà chiên sốt cay kiểu Hàn', 20, 1, 7),
    (N'Lẩu thái chua cay', 120000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385492/dishes/lau-thai-hai-san-thumb.jpg.jpg', N'Lẩu tôm mực kiểu Thái', 10, 1, 8),
    (N'Gỏi cuốn tôm thịt', 20000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384997/dishes/5519_4.jpg.jpg', N'Gỏi cuốn với nước mắm chấm', 35, 1, 9),
    (N'Nước ép cam tươi', 24000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385637/dishes/cach-lam-nuoc-ep-cam-11.jpg.jpg', N'Cam vắt nguyên chất', 30, 1, 10),
    (N'Bánh tart trứng', 12000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384767/dishes/cach-lam-banh-tart-trung.jpeg.jpg', N'Bánh mềm, nhân trứng sữa', 20, 1, 11),
    (N'Pizza xúc xích', 72000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385819/dishes/R%20%282%29.jpg.jpg', N'Món pizza Ý thơm ngon', 12, 1, 12),
    (N'Bánh tráng trộn', 16000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385769/dishes/banh-trang-tron-1.jpg.jpg', N'Món ăn vặt Sài Gòn đặc trưng', 50, 1, 13),
    (N'Mì xào bò', 36000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384825/dishes/mysaoR.jpg.jpg', N'Mì xào với thịt bò mềm và rau', 25, 1, 2),
    (N'Bún bò Huế', 40000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384858/dishes/bun-bo-hue-bowl.jpg.jpg', N'Món bún đặc trưng miền Trung', 20, 1, 2),
    (N'Cơm tấm sườn bì', 36000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385077/dishes/Suon-bi-op-la.png.png', N'Cơm tấm với sườn, bì, chả', 30, 1, 1),
    (N'Bánh mì chảo', 28000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384725/dishes/cach-lam-banh-mi-chao-tai-nha-8.jpg.jpg', N'Bánh mì chảo nóng với trứng và pate', 15, 1, 3),
    (N'Trà sữa thái xanh', 30400, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385757/dishes/R%20%281%29.jpg.jpg', N'Trà sữa vị trà thái tươi mát', 40, 1, 4),
    (N'Cà phê đen đá', 14400, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384982/dishes/ca-phe-den-da.png.png', N'Cà phê truyền thống đậm đà', 50, 1, 5),
    (N'Súp hải sản', 32000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384900/dishes/download%20%281%29.jpg.jpg', N'Súp thơm ngon với tôm và mực', 18, 1, 6),
    (N'Cánh gà chiên nước mắm', 36000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385139/dishes/OIP%20%282%29.jpg.jpg', N'Món cánh gà chiên giòn', 22, 1, 7),
    (N'Lẩu nấm chay', 96000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385534/dishes/Cach-lam-LAU-NAM-CHAY.jpg.jpg', N'Lẩu nấm thanh đạm phù hợp ăn chay', 12, 1, 8),
    (N'Nem cuốn', 16000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385017/dishes/e5899654-cach-lam-nem-cuon.jpg.jpg', N'Nem cuốn tươi ngon với rau sống', 35, 1, 9),
    (N'Sinh tố bơ', 28000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385654/dishes/cach-lam-sinh-to-bo-xoai.jpg.jpg', N'Sinh tố bơ sánh mịn', 25, 1, 10),
    (N'Bánh tiramisu', 32000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384781/dishes/banh-tiramisu.jpg.jpg', N'Bánh mềm, vị cà phê ngọt dịu', 20, 1, 11),
    (N'Cơm chiên hải sản', 40000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385101/dishes/original.jpg.jpg', N'Cơm chiên tôm mực thơm ngon', 28, 1, 1),
    (N'Pizza hải sản', 80000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385836/dishes/DSCF5429-1536x1024.jpg.jpg', N'Pizza topping tôm, mực, phô mai', 10, 1, 12),
    (N'Bánh tráng nướng', 20000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385806/dishes/vshjsfdghjhvc-1.jpg.jpg', N'Bánh tráng nướng kiểu Đà Lạt', 40, 1, 13),
    (N'Bánh mì que', 12000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384753/dishes/banh-mi-que-phap_1.jpg.jpg', N'Món ăn nhẹ tiện lợi', 30, 1, 3),
    (N'Mì ý sốt bò bằm', 48000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385857/dishes/hinh-mon-mi-y.jpg.jpg', N'Món Âu đơn giản, vị béo', 20, 1, 12),
    (N'Nước ép dứa', 22400, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385709/dishes/nuoc-ep-dua-luoi-thom-dua-692618.jpg.jpg', N'Nước ép thơm mát, giải nhiệt', 30, 1, 10),
    (N'Cháo sườn trứng bắc thảo', 28000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750384925/dishes/chao-trung-vit-bac-thao-2.jpg.jpg', N'Cháo đặc biệt cho buổi sáng', 15, 1, 6),
    (N'Lẩu cá chua cay', 128000, 25, 'https://res.cloudinary.com/dw0x1mci6/image/upload/v1750385623/dishes/lau-ca-dieu-hong-chua-cay.jpg.jpg', N'Lẩu với cá và măng chua', 8, 1, 8);

-- Insert Ingredients
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
    (N'Trân châu', 3000, 1),
    (N'Đường đen', 2000, 1),
    (N'Đá viên', 500, 1),
    (N'Thịt cua', 20000, 1),
    (N'Trứng bắc thảo', 5000, 1),
    (N'Ngô non', 1500, 1),
    (N'Bột năng', 1000, 1),
    (N'Gà miếng', 18000, 1),
    (N'Sốt cay Hàn', 3000, 1),
    (N'Bột chiên giòn', 2000, 1),
    (N'Tỏi băm', 1000, 1),
    (N'Tôm', 25000, 1),
    (N'Mực', 20000, 1),
    (N'Nước lẩu thái', 5000, 1),
    (N'Rau thập cẩm', 1500, 1),
    (N'Nấm', 2000, 1),
    (N'Bánh tráng', 1000, 1),
    (N'Tôm luộc', 30000, 1),
    (N'Thịt luộc', 20000, 1),
    (N'Cam tươi', 5000, 1),
    (N'Đường', 1000, 1),
    (N'Cà phê', 2000, 1),
    (N'Mì trứng', 1000, 1),
    (N'Thịt bò', 18000, 1),
    (N'Bún', 1000, 1),
    (N'Nước dùng heo', 3000, 1),
    (N'Sườn heo', 15000, 1),
    (N'Bì heo', 5000, 1),
    (N'Chả trứng', 6000, 1),
    (N'Trứng ốp la', 3000, 1),
    (N'Pate', 2000, 1),
    (N'Trà thái', 2000, 1),
    (N'Hải sản', 25000, 1),
    (N'Cánh gà', 15000, 1),
    (N'Nấm chay', 2000, 1),
    (N'Bơ', 5000, 1),
    (N'Phô mai', 3000, 1),
    (N'Bột bánh tráng', 1000, 1),
    (N'Topping Đà Lạt', 2000, 1),
    (N'Xúc xích', 7000, 1),
    (N'Sốt bò bằm', 5000, 1),
    (N'Dứa', 4000, 1),
    (N'Sườn non', 15000, 1),
    (N'Cá', 20000, 1),
    (N'Măng chua', 2000, 1);

-- Insert DishIngredient Relationships
INSERT INTO DishIngredient (dishID, ingredientID, quantity)
VALUES 
    (1, 1, 0.5), (1, 2, 0.2), (1, 3, 0.03), (1, 4, 0.01),
    (2, 5, 0.3), (2, 6, 0.15), (2, 7, 0.01), (2, 8, 0.01), (2, 9, 0.5),
    (3, 10, 0.2), (3, 11, 0.1), (3, 12, 0.05), (3, 13, 0.05),
    (4, 14, 0.02), (4, 15, 0.05), (4, 16, 0.1), (4, 17, 0.05), (4, 18, 0.2),
    (5, 37, 0.02), (5, 15, 0.03), (5, 18, 0.2),
    (6, 19, 0.05), (6, 20, 0.02), (6, 21, 0.03), (6, 22, 0.01),
    (7, 23, 0.2), (7, 24, 0.03), (7, 25, 0.05), (7, 26, 0.01),
    (8, 27, 0.1), (8, 28, 0.1), (8, 29, 0.3), (8, 30, 0.2), (8, 31, 0.1),
    (9, 32, 0.02), (9, 33, 0.05), (9, 34, 0.05), (9, 13, 0.05),
    (10, 35, 0.3), (10, 36, 0.01), (10, 18, 0.2),
    (11, 15, 0.02), (11, 36, 0.02),
    (12, 55, 0.1), (12, 52, 0.05),
    (13, 32, 0.05), (13, 54, 0.03), (13, 7, 0.01),
    (14, 38, 0.2), (14, 39, 0.1), (14, 13, 0.05), (14, 26, 0.01),
    (15, 40, 0.3), (15, 39, 0.1), (15, 41, 0.5), (15, 7, 0.01),
    (16, 1, 0.3), (16, 42, 0.1), (16, 43, 0.03), (16, 44, 0.03),
    (17, 10, 0.2), (17, 45, 0.02), (17, 46, 0.03), (17, 12, 0.05),
    (18, 47, 0.02), (18, 15, 0.05), (18, 16, 0.1), (18, 17, 0.05), (18, 18, 0.2),
    (19, 37, 0.02), (19, 18, 0.2), (19, 36, 0.01),
    (20, 48, 0.1), (20, 22, 0.01), (20, 30, 0.05),
    (21, 49, 0.2), (21, 3, 0.03), (21, 25, 0.05),
    (22, 50, 0.2), (22, 30, 0.2), (22, 31, 0.1),
    (23, 32, 0.02), (23, 33, 0.05), (23, 13, 0.05),
    (24, 51, 0.2), (24, 15, 0.03), (24, 18, 0.2),
    (25, 37, 0.01), (25, 15, 0.02), (25, 36, 0.02),
    (26, 1, 0.3), (26, 48, 0.1), (26, 7, 0.01),
    (27, 27, 0.05), (27, 28, 0.05), (27, 52, 0.1),
    (28, 53, 0.02), (28, 54, 0.03), (28, 7, 0.01),
    (29, 10, 0.1), (29, 55, 0.05), (29, 46, 0.03),
    (30, 38, 0.2), (30, 56, 0.06), (30, 52, 0.03),
    (31, 57, 0.3), (31, 36, 0.01), (31, 18, 0.2),
    (32, 58, 0.1), (32, 20, 0.02), (32, 1, 0.1),
    (33, 59, 0.2), (33, 60, 0.1), (33, 30, 0.2);
	select * from Voucher
-- Insert Vouchers
INSERT INTO Voucher (code, voucherDescription, discountType, discount, maxDiscountValue, minOrderValue, startDate, endDate, usageLimit, usedCount, active, FK_Voucher_Account)
VALUES 
    ('SELLER10', N'Giảm 10% cho đơn từ 100k', '%', 10.0, 30000, 100000, '2025-06-18', '2025-07-18', 100, 0, 1, 1),
    ('SELLER20K', N'Giảm 20K cho đơn từ 150k', 'VND', 20000, 20000, 150000, '2025-06-18', '2025-07-18', 50, 0, 1, 2),
    ('FREESHIP', N'Miễn phí ship cho đơn từ 80k', 'VND', 15000, 15000, 80000, '2025-06-18', '2025-07-03', 200, 0, 1, 3),
    ('COMBO50', N'Giảm 50K cho đơn combo từ 250k', 'VND', 50000, 50000, 250000, '2025-06-18', '2025-07-08', 30, 0, 1, 4),
    ('THAI15', N'Giảm 15% cho món Thái', '%', 15.0, 40000, 120000, '2025-06-18', '2025-07-13', 70, 0, 1, 5),
    ('COFFEELOVER', N'Giảm 25K cho đơn cà phê từ 100k', 'VND', 25000, 25000, 100000, '2025-06-18', '2025-06-28', 80, 0, 1, 1);

-- Insert Orders
INSERT INTO [Order] (amount, orderStatus, paymentStatus, orderCreatedAt, orderUpdatedAt, FK_Order_Voucher, FK_Order_Customer)
VALUES 
    (70000, 0, 0, '2025-06-14 10:00:00', '2025-06-14 10:00:00', 1, 6),
    (90000, 1, 1, '2025-06-13 12:30:00', '2025-06-13 13:00:00', NULL, 6),
    (150000, 3, 1, '2025-06-12 15:45:00', '2025-06-12 16:30:00', 3, 7),
    (200000, 4, 1, '2025-06-11 09:15:00', '2025-06-11 11:00:00', 4, 7),
    (60000, 5, 2, '2025-06-10 14:20:00', '2025-06-10 15:00:00', NULL, 8),
    (80000, 2, 1, '2025-06-14 11:30:00', '2025-06-14 12:00:00', 5, 6),
    (60000, 6, 0, '2025-06-13 09:00:00', '2025-06-13 09:30:00', NULL, 8),
    (100000, 1, 1, '2025-06-12 13:15:00', '2025-06-12 13:45:00', 2, 7),
    (90000, 4, 1, '2025-06-11 16:00:00', '2025-06-11 17:30:00', NULL, 6),
    (100000, 3, 1, '2025-06-10 18:00:00', '2025-06-10 19:00:00', 6, 8);

-- Insert OrderDetails
INSERT INTO OrderDetail (quantity, FK_OD_Order, FK_OD_Dish)
VALUES 
    (2, 1, 1),
    (2, 2, 2),
    (1, 3, 8),
    (2, 4, 12),
    (3, 5, 13),
    (2, 6, 4),
    (3, 7, 3),
    (4, 8, 9),
    (3, 9, 10),
    (2, 10, 7);

-- Insert Additional OrderDetails for OrderID = 1
INSERT INTO OrderDetail (quantity, FK_OD_Order, FK_OD_Dish)
VALUES
    (2, 1, 1),
    (1, 1, 2),
    (3, 1, 4),
    (1, 1, 7),
    (2, 1, 9);

-- Insert Reviews
INSERT INTO Review (rating, comment, reviewCreatedAt, FK_Review_OrderDetail, FK_Review_Customer)
VALUES 
    (5, N'Rất ngon, giao hàng nhanh!', GETDATE(), 3, 6),
    (4, N'Vị ổn nhưng hơi nguội.', GETDATE(), 4, 7),
    (3, N'Tạm ổn, không quá đặc sắc.', GETDATE(), 5, 6),
    (2, N'Món ăn không giống hình.', GETDATE(), 6, 7),
    (5, N'Tuyệt vời, sẽ đặt lại lần nữa!', GETDATE(), 7, 6);

-- Insert Contact Requests
INSERT INTO Contact ([subject], [message], FK_Contact_Customer)
VALUES
(N'Late Delivery', N'My order arrived 30 minutes late. Please improve delivery times.', 6),
(N'Wrong Order', N'I received the wrong dish. I ordered chicken but got beef.', 7),
(N'Service Feedback', N'The delivery person was very polite and helpful. Good job!', 8),
(N'App Bug', N'The app crashes when I try to view my order history.', 9),
(N'Suggestion', N'Can you add more vegan options to the menu?', 10);



-- Admin có accountID = 1
INSERT INTO [Notification] (notTitle, notDescription, FK_Notification_Account) VALUES
(N'Nhà hàng tạm đóng cửa', N'Nhà hàng Oishi sẽ tạm ngưng phục vụ từ 01/07 đến 03/07 để bảo trì hệ thống.', 1),
(N'Voucher mới 50%', N'Nhận ngay voucher giảm giá 50% cho đơn hàng đầu tiên trong tháng 7.', 1),
(N'Giờ phục vụ thay đổi', N'Giờ phục vụ mới: 8:00 sáng đến 10:00 tối, áp dụng từ ngày 05/07.', 1),
(N'Thông báo hệ thống', N'Hệ thống sẽ bảo trì vào lúc 23:00 ngày 30/06. Mong quý khách thông cảm.', 1);


-- Ví dụ có các customerID là 101, 102, 103
INSERT INTO CustomerNotification (customerID, notID, isRead) VALUES
(11, 1, 0), -- Khách 101 được gửi thông báo tạm đóng cửa
(6, 2, 1), -- Khách 101 đã đọc voucher mới
(8, 2, 0), -- Khách 102 nhận voucher mới
(9, 4, 0), -- Khách 102 nhận thông báo hệ thống
(10, 1, 0), -- Khách 103 nhận thông báo tạm đóng cửa
(6, 3, 0); -- Khách 103 đã đọc giờ phục vụ thay đổi




-- Verification Queries
SELECT accountID, fullName, email, [password], role, status, createAt
FROM Account
WHERE role = 'admin';

SELECT accountID, fullName, email, status, role, createAt
FROM Account
WHERE role = 'customer';

SELECT accountID, fullName, email, status, role, createAt
FROM Account
WHERE role = 'staff';

SELECT catID, catName, catDescription
FROM Category;

SELECT dishID, dishName, opCost, interestPercentage, [image], dishDescription, stock, isAvailable, FK_Dish_Category
FROM Dish;

SELECT ingredientID, name, unitCost, FK_Ingredient_Account
FROM Ingredient;

SELECT dishID, ingredientID, quantity
FROM DishIngredient;

SELECT voucherID, code, voucherDescription, discountType, discount, maxDiscountValue, minOrderValue, startDate, endDate, usageLimit, usedCount, active, FK_Voucher_Account
FROM Voucher;

SELECT a.accountID, a.fullName, a.email, a.[password], a.status, a.role, a.createAt, 
       c.phone, c.address 
FROM Account a 
LEFT JOIN Customer c ON a.accountID = c.customerID;