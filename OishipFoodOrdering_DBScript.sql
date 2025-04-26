USE [master]
GO

/*******************************************************************************
   Drop database if it exists
********************************************************************************/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'FoodDeliveryApp')
BEGIN
	ALTER DATABASE [FoodDeliveryApp] SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE [FoodDeliveryApp] SET ONLINE;
	DROP DATABASE [FoodDeliveryApp];
END

GO

CREATE DATABASE [FoodDeliveryApp]
GO

USE [FoodDeliveryApp]
GO

/*******************************************************************************
	Drop tables if exists
*******************************************************************************/
DECLARE @sql nvarchar(MAX) 
SET @sql = N'' 

SELECT @sql = @sql + N'ALTER TABLE ' + QUOTENAME(KCU1.TABLE_SCHEMA) 
    + N'.' + QUOTENAME(KCU1.TABLE_NAME) 
    + N' DROP CONSTRAINT ' -- + QUOTENAME(rc.CONSTRAINT_SCHEMA)  + N'.'  -- not in MS-SQL
    + QUOTENAME(rc.CONSTRAINT_NAME) + N'; ' + CHAR(13) + CHAR(10) 
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC 

INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KCU1 
    ON KCU1.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG  
    AND KCU1.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA 
    AND KCU1.CONSTRAINT_NAME = RC.CONSTRAINT_NAME 

EXECUTE(@sql) 

GO
DECLARE @sql2 NVARCHAR(max)=''

SELECT @sql2 += ' Drop table ' + QUOTENAME(TABLE_SCHEMA) + '.'+ QUOTENAME(TABLE_NAME) + '; '
FROM   INFORMATION_SCHEMA.TABLES
WHERE  TABLE_TYPE = 'BASE TABLE'

Exec Sp_executesql @sql2 
GO


/*******************************************************************************
   Create table
********************************************************************************/

-- Bảng quản lý trạng thái người dùng (customer, shipper, restaurant)
CREATE TABLE UserStatus (
    status_id INT PRIMARY KEY,
    status_name NVARCHAR(50)
)

-- Bảng người dùng
CREATE TABLE Users (
    user_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(100),
    email NVARCHAR(100) UNIQUE,
    phone NVARCHAR(20),
    password NVARCHAR(255),
    role NVARCHAR(20), -- customer, shipper, restaurant, admin
    cccd NVARCHAR(20),
    address NVARCHAR(255),
    status_id INT FOREIGN KEY REFERENCES UserStatus(status_id),
    created_at DATETIME DEFAULT GETDATE()
)

-- Tài khoản đăng nhập bằng social login
CREATE TABLE SocialAccounts (
    social_id INT IDENTITY PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    provider NVARCHAR(20), -- Google, Facebook
    provider_uid NVARCHAR(100)
)

-- Nhà hàng
CREATE TABLE Restaurants (
    restaurant_id INT IDENTITY PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    name NVARCHAR(100),
    address NVARCHAR(255),
    opening_hours NVARCHAR(100),
    cuisine_type NVARCHAR(100),
    status_id INT FOREIGN KEY REFERENCES UserStatus(status_id)
)

-- Món ăn
CREATE TABLE MenuItems (
    item_id INT IDENTITY PRIMARY KEY,
    restaurant_id INT FOREIGN KEY REFERENCES Restaurants(restaurant_id),
    name NVARCHAR(100),
    price DECIMAL(10,2),
    description NVARCHAR(255),
    image_url NVARCHAR(255),
    category NVARCHAR(50), -- đồ ăn, đồ uống, sáng, trưa, tối
    is_available BIT DEFAULT 1
)

-- Đánh giá món ăn
CREATE TABLE ItemReviews (
    review_id INT IDENTITY PRIMARY KEY,
    item_id INT FOREIGN KEY REFERENCES MenuItems(item_id),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
)

-- Giỏ hàng
CREATE TABLE Cart (
    cart_id INT IDENTITY PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id)
)

CREATE TABLE CartItems (
    cart_item_id INT IDENTITY PRIMARY KEY,
    cart_id INT FOREIGN KEY REFERENCES Cart(cart_id),
    item_id INT FOREIGN KEY REFERENCES MenuItems(item_id),
    quantity INT
)

-- Đơn hàng
CREATE TABLE Orders (
    order_id INT IDENTITY PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    restaurant_id INT FOREIGN KEY REFERENCES Restaurants(restaurant_id),
    shipper_id INT FOREIGN KEY REFERENCES Users(user_id),
    total_amount DECIMAL(10,2),
    payment_method NVARCHAR(50), -- online, offline
    discount_code NVARCHAR(50),
    status NVARCHAR(50), -- pending, preparing, delivering, delivered, cancelled
    created_at DATETIME DEFAULT GETDATE()
)

CREATE TABLE OrderItems (
    order_item_id INT IDENTITY PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    item_id INT FOREIGN KEY REFERENCES MenuItems(item_id),
    quantity INT,
    price DECIMAL(10,2)
)

-- Đánh giá shipper và nhà hàng
CREATE TABLE DeliveryReviews (
    review_id INT IDENTITY PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    reviewer_id INT FOREIGN KEY REFERENCES Users(user_id),
    target_type NVARCHAR(20), -- shipper, restaurant
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
)

-- Mã giảm giá
CREATE TABLE Promotions (
    promo_id INT IDENTITY PRIMARY KEY,
    code NVARCHAR(50),
    description NVARCHAR(255),
    discount_percent INT,
    valid_from DATETIME,
    valid_to DATETIME,
    max_uses INT,
    used_count INT DEFAULT 0
)

-- Lịch sử giao hàng của shipper
CREATE TABLE Deliveries (
    delivery_id INT IDENTITY PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    shipper_id INT FOREIGN KEY REFERENCES Users(user_id),
    status NVARCHAR(50), -- picked_up, delivering, delivered
    updated_at DATETIME DEFAULT GETDATE()
)

-- Doanh thu
CREATE TABLE RevenueReports (
    report_id INT IDENTITY PRIMARY KEY,
    restaurant_id INT FOREIGN KEY REFERENCES Restaurants(restaurant_id),
    date DATE,
    total_orders INT,
    total_revenue DECIMAL(10,2)
)

-- Quản lý ticket hỗ trợ
CREATE TABLE SupportTickets (
    ticket_id INT IDENTITY PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    subject NVARCHAR(100),
    message NVARCHAR(MAX),
    status NVARCHAR(50), -- open, pending, closed
    created_at DATETIME DEFAULT GETDATE()
)

