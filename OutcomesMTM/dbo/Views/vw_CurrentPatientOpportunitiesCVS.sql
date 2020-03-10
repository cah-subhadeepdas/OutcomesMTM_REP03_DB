



/****** Script for SelectTopNRows command from SSMS  ******/

CREATE view [dbo].[vw_CurrentPatientOpportunitiesCVS]

as

SELECT [ID]
      ,[Policy Name]
      ,[Policy ID]
      ,[Member ID]
      ,[Member First Name]
      ,[Member Last Name]
      ,[DOB]
      ,[Current TIP Opportunities]
      ,[CMR Eligible]
      ,[Currently Targeted for a CMR]
      ,[Last CMR - Date]
      ,[Last CMR - Result Name]
      ,[Last CMR - NCPDP]
      ,[Last CMR - Pharmacy Name]
      ,[Client Name]
      ,[Chain Name]
      ,[Primary Pharmacy NABP]
      ,[Chain Code]
	  ,[ClientId]
  FROM [OutcomesMTM].[dbo].[CurrentPatientOpportunities]
  where 
  [Chain Code] in 
  (
   '177'
  ,'207'
  ,'008'
  ,'039'
  )




