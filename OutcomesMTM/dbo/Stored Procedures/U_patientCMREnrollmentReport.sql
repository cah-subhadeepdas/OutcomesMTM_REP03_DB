

CREATE procedure [dbo].[U_patientCMREnrollmentReport]
as
begin 
set nocount on;
set xact_abort on;

update p
set p.[clientName] = t.[clientName]
, p.[policyName] = t.[policyName]
, p.[JAN] = t.[JAN]
, p.[FEB] = t.[FEB]
, p.[MAR] = t.[MAR]
, p.[APR] = t.[APR]
, p.[MAY] = t.[MAY]
, p.[JUN] = t.[JUN]
, p.[JUL] = t.[JUL]
, p.[AUG] = t.[AUG]
, p.[SEP] = t.[SEP]
, p.[OCT] = t.[OCT]
, p.[NOV] = t.[NOV]
, p.[DEC] = t.[DEC]
, p.[total] = t.[total] 
from patientCMREnrollmentReport p 
join patientCMREnrollmentReport_staging t on t.policyid = p.policyid 
where 1=1 
and not (
          isnull(p.[clientName],'') = isnull(t.[clientName],'')
          and isnull(p.[policyName],'') = isnull(t.[policyName],'')    
          and isnull(p.[JAN],0) = isnull(t.[JAN],0)
          and isnull(p.[FEB],0) = isnull(t.[FEB],0)
          and isnull(p.[MAR],0) = isnull(t.[MAR],0)
          and isnull(p.[APR],0) = isnull(t.[APR],0)
          and isnull(p.[MAY],0) = isnull(t.[MAY],0)
          and isnull(p.[JUN],0) = isnull(t.[JUN],0)
          and isnull(p.[JUL],0) = isnull(t.[JUL],0)
          and isnull(p.[AUG],0) = isnull(t.[AUG],0)
          and isnull(p.[SEP],0) = isnull(t.[SEP],0)
          and isnull(p.[OCT],0) = isnull(t.[OCT],0)
          and isnull(p.[NOV],0) = isnull(t.[NOV],0)
          and isnull(p.[DEC],0) = isnull(t.[DEC],0)
          and isnull(p.[total],0) = isnull(t.[total],0)
)

---------

insert into patientCMREnrollmentReport (policyid
, clientName
, policyName
, [JAN] 
, [FEB] 
, [MAR] 
, [APR] 
, [MAY] 
, [JUN] 
, [JUL] 
, [AUG] 
, [SEP] 
, [OCT] 
, [NOV] 
, [DEC]
, [Total]) 
select t.policyid
, t.clientName
, t.policyName
, t.[JAN] 
, t.[FEB] 
, t.[MAR] 
, t.[APR] 
, t.[MAY] 
, t.[JUN] 
, t.[JUL] 
, t.[AUG] 
, t.[SEP] 
, t.[OCT] 
, t.[NOV] 
, t.[DEC]
, t.total 
--select COUNT(*)
from patientCMREnrollmentReport_staging t 
where 1=1 
and not exists (
    select 1 
    from patientCMREnrollmentReport p 
    where 1=1 
    and t.policyid = p.policyid 
                   
)

----------

delete p 
--select COUNT(*)
from patientCMREnrollmentReport p 
where 1=1 
and not exists (
    select 1 
    from patientCMREnrollmentReport_staging t  
    where 1=1 
    and t.policyid = p.policyid 
)                  
                   


END





