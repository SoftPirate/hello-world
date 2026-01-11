/*
https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-develop-use-vscode?view=sql-server-2017
https://docs.microsoft.com/fr-fr/sql/t-sql/tutorial-writing-transact-sql-statements?view=sql-server-2017
https://docs.microsoft.com/fr-fr/sql/t-sql/language-reference?view=sql-server-2017
*/

--select *
--from Comptes.dbo.Releves01

/*
DECLARE @Cpt INT; DECLARE @Cpt2 INT;
SET @Cpt = 1; SET @Cpt2 = 1;

WHILE @Cpt2 <=7
BEGIN
    WHILE @Cpt <=10
    BEGIN
        IF @Cpt = 5
            --SET @Cpt = 8
            BREAK
            --CONTINUE
        PRINT @Cpt
        SET @Cpt = @Cpt +1
    END
    SET @Cpt=1
        IF @Cpt2 = 5
        BEGIN
            --SET @Cpt = 8
            BREAK
            --CONTINUE
        PRINT @Cpt2
        END
    SET @Cpt2=@Cpt2+1
END
*/

/*Inititialisation de tables */
USE [NeedRessources]
GO

IF OBJECT_ID ('[NeedRessources].[dbo].[Need]', 'U') IS NOT NULL  
   DROP TABLE [NeedRessources].[dbo].[Need];  
GO  

create table Need
(
Type NVARCHAR(1),
Item nvarchar(50),
Quantity decimal,
Date date,
SNOrder varchar(50),
Link varchar(50),
)
INSERT INTO Need (Type, Item, Quantity, Date, SNOrder, Link)
 VALUES
 ('N','Art1', -2, '01/06/2019', 'SO1',''),
 ('N','Art1', -3, '02/06/2019', 'SO2',''),
 ('N','Art1', -1, '03/06/2019', 'SO3',''),
 ('N','Art1', -5, '04/06/2019', 'SO4',''),
 ('N','Art1', -3, '05/06/2019', 'SO5','');

IF OBJECT_ID ('[NeedRessources].[dbo].[Ressources]', 'U') IS NOT NULL  
   DROP TABLE [NeedRessources].[dbo].[Ressources];  
GO  

create table Ressources
(
Type NVARCHAR(1),
Item nvarchar(50),
Quantity decimal,
Date date,
MPOrderNb varchar(50),
Link varchar(50),
)
INSERT INTO Ressources (Type, Item, Quantity, Date, MPOrderNb, Link)
 VALUES
 ('R','Art1', 1, '29/05/2019', 'STK',''),
 ('R','Art1', 4, '02/06/2019', 'MO2',''),
 ('R','Art1', 10, '03/06/2019', 'PO3','');

/*
  select 'B' as 'Type', * from [NeedRessources].[dbo].[Need]
  UNION
    select 'R' as 'Type', * from
  [NeedRessources].[dbo].[Ressources]
  Order by 4
*/

IF OBJECT_ID ('tempDB..#NRtemp', 'U') IS NOT NULL  
   DROP TABLE #NRtemp;  
GO  
IF OBJECT_ID ('tempDB..#NRtemp2', 'U') IS NOT NULL  
   DROP TABLE #NRtemp2;  
GO 

  select * INTO #NRtemp from [NeedRessources].[dbo].[Need]
  INSERT INTO #NRtemp select * from [NeedRessources].[dbo].[Ressources]

--Permet mettre un Id après un tri
SELECT ROW_NUMBER() OVER (ORDER BY Date, Type DESC) AS Id, *
INTO #NRtemp2
FROM #NRtemp
  
select * from #NRtemp2

--  ALTER TABLE #NRtemp   
--  ADD Id INT IDENTITY(1,1)
--  select * from #NRtemp
--select * from #NRtemp Order by Date, Type DESC



  select C1.Id, C1.Type, C1.Date , C1.Quantity, sum(C2.Quantity)
  from #NRtemp2 C1, #NRtemp2 C2 
  where C1.Id >= C2.Id --and C1.Type <>C2.Type
  group by C1.Id,C1.Type, C1.Date, C1.Quantity
  --having sum(C2.Quantity)>=0
  Order by C1.Date Asc, C1.Type DESC


--rechercher: sql alter table add id after sorting




/*

Sum B = Sum R + Rr
a11 r1 + a12 r2 + a13 r3 + a1p rn = b1

R\N     2   3   1   5   3
1       1   0   0   0   0
4       1   3   0   0   0
10      0   0   1   5   0
Rr      0   0   0   4   3

1+4+10 = 2+3+1+5+Rr => 15 = 11+Rr => Rr=4

a11+a12+a13+a14=r1
a21+a22+a23+a24=r2
a31+a34+a33+a34=r3
a41+a42+a43+a44=r4

a11+a21+a31+a41=n1
a12+a22+a32+a42=n2
a13+a23+a33+a43=n3
a14+a24+a34+a44=n4
*/