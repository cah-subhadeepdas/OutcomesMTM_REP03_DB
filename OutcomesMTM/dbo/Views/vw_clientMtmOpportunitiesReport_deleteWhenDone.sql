








CREATE view [dbo].[vw_clientMtmOpportunitiesReport_deleteWhenDone]
as 

       select cm.centerid
       ,policyid
       ,[Trained RPhs]
       ,[Trained Techs]
       ,TotalPatients
       ,TotalPrimaryPatients
       ,[Total CMRs]
       ,[Potential CMR Revenue]
       ,[Total Primary CMRs]
       ,[Potential CMR Revenue Primary]
       ,[CMRs scheduled]
       ,TotalTIPs
       ,TotalPrimaryTIPs
       ,PotentialTIPRevenue
       ,PotentialTIPRevenuePrimary
       ,[Unfinished Claims]
       ,[Review/Resubmit]
       ,[QA zone]
       ,[DTP %]
       ,[6 Month Claim History]
       ,NABP
       ,pharmacy_name
       ,pharmacy_type
       ,address
       ,city
       ,state
       ,stateID
       ,zipCode
       ,cm.phone
       ,cm.fax
       ,cm.contracted
       ,t.Relationship_ID
       ,t.Relationship_ID_Name
       --select cm.centerID, count(*)
       from [dbo].[clientMtmOpportunitiesReport] cm
       join [dbo].[pharmacy] ph on ph.centerid = cm.centerid
       left join ( 
              select 
                 pv.mtmCenterNumber, 
                 pv.Relationship_ID, 
                 pv.Relationship_ID_Name,
                 c.chaincode
              from [dbo].[pharmacychain] pp
                 JOIN [dbo].[Chain] AS c 
                    ON pp.chainid=c.chainid
                 JOIN [dbo].[pharmacy] AS ph 
                    ON pp.centerid=ph.centerid
                 left join [dbo].[providerRelationshipView] pv 
                    on ph.NCPDP_NABP = pv.mtmCenterNumber
                   and c.chaincode = pv.Relationship_ID 

              --select 
              --   pv.mtmCenterNumber, 
              --   pv.Relationship_ID, 
              --   pv.Relationship_ID_Name, 
              --   pp.chaincode
              --from [dbo].[ProviderChain] pp
              --left join [dbo].[providerRelationshipView] pv 
              --   on pp.NCPDP_Provider_ID = pv.mtmCenterNumber
              --  and pp.chaincode = pv.Relationship_ID
              --where 1=1
       ) t on t.mtmCenterNumber = ph.NCPDP_NABP
       where 1=1





