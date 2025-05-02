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

--I. Các bảng role:

-- Bảng trạng thái User
CREATE TABLE UserStatus (
    status_id INT PRIMARY KEY,
    status_name NVARCHAR(50) UNIQUE NOT NULL,
    description NVARCHAR(255)
);

-- Bảng Customer
CREATE TABLE Customer (
    customer_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(15) NOT NULL CHECK (phone LIKE '0%' AND LEN(phone) = 10 AND phone NOT LIKE '%[^0-9]%'),
    password NVARCHAR(60) NOT NULL,
    address NVARCHAR(255) NOT NULL, --tao bang rieng
    status_id INT NOT NULL FOREIGN KEY REFERENCES UserStatus(status_id),
    created_at DATETIME DEFAULT GETDATE()
);

-- Bảng Shipper
CREATE TABLE Shipper (
    shipper_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(15) NOT NULL CHECK (phone LIKE '0%' AND LEN(phone) = 10 AND phone NOT LIKE '%[^0-9]%'),
    password NVARCHAR(60) NOT NULL,
    cccd NVARCHAR(12) NOT NULL CHECK (LEN(cccd) = 12 AND cccd NOT LIKE '%[^0-9]%'),
    driver_license NVARCHAR(12) NOT NULL CHECK (LEN(driver_license) BETWEEN 10 AND 12),
    driver_license_image VARBINARY(MAX),
    address NVARCHAR(255) NOT NULL,
    vehicle_info NVARCHAR(100) NOT NULL, --bang so xe
    status_id INT NOT NULL FOREIGN KEY REFERENCES UserStatus(status_id),
    created_at DATETIME DEFAULT GETDATE()
);

-- Bảng RestaurantManager
CREATE TABLE RestaurantManager (
    restaurantmanager_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(15) NOT NULL CHECK (phone LIKE '0%' AND LEN(phone) = 10 AND phone NOT LIKE '%[^0-9]%'),
    password NVARCHAR(60) NOT NULL,
    address NVARCHAR(255) NOT NULL,
    opening_hours NVARCHAR(100),
    status_id INT NOT NULL FOREIGN KEY REFERENCES UserStatus(status_id),
    created_at DATETIME DEFAULT GETDATE()
);

-- Bảng Admin
CREATE TABLE [Admin] (
    admin_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(60) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);


--II. Các bảng giao dịch:

-- Bảng Category (Phân loại món ăn)
CREATE TABLE Category (
    category_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    restaurant_id INT NOT NULL FOREIGN KEY REFERENCES RestaurantManager(restaurantmanager_id),
    created_at DATETIME DEFAULT GETDATE()
);

--Bảng Menu (Chứa các MenuItem/Món ăn)
CREATE TABLE Menu (
    menu_id INT IDENTITY PRIMARY KEY,
    restaurant_id INT NOT NULL FOREIGN KEY REFERENCES RestaurantManager(restaurantmanager_id),
    available BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
);

-- Bảng MenuItem (Món ăn)
CREATE TABLE MenuItem (
    item_id INT IDENTITY PRIMARY KEY,
    restaurant_id INT NOT NULL FOREIGN KEY REFERENCES RestaurantManager(restaurantmanager_id),
	menu_id INT NOT NULL FOREIGN KEY REFERENCES Menu(menu_id),
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    image_url NVARCHAR(255),
    is_available BIT NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
	category_id INT FOREIGN KEY REFERENCES Category(category_id)
);

-- Bảng Cart (Giỏ hàng của Customer, chứa các CartItem)
CREATE TABLE Cart (
    cart_id INT IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL FOREIGN KEY REFERENCES Customer(customer_id),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE() --update status cua Orders table
);

