

CREATE PROCEDURE [dbo].[S_patientTipDetailReport]
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

   IF OBJECT_ID('Staging.TemporaryPatientTipDetailRank', 'U') IS NOT NULL
      BEGIN
         DROP TABLE Staging.TemporaryPatientTipDetailRank
      END

   IF OBJECT_ID('Staging.TemporaryDeLimitedPatientTipDetail', 'U') IS NOT NULL
      BEGIN
         DROP TABLE Staging.TemporaryDeLimitedPatientTipDetail
      END

   SELECT 
       tipresultid   
      ,patientid_all 
      ,First_Name
      ,last_name 
      ,DOB 
      ,primaryPharmacy
      ,pctFillatCenter 
      ,policyid 
      ,policyname 
      ,TipGenerationDT
      ,reasontypeid 
      ,reasoncode 
      ,reasonTypeDesc
      ,actionTypeID 
      ,actionCode
      ,actionNM
      ,ecaLevelID
      ,tiptitle 
      ,tiptype 
      ,NPI
      ,Primary_NCPDP_NABP
      ,Primary_PharmacyName
      ,Phone
      ,Address1
      ,Address2
      ,City
      ,State
      ,ZipCode    
      ,pharmacyCnt 
      ,PharmacyNABPList 
      ,pharmacyNameList 
      ,primaryPharmacyList  
   INTO Staging.TemporaryPatientTipDetailRank
   FROM (SELECT
	          row_number() over (partition by t.tipresultid order by newid()) AS tiprank  
            ,t.tipresultid   
	         ,pt.patientid_all 
	         ,pt.First_Name
	         ,pt.last_name 
	         ,pt.DOB 
	         ,pp.primaryPharmacy
	         ,pp.pctFillatCenter 
	         ,p.policyid 
	         ,p.policyname 
	         ,tcd.TipGenerationDT
	         ,rt.reasontypeid 
	         ,rt.reasoncode 
	         ,rt.reasonTypeDesc
	         ,at.actionTypeID 
	         ,at.actionCode
	         ,at.actionNM
	         ,td.ecaLevelID
	         ,td.tiptitle 
	         ,CASE 
                WHEN ISNULL(td.StarTip,0) = 1 
                   THEN 'STAR' 
				    WHEN ISNULL(td.StarTip,0) = 0 
                 AND rt.reasonTypeID = 2 
                   THEN 'COST'
				    ELSE 'QUALITY' 
             END AS tiptype 
	         ,ph.NPI
	         ,ph.NCPDP_NABP AS Primary_NCPDP_NABP
	         ,ph.centername AS Primary_PharmacyName
	         ,pt.Phone
	         ,pt.Address1
	         ,pt.Address2
	         ,pt.City
	         ,pt.State
	         ,pt.ZipCode    
	         ,CAST(NULL AS INT) AS pharmacyCnt 
	         ,CAST(NULL AS VARCHAR(8000)) AS PharmacyNABPList 
	         ,CAST(NULL AS VARCHAR(8000)) AS pharmacyNameList 
	         ,CAST(NULL AS VARCHAR(8000)) AS primaryPharmacyList  
         FROM (SELECT
                   trs.tipresultid 
                  ,tr.patientid 
                  ,td.tipdetailid
               FROM outcomesMTM.Staging.tipresultstatus trs WITH (NOLOCK)
                  JOIN outcomesMTM.Staging.tipresultstatuscenter trsc WITH (NOLOCK) 
                     ON trs.tipresultstatusid = trsc.tipresultstatusid
                  JOIN outcomesMTM.dbo.TIPResultDim tr WITH (NOLOCK) 
                     ON tr.tipresultid = trs.tipresultid 
                  JOIN outcomesMTM.staging.tipdetail_tip td WITH (NOLOCK) 
                     ON tr.tipdetailid = td.tipdetailid 
               WHERE 1=1 
                 AND trs.active = 1
                 AND trsc.active = 1
                 AND trs.tipstatusid = 1
               GROUP BY
                   trs.tipresultid 
                  ,tr.patientid 
                  ,td.tipdetailid

	           ) t 
            JOIN outcomesMTM.staging.tipdetail_tip td WITH (NOLOCK) 
               ON td.tipdetailid = t.tipdetailid 
            JOIN outcomesMTM.Staging.reasontype rt WITH (NOLOCK) 
               ON rt.reasonTypeID = td.reasontypeid 
	         JOIN outcomesMTM.Staging.actiontype at WITH (NOLOCK) 
               ON at.actionTypeID = td.actiontypeid 
	         JOIN outcomesMTM.dbo.patientDim pt WITH (NOLOCK) 
               ON pt.patientid = t.patientid 
              AND pt.isCurrent = 1
      	   JOIN outcomesMTM.dbo.policy p WITH (NOLOCK) 
               ON p.policyid = pt.policyid 
--           LEFT JOIN outcomesMTM.dbo.patientPrimaryPharmacyDim pp WITH (NOLOCK) 
--      	   LEFT JOIN outcomesMTM.staging.staging_patientPrimaryPharmacy pp WITH (NOLOCK) 
      	   LEFT JOIN outcomesMTM.staging.patientPrimaryPharmacy pp WITH (NOLOCK) 
               ON pp.patientid = pt.patientid 
              AND pp.primarypharmacy = 1
      	   LEFT JOIN outcomesMTM.dbo.pharmacy ph WITH (NOLOCK) 
               ON pp.centerID = ph.centerID 
			  AND ph.active = 1                                                                                                                                              
      	   LEFT JOIN (SELECT
                           trs1.tipresultID
                          ,MAX(trs1.createdate) AS TipGenerationDT 
                       FROM outcomesMTM.Staging.tipresultstatus trs1 WITH (NOLOCK) 
                       WHERE 1=1 
                         AND trs1.active = 1
                       GROUP BY trs1.tipresultID
	                   ) tcd 
               ON tcd.tipresultid = t.tipresultid 
	      WHERE 1=1 
        ) T
   WHERE 1=1 
     AND t.tiprank = 1

  CREATE CLUSTERED INDEX ind_2 ON Staging.TemporaryPatientTipDetailRank(tipresultID); 

  SELECT DISTINCT
      tr.tipresultID 
     ,LTRIM(RTRIM(replace(ph.ncpdp_nabp,',',''))) AS ncpdp_nabp 
     ,LTRIM(RTRIM(replace(ph.centername,',',''))) AS centerName
     ,CASE 
         WHEN pph.primaryPharmacy = 1 
            THEN 'Primary' 
         ELSE '' 
      END AS primaryPharmacy
     ,1 AS PharmacyCnt
   INTO Staging.TemporaryDeLimitedPatientTipDetail
   FROM outcomesMTM.Staging.tipresultstatus trs WITH (NOLOCK)
      JOIN outcomesMTM.Staging.tipresultstatuscenter trsc WITH (NOLOCK) 
         ON trs.tipresultstatusid = trsc.tipresultstatusid
      JOIN Staging.TemporaryPatientTipDetailRank t 
         ON t.tipresultid = trs.tipresultid 
      JOIN outcomesMTM.dbo.TIPResultDim tr WITH (NOLOCK) 
         ON tr.tipresultid = trs.tipresultid 
      JOIN outcomesMTM.dbo.patientDim pt WITH (NOLOCK) 
         ON pt.patientid = tr.patientid  
        AND pt.isCurrent = 1
      JOIN outcomesMTM.dbo.pharmacy ph WITH (NOLOCK) 
         ON ph.centerid = trsc.centerid 
		AND ph.active = 1
