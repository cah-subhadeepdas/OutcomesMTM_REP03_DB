CREATE proc [dbo].[U_CMRActivityClaim]
as
begin
set nocount on;
set xact_abort on;



update c
set c.[patientid] = st.[patientid]
  , c.[policyID] = st.[policyID]
  , c.[centerID] = st.[centerID]
  , c.[reasonTypeID] = st.[reasonTypeID]
  , c.[actionTypeID] = st.[actionTypeID]
  , c.[resultTypeID] = st.[resultTypeID]
  , c.[statusID] = st.[statusID]
  , c.[paid] = st.[paid]
  , c.[postHospitalDischarge] = st.[postHospitalDischarge]
  , c.[cmrDeliveryTypeID] = st.[cmrDeliveryTypeID]
  , c.[mtmServiceDT] = st.[mtmServiceDT]
  , c.[submitDT] = st.[submitDT]
  , c.[Language] = st.[Language]
  , c.[changeDate] = st.[changeDate]
-- select top 10 *
from dbo.CMRActivityClaim c WITH (NOLOCK)
join dbo.CMRActivityClaimStaging st WITH (NOLOCK) 
   on c.claimID = st.claimID
where 1  = 1

--Disabling index for CMRActivityClaim table 
--ALTER INDEX [ind_statusid] ON [dbo].[CMRActivityClaim] DISABLE

insert into dbo.CMRActivityClaim([claimID]
                                                          , [patientid]
                                                          , [policyID]
                                                          , [centerID]
                                                          , [reasonTypeID]
                                                          , [actionTypeID]
                                                          , [resultTypeID]
                                                          , [statusID]
                                                          , [paid]
                                                          , [postHospitalDischarge]
                                                          , [cmrDeliveryTypeID]
                                                          , [mtmServiceDT]
                                                          , [submitDT]
                                                          , [Language]
                                                          , [changeDate]                                                   
)
select st.[claimID]
       , st.[patientid]
       , st.[policyID]
       , st.[centerID]
       , st.[reasonTypeID]
       , st.[actionTypeID]
       , st.[resultTypeID]
       , st.[statusID]
       , st.[paid]
       , st.[postHospitalDischarge]
       , st.[cmrDeliveryTypeID]
       , st.[mtmServiceDT]
       , st.[submitDT]
       , st.[Language]
       , st.[changeDate]
from dbo.CMRActivityClaimStaging st WITH (NOLOCK)
where 1  = 1
and not exists (select 1
                           from dbo.CMRActivityClaim c
                           where 1 = 1
                           and c.claimID = st.claimID)

--Enabling index for CMRActivityClaim table 
--ALTER INDEX [ind_statusid] ON [dbo].[CMRActivityClaim] REBUILD
END



