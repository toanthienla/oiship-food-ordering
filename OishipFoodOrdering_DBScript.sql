-- OishipFoodOrdering_DBScript_Ver10.3.sql

USE master
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Oiship')
BEGIN
    ALTER DATABASE [Oiship] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [Oiship];
END
GO

CREATE DATABASE Oiship
GO

USE Oiship
GO

--I. Bảng Account:

--Cần nhập dữ liệu mẫu Admin trước
CREATE TABLE Account (
	account_id INT IDENTITY PRIMARY KEY,
	account_name NVARCHAR(100) NOT NULL,
	email NVARCHAR(100) NOT NULL UNIQUE,
	phone NVARCHAR(15) NOT NULL CHECK (phone LIKE '0%' AND LEN(phone) = 10 AND phone NOT LIKE '%[^0-9]%'),
	[password] NVARCHAR(60) NOT NULL,
	[status] NVARCHAR(50) NOT NULL CHECK ([status] IN ('not_verified', 'active', 'pending_approval', 'banned', 'online', 'offline')),
	cccd NVARCHAR(12) CHECK (LEN(cccd) = 12 AND cccd NOT LIKE '%[^0-9]%'), --Check NOT NULL với role Shipper
    license NVARCHAR(12) CHECK (LEN(license) BETWEEN 10 AND 12), --Check NOT NULL với role Shipper
    license_image VARBINARY(MAX), --Check NOT NULL với role Shipper
	number_plate NVARCHAR(100), --Bảng số xe, Check NOT NULL với role Shipper
	opening_time TIME,  -- Thời gian mở cửa, Check NOT NULL với role RestaurantManager
    closing_time TIME,  -- Thời gian đóng cửa, Check NOT NULL với role RestaurantManager
	[address] NVARCHAR(255),
	longitude DECIMAL(9,6), --Kinh độ
    latitude DECIMAL(9,6), --Vĩ độ
	account_created_at DATETIME DEFAULT GETDATE(), --Ngày tạo tài khoản
	[role] NVARCHAR(100) NOT NULL CHECK ([role] IN ('Admin', 'Customer', 'Shipper', 'RestaurantManager'))
);


--II. Các bảng giao dịch:

--Bảng Menu (Chứa các MenuItem/Món ăn)
CREATE TABLE Menu (
    menu_id INT IDENTITY PRIMARY KEY,
	available BIT DEFAULT 1, -- 1: available, 0: not available
	category NVARCHAR(100) NOT NULL CHECK (category IN ('breakfast', 'lunch', 'afternoon', 'dinner','late night')),
	restaurant_manager_id INT FOREIGN KEY REFERENCES Account(account_id) -- [RestaurantManager]
);

-- Bảng MenuDetail là những món ăn nằm trong menu
CREATE TABLE MenuDetail (
    menu_detail_id INT IDENTITY PRIMARY KEY,
	menu_detail_name NVARCHAR(100) NOT NULL,
	price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
	[image] NVARCHAR(255),
	menu_description NVARCHAR(255),
	is_available BIT NOT NULL DEFAULT 1,
    restaurant_manager_id INT FOREIGN KEY REFERENCES Account(account_id), --[RestaurantManager]
	menu_id INT NOT NULL FOREIGN KEY REFERENCES Menu(menu_id)
);

--Bảng mã giảm giá được sử dụng khi tạo Order
CREATE TABLE Discount (
    discount_id INT IDENTITY PRIMARY KEY,
    discount_code NVARCHAR(50) UNIQUE NOT NULL,       -- Mã giảm giá, ví dụ: 'SUMMER2025'
    discount_description NVARCHAR(255),
    discount_type NVARCHAR(50) CHECK (discount_type IN ('fixed', 'percentage')) NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    max_discount_value DECIMAL(10,2), -- Áp dụng nếu là phần trăm
    min_order_value DECIMAL(10,2),    -- Giá trị đơn tối thiểu để được áp dụng
    [start_date] DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    usage_limit INT,                 -- Số lần được dùng tổng cộng
    used_count INT DEFAULT 0,
    is_active BIT DEFAULT 1
);

