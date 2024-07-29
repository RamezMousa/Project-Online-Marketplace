CREATE SCHEMA Users;
GO

CREATE SCHEMA Stores;
GO

CREATE TABLE Users.Countries (
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(255) NOT NULL
);
GO

CREATE TABLE Users.Info (
    UserID INT IDENTITY(1, 1) PRIMARY KEY,
    Username VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Active', 'Terminated', 'Inactive')),
    AddressLine1 VARCHAR(255) NOT NULL,
    AddressLine2 VARCHAR(255) NOT NULL,
    City VARCHAR(75),
    State VARCHAR(75),
    PostalCode VARCHAR(20),
    CountryID INT, 
    CreatedAt DATETIME DEFAULT GETDATE(), 
    FOREIGN KEY (CountryID) REFERENCES Users.Countries(CountryID)
);
GO

CREATE TABLE Stores.Categories (
    CategoryID INT IDENTITY(1, 1) PRIMARY KEY,
    CategoryName VARCHAR(255) NOT NULL, 
    Description VARCHAR(255)
);
GO

CREATE TABLE Stores.Items (
    ItemID INT IDENTITY(1, 1) PRIMARY KEY,
    SellerID INT,
    CategoryID INT,
    Title VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    StartingPrice DECIMAL(10, 2) NOT NULL,
    CurrentPrice DECIMAL(10, 2) NOT NULL,
    StartDate DATETIME DEFAULT GETDATE(), 
    EndDate DATETIME, 
    ImageURL VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(), 
    FOREIGN KEY (SellerID) REFERENCES Users.Info(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Stores.Categories(CategoryID)
);
GO


CREATE TABLE Stores.Bids (
    BidID INT IDENTITY(1, 1) PRIMARY KEY,
    ItemID INT,
    UserID INT,
    BidAmount DECIMAL(10, 2) NOT NULL,
    BidTime DATETIME DEFAULT GETDATE(), 
    FOREIGN KEY (ItemID) REFERENCES Stores.Items(ItemID),
    FOREIGN KEY (UserID) REFERENCES Users.Info(UserID)
);
GO

CREATE TABLE Stores.Orders (
    OrderID INT IDENTITY(1, 1) PRIMARY KEY,
    BuyerID INT,
    ItemID INT,
    OrderDate DATETIME DEFAULT GETDATE(), 
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (BuyerID) REFERENCES Users.Info(UserID),
    FOREIGN KEY (ItemID) REFERENCES Stores.Items(ItemID)
);
GO


CREATE TABLE Users.Notification (
    NotificationID INT IDENTITY(1, 1) PRIMARY KEY,
    UserID INT,
    Message TEXT NOT NULL,
    IsRead TINYINT DEFAULT 0, 
    CreatedAt DATETIME DEFAULT GETDATE(), 
    FOREIGN KEY (UserID) REFERENCES Users.Info(UserID)
);
GO
