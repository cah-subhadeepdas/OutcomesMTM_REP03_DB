
--Author:- Santhosh K Thopu
--Description:- Final report generation for Patient and tip Trending Report

 
CREATE  procedure [reporting].[S_Patient_And_TIP_Trending_Report] 
AS
BEGIN

/*Fetching data as of Today*/
SELECT T.*
Into #Temp1
From
      (
	  Select  
	  [PolicyID]
      ,[ClientID]
      ,[PolicyName]
      ,[ClientName]
      ,[Count Of Active Patients]
      ,[Count Of Active patients At MTM Centers]
      ,[Count Of TIP Opportunities YTD]
      ,[Count Of Active TIPS]
      ,[Count Of WithDrawn TIPS]
      ,[Count Of Expired TIPS]
      ,[Count OF Active TIPS With GPI]
	  ,[Count Of CMR Eligible patients]
      ,[Count of 01 Optout patients]
      ,[Count of 02 Optout patients]
      ,[Count of 03 Optout patients]
      ,[Count of 99 Optout patients]
      ,[TIP Opportunites Per Active patients]
	  ,[Load Date]
	  ,rank()over(partition by p.PolicyID Order by [Load Date] Desc)   As [Ranker]
  FROM [OutcomesMTM].[reporting].[Patient_TIPTrendingReport] p
  Where 1=1
  )T
  Where 1=1
  and T.Ranker=1



/*Fetching data as of Yesterday*/  
 SELECT T.*
 Into #Temp2
From
      (
	  Select  
	  [PolicyID]
      ,[ClientID]
      ,[PolicyName]
      ,[ClientName]
      ,[Count Of Active Patients]
      ,[Count Of Active patients At MTM Centers]
      ,[Count Of TIP Opportunities YTD]
      ,[Count Of Active TIPS]
      ,[Count Of WithDrawn TIPS]
      ,[Count Of Expired TIPS]
      ,[Count OF Active TIPS With GPI]
	  ,[Count Of CMR Eligible patients]
      ,[Count of 01 Optout patients]
      ,[Count of 02 Optout patients]
      ,[Count of 03 Optout patients]
      ,[Count of 99 Optout patients]
      ,[TIP Opportunites Per Active patients]
	  ,[Load Date]
	  ,rank()over(partition by p.PolicyID Order by [Load Date] Desc)   As [Ranker]
  FROM [OutcomesMTM].[reporting].[Patient_TIPTrendingReport] p
  Where 1=1
  )T
  Where 1=1
  and T.Ranker=2  


--Select * From #Temp1

--Select * from #Temp2


/*Final Report*/

