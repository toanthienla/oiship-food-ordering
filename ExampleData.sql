-- This script populates the database with example records.

-- Password = admin123
-- Insert Admin
INSERT INTO [Admin] (name, email, password, created_at)
VALUES ('Admin', 'admin@foodship.com',
        '$2a$12$U5uOJplL2KzR8P1/PL0F6OlGEB6R2UAKxMTpcE8MCw2AYTZW6j2cK', 
        GETDATE());

-- Insert RestaurantManager
INSERT INTO RestaurantManager (name, email, phone, password, address, status_id, created_at)
VALUES
('Pho 24', 'restaurant1@gmail.com', '0903456789', '$2a$12$7z6WJm57Kztg1zUtTwf35uTLfyfzrk/ovl6cF2lFc6Jsf.3MqxMZ2', 'Da Nang', 1, GETDATE()),
('Quan Com Tam', 'restaurant2@gmail.com', '0904567890', '$2a$12$7z6WJm57Kztg1zUtTwf35uTLfyfzrk/ovl6cF2lFc6Jsf.3MqxMZ2', 'Can Tho', 0, GETDATE());

-- Password Customer: 12345678
-- Status_id: 1 = Active, 0 = Pending, 3 = Banned
-- Insert Customer
INSERT INTO Customer (name, email, phone, password, address, status_id, created_at)
VALUES
('Tran Van A', 'customer1@gmail.com', '0911234567', '$2a$12$7z6WJm57Kztg1zUtTwf35uTLfyfzrk/ovl6cF2lFc6Jsf.3MqxMZ2', 'Ha Noi', 1, GETDATE()),
('Nguyen Thi B', 'customer2@gmail.com', '0912345678', '$2a$12$7z6WJm57Kztg1zUtTwf35uTLfyfzrk/ovl6cF2lFc6Jsf.3MqxMZ2', 'Hue', 1, GETDATE()),
('Pham C', 'customer3@gmail.com', '0913456789', '$2a$12$7z6WJm57Kztg1zUtTwf35uTLfyfzrk/ovl6cF2lFc6Jsf.3MqxMZ2', 'Sai Gon', 0, GETDATE());