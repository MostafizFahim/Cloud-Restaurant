
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
