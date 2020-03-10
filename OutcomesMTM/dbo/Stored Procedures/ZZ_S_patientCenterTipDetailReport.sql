

CREATE PROCEDURE [dbo].[ZZ_S_patientCenterTipDetailReport]
AS
BEGIN 
   SET NOCOUNT ON;
   SET XACT_ABORT ON;

   SELECT 
       tipresultstatusid
      ,centerid  
      ,NCPDP_NABP
      ,centername 
      ,patientid_all 
      ,First_Name
      ,lASt_name 
      ,DOB 
      ,address1 
      ,address2 
      ,city 
      ,state 
      ,zipcode 
      ,phone 
      ,primarypharmacy 
      ,pctFillatCenter 
      ,pctFillatChain
      ,policyid 
      ,policyname 
      ,TipGenerationDT
      ,reASontypeid 
      ,reASoncode 
      ,reASonTypeDesc
      ,actionTypeID 
      ,actionCode
      ,actionNM
      ,ecaLevelID
      ,tiptitle 
      ,tiptype
      ,NPI
      ,Pharmacy_Address1
      ,Pharmacy_Address2
      ,Pharmacy_city
      ,Pharmacy_state
      ,Pharmacy_zip       
      ,TipExpirationDT
   FROM (SELECT 
             row_number() over (partition by trsc.tipresultstatuscenterID order by newid()) AS tiprank 
	         ,trsc.tipresultstatuscenterID AS tipresultstatusid
	         ,ph.centerid  
	         ,ph.NCPDP_NABP
	         ,ph.centername 
	         ,pt.patientid_all 
	         ,pt.First_Name
	         ,pt.lASt_name 
	         ,pt.DOB 
	         ,pt.address1 
	         ,pt.address2 
	         ,pt.city 
	         ,pt.state 
	         ,pt.zipcode 
	         ,pt.phone 
	         ,isnull(pp.primaryPharmacy,0) AS primarypharmacy 
	         ,isnull(pp.pctFillatCenter,0.00) AS pctFillatCenter 
	         ,isnull(pp.pctFillatChain,0.00) AS pctFillatChain
	         ,p.policyid 
	         ,p.policyname 
	         ,tcd.TipGenerationDT
	         ,rt.reASontypeid 
	         ,rt.reASoncode 
	         ,rt.reASonTypeDesc
	         ,at.actionTypeID 
	         ,at.actionCode
	         ,at.actionNM
	         ,td.ecaLevelID
	         ,td.tiptitle 
	         ,CASE 
                WHEN isnull(td.StarTip,0) = 1 
                   THEN 'STAR' 
				    WHEN isnull(td.StarTip,0) = 0 AND rt.reASonTypeID = 2 
                  THEN 'COST'
				    ELSE 'QUALITY' 
             END AS tiptype
	         ,ph.NPI
	         ,ph.Address1 AS Pharmacy_Address1
	         ,ph.Address2 AS Pharmacy_Address2
	         ,ph.AddressCity AS Pharmacy_city
	         ,ph.AddressState AS Pharmacy_state
	         ,ph.AddressPostalCode AS Pharmacy_zip         
   	      ,CASE 
                WHEN tdr.IsMedRecTIP = 1 
                   THEN DATEADD(d, 30, IsNull(mr.DischargeDate, getdate()))
	   		    ELSE NULL
		       END AS TipExpirationDT
	         --SELECT count(distinct trs.tipresultstatusID),count(*)  
	      FROM outcomesmtm.staging.tipresultstatus trs WITH (NOLOCK)
	         JOIN outcomesmtm.staging.tipresultstatuscenter trsc WITH (NOLOCK) 
               ON trs.tipresultstatusid = trsc.tipresultstatusid
	         JOIN outcomesmtm.dbo.tipresultdim tr WITH (NOLOCK) 
               ON tr.tipresultid = trs.tipresultid 
	         JOIN outcomesmtm.staging.tipdetail_tip td WITH (NOLOCK) 
               ON tr.tipdetailid = td.tipdetailid 
            JOIN tipdetailrule tdr with(nolock) 
               ON td.tipdetailid = tdr.tipdetailid 
              AND tdr.active = 1
	         JOIN outcomesmtm.staging.reasontype rt WITH (NOLOCK) 
               ON rt.reasonTypeID = td.reasontypeid 
	         JOIN outcomesmtm.staging.actiontype at WITH (NOLOCK) 
               ON at.actionTypeID = td.actiontypeid 
	         JOIN outcomesmtm.dbo.patientDim pt WITH (NOLOCK) 
               ON pt.patientid = tr.patientid 
              AND pt.isCurrent = 1
	         JOIN outcomesmtm.dbo.policy p WITH (NOLOCK) 
               ON p.policyid = pt.policyid 
	         JOIN outcomesmtm.dbo.pharmacy ph WITH (NOLOCK) 
               ON ph.centerid = trsc.centerid 
	         LEFT JOIN outcomesmtm.staging.patientPrimaryPharmacy pp WITH (NOLOCK) 
               ON pp.patientid = pt.patientid 
              AND pp.centerid = ph.centerid 
	         LEFT JOIN (SELECT 
                          trs1.tipresultID,max(trs1.createdate) AS TipGenerationDT 
			              FROM outcomesmtm.staging.tipresultstatus trs1 WITH (NOLOCK) 
			              WHERE 1=1 
			                AND trs1.active = 1
			              GROUP BY trs1.tipresultID
	                   ) tcd 
               ON tcd.tipresultid = trs.tipresultid 
            LEFT JOIN (SELECT 
                          patientid,
			                 Max(DischargeDate) as DischargeDate
			              FROM medRecDim with (nolock) 
			              WHERE active = 1
			              GROUP BY patientid
	                   ) mr 
               ON mr.patientid = pt.patientid 
	      WHERE 1=1 
           AND trs.active = 1
           AND trsc.active = 1
           AND trs.tipstatusid = 1
        ) T
   WHERE 1=1 
     AND t.tiprank = 1

END 
