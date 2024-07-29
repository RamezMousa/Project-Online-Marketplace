CREATE PROCEDURE Users.CreateUser
    @Username VARCHAR(255),
    @Email VARCHAR(255),
    @PasswordHash VARCHAR(255),
    @Status VARCHAR(20),
    @AddressLine1 VARCHAR(255),
    @AddressLine2 VARCHAR(255),
    @City VARCHAR(75),
    @State VARCHAR(75),
    @PostalCode VARCHAR(20),
    @CountryID INT
AS
BEGIN
    INSERT INTO Users.Info (Username, Email, Password, Status, AddressLine1, AddressLine2, City, State, PostalCode, CountryID)
    VALUES (@Username, @Email, @PasswordHash, @Status, @AddressLine1, @AddressLine2, @City, @State, @PostalCode, @CountryID);
    
    SELECT SCOPE_IDENTITY() AS NewUserID;
END;
GO
EXEC Users.CreateUser 
    @Username = 'Ramez', 
    @Email = 'Ramez@Gmail.com', 
    @PasswordHash = '123654', 
    @Status = 'Active', 
    @AddressLine1 = 'Damietta', 
    @AddressLine2 = 'Alex', 
    @City = 'Cairo', 
    @State = 'Cairo', 
    @PostalCode = '12345', 
    @CountryID = 20;  


CREATE PROCEDURE Stores.CreateItem
    @SellerID INT,
    @CategoryID INT,
    @Title VARCHAR(100),
    @Description VARCHAR(255),
    @StartingPrice DECIMAL(10, 2),
    @CurrentPrice DECIMAL(10, 2),
    @StartDate DATETIME,
    @EndDate DATETIME,
    @ImageURL VARCHAR(255)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Users.Info WHERE UserID = @SellerID)
    BEGIN
        RAISERROR('SellerID does not exist in the Users table.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Stores.Categories WHERE CategoryID = @CategoryID)
    BEGIN
        RAISERROR('CategoryID does not exist in the Categories table.', 16, 1);
        RETURN;
    END

    INSERT INTO Stores.Items (SellerID, CategoryID, Title, Description, StartingPrice, CurrentPrice, StartDate, EndDate, ImageURL, CreatedAt)
    VALUES (@SellerID, @CategoryID, @Title, @Description, @StartingPrice, @CurrentPrice, @StartDate, @EndDate, @ImageURL, CURRENT_TIMESTAMP);
    
    SELECT SCOPE_IDENTITY() AS NewItemID;
END;
GO
EXEC Stores.CreateItem 
    @SellerID = 1,                
    @CategoryID = 1,              
    @Title = 'New basic shirt',    
    @Description = 'White Basic', 
    @StartingPrice = 15.50,       
    @CurrentPrice = 15.50,        
    @StartDate = '2024-07-01 09:00:00', 
    @EndDate = '2024-07-10 09:00:00',    
    @ImageURL = 'http://example.com/image2.jpg';


CREATE PROCEDURE Stores.PlaceBid
    @ItemID INT,
    @UserID INT,
    @BidAmount DECIMAL(10, 2)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Stores.Items WHERE ItemID = @ItemID)
    BEGIN
        RAISERROR('ItemID does not exist in the Items table.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Users.Info WHERE UserID = @UserID)
    BEGIN
        RAISERROR('UserID does not exist in the Users table.', 16, 1);
        RETURN;
    END

    DECLARE @CurrentPrice DECIMAL(10, 2);
    SELECT @CurrentPrice = CurrentPrice FROM Stores.Items WHERE ItemID = @ItemID;

    IF @BidAmount <= @CurrentPrice
    BEGIN
        RAISERROR('Bid amount must be greater than the current price.', 16, 1);
        RETURN;
    END

    INSERT INTO Stores.Bids (ItemID, UserID, BidAmount, BidTime)
    VALUES (@ItemID, @UserID, @BidAmount, CURRENT_TIMESTAMP);

    UPDATE Stores.Items
    SET CurrentPrice = @BidAmount
    WHERE ItemID = @ItemID;
END;
GO

EXEC Stores.PlaceBid 
    @ItemID = 1,          
    @UserID = 1,         
    @BidAmount = 20.00;   



