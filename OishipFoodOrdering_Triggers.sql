-- Drop the existing trigger first
DROP TRIGGER IF EXISTS trg_UpdateAvailabilityBasedOnStock;
GO

-- Create the updated trigger
CREATE TRIGGER trg_UpdateAvailabilityBasedOnStock
ON Dish
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if this is an UPDATE operation and if isAvailable or stock columns were modified
    IF UPDATE(isAvailable) OR UPDATE(stock)
    BEGIN
        -- Update dishes to ensure stock = 0 dishes cannot be available
        UPDATE d
        SET d.isAvailable = CASE 
            WHEN d.stock = 0 THEN 0  -- Force unavailable if no stock
            ELSE d.isAvailable       -- Keep current value if stock > 0
        END
        FROM Dish d
        INNER JOIN inserted i ON d.DishID = i.DishID
        WHERE d.stock = 0 AND d.isAvailable = 1; -- Only update if trying to set available with no stock
        
        -- Optional: Log which dishes were automatically set to unavailable
        IF @@ROWCOUNT > 0
        BEGIN
            PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' dish(es) with zero stock were automatically set to unavailable.';
        END
    END
END;
GO