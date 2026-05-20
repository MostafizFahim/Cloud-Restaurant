-- CloudDB all-in-one restore script
-- Generated from sqlTableCode/*.sql
-- Use on a fresh SQL Server instance. If CloudDB already exists, rename/drop it first.


/* ============================================================
   Source: SQLQuery1.sql
   ============================================================ */
IF DB_ID(N'CloudDB') IS NULL
BEGIN
    CREATE DATABASE [CloudDB];
END
GO
USE [CloudDB]
GO

CREATE TABLE [Users](
	[UserId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Username] [varchar](50) NULL UNIQUE,
	[Mobile] [varchar](50) NULL,
	[Email] [varchar](50) NULL UNIQUE,
	[Address] [varchar](max) NULL,
	[PostCode] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[ImageUrl] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL
)

CREATE TABLE [Contact](
	[ContactId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Subject] [varchar](200) NULL,
	[Message] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL
)

CREATE TABLE [Categories](
	[CategoryId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[ImageUrl] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL
)

CREATE TABLE [Products](
	[ProductId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Description] [varchar](max) NULL,
	[Price] [decimal](18,2) NULL,
	[Quantity] [int] NULL,
	[ImageUrl] [varchar](max) NULL,
	[CategoryId] [int] NULL, --FK
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL
)

CREATE TABLE [Carts](
	[CartId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL, --FK
	[Quantity] [int] NULL,
	[UserId] [int] NULL, --FK
)

CREATE TABLE [Orders](
	[OrderDetailsId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[OrderNo] [varchar](max) NULL,
	[ProductId] [int] NULL, --FK
	[Quantity] [int] NULL,
	[UserId] [int] NULL, --FK
	[Status] [varchar](50) NULL,
	[PaymentId] [int] NULL, --FK
	[OrderDate] [datetime] NULL
)

CREATE TABLE [Payment](
	[PaymentId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[CardNo] [varchar](50) NULL,
	[ExpiryDate] [varchar](50) NULL,
	[CvvNo] [int] NULL,
	[Address] [varchar](max) NULL,
	[PaymentMode] [varchar](50) NULL
	
)

GO

/* ============================================================
   Source: SQLQuery2.sql
   ============================================================ */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE Category_Crud 
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(10),
	@CategoryId INT = NULL,
	@Name VARCHAR(100) = NULL,
	@IsActive BIT = false,
	@ImageUrl VARCHAR(MAX) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- SELECT
	IF @Action = 'SELECT'
		BEGIN
			SELECT * FROM dbo.Categories ORDER BY CreatedDate DESC
		END
	-- INSERT
	IF @Action = 'INSERT'
		BEGIN
			INSERT INTO dbo.Categories(Name,ImageUrl,IsActive,CreatedDate)
			VALUES (@Name,@ImageUrl,@IsActive,GETDATE())
		END

	-- UPDATE
	IF @Action = 'UPDATE'
		BEGIN
			DECLARE @UPDATE_IMAGE VARCHAR(20)
			SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)
			IF @UPDATE_IMAGE = 'NO'
			BEGIN
			UPDATE dbo.Categories
			SET Name = @Name,IsActive = @IsActive
			WHERE CategoryId = @CategoryId
		END
	ELSE
	  BEGIN
	  UPDATE dbo.Categories
			SET Name = @Name,ImageUrl= @ImageUrl,IsActive = @IsActive
			WHERE CategoryId = @CategoryId
		END
	END

	-- DELECT
	IF @Action = 'DELETE'
		BEGIN
			DELETE FROM dbo.Categories WHERE CategoryId=@CategoryId
		END

	-- GETBYID
	IF @Action = 'GETBYID'
		BEGIN
			SELECT * FROM dbo.Categories WHERE CategoryId=@CategoryId
		END



    
	
END
GO

GO

/* ============================================================
   Source: SQLQuery3(SP).sql
   ============================================================ */
CREATE PROCEDURE [dbo].[Product_Crud] 
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(10),
	@ProductId INT = NULL,
	@Name VARCHAR(100) = NULL,
	@Description VARCHAR(MAX) = NULL,
	@Price DECIMAL(18,2) = 0,
	@Quantity INT = NULL,
	@ImageUrl VARCHAR(MAX) = NULL,
	@CategoryId INT = NULL,
	@IsActive BIT = false

AS
BEGIN
	
	SET NOCOUNT ON;
	-- SELECT
	IF @Action = 'SELECT'
		BEGIN
			SELECT P.*,C.Name AS CategoryName FROM dbo.Products p
			INNER JOIN dbo.Categories c on c.CategoryId = p.CategoryId ORDER BY p.CreatedDate DESC
		END
	-- INSERT
	IF @Action = 'INSERT'
		BEGIN
			INSERT INTO dbo.Products(Name,Description,Price,Quantity,ImageUrl,CategoryId,IsActive,CreatedDate)
			VALUES (@Name,@Description,@Price,@Quantity,@ImageUrl,@CategoryId,@IsActive,GETDATE())
		END

	-- UPDATE
	IF @Action = 'UPDATE'
		BEGIN
			DECLARE @UPDATE_IMAGE VARCHAR(20)
			SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)
			IF @UPDATE_IMAGE = 'NO'
			BEGIN
			UPDATE dbo.Products
			SET Name = @Name,Description = @Description,Price=@Price,Quantity=@Quantity,
			CategoryId=@CategoryId,IsActive=@IsActive
			WHERE ProductId = @ProductId
		END
	ELSE
	  BEGIN
	  UPDATE dbo.Products
			SET Name = @Name,Description= @Description,Price = @Price,Quantity=@Quantity,
			ImageUrl=@ImageUrl,CategoryId=@CategoryId,IsActive=@IsActive
			WHERE ProductId = @ProductId
		END
	END

	-- UPDATE Quantity
	IF @Action = 'QTYUPDATE'
		BEGIN
			UPDATE dbo.Products SET Quantity = @Quantity
			WHERE ProductId = @ProductId
		END

	-- DELECT
	IF @Action = 'DELETE'
		BEGIN
			DELETE FROM dbo.Products WHERE ProductId=@ProductId
		END

	-- GETBYID
	IF @Action = 'GETBYID'
		BEGIN
			SELECT * FROM dbo.Products WHERE ProductId=@ProductId
		END



    
	
END

GO

/* ============================================================
   Source: SQLQuery(User_Crud).sql
   ============================================================ */
CREATE PROCEDURE [dbo].[User_Crud] 
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(10),
	@UserId INT = NULL,
	@Name VARCHAR(50) = NULL,
	@Username VARCHAR(50) = NULL,
	@Mobile VARCHAR(50) = NULL,
	@Email VARCHAR(50) = NULL,
	@Address VARCHAR(MAX) = NULL,
	@PostCode VARCHAR(50) = NULL,
	@Password VARCHAR(50) = NULL,
	@ImageUrl VARCHAR(MAX) = NULL

AS
BEGIN
	
	SET NOCOUNT ON;
	
	-- SELECT FOR LOGIN
	IF @Action = 'SELECT4LOGIN'
		BEGIN
			SELECT * FROM dbo.Users WHERE Username = @Username and Password = @Password
		END
	-- SELECT FOR USER PROFILE
	IF @Action = 'SELECT4PROFILE'
		BEGIN
			SELECT * FROM dbo.Users WHERE UserId = @UserId
		END

		-- insert(registration)
	IF @Action = 'INSERT'
		BEGIN
			Insert into dbo.Users(Name,Username,Mobile,Email,Address,PostCode,Password,ImageUrl,CreatedDate)
			values (@Name,@Username,@Mobile,@Email,@Address,@PostCode,@Password,@ImageUrl,GETDATE())
		END

		-- UPDATE USER PROFILE
	IF @Action = 'UPDATE'
		BEGIN
			DECLARE @UPDATE_IMAGE VARCHAR(20)
			SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)
			IF @UPDATE_IMAGE = 'NO'
			BEGIN
			UPDATE dbo.Users
			SET Name = @Name, Username = @Username,Mobile=@Mobile,Email=@Email,Address=@Address,
			PostCode=@PostCode
			WHERE UserId = @UserId
		END
	ELSE
	  BEGIN
			UPDATE dbo.Users
			SET Name = @Name,Username = @Username,Mobile=@Mobile,Email=@Email,Address=@Address,
			PostCode=@PostCode,ImageUrl=@ImageUrl
			WHERE UserId = @UserId
		END
		
	END

	-- SELECT FOR ADMIN
	IF @Action = 'SELECT4ADMIN'
		BEGIN
			SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS [SrNo],UserId,Name,
			Username,Email,CreatedDate
			FROM Users
		END

	-- DELECT BY ADMIN
	IF @Action = 'DELETE'
		BEGIN
			DELETE FROM dbo.Users WHERE UserId=@UserId
		END
	
END
GO

GO

/* ============================================================
   Source: SQLQuery(Cart_crud).sql
   ============================================================ */
CREATE PROCEDURE Cart_Crud
@Action VARCHAR(10),
@ProductId INT = NULL,
@Quantity INT = NULL,
@UserId INT =NULL
AS
BEGIN
  SET NOCOUNT ON;
--SELECT
IF @Action = 'SELECT'
  BEGIN
    SELECT c.ProductId,p.Name,p.ImageUrl,p.Price,c.Quantity AS Qty,p.Quantity AS PrdQty 
    FROM dbo.Carts c
    INNER JOIN dbo.Products p ON p.ProductId = c.ProductId
    WHERE c.UserId = @UserId
  END
--INSERT
IF @Action = 'INSERT'
  BEGIN
    INSERT INTO dbo.Carts(ProductId,Quantity,UserId)
    VALUES (@ProductId,@Quantity,@UserId)
    
  END

--UPDATE
IF @Action = 'UPDATE'
  BEGIN
    UPDATE dbo.Carts
    SET Quantity = @Quantity
    WHERE ProductId = @ProductId AND UserId = @UserId
  END

--DELETE
IF @Action = 'DELETE'
  BEGIN
    DELETE dbo.Carts
    WHERE ProductId = @ProductId AND UserId = @UserId
  END

--GET BY ID (PRODUCTID & USERID)
IF @Action = 'GETBYID'
  BEGIN
    SELECT * FROM dbo.Carts
    WHERE ProductId = @ProductId AND UserId = @UserId
  END


END

GO

/* ============================================================
   Source: SQLQuery(ContactSp).sql
   ============================================================ */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE ContactSp
  @Action VARCHAR(10),
  @ContactId INT = NULL,
  @Name VARCHAR(50) = NULL,
  @Email VARCHAR(50) = NULL,
  @Subject VARCHAR(200) = NULL,
  @Massage VARCHAR(MAX)= NULL
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

   --INSERT
   IF @Action = 'INSERT'
  BEGIN
    INSERT INTO dbo.Contact(NAME,Email,Subject,Message,CreatedDate)
    VALUES (@name,@Email,@Subject,@Massage,GETDATE())
  END
  --SELECT
  IF @Action = 'SELECT'
    BEGIN 
      SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS [SrNo],* FROM dbo.Contact
    END

  IF @Action = 'DELETE'
    BEGIN 
      DELETE FROM dbo.Contact WHERE ContactId =  @ContactId
    END

        
END
GO

GO

/* ============================================================
   Source: SQLQuery(Table_type).sql
   ============================================================ */
CREATE TYPE [dbo.OrderDetailss] AS TABLE(
[OrderNo][varchar](max) NULL,
[ProductId][int] NULL,
[Quantity][int] NULL,
[UserId][int] NULL,
[Status][varchar](50) NULL,
[PaymentId][int] NULL,
[OrderDate][datetime] NULL
)

GO

/* ============================================================
   Source: SQLQuery(table type and store procedures).sql
   ============================================================ */
CREATE TYPE dbo.OrderDetails AS TABLE (
    OrderNo varchar(MAX) NULL,
    ProductId int NULL,
    Quantity int NULL,
    UserId int NULL,
    Status varchar(50) NULL,
    PaymentId int NULL,
    OrderDate datetime NULL
);
GO

create procedure [dbo].[Save_Orders] @tblOrders [dbo].[OrderDetails] readonly
as
begin
		set nocount on;
		insert into Orders(OrderNo,ProductId,Quantity,UserId,Status,PaymentId,OrderDate)
		select OrderNo,ProductId,Quantity,UserId,status,PaymentId,OrderDate from @tblOrders
end
GO

create procedure [dbo].[Save_Payment]
	@Name varchar(100) = null,
	@CardNo varchar(50) = null,
	@ExpiryDate varchar(50) = null,
	@Cvv int = null,
	@Address varchar(max) = null,
	@PaymentMode varchar(10) = 'card',
	@InsertedId int OUTPUT
as
begin
	set nocount on;
	--insert
	begin
		insert into dbo.Payment(Name,CardNo,ExpiryDate,CvvNo,Address,PaymentMode)
		values (@Name,@CardNo,@ExpiryDate,@Cvv,@Address,@PaymentMode)

		select @InsertedId = SCOPE_IDENTITY();
	end
end

GO

/* ============================================================
   Source: SQLQuery(InvoiceSP).sql
   ============================================================ */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE Invoice
		@Action VARCHAR(10),
		@PaymentId INT = NULL,
		@UserId INT = NULL,
		@OrderDetailsId INT = NULL,
		@Status VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--GET INVOICE BY ID
	IF @Action = 'INVOICEBYID'
	BEGIN
		SELECT ROW_NUMBER() OVER(ORDER BY(SELECT 1)) AS [SrNo], o.OrderNo, p.Name, p.Price,o.Quantity,
		(p.Price * o.Quantity) as TotalPrice, o.OrderDate, o.Status from Orders o
		INNER JOIN Products p on p.ProductId = o.ProductId
		where o.PaymentId = @PaymentId and o.UserId = @UserId
	END

    --SELECT ORDER HISTORY
	IF @Action = 'ODRHISTORY'
	BEGIN
		SELECT DISTINCT p.PaymentId , p.PaymentMode, p.CardNo From Orders o 
		inner join Payment p on p.PaymentId = o.PaymentId
		where o.UserId = @UserId
	END
	--GET ORDER STATUS
	IF @Action = 'GETSTATUS'
	BEGIN
		SELECT o.OrderDetailsId, o.OrderNo, (pr.Price * o.Quantity) as TotalPrice, o.Status,
		o.OrderDate , p.PaymentMode, pr.Name from Orders o
		inner join Payment p on p.PaymentId = o.PaymentId
		inner join Products pr on pr.ProductId = o.ProductId
	END
	--GET ORDER STATUS BY ID
	IF @Action = 'STATUSBYID'
	BEGIN
		SELECT OrderDetailsId, Status From Orders
		where OrderDetailsId = @OrderDetailsId
		
	END
	--UPDATE ORDER STATUS
	IF @Action = 'UPDSTATUS'
	BEGIN
		UPDATE dbo.Orders
		set status = @Status where OrderDetailsId = @OrderDetailsId
		
	END
	
END
GO

GO

/* ============================================================
   Source: SQLQuery(InvoiceUpdate).sql
   ============================================================ */
USE [CloudDB]
GO
/****** Object:  StoredProcedure [dbo].[Invoice]    Script Date: 7/14/2024 2:22:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Invoice]
		@Action VARCHAR(10),
		@PaymentId INT = NULL,
		@UserId INT = NULL,
		@OrderDetailsId INT = NULL,
		@Status VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--GET INVOICE BY ID
	IF @Action = 'INVOICE'
	BEGIN
		SELECT ROW_NUMBER() OVER(ORDER BY(SELECT 1)) AS [SrNo], o.OrderNo, p.Name, p.Price,o.Quantity,
		(p.Price * o.Quantity) as TotalPrice, o.OrderDate, o.Status from Orders o
		INNER JOIN Products p on p.ProductId = o.ProductId
		where o.PaymentId = @PaymentId and o.UserId = @UserId
	END

    --SELECT ORDER HISTORY
	IF @Action = 'ODRHISTORY'
	BEGIN
		SELECT DISTINCT p.PaymentId , p.PaymentMode, p.CardNo From Orders o 
		inner join Payment p on p.PaymentId = o.PaymentId
		where o.UserId = @UserId
	END
	--GET ORDER STATUS
	IF @Action = 'GETSTATUS'
	BEGIN
		SELECT o.OrderDetailsId, o.OrderNo, (pr.Price * o.Quantity) as TotalPrice, o.Status,
		o.OrderDate , p.PaymentMode, pr.Name from Orders o
		inner join Payment p on p.PaymentId = o.PaymentId
		inner join Products pr on pr.ProductId = o.ProductId
	END
	--GET ORDER STATUS BY ID
	IF @Action = 'STATUSBYID'
	BEGIN
		SELECT OrderDetailsId, Status From Orders
		where OrderDetailsId = @OrderDetailsId
		
	END
	--UPDATE ORDER STATUS
	IF @Action = 'UPDSTATUS'
	BEGIN
		UPDATE dbo.Orders
		set status = @Status where OrderDetailsId = @OrderDetailsId
		
	END
	
END

GO

/* ============================================================
   Source: SQLQuery(Menu_category).sql
   ============================================================ */
USE [CloudDB]
GO
/****** Object:  StoredProcedure [dbo].[Category_Crud]    Script Date: 7/7/2024 4:48:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Category_Crud] 
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(10),
	@CategoryId INT = NULL,
	@Name VARCHAR(100) = NULL,
	@IsActive BIT = false,
	@ImageUrl VARCHAR(MAX) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- SELECT
	IF @Action = 'SELECT'
		BEGIN
			SELECT * FROM dbo.Categories ORDER BY CreatedDate DESC
		END
		-- Active Category
	IF @Action = 'ACTIVECAT'
		BEGIN
			SELECT * FROM dbo.Categories WHERE IsActive=1
		END
	-- INSERT
	IF @Action = 'INSERT'
		BEGIN
			INSERT INTO dbo.Categories(Name,ImageUrl,IsActive,CreatedDate)
			VALUES (@Name,@ImageUrl,@IsActive,GETDATE())
		END

	-- UPDATE
	IF @Action = 'UPDATE'
		BEGIN
			DECLARE @UPDATE_IMAGE VARCHAR(20)
			SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)
			IF @UPDATE_IMAGE = 'NO'
			BEGIN
			UPDATE dbo.Categories
			SET Name = @Name,IsActive = @IsActive
			WHERE CategoryId = @CategoryId
		END
	ELSE
	  BEGIN
	  UPDATE dbo.Categories
			SET Name = @Name,ImageUrl= @ImageUrl,IsActive = @IsActive
			WHERE CategoryId = @CategoryId
		END
	END

	-- DELECT
	IF @Action = 'DELETE'
		BEGIN
			DELETE FROM dbo.Categories WHERE CategoryId=@CategoryId
		END

	-- GETBYID
	IF @Action = 'GETBYID'
		BEGIN
			SELECT * FROM dbo.Categories WHERE CategoryId=@CategoryId
		END



    
	
END

GO

/* ============================================================
   Source: SQLQuery(Menu).sql
   ============================================================ */
USE [CloudDB]
GO
/****** Object:  StoredProcedure [dbo].[Product_Crud]    Script Date: 7/7/2024 4:28:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Product_Crud] 
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(20),
	@ProductId INT = NULL,
	@Name VARCHAR(100) = NULL,
	@Description VARCHAR(MAX) = NULL,
	@Price DECIMAL(18,2) = 0,
	@Quantity INT = NULL,
	@ImageUrl VARCHAR(MAX) = NULL,
	@CategoryId INT = NULL,
	@IsActive BIT = false

AS
BEGIN
	
	SET NOCOUNT ON;
	-- SELECT
	IF @Action = 'SELECT'
		BEGIN
			SELECT P.*,C.Name AS CategoryName FROM dbo.Products p
			INNER JOIN dbo.Categories c on c.CategoryId = p.CategoryId ORDER BY p.CreatedDate DESC
		END
		-- Active Product
	IF @Action = 'ACTIVEPROD'
		BEGIN
			SELECT P.*,C.Name AS CategoryName FROM dbo.Products p
			INNER JOIN dbo.Categories c on c.CategoryId = p.CategoryId
			WHERE p.IsActive=1
		END
	-- INSERT
	IF @Action = 'INSERT'
		BEGIN
			INSERT INTO dbo.Products(Name,Description,Price,Quantity,ImageUrl,CategoryId,IsActive,CreatedDate)
			VALUES (@Name,@Description,@Price,@Quantity,@ImageUrl,@CategoryId,@IsActive,GETDATE())
		END

	-- UPDATE
	IF @Action = 'UPDATE'
		BEGIN
			DECLARE @UPDATE_IMAGE VARCHAR(20)
			SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)
			IF @UPDATE_IMAGE = 'NO'
			BEGIN
			UPDATE dbo.Products
			SET Name = @Name,Description = @Description,Price=@Price,Quantity=@Quantity,
			CategoryId=@CategoryId,IsActive=@IsActive
			WHERE ProductId = @ProductId
		END
	ELSE
	  BEGIN
	  UPDATE dbo.Products
			SET Name = @Name,Description= @Description,Price = @Price,Quantity=@Quantity,
			ImageUrl=@ImageUrl,CategoryId=@CategoryId,IsActive=@IsActive
			WHERE ProductId = @ProductId
		END
	END

	-- UPDATE Quantity
	IF @Action = 'QTYUPDATE'
		BEGIN
			UPDATE dbo.Products SET Quantity = @Quantity
			WHERE ProductId = @ProductId
		END

	-- DELECT
	IF @Action = 'DELETE'
		BEGIN
			DELETE FROM dbo.Products WHERE ProductId=@ProductId
		END

	-- GETBYID
	IF @Action = 'GETBYID'
		BEGIN
			SELECT * FROM dbo.Products WHERE ProductId=@ProductId
		END



    
	
END

GO

/* ============================================================
   Source: SQLQuery(Dashboard).sql
   ============================================================ */
Create procedure Dashboard
@Action varchar (20) =null
as
begin

  SET NOCOUNT ON;

  --1.Categories

  IF @Action = 'CATEGORY'
  BEGIN
    SELECT COUNT(*) FROM dbo.Categories
  END

  --2.Products
  IF @Action = 'PRODUCT'
  BEGIN
    SELECT COUNT(*) FROM dbo. Products
  END

  --3.Orders
  IF @Action = 'ORDER'
  BEGIN
    SELECT COUNT(*) FROM dbo.Orders
  END

  --4.Orders Delivered
  IF @Action = 'DELIVERED'
  BEGIN
  SELECT COUNT(*) FROM dbo.Orders
  WHERE Status = 'Delivered'
  END

  --5.Orders Pending
  IF @Action = 'PENDING'
  BEGIN
  SELECT COUNT(*) FROM dbo.Orders
  WHERE Status IN ('Pending','Dispatched')
  END

  --Users
  IF @Action = 'USER'
  BEGIN
    SELECT COUNT(*) FROM dbo.Users
  END

  --SOld Item Cost
  IF @Action = 'SOLDAMOUNT'
  BEGIN
    SELECT SUM(o.Quantity*p.Price) FROM Orders o
    INNER JOIN Products p ON p.ProductId=o.PaymentId
  END

  --Contact
  IF @Action = 'CONTACT'
  BEGIN
    SELECT COUNT(*) FROM dbo.Contact
  END

end

GO

/* ============================================================
   Source: SQLQuery(selling report).sql
   ============================================================ */
Create Procedure SellingReport

@FromDate Date=null,

@ToDate Date = null

as

begin

SET NOCOUNT ON;

Select ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS [SrNo], u. Name, u. Email, 
Sum(o.Quantity) as TotalOrders, Sum (o. Quantity * p. Price) as TotalPrice 
from Orders o

INNER JOIN Products p ON p.ProductId = o. ProductId

INNER JOIN Users u ON u. UserId = o. UserId

WHERE CAST(o. OrderDate as Date) Between @FromDate AND @ToDate

GROUP By u. Name, u. Email



end

GO
