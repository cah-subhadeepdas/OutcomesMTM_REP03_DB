CREATE   PROCEDURE [dbo].[S_ClientManagerReport]
AS
   BEGIN
      SET NOCOUNT ON;
      SET XACT_ABORT ON;

--*********************************
--***   PREPARE lookup tables   ***
--*********************************

      --Adherence Barrier Lookup Table
      TRUNCATE TABLE staging.ClientManagerReportAB_DeleteWhenDone

      INSERT INTO staging.ClientManagerReportAB_DeleteWhenDone (claimid, adherenceBarrierTypeID, adherenceActionTypeNM)
      SELECT
          claimid
         ,adherenceBarrierTypeID
         ,left(STUFF((SELECT ',' + LTRIM(RTRIM(aat.adherenceActionTypeNM))
                      FROM staging.adherenceActionType aat WITH (NOLOCK)
                         JOIN staging.adherenceBarrier ab WITH (NOLOCK)
                            ON ab.adherenceActionTypeID = aat.adherenceActionTypeID
                      WHERE ab.adherenceBarrierTypeID = t.adherenceBarrierTypeID
                        AND ab.claimID= t.claimID
                      FOR XML PATH(''),TYPE).value('(./text())[1]','varchar(400)'),1,1,''),400) AS [adherenceActionTypeNM]
      FROM (SELECT
                row_number() over (partition by ab.claimid, ab.adherenceBarrierTypeID
                                   order by ab.adherencebarrierid) AS abrow
               ,ab.claimid
               ,ab.adherenceBarrierTypeID
               ,LTRIM(RTRIM(aat.adherenceActionTypeNM)) AS adherenceActionTypeNM
            FROM staging.adherenceActionType aat WITH (NOLOCK)
               JOIN staging.adherenceBarrier ab WITH (NOLOCK)
                  ON ab.adherenceActionTypeID = aat.adherenceActionTypeID
            WHERE 1=1
           ) t
      WHERE 1=1
        AND t.abrow = 1

      ------------------------------------------------

      ;WITH [claim] AS (SELECT
                            claimRow
                           ,claimid
                           ,policyid
                           ,policyNM
                           ,mtmserviceDT
                           ,[status]
                           ,patientid
                           ,MemberID
                           ,MemberFirstNM
                           ,MemberlastNM
                           ,MemberDOB
                           ,MemberGender
                           ,MemberPhone
                           ,[memberCMSContractNumber]
                           ,[memberPBP]
                           ,centerid
                           ,PharmacyNABP
                           ,PharmacyName
                           ,carrier
                           ,account
                           ,[group]
                           ,PharmacyState
                           ,pharmacistUserID
                           ,pharmacistFirstNM
                           ,pharmacistlastNM
                           ,reasontypeid
                           ,[reason]
                           ,[reasonNM]
                           ,actiontypeid
                           ,[action]
                           ,[actionNM]
                           ,resulttypeid
                           ,[result]
                           ,[resultNM]
                           ,ecalevelid
                           ,[serveritylevel]
                           ,[serveritylevelNM]
                           ,estimated_cost
                           ,AIM
                           ,charges
                           ,face2face
                           ,claimFROMcmr
                           ,isTipClaim
                           ,tipResultID
                           ,tipdetailid
                           ,tiptitle
                           ,currentMedRxNumber
                           ,currentMedMetricQuantity
                           ,currentMedDaysSupply
                           ,currentMedGpi
                           ,currentMedName
                           ,newMedRxNumber
                           ,newMedMetricQuantity
                           ,newMedDaysSupply
                           ,newMedGpi
                           ,newMedName
                           ,refillpickedup
                           ,[memberRefusalDesc]
                           ,[prescriberRefusalDesc]
                           ,paiddate
                           ,lastupdatedt
                           ,documentationUserID
                           ,documentationFirstNM
                           ,documentationLastNM
                           ,documentationRole
                           ,pctfillatCenter
                           ,pctfillatChain
                           ,primarypharmacy
                           ,validated
                           ,claimValidationProcessed
                           ,claimValidationPaymentProcessed
                           ,claimValidationFee
                           ,healthTestValue
                           ,PCPName
                           ,pregTestResult
                           ,isLegacyServiceTypeClaim
                           ,isEssentialServiceTypeClaim
                           ,isStarServiceTypeClaim
                           ,isMedRecServiceTypeClaim
                           ,currentMedPrescriber
                           ,currentPrescriberNPI
                           ,timeToComplete
                           ,username
                           ,invoiceStatusTypeID
                           ,invoiceStatusTypeNM
                           ,invoiceStatusDT
                           ,pharmacistid
                           ,cmrDeliveryTypeID
                           ,createDT
                           ,changedate
                           ,conditionNM
                           ,plannedMedSyncDT
                           ,labNM
                           ,currentMedName2
                           ,currentMedGpi2
                           ,currentMedRxNumber2
                           ,currentMedMetricQuantity2
                           ,currentMedDaysSupply2
                           ,currentMedPrescriber2
                           ,currentPrescriberNPI2
                           ,StatusDT
                           ,submitDT
                        FROM (SELECT
                                  row_number() over (partition by c.claimid order by c.createdt) AS claimRow
                                 ,c.claimid
                                 ,po.policyid
                                 ,po.policyname AS policyNM
                                 ,c.mtmserviceDT
                                 ,CASE
                                     WHEN UPPER(s.statusnm) = 'APPROVED'
                                      AND c.paid = 1
                                        THEN 'Approved - Paid'
                                     WHEN UPPER(s.statusnm) = 'APPROVED'
                                      AND ISNULL(c.paid,0) = 0
                                        THEN 'Approved - Not Paid'
                                     ELSE s.statusNM
                                  END AS [status]
                                 ,pt.patientid
                                 ,pt.patientid_all AS MemberID
                                 ,pt.First_Name AS MemberFirstNM
                                 ,pt.last_name AS MemberlastNM
                                 ,cast(pt.dob AS date) AS MemberDOB
                                 ,pt.gender AS MemberGender
                                 ,pt.phone AS MemberPhone
                                 ,pt.CMSContractNumber AS [memberCMSContractNumber]
                                 ,pt.pbp AS [memberPBP]
                                 ,c.centerid
                                 ,ph.ncpdp_nabp AS PharmacyNABP
                                 ,ph.centername AS PharmacyName
                                 ,ptAdd.CarrierID as [carrier]
                                 ,ptAdd.AccountID as [account]
                                 ,ptAdd.GroupID as [group]
                                 ,ph.[AddressState] AS PharmacyState
                                 ,con.userid AS pharmacistUserID
                                 ,con.firstnm AS pharmacistFirstNM
                                 ,con.lastnm AS pharmacistlastNM
                                 ,rt.reasontypeid
                                 ,rt.reasoncode AS [reason]
                                 ,rt.reasontypedesc AS [reasonNM]
                                 ,at.actiontypeid
                                 ,at.actionCode AS [action]
                                 ,at.actionNM AS [actionNM]
                                 ,rst.resulttypeid
                                 ,rst.resultCode AS [result]
                                 ,rst.resultDesc AS [resultNM]
                                 ,el.ecalevelid
                                 ,el.ecaLevel AS [serveritylevel]
                                 ,el.ecaDesc AS [serveritylevelNM]
                                 ,c.estimated_cost
                                 ,c.AIM
                                 ,c.charges
                                 ,c.cmrFace2Face AS face2face
                                 ,c.claimFROMcmr
                                 ,c.isTipClaim
                                 ,c.tipResultID
                                 ,td.tipdetailid
                                 ,td.tiptitle
                                 ,c.currentMedRxNumber
                                 ,c.currentMedMetricQuantity
                                 ,c.currentMedDaysSupply
                                 ,c.currentMedGpi
                                 ,c.currentMedName
                                 ,c.newMedRxNumber
                                 ,c.newMedMetricQuantity
                                 ,c.newMedDaysSupply
                                 ,c.newMedGpi
                                 ,c.newMedName
                                 ,c.refillpickedup
                                 ,COALESCE(c.patRefusalReason, patRef.patRefusalDesc) AS [memberRefusalDesc]
                                 ,COALESCE(c.presRefusalReason, presRef.presRefusalDesc) AS [prescriberRefusalDesc]
                                 ,c.paiddate
                                 ,COALESCE(c.changeDate, c.submitDt) as lastupdatedt
                                 --,cStd.StatusDT AS lastupdatedt
                                 ,con1.userid AS documentationUserID
                                 ,con1.firstnm AS documentationFirstNM
                                 ,con1.lastnm AS documentationLastNM
                                 ,con1ur.roleTypeDesc AS documentationRole
                                 ,ISNULL(pph.pctfillatCenter,0.00) AS pctfillatCenter
                                 ,ISNULL(pph.pctfillatChain,0.00) AS pctfillatChain
                                 ,CASE WHEN pph.primarypharmacy = 1 THEN 'Yes' ELSE 'No' END AS primarypharmacy
                                 ,cv.validated AS validated
                                 ,cv.processed AS claimValidationProcessed
                                 ,cvp.processed AS claimValidationPaymentProcessed
                                 ,cvp.payment AS claimValidationFee
                                 ,c.healthTestValue
                                 ,c.PCPName
                                 ,c.pregTestResult
                                 ,CASE
                                     WHEN ISNULL(ls.claimServiceTypeID, 0) > 0
                                        THEN 1
                                     ELSE 0
                                  END AS isLegacyServiceTypeClaim
                                 ,CASE
                                     WHEN ISNULL(es.claimServiceTypeID, 0) > 0
                                        THEN 1
                                     ELSE 0
                                  END AS isEssentialServiceTypeClaim
                                 ,CASE
                                     WHEN ISNULL(ss.claimServiceTypeID, 0) > 0
                                        THEN 1
                                     ELSE 0
                                  END AS isStarServiceTypeClaim
                                 ,CASE
                                     WHEN ISNULL(ms.claimServiceTypeID, 0) > 0
                                        THEN 1
                                     ELSE 0
                                  END as isMedRecServiceTypeClaim
                                 ,c.currentMedPrescriber
                                 ,c.currentPrescriberNPI
                                 ,c.timeToComplete
                                 ,u.username
                                 ,ist.invoiceStatusTypeID
                                 ,ist.invoiceStatusTypeNM
                                 ,ics.createDT AS invoiceStatusDT
                                 ,c.pharmacistid
                                 ,c.cmrDeliveryTypeID
                                 ,c.createDT
                                 ,c.changeDate
                                 ,co.conditionNM
                                 ,c.initialConsultDT AS plannedMedSyncDT
                                 ,l.labNM
                                 ,c.currentMedName2
                                 ,c.currentMedGpi2
                                 ,c.currentMedRxNumber2
                                 ,c.currentMedMetricQuantity2
                                 ,c.currentMedDaysSupply2
                                 ,c.currentMedPrescriber2
                                 ,c.currentPrescriberNPI2
                                 ,COALESCE(c.changeDate, c.submitDT) as StatusDt
                                 ,c.submitDT
                              --select count(*)
                              FROM dbo.claim c WITH (NOLOCK)
                                 --------------------------OUTER JOINs----------------------------------
                                 JOIN dbo.pharmacy ph WITH (NOLOCK)
                                    ON ph.centerid = c.centerid
                                 JOIN dbo.patientDim pt WITH (NOLOCK)
                                    ON pt.patientid = c.patientid
                                   AND pt.isCurrent = 1
                                 JOIN dbo.policy po WITH (NOLOCK)
                                    ON po.policyid = COALESCE(c.policyID, pt.policyid)
                                 JOIN staging.status s
                                    ON s.statusID = c.statusID
                                 ----------------------------LEFT JOINs----------------------------------
                                 LEFT JOIN staging.role r WITH (NOLOCK)
                                    ON r.roleID = c.documentationRoleID
                                 LEFT JOIN staging.contact con WITH (NOLOCK)
                                    ON con.userid = c.pharmacistid
                                 LEFT JOIN staging.contact con1 WITH (NOLOCK)
                                    ON con1.userid = r.userID
                                 LEFT JOIN staging.roletype con1ur WITH (NOLOCK)
                                    ON con1ur.roletypeid = r.roletypeid
                                 LEFT JOIN staging.reasontype rt WITH (NOLOCK)
                                    ON rt.reasontypeid = c.reasontypeid
                                 LEFT JOIN staging.actiontype at WITH (NOLOCK)
                                    ON at.actiontypeid = c.actiontypeid
                                 LEFT JOIN staging.resulttype rst WITH (NOLOCK)
                                    ON rst.resulttypeid = c.resulttypeid
                                 LEFT JOIN staging.ECALevel el WITH (NOLOCK)
                                    ON el.ecaLevelID = c.ecaLevelID
                                 LEFT JOIN staging.presRefusal presRef WITH (NOLOCK)
                                    ON presRef.presRefusalID = c.presRefusalID
                                 LEFT JOIN staging.patRefusal patRef WITH (NOLOCK)
                                    ON patRef.patRefusalID = c.patrefusalID
                                 LEFT JOIN staging.patientPrimaryPharmacy pph
                                    ON pt.patientid = pph.patientid
                                   AND c.centerid = pph.centerid
                                 LEFT JOIN staging.claimvalidation cv WITH (NOLOCK)
                                    ON cv.claimid = c.claimid
                                   AND cv.payable = 1
                                   AND cv.active = 1
                                 LEFT JOIN staging.claimvalidationpayment cvp WITH (NOLOCK)
                                    ON cvp.claimvalidationid = cv.claimvalidationid
                                   AND cvp.validationPaymentStatusid = 1
                                   AND cvp.active = 1
                                 LEFT JOIN staging.claimServiceType ls with(nolock)
                                    ON c.claimID = ls.claimID
                                   AND ls.active = 1
                                   AND ls.serviceTypeID = 1
                                 LEFT JOIN staging.claimServiceType es with(nolock)
                                    ON c.claimID = es.claimID
                                   AND es.active = 1
                                   AND es.serviceTypeID = 2
                                 LEFT JOIN staging.claimServiceType ss with(nolock)
                                    ON c.claimID = ss.claimID
                                   AND ss.active = 1
                                   AND ss.serviceTypeID = 3
                                 LEFT JOIN staging.claimServiceType ms with(nolock)
                                    ON c.claimID = ms.claimID
                                   AND ms.active = 1
                                   AND ms.serviceTypeID = 4
                                 LEFT JOIN staging.invoiceClaimStatus ics with(nolock)
                                    ON c.claimID = ics.claimID and ics.active = 1
                                 LEFT JOIN staging.invoiceStatusType ist with(nolock)
                                    ON ics.invoiceStatusTypeID = ist.invoiceStatusTypeID
                                 LEFT JOIN staging.users u
                                    ON c.pharmacistid = u.userID
                                 LEFT JOIN staging.TIPDetail_tip td
                                    ON td.tipdetailid = c.tipDetailID
                                   AND c.tipresultid is not null
                                 LEFT JOIN staging.conditions co
                                    ON co.conditionid = c.condition
                                 LEFT JOIN staging.lab l
                                    ON l.labID = c.labID
                                 LEFT JOIN (SELECT
                                    pai.PatientID,
                                    XC.value('(CARRIERID)[1]', 'varchar(50)') AS CarrierID,
                                    XC.value('(ACCOUNTID)[1]', 'varchar(50)') AS AccountID,
                                    XC.value('(GROUPID)[1]', 'varchar(50)') AS GroupID
                                    FROM outcomes.dbo.patientAdditionalInfo pai
                                    OUTER APPLY additionalinfoxml.nodes('/') AS XT(XC)
                                    WHERE 1=1
                                 ) AS ptAdd ON ptAdd.patientid = pt.patientid
                              WHERE 1=1
                                AND c.statusID <> 3
                             ) t
                        WHERE 1=1
                          AND t.claimRow = 1
                       )

      SELECT
          wc.claimid
         ,wc.policyid
         ,wc.policyNM
         ,wc.mtmserviceDT
         ,wc.[status]
         ,wc.patientid
         ,wc.MemberID
         ,wc.MemberFirstNM
         ,wc.MemberlastNM
         ,wc.MemberDOB
         ,wc.MemberGender
         ,wc.MemberPhone
         ,wc.[memberCMSContractNumber]
         ,wc.[memberPBP]
         ,wc.centerid
         ,wc.PharmacyNABP
         ,wc.PharmacyName
         ,wc.carrier
         ,wc.account
         ,wc.[group]
         ,wc.PharmacyState
         ,wc.pharmacistUserID
         ,wc.pharmacistFirstNM
         ,wc.pharmacistlastNM
         ,wc.reasontypeid
         ,wc.[reason]
         ,wc.[reasonNM]
         ,wc.actiontypeid
         ,wc.[action]
         ,wc.[actionNM]
         ,wc.resulttypeid
         ,wc.[result]
         ,wc.[resultNM]
         ,wc.ecalevelid
         ,wc.[serveritylevel]
         ,wc.[serveritylevelNM]
         ,wc.estimated_cost
         ,wc.AIM
         ,wc.charges
         ,wc.face2face
         ,wc.claimFROMcmr
         ,wc.isTipClaim
         ,wc.tipResultID
         ,wc.tipdetailid
         ,wc.tiptitle
         ,wc.currentMedRxNumber
         ,wc.currentMedMetricQuantity
         ,wc.currentMedDaysSupply
         ,wc.currentMedGpi
         ,wc.currentMedName
         ,wc.newMedRxNumber
         ,wc.newMedMetricQuantity
         ,wc.newMedDaysSupply
         ,wc.newMedGpi
         ,wc.newMedName
         ,wc.refillpickedup
         ,wc.[memberRefusalDesc]
         ,wc.[prescriberRefusalDesc]
         ,wc.paiddate
         ,wc.lastupdatedt
         ,wc.documentationUserID
         ,wc.documentationFirstNM
         ,wc.documentationLastNM
         ,wc.documentationRole
         ,wc.pctfillatCenter
         ,wc.pctfillatChain
         ,wc.primarypharmacy
         ,wc.validated
         ,wc.claimValidationProcessed
         ,wc.claimValidationPaymentProcessed
         ,wc.claimValidationFee
         ,wc.healthTestValue
         ,wc.PCPName
         ,wc.pregTestResult
         ,wc.isLegacyServiceTypeClaim
         ,wc.isEssentialServiceTypeClaim
         ,wc.isStarServiceTypeClaim
         ,wc.isMedRecServiceTypeClaim
         ,wc.currentMedPrescriber
         ,wc.currentPrescriberNPI
         ,wc.timeToComplete
         ,wc.username
         ,wc.invoiceStatusTypeID
         ,wc.invoiceStatusTypeNM
         ,wc.invoiceStatusDT
         ,n2.Note AS ECAexplanation
         ,n3.note AS additionalnotes
         ,ISNULL(n1.numberOfNotes,0) AS numberOfNotes
         ,cast(trs.createdate AS date) AS tipidentificationdate
         ,COALESCE(ul.licenseNumber   ,ul1.licenseNumber) AS PharmacistlicenseNumber
         ,ab1.adherenceActionTypeNM AS [Adherence - Too many medications or doses per day]
         ,ab2.adherenceActionTypeNM AS [Adherence - Forgets to take ON routine days]
         ,ab3.adherenceActionTypeNM AS [Adherence - Forgets to take ON non-routine days]
         ,ab4.adherenceActionTypeNM AS [Feels medication is not helping]
         ,ab5.adherenceActionTypeNM AS [Feels medication is not needed]
         ,ab6.adherenceActionTypeNM AS [Experienced side effects]
         ,ab7.adherenceActionTypeNM AS [Concerned about potential side effects]
         ,ab8.adherenceActionTypeNM AS [Medication cost is too high]
         ,ab9.adherenceActionTypeNM AS [Decreased cognitive function]
         ,ab10.adherenceActionTypeNM AS [Limitations ON activities of daily living]
         ,ab11.adherenceActionTypeNM AS [Transportation limitations prevent pharmacy access]
         ,ab12.adherenceActionTypeNM AS [Patient taking differently than written directions]
         ,ab13.adherenceActionTypeNM AS [Refill request delay]
         ,ab14.adherenceActionTypeNM AS [No barrier identified]
         ,ab15.adherenceActionTypeNM AS [Pharmacy error in directions/delivery/medication]
         ,ab16.adherenceActionTypeNM AS [Forgets to take]
         ,ab17.adherenceActionTypeNM AS [Unsure how to use medication]
         ,ab18.adherenceActionTypeNM AS [Unable to swallow or administer]
         ,ab19.adherenceActionTypeNM AS [Believes to be adherent]
         ,ab20.adherenceActionTypeNM AS [Patient has no concerns or barriers]
         ,wc.cmrDeliveryTypeID
         ,wc.createDT
         ,wc.changeDate
         ,wc.conditionNm
         ,wc.plannedMedSyncDT
         ,wc.labNM
         ,wc.currentMedName2
         ,wc.currentMedGpi2
         ,wc.currentMedRxNumber2
         ,wc.currentMedMetricQuantity2
         ,wc.currentMedDaysSupply2
         ,wc.currentMedPrescriber2
         ,wc.currentPrescriberNPI2
         ,wc.submitDT
         ,wc.StatusDT
      FROM claim wc
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab1
            ON ab1.claimid = wc.claimid
           AND ab1.adherenceBarrierTypeID = 1
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab2
            ON ab2.claimid = wc.claimid
           AND ab2.adherenceBarrierTypeID = 2
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab3
            ON ab3.claimid = wc.claimid
           AND ab3.adherenceBarrierTypeID = 3
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab4
            ON ab4.claimid = wc.claimid
           AND ab4.adherenceBarrierTypeID = 4
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab5
            ON ab5.claimid = wc.claimid
           AND ab5.adherenceBarrierTypeID = 5
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab6
            ON ab6.claimid = wc.claimid
           AND ab6.adherenceBarrierTypeID = 6
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab7
            ON ab7.claimid = wc.claimid
           AND ab7.adherenceBarrierTypeID = 7
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab8
            ON ab8.claimid = wc.claimid
           AND ab8.adherenceBarrierTypeID = 8
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab9
            ON ab9.claimid = wc.claimid
           AND ab9.adherenceBarrierTypeID = 9
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab10
            ON ab10.claimid = wc.claimid
           AND ab10.adherenceBarrierTypeID = 10
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab11
            ON ab11.claimid = wc.claimid
           AND ab11.adherenceBarrierTypeID = 11
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab12
            ON ab12.claimid = wc.claimid
           AND ab12.adherenceBarrierTypeID = 12
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab13
            ON ab13.claimid = wc.claimid
           AND ab13.adherenceBarrierTypeID = 13
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab14
            ON ab14.claimid = wc.claimid
           AND ab14.adherenceBarrierTypeID = 14
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab15
            ON ab15.claimid = wc.claimid
           AND ab15.adherenceBarrierTypeID = 15
         LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab16
           ON ab15.claimid = wc.claimid
           AND ab15.adherenceBarrierTypeID = 16
           LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab17
           ON ab15.claimid = wc.claimid
           AND ab15.adherenceBarrierTypeID = 17
           LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab18
           ON ab15.claimid = wc.claimid
           AND ab15.adherenceBarrierTypeID = 18
           LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab19
           ON ab15.claimid = wc.claimid
           AND ab15.adherenceBarrierTypeID = 19
           LEFT JOIN staging.ClientManagerReportAB_DeleteWhenDone ab20
           ON ab15.claimid = wc.claimid
           AND ab15.adherenceBarrierTypeID = 20

           LEFT JOIN dbo.claimnote n2 WITH (NOLOCK)
            ON n2.claimid = wc.claimid
           AND n2.notetypeid = 2
           AND n2.active = 1
         LEFT JOIN dbo.claimnote n3 WITH (NOLOCK)
            ON n3.claimid = wc.claimid
           AND n3.notetypeid = 3
           AND n3.active = 1
         LEFT JOIN (SELECT
                        claimid
                       ,COUNT(*) AS numberOfNotes
                    FROM dbo.claimnote n
                    WHERE 1=1
                      AND n.active = 1
                      AND n.notetypeid = 1
                    GROUP BY n.claimid
                     ) n1
            ON n1.claimid = wc.claimid
         LEFT JOIN staging.tipresultstatus trs WITH (NOLOCK) on trs.claimId = wc.claimId
         LEFT JOIN (SELECT
                        t.userlicenseID
                       ,t.userid
                       ,t.licenseNumber
                       ,t.stateAbbr
                    FROM (SELECT
                              rank() over (partition by ul.userid, s.stateid
                                           order by ul.userlicenseID desc) AS [rank]
                             ,ul.userlicenseID
                             ,ul.userid
                             ,ul.licenseNumber
                             ,s.stateAbbr
                          FROM staging.userLicense ul WITH (NOLOCK)
                             JOIN staging.states s
                                ON s.stateID = ul.stateID
                          WHERE 1=1
                            AND ul.licensetypeid = 1
                         ) t
                    WHERE 1=1
                      AND t.[rank] = 1
                   ) ul
            ON ul.userID = wc.pharmacistid
           AND ul.stateAbbr = wc.PharmacyState
         LEFT JOIN (SELECT
                        t.userlicenseID
                       ,t.userid
                       ,t.licenseNumber
                       ,t.stateAbbr
                    FROM (SELECT
                              rank() over (partition by ul.userid
                                           order by ul.userlicenseID desc) AS [rank]
                             ,ul.userlicenseID
                             ,ul.userid
                             ,ul.licenseNumber
                             ,s.stateAbbr
                          FROM staging.userLicense ul WITH (NOLOCK)
                             JOIN staging.states s
                                ON s.stateID = ul.stateID
                          WHERE 1=1
                            AND ul.licensetypeid = 1
                         ) t
                    WHERE 1=1
                      AND t.[rank] = 1
                   ) ul1
            ON ul1.userID = wc.pharmacistid

   END