-- Bảng Order (Là giỏ hàng đã được Customer xác nhận đặt hàng)
CREATE TABLE [Order] (
    order_id INT IDENTITY PRIMARY KEY,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method NVARCHAR(50) NOT NULL CHECK (payment_method IN ('online', 'offline')),
    order_status NVARCHAR(50) CHECK (order_status IN ('pending', 'preparing','taking place','picked', 'delivering', 'delivered','payment error', 'cancelled')),
	distance_km DECIMAL(10,2), --Khoảng cách tính dựa trên location của customer và restaurant manager
    order_created_at DATETIME DEFAULT GETDATE(), --Thời gian tạo đơn
    order_updated_at DATETIME DEFAULT GETDATE(), --Thời gian khi đơn cập nhật trạng thái/ hoàn thành đơn
	discount_id INT FOREIGN KEY REFERENCES Discount (discount_id),
	customer_id INT NOT NULL FOREIGN KEY REFERENCES Account(account_id),
    restaurant_manager_id INT NOT NULL FOREIGN KEY REFERENCES Account(account_id),
    shipper_id INT FOREIGN KEY REFERENCES Account(account_id)
);

-- Bảng OrderDetail (Là chi tiết của Order)
CREATE TABLE OrderDetail (
    order_detail_id INT IDENTITY PRIMARY KEY,
	quantity INT NOT NULL CHECK (quantity > 0),
	is_cart BIT DEFAULT 1, --Trạng thái mặc định là cart, khi người dùng xác nhận đổi thành 0
    order_id INT NOT NULL FOREIGN KEY REFERENCES [Order](order_id),
    menu_detail_id INT NOT NULL FOREIGN KEY REFERENCES MenuDetail(menu_detail_id),
	restaurant_manager_id INT FOREIGN KEY REFERENCES Account(account_id), --[RestaurantManager], Để biết món được thêm của nhà hàng nào 
	customer_id INT FOREIGN KEY REFERENCES Account(account_id) --[Customer]
);

-- III. Các bảng phụ trợ:

-- Bảng DishReview (Review từng món trong Order sau khi đơn hàng hoàn thành)
CREATE TABLE DishReview (
    dish_review_id INT IDENTITY PRIMARY KEY,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(255),
    dish_review_created_at DATETIME DEFAULT GETDATE(),
	order_detail_id INT NOT NULL FOREIGN KEY REFERENCES OrderDetail(order_detail_id),
    customer_id INT NOT NULL FOREIGN KEY REFERENCES Account(account_id)
);

-- Bảng DeliveryReviews (Review đơn hàng, shipper, restaurant sau khi đơn hàng hoàn thành)
CREATE TABLE DeliveryReview (
    delivery_review_id INT IDENTITY PRIMARY KEY,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
	order_id INT NOT NULL FOREIGN KEY REFERENCES [Order](order_id),
    restaurant_manager_id INT FOREIGN KEY REFERENCES Account(account_id),
    shipper_id INT FOREIGN KEY REFERENCES Account(account_id),
	customer_id INT FOREIGN KEY REFERENCES Account(account_id) --[Customer]
);

-- Bảng VerificationCode (OTP hệ thống gửi cho user xác nhận gmail khi tạo tài khoản)
CREATE TABLE OTP (
    verification_id INT IDENTITY PRIMARY KEY,
    code NVARCHAR(32) NOT NULL,
    plain_code NVARCHAR(6) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    expires_at DATETIME NOT NULL,
    is_used BIT NOT NULL DEFAULT 0,
	account_id INT FOREIGN KEY REFERENCES Account(account_id)
);

--Thông báo cho customer,shipper,restaurantmanager khi đơn hoàn thành
CREATE TABLE [Notification] (
    notification_id INT IDENTITY PRIMARY KEY,
    noti_message NVARCHAR(255),
    noti_type NVARCHAR(50) CHECK (noti_type IN ('order_completed', 'order_cancelled')) NOT NULL,
    is_read BIT DEFAULT 0,
	order_id INT NOT NULL FOREIGN KEY REFERENCES [Order](order_id),
    customer_id INT NOT NULL FOREIGN KEY REFERENCES Account(account_id),
    restaurant_manager_id INT NOT NULL FOREIGN KEY REFERENCES Account(account_id),
    shipper_id INT FOREIGN KEY REFERENCES Account(account_id)
);

--Bảng Contact
CREATE TABLE Contact (
	contact_id INT IDENTITY PRIMARY KEY,
	contact_subject NVARCHAR (255),
	contact_message NVARCHAR (2000),
	account_id INT FOREIGN KEY REFERENCES Account(account_id)
);