Select 
f.clientID
,f.clientName
,f.policyID
,f.policyName
,f.[Count Of Active patients]
,pd.[Count Of Active Patients]                 As [Count Of Active Patients Prior Day]
,ISNULL(Cast(Cast((((f.[Count Of Active Patients] *1.00)-(pd.[Count Of Active Patients]*1.00))/NULLIF((pd.[Count Of Active Patients]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of Outcomes Active Patients]

,f.[Count Of Active patients At MTM Centers]
,pd.[Count Of Active patients At MTM Centers]   As [Count Of Active Patients at MTM Center Prior Day]
,ISNULL(Cast(Cast((((f.[Count Of Active patients At MTM Centers] *1.00)-(pd.[Count Of Active patients At MTM Centers]*1.00))/NULLIF((pd.[Count Of Active patients At MTM Centers]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of Active Patients at MTM Center]

,f.[Count Of TIP Opportunities YTD]
,pd.[Count Of TIP Opportunities YTD]     As [Count Of Total TIP Opportunities YTD Prior Day]
,ISNULL(Cast(Cast((((f.[Count Of TIP Opportunities YTD] *1.00)-(pd.[Count Of TIP Opportunities YTD]*1.00))/NULLIF((pd.[Count Of TIP Opportunities YTD]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of Total TIP Opportunities YTD]

,f.[Count Of Active TIPS]
,pd.[Count Of Active TIPS]                     As [Count Of Active TIPS Prior day]
,ISNULL(Cast(Cast((((f.[Count Of Active TIPS] *1.00)-(pd.[Count Of Active TIPS]*1.00))/NULLIF((pd.[Count Of Active TIPS]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of Active TIPS]

,f.[Count Of WithDrawn TIPS]
,pd.[Count Of WithDrawn TIPS]                  As [Count Of WithDrawn TIPS Prior day]
,ISNULL(Cast(Cast((((f.[Count Of WithDrawn TIPS] *1.00)-(pd.[Count Of WithDrawn TIPS]*1.00))/NULLIF((pd.[Count Of WithDrawn TIPS]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of WithDrawn TIPS]

,f.[Count Of Expired TIPS]
,pd.[Count Of Expired TIPS]                    As [Count Of Expired TIPS Prior day]
,ISNULL(Cast(Cast((((f.[Count Of Expired TIPS] *1.00)-(pd.[Count Of Expired TIPS]*1.00))/NULLIF((pd.[Count Of Expired TIPS]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of  Expired TIPS]

,f.[Count OF Active TIPS With GPI]
,pd.[Count OF Active TIPS With GPI]            As [Count OF Active TIPS With GPI Priror Day]
,ISNULL(Cast(Cast((((f.[Count OF Active TIPS With GPI] *1.00)-(pd.[Count OF Active TIPS With GPI]*1.00))/NULLIF((pd.[Count OF Active TIPS With GPI]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of  Active TIPS With GPI]




,f.[Count Of CMR Eligible patients]
,pd.[Count Of CMR Eligible patients]            As [Count Of CMR Eligible patients Prior Day]
,ISNULL(Cast(Cast((((f.[Count Of CMR Eligible patients] *1.00)-(pd.[Count Of CMR Eligible patients]*1.00))/NULLIF((pd.[Count Of CMR Eligible patients]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of  CMR Eligible patients]


,f.[TIP Opportunites Per Active patients]
,pd.[TIP Opportunites Per Active patients] AS [TIP Opportunites Per Active patients Prior Day]
,ISNULL(Cast(Cast((((f.[TIP Opportunites Per Active patients] *1.00)-(pd.[TIP Opportunites Per Active patients]*1.00))/NULLIF((pd.[TIP Opportunites Per Active patients]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of  TIP Opportunites Per Active patients]



,f.[Count of 01 Optout patients]
,pd.[Count of 01 Optout patients]              As [Count of 01 Optout patients Prior day ]
,ISNULL(Cast(Cast((((f.[Count of 01 Optout patients] *1.00)-(pd.[Count of 01 Optout patients]*1.00))/NULLIF((pd.[Count of 01 Optout patients]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of  01 Optout patients]

,f.[Count of 02 Optout patients]
,pd.[Count of 02 Optout patients]              As [Count of 02 Optout patients Priror Day]
,ISNULL(Cast(Cast((((f.[Count of 02 Optout patients] *1.00)-(pd.[Count of 02 Optout patients]*1.00))/NULLIF((pd.[Count of 02 Optout patients]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of  02 Optout patients]

,f.[Count of 03 Optout patients]
,pd.[Count of 03 Optout patients]              As [Count of 03 Optout patients Prior Day]
,ISNULL(Cast(Cast((((f.[Count of 03 Optout patients] *1.00)-(pd.[Count of 03 Optout patients]*1.00))/NULLIF((pd.[Count of 03 Optout patients]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of  03 Optout patients]

,f.[Count of 99 Optout patients]
,pd.[Count of 99 Optout patients]              As [Count of 99 Optout patients Prior Day]
,ISNULL(Cast(Cast((((f.[Count of 99 Optout patients] *1.00)-(pd.[Count of 99 Optout patients]*1.00))/NULLIF((pd.[Count of 99 Optout patients]*1.00),0))*100 as decimal(18,3)) As Nvarchar(10)),0.00) AS [%difference Of  99 Optout patients]
--,rank()over(partition by pd.PolicyID order by [Load Date] Desc) as [Ranker]
--,pd.[Load Date]
From #temp1 f
Join #temp2 pd on f.policyID=pd.policyID --and f.policyID In(581,829,378,737,498)
Where 1=1
END

/*
Exec [reporting].[S_Patient_And_TIP_Trending_Report]
With result sets(
(
    [ClientID] int,
	[ClientName] varchar(50) ,
	[PolicyID] int,
	[PolicyName] varchar(50) ,

	[Count Of Active Patients] bigint,
	[Count Of Active Patients Prior Day] bigint,
	[%difference Of Outcomes Active Patients] decimal(18,3),

	[Count Of Active patients At MTM Centers] bigint,
	[Count Of Active Patients at MTM Center Prior Day] bigint,
	[%difference Of Active Patients at MTM Center] decimal(18, 3),

	[Count Of TIP Opportunities YTD] bigint,
	[Count Of Total TIP Opportunities YTD Prior Day] bigint,
	[%difference Of Total TIP Opportunities YTD] decimal(18, 3),

	[Count Of Active TIPS] bigint,
	[Count Of Active TIPS Prior day] bigint,
	[%difference Of Active TIPS] decimal(18, 3),

	[Count Of WithDrawn TIPS] bigint,
	[Count Of WithDrawn TIPS Prior day] bigint,
	[%difference Of WithDrawn TIPS] decimal(18, 3),

	[Count Of Expired TIPS] bigint,
	[Count Of Expired TIPS Prior day] bigint,
	[%difference Of  Expired TIPS] decimal(18, 3),

	[Count OF Active TIPS With GPI] bigint,
	[Count OF Active TIPS With GPI Priror Day] bigint,
	[%difference Of  Active TIPS With GPI] decimal(18, 3),

	[Count Of CMR Eligible patients] bigint,
	[Count Of CMR Eligible patients Prior Day] bigint,
	[%difference Of  CMR Eligible patients] decimal(18, 3),

	[TIP Opportunites Per Active patients] bigint,
	[TIP Opportunites Per Active patients Prior Day] bigint,
	[%difference Of  TIP Opportunites Per Active patients] decimal(18, 3),


	[Count of 01 Optout patients] bigint,
	[Count of 01 Optout patients Prior day] bigint,
	[%difference Of  01 Optout patients] decimal(18, 3),

	[Count of 02 Optout patients] bigint,
	[Count of 02 Optout patients Priror Day] bigint,
	[%difference Of  02 Optout patients] decimal(18, 3),

	[Count of 03 Optout patients] bigint,
	[Count of 03 Optout patients Prior Day] bigint,
	[%difference Of  03 Optout patients] decimal(18, 3),

	[Count of 99 Optout patients] bigint,
	[Count of 99 Optout patients Prior Day] bigint,
	[%difference Of  99 Optout patients] decimal(18, 3)
	--[TIP Opportunites Per Active patients] decimal(18, 3)
)
)
*/