--      LEFT JOIN outcomesMTM.dbo.patientPrimaryPharmacyDim pph WITH (NOLOCK) 
--      LEFT JOIN outcomesMTM.staging.staging_patientPrimaryPharmacy pph WITH (NOLOCK) 
      LEFT JOIN outcomesMTM.staging.patientPrimaryPharmacy pph WITH (NOLOCK) 
         ON pph.patientid = pt.patientid
        AND pph.centerid = ph.centerid
        AND pph.primarypharmacy = 1
   WHERE 1=1 
     AND trs.active = 1
     AND trsc.active = 1
     AND trs.tipstatusid = 1 

   ALTER TABLE Staging.TemporaryDeLimitedPatientTipDetail ADD rowid INT identity(1,1) primary key; 
   
   CREATE NONCLUSTERED INDEX ind_2 ON Staging.TemporaryDeLimitedPatientTipDetail(tipresultID); 

   UPDATE t
      SET t.pharmacyCnt = (SELECT SUM(PharmacyCnt) 
                           FROM Staging.TemporaryDeLimitedPatientTipDetail d 
                           WHERE d.tipresultid = t.tipresultid) 
         ,t.[PharmacyNABPList] = LEFT(LTRIM(RTRIM(STUFF((
                                         SELECT ',' + d.ncpdp_nabp
                                         FROM Staging.TemporaryDeLimitedPatientTipDetail d
                                         WHERE d.tipresultid = t.tipresultid
                                         ORDER BY d.rowid
                                         FOR XML PATH(''), 
                                         TYPE).value('(./text())[1]','VARCHAR(MAX)'),1,1,''))),8000)
         ,t.[pharmacyNameList] = LEFT(LTRIM(RTRIM(STUFF((
                                         SELECT ',' + d.centerName
                                         FROM Staging.TemporaryDeLimitedPatientTipDetail d
                                         WHERE d.tipresultid = t.tipresultid
                                         ORDER BY d.rowid
                                         FOR XML PATH(''), 
                                         TYPE).value('(./text())[1]','VARCHAR(MAX)'),1,1,''))),8000)
         ,t.[primaryPharmacyList] = LEFT(LTRIM(RTRIM(STUFF((
                                         SELECT ',' + d.primaryPharmacy
                                         FROM Staging.TemporaryDeLimitedPatientTipDetail d
                                         WHERE d.tipresultid = t.tipresultid
                                         ORDER BY d.rowid
                                         FOR XML PATH(''), 
                                         TYPE).value('(./text())[1]','VARCHAR(MAX)'),1,1,''))),8000)
   FROM Staging.TemporaryPatientTipDetailRank t
   WHERE 1=1 

   SELECT
       tipresultid   
      ,patientid_all 
      ,First_Name
      ,last_name 
      ,DOB 
      ,primaryPharmacy
      ,pctFillatCenter 
      ,policyid 
      ,policyname 
      ,TipGenerationDT
      ,reasontypeid 
      ,reasoncode 
      ,reasonTypeDesc
      ,actionTypeID 
      ,actionCode
      ,actionNM
      ,ecaLevelID
      ,tiptitle 
      ,tiptype 
      ,pharmacyCnt 
      ,PharmacyNABPList 
      ,pharmacyNameList 
      ,primaryPharmacyList 
      ,NPI
      ,Primary_NCPDP_NABP
      ,Primary_PharmacyName
      ,Phone
      ,Address1
      ,Address2
      ,City
      ,State
      ,ZipCode    
   FROM Staging.TemporaryPatientTipDetailRank

END
