 create table #final
 (
 CompanyId int,
 PackageId int,
 partsfamilyid int,
 countparts int
 )
 insert into #final(CompanyId,PackageId,partsfamilyid,countparts)
 VALUES
 (1003808,4894,1871020,4),
 (1009541,4820,1871000,5),
 (1009320,4800,1870000,3),
 (1009300,4700,1860000,1)
    
 create table #finaldetails
 (
 CompanyId int,
 PackageId int,
 partsfamilyid int,
 countPartsValues int,
 MSLIDValue varchar(50)
 )
 insert into #finaldetails(CompanyId,PackageId,partsfamilyid,MSLIDValue,countPartsValues)
 values
 (1003808,4894,1871020,'1',2),
 (1003808,4894,1871020,'N/A',2),
    
 (1009541,4820,1871000,'N0',3),
 (1009541,4820,1871000,'N/A',2),
    
 (1009320,4800,1870000,'N0',1),
 (1009320,4800,1870000,'N/A',2),
    
 (1009300,4700,1860000,'A',1)
 
 
 /*
 Expected OUtput
 
 companyID	packageid	partsfamilyid		val
1003808			4894		1871020			(2)N/A|(2)1
1009300  	4700		1860000				(1)A
1009320	    4800		1870000	 			(1)N0|(2)N/A
1009541	   4820			1871000		 		(3)N0|(2)N/A
 
 
 
 
 */
 
 
 
 
 --Solution
 
 with cte1 as
 (
  SELECT    CompanyID,STRING_AGG(CONVERT(NVARCHAR(max),'('+cast(countPartsValues as varchar(4))+')'+cast(MSLIDValue as varchar(4))),'|') within group (order by MSLIDValue desc) as val FROM   #finaldetails    
 GROup BY  CompanyID  

 )
 ,cte2 as
 (
 select DISTINCT 
 companyID,Packageid,partsfamilyid 
 from #finaldetails
 )
 select cte1.companyID,cte2.packageid,cte2.partsfamilyid,cte1.val
 from 
 cte1 
 INNER JOIN
 cte2
 on
 cte1.companyID=cte2.companyID