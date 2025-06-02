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

-- Account table: Stores user information for all account types (admin, customer, staff).
-- Includes personal details, login credentials, and account status/role.
-- status values:
-- 0 Ban
-- 1 = Active

CREATE TABLE Account (
	accountID INT IDENTITY(1,1) PRIMARY KEY,
	fullName NVARCHAR(255),
	email NVARCHAR(100) UNIQUE,
	phone NVARCHAR(15),
	[password] NVARCHAR(255),
	[address] NVARCHAR(255),
	[status] INT,
	createAt DATETIME DEFAULT GETDATE(),
	[role] VARCHAR(20) CHECK ([role] IN ('admin', 'customer', 'staff'))
);

-- Staff table: Stores specific details for staff accounts, linking to the Account table.
-- Defines staff type (e.g., seller or inventory staff) for role-specific responsibilities.
CREATE TABLE Staff (
    staffId INT PRIMARY KEY,
    staffType VARCHAR(20) CHECK ([staffType] IN ('sellerStaff', 'ingredientStaff')),
    FOREIGN KEY (staffId) REFERENCES Account(accountID)
);

-- Category table: Stores food categories for organizing Dishes in the system.
-- Includes category name and description for menu classification.
CREATE TABLE Category (
    catID INT IDENTITY(1,1) PRIMARY KEY,
	catName NVARCHAR(255) UNIQUE,
	catDescription NVARCHAR(255)
);

-- Dish table: Stores details of food items available for order.
-- Includes Dish name, opCost (VND), interestPercentage(%), image, description, stock, and category reference.
CREATE TABLE Dish (
    DishID INT IDENTITY(1,1) PRIMARY KEY,
	DishName NVARCHAR(255),
	opCost DECIMAL(10,2),
	interestPercentage DECIMAL(10,2),
	[image] NVARCHAR(255),
	DishDescription NVARCHAR(255),
	stock INT,
	FK_Dish_Category INT FOREIGN KEY REFERENCES Category(catID)
);

--Ingredient table: Stores raw materials, ingredient for Dish
-- Includes name, quantity(kg), unitCost(VND/kg)
CREATE TABLE Ingredient (
	ingredientID INT IDENTITY(1,1) PRIMARY KEY,
	name NVARCHAR(255),
	quantity INT,
	unitCost DECIMAL(10,2),
	FK_Ingredient_Dish INT FOREIGN KEY REFERENCES Dish(DishID)
);

-- Cart table: Stores items added to a user's cart before placing an order.
-- Links accounts to Dishes with quantities for temporary storage.
CREATE TABLE Cart (
	cartID INT IDENTITY(1,1) PRIMARY KEY,
	quantity INT,
	FK_Cart_Account INT FOREIGN KEY REFERENCES Account(accountID),
	FK_Cart_Dish INT FOREIGN KEY REFERENCES Dish(DishID)
);

-- Voucher table: Stores discount vouchers for orders.
-- Includes voucher code, discount details, validity period, usage limits, and staff creator.
-- active values:
-- 0 = Not available
-- 1 = Active
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
	FK_Voucher_Staff INT FOREIGN KEY REFERENCES Staff(staffID)
);

-- Order table: Stores order details with status tracking and references to related entities.
-- Includes order amount, status (e.g., pending, delivered), creation/update timestamps, and links to voucher, account, and staff.
-- orderStatus values:
-- 0 = Pending            -- Order placed but not yet confirmed.
-- 1 = Confirmed          -- Order confirmed and is being prepared.
-- 2 = In Delivery        -- Order has been shipped and is on the way.
-- 3 = Delivered          -- Order successfully delivered to the customer.
-- 4 = Cancelled by User  -- Customer cancelled the order.
-- 5 = Cancelled by Staff -- Staff/admin cancelled the order due to issues.
-- 6 = Failed             -- Order failed due to payment or system error.
-- 7 = Refunded           -- Payment refunded to the customer.
CREATE TABLE [Order] (
    orderID INT IDENTITY(1,1) PRIMARY KEY,
	amount DECIMAL(10,2),
    orderStatus INT,
    orderCreatedAt DATETIME DEFAULT GETDATE(),
    orderUpdatedAt DATETIME DEFAULT GETDATE(),
	FK_Order_Voucher INT FOREIGN KEY REFERENCES Voucher(voucherID),
	FK_Order_Account INT FOREIGN KEY REFERENCES Account(accountID),
    FK_Order_Staff INT FOREIGN KEY REFERENCES Staff(staffID)
);

-- OrderDetail table: Stores individual items within an order.
-- Links orders to Dishes with quantities for detailed order breakdown.
CREATE TABLE OrderDetail (
    ODID INT IDENTITY(1,1) PRIMARY KEY,
	quantity INT,
    FK_OD_Order INT FOREIGN KEY REFERENCES [Order](orderID),
    FK_OD_Dish INT FOREIGN KEY REFERENCES Dish(DishID)
);

-- Payment table: Stores payment details for orders.
-- Includes transaction information, confirmation status, and links to orders.
CREATE TABLE Payment (
    paymentID INT IDENTITY(1,1) PRIMARY KEY,
    transactionCode NVARCHAR(100),
    bankName NVARCHAR(100),
    paymentTime DATETIME DEFAULT GETDATE(),
    isConfirmed BIT DEFAULT 0,
    FK_Payment_Order INT FOREIGN KEY REFERENCES [Order](orderID)
);

-- Review table: Stores customer reviews and ratings for orders.
-- Includes rating, comments, creation timestamp, and links to order and account.
CREATE TABLE Review (
    reviewID INT IDENTITY(1,1) PRIMARY KEY,
    rating INT,
    comment NVARCHAR(255),
    reviewCreatedAt DATETIME DEFAULT GETDATE(),
	FK_Review_Order INT FOREIGN KEY REFERENCES [Order](orderID),
    FK_Review_Account INT FOREIGN KEY REFERENCES Account(accountID)
);

-- OTP table: Stores one-time passwords for account verification or authentication.
-- Includes OTP code, creation/expiry timestamps, usage status, and account link.
CREATE TABLE OTP (
    otpID INT IDENTITY(1,1) PRIMARY KEY,
    otp NVARCHAR(32),
    otpCreatedAt DATETIME DEFAULT GETDATE(),
    otpExpiresAt DATETIME,
    isUsed INT,
	email NVARCHAR(100),
	FK_OTP_Account INT FOREIGN KEY REFERENCES Account(accountID)
);

-- Notification table: Stores notifications sent to users.
-- Includes title, description, read status, notification status, and account link.
CREATE TABLE [Notification] (
    notID INT IDENTITY(1,1) PRIMARY KEY,
    notTitle NVARCHAR(255),
	notDescription NVARCHAR(255),
    isRead INT,
	notStatus INT,
	FK_Notification_Account INT FOREIGN KEY REFERENCES Account(accountID)
);

-- Contact table: Stores customer inquiries or support messages.
-- Includes subject, message content, and link to the account submitting the contact.
CREATE TABLE Contact (
	contactID INT IDENTITY PRIMARY KEY,
	[subject] NVARCHAR (255),
	[message] NVARCHAR (2000),
	FK_Contact_Account INT FOREIGN KEY REFERENCES Account(accountID)
);


-- Triggers for notifications:
-- Comming soon...

