

CREATE procedure [dbo].[S_patientCMREnrollmentReport]
AS
BEGIN 
   SET NOCOUNT ON;
   SET XACT_ABORT ON;

   SELECT 
       t.policyid
      ,p.policyName
      ,cl.clientName
      ,SUM(CASE WHEN t.[month] = '01' THEN 1 ELSE 0 END) AS [JAN]
      ,SUM(CASE WHEN t.[month] = '02' THEN 1 ELSE 0 END) AS [FEB]
      ,SUM(CASE WHEN t.[month] = '03' THEN 1 ELSE 0 END) AS [MAR]
      ,SUM(CASE WHEN t.[month] = '04' THEN 1 ELSE 0 END) AS [APR]
      ,SUM(CASE WHEN t.[month] = '05' THEN 1 ELSE 0 END) AS [MAY]
      ,SUM(CASE WHEN t.[month] = '06' THEN 1 ELSE 0 END) AS [JUN]
      ,SUM(CASE WHEN t.[month] = '07' THEN 1 ELSE 0 END) AS [JUL]
      ,SUM(CASE WHEN t.[month] = '08' THEN 1 ELSE 0 END) AS [AUG]
      ,SUM(CASE WHEN t.[month] = '09' THEN 1 ELSE 0 END) AS [SEP]
      ,SUM(CASE WHEN t.[month] = '10' THEN 1 ELSE 0 END) AS [OCT]
      ,SUM(CASE WHEN t.[month] = '11' THEN 1 ELSE 0 END) AS [NOV]
      ,SUM(CASE WHEN t.[month] = '12' THEN 1 ELSE 0 END) AS [DEC]
      ,count(*) AS total 
   FROM (SELECT 
            e.patientid
           ,e.policyid
           ,substring(replace(cast(cast(e.createDT AS date) AS varchar),'-',''),5,2) AS [month] 
         FROM outcomesMTM.dbo.patientCMREnrollment e 
         WHERE 1=1 
           AND year(e.createDT) = year(getdate())
        ) T
   JOIN outcomesMTM.dbo.policy p WITH (NOLOCK) 
      ON p.policyid = t.policyid
   JOIN outcomesMTM.dbo.contract co WITH (NOLOCK) 
      ON co.contractid = p.contractid
   JOIN outcomesMTM.dbo.client cl WITH (NOLOCK) 
      ON cl.clientid = co.clientid
   WHERE 1=1 
   GROUP BY t.policyid , p.policyName, cl.clientName

END 
