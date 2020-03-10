
--Exec [Staging].[I_InvoicedClaims]

--Author:- Santhosh K thopu

CREATE    Procedure [staging].[I_InvoicedClaims]
As
Begin

Insert Into [staging].[Final_InvoicedClaims](
[Transaction Type ID] 
,[Claim ID] 
,[MTM Service Date] 
,[Policy ID] 
,[Policy Name] 
,[NCPDP] 
,[Pharmacy Name] 
,[Reason Code] 
,[Action Code] 
,[Result Code] 
,[TIP DETAIL ID NUMBER] 
,[Tip Title] 
,[SAP Customer ID] 
,[Invoice #] 
,[Invoice Date] 
,[Invoice Amount] 
,[Transactional Fee] 
,[RecordType]
,[File Load Date]
)
SELECT 
      [Transaction Type ID]
      ,[Claim ID]
      ,[MTM Service Date]
      ,[Policy ID]
      ,[Policy Name]
      ,[NCPDP]
      ,[Pharmacy Name]
      ,[Reason Code]
      ,[Action Code]
      ,[Result Code]
      ,[TIP DETAIL ID NUMBER]
      ,[Tip Title]
      ,[SAP Customer ID]
      ,[Invoice #]
      ,[Invoice Date]
      ,[Invoice Amount]
      ,[Transactional Fee]
	  ,[RecordType]
      ,[File Load Date]
  FROM [OutcomesMTM].[staging].[InvoicedClaims] stg
  where 1=1 and 
not  exists 
( 
select 1 from [OutcomesMTM].[staging].[Final_InvoicedClaims] fnl
where 1=1 
      and fnl.[Transaction Type ID]=stg.[Transaction Type ID]
      and  fnl.[Claim ID]=stg.[Claim ID]
      and  fnl.[MTM Service Date]=stg.[MTM Service Date]
      and  fnl.[Policy ID]=stg.[Policy ID]
      and  fnl.[Policy Name]=stg.[Policy Name]
      and  fnl.[NCPDP]=stg.[NCPDP]
      and  fnl.[Pharmacy Name]=stg.[Pharmacy Name]
      and  fnl.[Reason Code]=stg.[Reason Code]
      and  fnl.[Action Code]=stg.[Action Code]
      and  fnl.[Result Code]=stg.[Result Code]
      and  fnl.[TIP DETAIL ID NUMBER]=stg.[TIP DETAIL ID NUMBER]
      and  fnl.[Tip Title]=stg.[Tip Title]
      and  fnl.[SAP Customer ID]=stg.[SAP Customer ID]
      and  fnl.[Invoice #]=stg.[Invoice #]
      and  fnl.[Invoice Date]=stg.[Invoice Date]
      and  fnl.[Invoice Amount]=stg.[Invoice Amount]
      and  fnl.[Transactional Fee]=stg.[Transactional Fee]
	  and  fnl.[RecordType]=stg.[RecordType]
      --and  fnl.[File Load Date]=stg.[File Load Date]
)

End



--Select  * From [staging].[Final_InvoicedClaims]

--Select * from   [OutcomesMTM].[staging].[InvoicedClaims]
