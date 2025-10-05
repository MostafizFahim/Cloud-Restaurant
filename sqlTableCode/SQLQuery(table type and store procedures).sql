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
