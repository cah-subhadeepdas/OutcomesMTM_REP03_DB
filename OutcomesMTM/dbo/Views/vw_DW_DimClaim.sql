﻿

CREATE view [dbo].[vw_DW_DimClaim]

as

SELECT [claimKey]
      ,[claimID]
      ,[patientID]
      ,[reasonTypeID]
      ,[reasonTypeDesc]
      ,[reasonCode]
      ,[actiontypeID]
      ,[actionNM]
      ,[actionCode]
      ,[statusID]
      ,[statusNM]
      ,[isTipClaim]
      ,[tipDetailID]
      ,[tipresultID]
      ,[tiptitle]
      ,[resultTypeID]
      ,[resultDesc]
      ,[resultCode]
      ,[centerID]
      --,[estimated_cost]
      --,[AIM]
      ,[initDT]
      ,[completeDT]
      ,[resultDT]
      ,[claimProviderRoleID]
      ,[cmrCompleted]
      ,[cmrFace2Face]
      ,[cmrPostDischarge]
      ,[currentMedGpi]
      ,[currentMedMetricQuantity]
      ,[currentMedName]
      ,[currentMedPrescriber]
      ,[currentMedRXNumber]
      ,[currentMedRxNumber2]
      ,[documentationRoleID]
      ,[ecaLevelID]
      ,[EcaActiveFlag]
      ,[ECAValue]
      ,[ecaLevel]
      ,[ecaDesc]
      ,[face2face]
      ,[featureEncounter]
      ,[funded]
      ,[invoiceStatusTypeID]
      ,[medicationID]
      ,[mtmServiceDT]
      ,[paiddate]
      ,[pharmacistID]
      ,[policyID]
      ,[policyName]
      ,[contractID]
      ,[contractname]
      ,[clientID]
      ,[clientName]
      ,[priorAuthCode]
      --,[submitDT]
      --,[timetoComplete]
      --,[createDT]
      --,[changeDate]
      --,[DW_InsertDate]
      --,[DW_ChangeDate]
      --,[batchID]
  FROM [OutcomesMTM].[dbo].[DW_DimClaim]


