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