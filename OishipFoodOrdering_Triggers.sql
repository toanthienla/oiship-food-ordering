-- Trigger to check stock in Dish = 0 => isAvailable = 0
CREATE TRIGGER trg_UpdateAvailabilityBasedOnStock
ON Dish
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE d
    SET d.isAvailable = CASE 
		WHEN i.stock = 0 THEN 0
		ELSE d.isAvailable  -- Keep current value if stock > 0
    END
    FROM Dish d
    INNER JOIN inserted i ON d.DishID = i.DishID;
END;
GO