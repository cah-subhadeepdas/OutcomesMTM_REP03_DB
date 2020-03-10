
CREATE view [dbo].[vw_clientMtmOpportunitiesReport]
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
              select pv.mtmCenterNumber, pv.Relationship_ID, pv.Relationship_ID_Name, pp.chainid
              from [dbo].[pharmacychain] pp
                 JOIN dbo.pharmacy ph 
                    on ph.centerid = pp.centerid
                 JOIN dbo.Chain ch 
                    on ch.chainid = pp.chainid
                 left join [dbo].[providerRelationshipView] pv 
                    on ph.NCPDP_NABP = pv.mtmCenterNumber
                   and ch.chaincode = pv.Relationship_ID
       ) t on t.mtmCenterNumber = ph.NCPDP_NABP
       where 1=1

