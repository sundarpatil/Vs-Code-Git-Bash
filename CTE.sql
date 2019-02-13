____________________________________________________________________________________________________

recursive Common Table Expression
____________________________________________________________________________________________________

1)
        WITH
            CTEReports (EmployeeID, FirstName, LastName, ManagerID, EmployeeLevel)
            AS
            (
              SELECT EmployeeID, FirstName, LastName, ManagerID, 1 FROM Employees WHERE ManagerID IS NULL
              UNION ALL
              SELECT e.EmployeeID, e.FirstName, e.LastName, e.ManagerID, r.EmployeeLevel + 1 FROM Employees e
              INNER JOIN CTEReports r ON e.ManagerID = r.EmployeeID
            )
        SELECT FirstName, LastName,  EmployeeLevel, (SELECT FirstName + ' ' + LastName FROM Employees WHERE EmployeeID = CTEReports.MgrID) AS Manager
        FROM CTEReports  
        ORDER BY EmployeeLevel, ManagerID
        OPTION (MAXRECURSION 2);  

____________________________________________________________________________________________________

nonrecursive Common Table Expression
____________________________________________________________________________________________________

1)
        WITH 
          CTETotalSales (SalesPersonID, NetSales)
          AS
          (
            SELECT SalesPersonID, ROUND(SUM(SubTotal), 2) FROM Sales.Order  WHERE SalesPersonID IS NOT NULL
            GROUP BY SalesPersonID
          )
        SELECT 
          sp.FirstName, sp.LastName, sp.Location, TS.NetSales
        FROM Sales.SalesPerson AS sp INNER JOIN CTETotalSales as TS ON sp.ID = TS.SalesPersonID
        ORDER BY ts.NetSales DESC

 
_____________________

2)
        WITH CTESales (SalesPersonID, SalesOrderID, SalesYear)  
        AS  
        (  
            SELECT SalesOrderID, SalesPersonID, YEAR(OrderDate) AS SalesYear  FROM SalesOrder
        )  
        SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear  FROM CTESales  
        GROUP BY SalesYear, SalesPersonID  
        GO  

_____________________

4)
-- WITH CTE1   
--   AS (  
--     SELECT 'CTE1' CTEType ,@startDate StartDate,'W'+convert(varchar(2),DATEPART( wk, @startDate))+'('+convert(varchar(2),@startDate,106)+')' as 'WeekNumber'  
-- 	    UNION ALL
--     SELECT CTEType, dateadd(DAY, 1, StartDate) ,'W'+convert(varchar(2),DATEPART( wk, StartDate))+'('+convert(varchar(2),dateadd(DAY, 1, StartDate),106)+')' as 'WeekNumber' 
-- 	    FROM CTE1  
-- 	    WHERE dateadd(DAY, 1, StartDate)<=  @endDate  
--              ),  
--   CTE2
--   AS (  
--        SELECT 'CTE2' CTEType, @startDate StartDate,'W'+convert(varchar(2),DATEPART( wk, @startDate1))+'('+convert(varchar(2),@startDate1,106)+')' as 'WeekNumber'   
-- 	      UNION ALL
-- 	  SELECT 'CTE2' valuetype, dateadd(DAY, 1, StartDate) ,'W'+convert(varchar(2),DATEPART( wk, StartDate))+'('+convert(varchar(2),dateadd(DAY, 1, StartDate),106)+')' as 'WeekNumber'         
-- 		  FROM CTE2  
-- 		  WHERE dateadd(DAY, 1, StartDate)<=  @endDate1  
--  ) 
  
--     SELECT CTEType, Convert(varchar(10),StartDate,105)  as StartDate ,WeekNumber    FROM    CTE1  
-- 		 UNION ALL   
--     SELECT CTEType, Convert(varchar(10),StartDate,105)  as StartDate ,WeekNumber    FROM    CTE2

3)
  WITH CTEParts(AssemblyID, ComponentID, PerAssemblyQty, EndDate, CoLevel) AS  
  (  
      SELECT AssemblyID, ComponentID, PerAssemblyQty,  EndDate, 0 AS CoLevel  FROM BillOfMaterials  WHERE AssemblyID = 800  AND EndDate IS NULL  
      UNION ALL  
      SELECT bom.AssemblyID, bom.ComponentID, p.PerAssemblyQty,  bom.EndDate, CoLevel + 1  FROM BillOfMaterials AS bom   
          INNER JOIN CTEParts AS p  ON bom.AssemblyID = p.ComponentID  AND bom.EndDate IS NULL  
  )
  UPDATE BillOfMaterials  SET PerAssemblyQty = c.PerAssemblyQty * 2  FROM BillOfMaterials AS c  JOIN CTEParts AS d ON c.AssemblyID = d.AssemblyID  
  WHERE d.CoLevel = 0;  


____________________________________________________________________________________________________

Insert example Common Table Expression
____________________________________________________________________________________________________

WITH CTEinsert AS (
  SELECT
    ID, Colume1, Colume2, Colume3, Colume4 FROM TableName1
    -- we can have recursive CTE, Multiple CTE, 
)
INSERT TableName2 (ID, Colume1, Colume2, Colume3, Colume4) SELECT ID, Colume1, Colume2, Colume3, Colume4
FROM CTEinsert

_____________________________________________________________________
 
