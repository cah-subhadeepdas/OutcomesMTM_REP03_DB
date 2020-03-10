
/****** Script for SelectTopNRows command from SSMS  ******/

CREATE view [dbo].[vwp_DW_StatsFact]

as

SELECT a.[FactID]
      ,a.[FactDesc]
	  ,b.ClaimKey
	  ,format(b.FactDate, 'yyyyMMdd') FactDate
	  ,b.FactAmount
	  ,b.batchID
FROM [OutcomesMTM].[dbo].[DW_Fact_Desc] a
left join 
[OutcomesMTM].[dbo].[DW_Fact_ST] b
on a.factDesc = b.factDescription
