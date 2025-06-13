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

CREATE TABLE Account (
	accountID INT IDENTITY(1,1) PRIMARY KEY,
	fullName NVARCHAR(255),
	email NVARCHAR(100) UNIQUE,
	[password] NVARCHAR(255),
	role NVARCHAR(20) CHECK (role IN ('admin', 'staff', 'customer')),
	createAt DATETIME DEFAULT GETDATE()
);

-- Customer table
CREATE TABLE Customer (
    customerID INT PRIMARY KEY, -- accountID
    phone NVARCHAR(15),
    address NVARCHAR(255),
    status INT DEFAULT 1, -- 1 active, 0 inactive, -1 banned
    FOREIGN KEY (customerID) REFERENCES Account(accountID)

);

-- Category table
CREATE TABLE Category (
    catID INT IDENTITY(1,1) PRIMARY KEY,
	catName NVARCHAR(255) UNIQUE,
	catDescription NVARCHAR(255)
);

-- Dish table
CREATE TABLE Dish (
    DishID INT IDENTITY(1,1) PRIMARY KEY,
    DishName NVARCHAR(255),
    opCost DECIMAL(10,2),
    interestPercentage DECIMAL(10,2),
    [image] NVARCHAR(255),
    DishDescription NVARCHAR(255),
    stock INT, -- Represents the number of ready-to-sell dishes
    isAvailable BIT DEFAULT 0, -- 1 = available, 0 = not available
    FK_Dish_Category INT FOREIGN KEY REFERENCES Category(catID)
);

-- Ingredient table
CREATE TABLE Ingredient (
    ingredientID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    unitCost DECIMAL(10,2), -- (vnđ/kg)
    FK_Ingredient_Account INT FOREIGN KEY REFERENCES Account(accountID)
);

-- Dish - Ingredient (n-n)
CREATE TABLE DishIngredient (
    dishID INT FOREIGN KEY REFERENCES Dish(DishID),
    ingredientID INT FOREIGN KEY REFERENCES Ingredient(ingredientID),
    quantity DECIMAL(10,2), -- Represents the quantity of this ingredient used in this specific dish (kg)
    PRIMARY KEY (dishID, ingredientID)
);

-- Cart table
CREATE TABLE Cart (
	cartID INT IDENTITY(1,1) PRIMARY KEY,
	quantity INT,
	FK_Cart_Customer INT FOREIGN KEY REFERENCES Customer(customerID),
	FK_Cart_Dish INT FOREIGN KEY REFERENCES Dish(DishID)
);

-- Voucher table
CREATE TABLE Voucher (
    voucherID INT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(255) UNIQUE,
    voucherDescription NVARCHAR(255),
    discount DECIMAL(10,2),
    maxDiscountValue DECIMAL(10,2),
    minOrderValue DECIMAL(10,2),
    startDate DATETIME,
    endDate DATETIME,
    usageLimit INT,
    usedCount INT DEFAULT 0,
    active INT,
	FK_Voucher_Account INT FOREIGN KEY REFERENCES Account(accountID) -- Admin/Staff add voucher
);

-- Voucher - Customer (n-n)
CREATE TABLE CustomerVoucher (
    customerID INT,
    voucherID INT,
    PRIMARY KEY (customerID, voucherID),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID),
    FOREIGN KEY (voucherID) REFERENCES Voucher(voucherID)
);

-- Order table
CREATE TABLE [Order] (
    orderID INT IDENTITY(1,1) PRIMARY KEY,
    amount DECIMAL(10,2),

    -- Order status:
    -- 0 = Pending       -- Order placed, waiting for confirmation
    -- 1 = Confirmed     -- Order confirmed by staff
    -- 2 = Preparing     -- Order is being prepared
    -- 3 = Out for Delivery -- Order is on the way
    -- 4 = Delivered     -- Order delivered successfully
    -- 5 = Cancelled     -- Order cancelled by customer or staff
    -- 6 = Failed        -- Order failed due to system or payment issue
    orderStatus INT,

    -- Payment status:
    -- 0 = Unpaid
    -- 1 = Paid
    -- 2 = Refunded
    paymentStatus INT DEFAULT 0,

    orderCreatedAt DATETIME DEFAULT GETDATE(),
    orderUpdatedAt DATETIME DEFAULT GETDATE(),

    FK_Order_Voucher INT FOREIGN KEY REFERENCES Voucher(voucherID),
    FK_Order_Customer INT FOREIGN KEY REFERENCES Customer(customerID)
);

-- OrderDetail table
CREATE TABLE OrderDetail (
    ODID INT IDENTITY(1,1) PRIMARY KEY,
	quantity INT,
    FK_OD_Order INT FOREIGN KEY REFERENCES [Order](orderID),
    FK_OD_Dish INT FOREIGN KEY REFERENCES Dish(DishID)
);

-- Payment table
CREATE TABLE Payment (
    paymentID INT IDENTITY(1,1) PRIMARY KEY,
    transactionCode NVARCHAR(100),
    bankName NVARCHAR(100),
    paymentTime DATETIME DEFAULT GETDATE(),
    isConfirmed BIT DEFAULT 0,
    FK_Payment_Order INT FOREIGN KEY REFERENCES [Order](orderID),
	FK_Notification_Account INT FOREIGN KEY REFERENCES Account(accountID)
);

-- Review table
CREATE TABLE Review (
    reviewID INT IDENTITY(1,1) PRIMARY KEY,
    rating INT,
    comment NVARCHAR(255),
    reviewCreatedAt DATETIME DEFAULT GETDATE(),
    FK_Review_OrderDetail INT FOREIGN KEY REFERENCES [OrderDetail](ODID),
    FK_Review_Customer INT FOREIGN KEY REFERENCES Customer(customerID)
);

-- OTP table
CREATE TABLE OTP (
    otpID INT IDENTITY(1,1) PRIMARY KEY,
    otp NVARCHAR(32),
    otpCreatedAt DATETIME DEFAULT GETDATE(),
    otpExpiresAt DATETIME,
    isUsed INT,
	email NVARCHAR(100),
	FK_OTP_Customer INT FOREIGN KEY REFERENCES Customer(customerID)
);

-- Notification table
-- Example: close/open restaurant date, have new voucher,...   
CREATE TABLE [Notification] (
    notID INT IDENTITY(1,1) PRIMARY KEY,
    notTitle NVARCHAR(255),
	notDescription NVARCHAR(255),
	FK_Notification_Account INT FOREIGN KEY REFERENCES Account(accountID) -- Admin/Staff add notification
);

-- Notification - Customer
CREATE TABLE CustomertNotification (
    customerID INT,
    notID INT,
    PRIMARY KEY (customerID, notID),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID),
    FOREIGN KEY (notID) REFERENCES Notification(notID)
);
-- Contact table
CREATE TABLE Contact (
	contactID INT IDENTITY PRIMARY KEY,
	[subject] NVARCHAR (255),
	[message] NVARCHAR (2000),
	FK_Contact_Customer INT FOREIGN KEY REFERENCES Customer(customerID)
);

-- Triggers for notifications:
-- Comming soon...

