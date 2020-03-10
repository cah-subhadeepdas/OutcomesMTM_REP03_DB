

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE view [dbo].[vwp_DW_StatsFactDescriptionInsert]

as


SELECT distinct 
       [OriginID]
      ,[OriginCol]
      ,[OriginTbl]
      ,[OriginDesc]
FROM [OutcomesMTM].[dbo].[vwp_DW_Stats_Fact_ST]
where originID is not null 

except 

SELECT distinct 
       [OriginID]
      ,[OriginCol]
      ,[OriginTbl]
      ,[FactDesc]
FROM [OutcomesMTM].[dbo].[DW_Fact_Desc]