-- Bảng CartItem (Là các Item Customer bỏ vào trong wishlist)
CREATE TABLE CartItem (
    cart_item_id INT IDENTITY PRIMARY KEY,
    cart_id INT NOT NULL FOREIGN KEY REFERENCES Cart(cart_id),
    item_id INT NOT NULL FOREIGN KEY REFERENCES MenuItem(item_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    created_at DATETIME DEFAULT GETDATE()
);

-- Bảng Order (Là final cart đã được Customer xác nhận đặt hàng)
CREATE TABLE [Order] (
    order_id INT IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL FOREIGN KEY REFERENCES Customer(customer_id),
    restaurant_id INT NOT NULL FOREIGN KEY REFERENCES RestaurantManager(restaurantmanager_id),
    shipper_id INT NULL FOREIGN KEY REFERENCES Shipper(shipper_id),
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method NVARCHAR(50) NOT NULL CHECK (payment_method IN ('online', 'offline')),
    discount_code NVARCHAR(50),
    status NVARCHAR(50) NOT NULL CHECK (status IN ('pending', 'preparing', 'delivering', 'delivered', 'cancelled')),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE() --update khi thay doi status pending, preparing, delivering, delivered, cancelled
);

-- Bảng OrderItem (Là các item chứa trong Order/bill)
CREATE TABLE OrderItem (
    order_item_id INT IDENTITY PRIMARY KEY,
    order_id INT NOT NULL FOREIGN KEY REFERENCES [Order](order_id),
    item_id INT NOT NULL FOREIGN KEY REFERENCES MenuItem(item_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
);

-- Bảng Deliverie
CREATE TABLE Deliverie (
    delivery_id INT IDENTITY PRIMARY KEY,
    order_id INT NOT NULL FOREIGN KEY REFERENCES [Order](order_id),
    shipper_id INT NOT NULL FOREIGN KEY REFERENCES Shipper(shipper_id),
    status NVARCHAR(50) NOT NULL CHECK (status IN ('picked_up', 'delivering_ship', 'delivered_ship')),
    updated_at DATETIME DEFAULT GETDATE() --update khi thay doi status picked_up,delivering_ship,delivered_ship
);

-- III. Các bảng phụ trợ:

-- Bảng ItemReview (Review từng món trong Order sau khi đơn hàng hoàn thành)
CREATE TABLE ItemReview (
    review_id INT IDENTITY PRIMARY KEY,
    item_id INT NOT NULL FOREIGN KEY REFERENCES MenuItem(item_id),
    customer_id INT NOT NULL FOREIGN KEY REFERENCES Customer(customer_id),
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    UNIQUE (item_id, customer_id)
);

-- Bảng DeliveryReviews (Review đơn hàng, shipper, restaurant sau khi đơn hàng hoàn thành)
CREATE TABLE DeliveryReview (
    review_id INT IDENTITY PRIMARY KEY,
    order_id INT NOT NULL FOREIGN KEY REFERENCES [Order](order_id),
    customer_id INT NOT NULL FOREIGN KEY REFERENCES Customer(customer_id),
    target_type NVARCHAR(20) NOT NULL CHECK (target_type IN ('shipper', 'restaurant')),
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    UNIQUE (order_id, target_type)
);

-- Bảng SupportTicket (Mở yêu cầu hỗ trợ khi Customer cần)
CREATE TABLE SupportTicket (
    ticket_id INT IDENTITY PRIMARY KEY,
    customer_id INT NULL FOREIGN KEY REFERENCES Customer(customer_id),
    shipper_id INT NULL FOREIGN KEY REFERENCES Shipper(shipper_id),
    restaurant_id INT NULL FOREIGN KEY REFERENCES RestaurantManager(restaurantmanager_id),
    subject NVARCHAR(100) NOT NULL,
    message NVARCHAR(MAX) NOT NULL,
    status NVARCHAR(50) NOT NULL CHECK (status IN ('open', 'pending', 'closed')),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT chk_support_ticket CHECK (
        (customer_id IS NOT NULL AND shipper_id IS NULL AND restaurant_id IS NULL) OR
        (customer_id IS NULL AND shipper_id IS NOT NULL AND restaurant_id IS NULL) OR
        (customer_id IS NULL AND shipper_id IS NULL AND restaurant_id IS NOT NULL)
    )
);

-- Bảng VerificationCode (OTP hệ thống người cho user xác nhận gmail khi tạo tài khoản)
CREATE TABLE VerificationCode (
    verification_id INT IDENTITY PRIMARY KEY,
    customer_id INT NULL FOREIGN KEY REFERENCES Customer(customer_id),
    shipper_id INT NULL FOREIGN KEY REFERENCES Shipper(shipper_id),
    restaurant_id INT NULL FOREIGN KEY REFERENCES RestaurantManager(restaurantmanager_id),
    code NVARCHAR(32) NOT NULL,
    plain_code NVARCHAR(6) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    expires_at DATETIME NOT NULL,
    is_used BIT NOT NULL DEFAULT 0,
    CONSTRAINT chk_verification_user CHECK (
        (customer_id IS NOT NULL AND shipper_id IS NULL AND restaurant_id IS NULL) OR
        (customer_id IS NULL AND shipper_id IS NOT NULL AND restaurant_id IS NULL) OR
        (customer_id IS NULL AND shipper_id IS NULL AND restaurant_id IS NOT NULL)
    )
)

-- Bảng phí nhà hàng (Dùng cho role Admin điều chỉnh phí)
CREATE TABLE RestaurantFee (
    fee_id INT IDENTITY PRIMARY KEY,
    restaurant_id INT FOREIGN KEY REFERENCES RestaurantManager(restaurantmanager_id),
    order_id INT FOREIGN KEY REFERENCES [Order](order_id),
    fee_amount DECIMAL(10,2),
    fee_type NVARCHAR(50), -- commission, service_fee
    created_at DATETIME DEFAULT GETDATE()
)
GO

-- Bảng phí shipper (Dùng cho role Admin điều chỉnh phí)
CREATE TABLE ShipperFee (
    fee_id INT IDENTITY PRIMARY KEY,
    shipper_id INT FOREIGN KEY REFERENCES Shipper(shipper_id),
    order_id INT FOREIGN KEY REFERENCES [Order](order_id),
    fee_amount DECIMAL(10,2),
    fee_type NVARCHAR(50), -- delivery_fee, bonus
    created_at DATETIME DEFAULT GETDATE()
);

--Thông báo cho customer khi đơn hoàn thành
CREATE TABLE OrderNotification (
    notification_id INT IDENTITY PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES [Order](order_id),
    customer_id INT NULL FOREIGN KEY REFERENCES Customer(customer_id),
    shipper_id INT NULL FOREIGN KEY REFERENCES Shipper(shipper_id),
    restaurant_id INT NULL FOREIGN KEY REFERENCES RestaurantManager(restaurantmanager_id),
    message NVARCHAR(255),
    notification_type NVARCHAR(50), -- order_completed, order_cancelled
    is_read BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT chk_one_user_target CHECK (
        (customer_id IS NOT NULL AND shipper_id IS NULL AND restaurant_id IS NULL) OR
        (customer_id IS NULL AND shipper_id IS NOT NULL AND restaurant_id IS NULL) OR
        (customer_id IS NULL AND shipper_id IS NULL AND restaurant_id IS NOT NULL)
    )
);
