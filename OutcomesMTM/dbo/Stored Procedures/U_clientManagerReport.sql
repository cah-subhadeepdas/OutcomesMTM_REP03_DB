CREATE proc [dbo].[U_clientManagerReport]
as
  begin
    set nocount on;
    set xact_abort on;


    --drop table #tempupdate
    create table #tempupdate (
        id int identity(1,1) primary key
      , claimid int
    )

    insert into #tempupdate with (tablock) (claimid)
    select p.claimid
    from clientManagerReport p
           join clientManagerReport_staging t on t.claimid = p.claimid
    where 1=1
      and not (
        isnull(p.policyid,0) = isnull(t.policyid,0)
          and isnull(p.policyNM,'') = isnull(t.policyNM,'')
          and isnull(p.mtmserviceDT,'19000101') = isnull(t.mtmserviceDT,'19000101')
          and isnull(p.[status],'') = isnull(t.[status],'')
          and isnull(p.patientid,0) = isnull(t.patientid,0)
          and isnull(p.MemberID,'') = isnull(t.MemberID,'')
          and isnull(p.MemberFirstNM,'') = isnull(t.MemberFirstNM,'')
          and isnull(p.MemberlastNM,'') = isnull(t.MemberlastNM,'')
          and isnull(p.MemberDOB,'19000101') = isnull(t.MemberDOB,'19000101')
          and isnull(p.MemberGender,'') = isnull(t.MemberGender,'')
          and isnull(p.MemberPhone,'') = isnull(t.MemberPhone,'')
          and isnull(p.memberCMSContractNumber,'') = isnull(t.memberCMSContractNumber,'')
          and isnull(p.memberPBP,'') = isnull(t.memberPBP,'')
          and isnull(p.centerid,0) = isnull(t.centerid,0)
          and isnull(p.PharmacyNABP,'') = isnull(t.PharmacyNABP,'')
          and isnull(p.PharmacyName,'') = isnull(t.PharmacyName,'')
          and isnull(p.carrier,'') = isnull(t.carrier,'')
          and isnull(p.account,'') = isnull(t.account,'')
          and isnull(p.[group],'') = isnull(t.[group],'')
          and isnull(p.PharmacyState,'') = isnull(t.PharmacyState,'')
          and isnull(p.pharmacistUserID,0) = isnull(t.pharmacistUserID,0)
          and isnull(p.pharmacistFirstNM,'') = isnull(t.pharmacistFirstNM,'')
          and isnull(p.pharmacistlastNM,'') = isnull(t.pharmacistlastNM,'')
          and isnull(p.PharmacistlicenseNumber,'') = isnull(t.PharmacistlicenseNumber,'')
          and isnull(p.reasonTypeID,0) = isnull(t.reasonTypeID,0)
          and isnull(p.reason,0) = isnull(t.reason,0)
          and isnull(p.reasonNM,'') = isnull(t.reasonNM,'')
          and isnull(p.actiontypeid,0) = isnull(t.actiontypeid,0)
          and isnull(p.[action],0) = isnull(t.[action],0)
          and isnull(p.actionNM,'') = isnull(t.actionNM,'')
          and isnull(p.resulttypeid,0) = isnull(t.resulttypeid,0)
          and isnull(p.[result],0) = isnull(t.[result],0)
          and isnull(p.resultNM,'') = isnull(t.resultNM,'')
          and isnull(p.ecalevelid,0) = isnull(t.ecalevelid,0)
          and isnull(p.serveritylevel,0) = isnull(t.serveritylevel,0)
          and isnull(p.serveritylevelNM,'') = isnull(t.serveritylevelNM,'')
          and isnull(p.estimated_cost,0) = isnull(t.estimated_cost,0)
          and isnull(p.AIM,0) = isnull(t.AIM,0)
          and isnull(p.charges,0) = isnull(t.charges,0)
          and isnull(cast(p.ECAexplanation as varchar(8000)),'') = isnull(cast(t.ECAexplanation as varchar(8000)),'')
          and isnull(cast(p.additionalnotes as varchar(8000)),'') = isnull(cast(t.additionalnotes as varchar(8000)),'')
          and isnull(p.face2face,0) = isnull(t.face2face,0)
          and isnull(p.claimfromcmr,0) = isnull(t.claimfromcmr,0)
          and isnull(p.isTipClaim,0) = isnull(t.isTipClaim,0)
          and isnull(p.tipResultID,0) = isnull(t.tipResultID,0)
          and isnull(p.tiptitle,'') = isnull(t.tiptitle,'')
          and isnull(p.tipidentificationdate,'19000101') = isnull(t.tipidentificationdate,'19000101')
          and isnull(p.currentMedRxNumber,'') = isnull(t.currentMedRxNumber,'')
          and isnull(p.currentMedMetricQuantity,0) = isnull(t.currentMedMetricQuantity,0)
          and isnull(p.currentMedDaysSupply,0) = isnull(t.currentMedDaysSupply,0)
          and isnull(p.currentMedGpi,'') = isnull(t.currentMedGpi,'')
          and isnull(p.currentMedName,'') = isnull(t.currentMedName,'')
          and isnull(p.newMedRxNumber,'') = isnull(t.newMedRxNumber,'')
          and isnull(p.newMedMetricQuantity,0) = isnull(t.newMedMetricQuantity,0)
          and isnull(p.newMedDaysSupply,0) = isnull(t.newMedDaysSupply,0)
          and isnull(p.newMedGpi,'') = isnull(t.newMedGpi,'')
          and isnull(p.newMedName,'') = isnull(t.newMedName,'')
          and isnull(p.[Adherence - Too many medications or doses per day],'') = isnull(t.[Adherence - Too many medications or doses per day],'')
          and isnull(p.[Adherence - Forgets to take on routine days],'') = isnull(t.[Adherence - Forgets to take on routine days],'')
          and isnull(p.[Adherence - Forgets to take on non-routine days],'') = isnull(t.[Adherence - Forgets to take on non-routine days],'')
          and isnull(p.[Feels medication is not helping],'') = isnull(t.[Feels medication is not helping],'')
          and isnull(p.[Feels medication is not needed],'') = isnull(t.[Feels medication is not needed],'')
          and isnull(p.[Experienced side effects],'') = isnull(t.[Experienced side effects],'')
          and isnull(p.[Concerned about potential side effects],'') = isnull(t.[Concerned about potential side effects],'')
          and isnull(p.[Medication cost is too high],'') = isnull(t.[Medication cost is too high],'')
          and isnull(p.[Decreased cognitive function],'') = isnull(t.[Decreased cognitive function],'')
          and isnull(p.[Limitations on activities of daily living],'') = isnull(t.[Limitations on activities of daily living],'')
          and isnull(p.[Transportation limitations prevent pharmacy access],'') = isnull(t.[Transportation limitations prevent pharmacy access],'')
          and isnull(p.[Patient taking differently than written directions],'') = isnull(t.[Patient taking differently than written directions],'')
          and isnull(p.[Refill request delay],'') = isnull(t.[Refill request delay],'')
          and isnull(p.[No barrier identified],'') = isnull(t.[No barrier identified],'')
          and isnull(p.[Pharmacy error in directions/delivery/medication],'') = isnull(t.[Pharmacy error in directions/delivery/medication],'')
          and isnull(p.[Forgets to take],'') = isnull(t.[Forgets to take],'')
          and isnull(p.[Unsure how to use medication],'') = isnull(t.[Unsure how to use medication],'')
          and isnull(p.[Unable to swallow or administer],'') = isnull(t.[Unable to swallow or administer],'')
          and isnull(p.[Believes to be adherent],'') = isnull(t.[Believes to be adherent],'')
          and isnull(p.[Patient has no concerns or barriers],'') = isnull(t.[Patient has no concerns or barriers],'')
          and isnull(p.refillpickedup,'') = isnull(t.refillpickedup,'')
          and isnull(p.[memberRefusalDesc],'') = isnull(t.[memberRefusalDesc],'')
          and isnull(p.[prescriberRefusalDesc],'') = isnull(t.[prescriberRefusalDesc],'')
          and isnull(p.paiddate,'19000101') = isnull(t.paiddate,'19000101')
          and isnull(p.claimSubmitDT,'19000101') = isnull(t.claimSubmitDT,'19000101')
          and isnull(p.lastupdatedt,'19000101') = isnull(t.lastupdatedt,'19000101')
          and isnull(p.documentationUserID,0) = isnull(t.documentationUserID,0)
          and isnull(p.documentationFirstNM,'') = isnull(t.documentationFirstNM,'')
          and isnull(p.documentationLastNM,'') = isnull(t.documentationLastNM,'')
          and isnull(p.documentationRole,'') = isnull(t.documentationRole,'')
          and isnull(p.pctfillatCenter,0)  = isnull(t.pctfillatCenter,0)
          and isnull(p.pctfillatChain,0)  = isnull(t.pctfillatChain,0)
          and isnull(p.primarypharmacy,'') = isnull(t.primarypharmacy,'')
          and isnull(p.validated,0) = isnull(t.validated,0)
          and isnull(p.claimValidationProcessed,0) = isnull(t.claimValidationProcessed,0)
          and isnull(p.claimValidationPaymentProcessed,0) = isnull(t.claimValidationPaymentProcessed,0)
          and isnull(p.claimValidationFee,0) = isnull(t.claimValidationFee,0)
          and isnull(p.tipDetailID,0) = isnull(t.tipDetailID,0)
          and isnull(p.healthTestValue,'') = isnull(t.healthTestValue,'')
          and isnull(p.PCPName,'') = isnull(t.PCPName,'')
          and isnull(p.pregTestResult,0) = isnull(t.pregTestResult,0)
          and isnull(p.isLegacyServiceTypeClaim, 0) = isnull(t.isLegacyServiceTypeClaim, 0)
          and isnull(p.isEssentialServiceTypeClaim, 0) = isnull(t.isEssentialServiceTypeClaim, 0)
          and isnull(p.isStarServiceTypeClaim, 0) = isnull(t.isStarServiceTypeClaim, 0)
          and isnull(p.isMedRecServiceTypeClaim, 0) = isnull(t.isMedRecServiceTypeClaim, 0)
          and isnull(p.currentMedPrescriber, '') = isnull(t.currentMedPrescriber, '')
          and isnull(p.currentPrescriberNPI, '') = isnull(t.currentPrescriberNPI, '')
          and isnull(p.numberOfNotes, 0) = isnull(t.numberOfNotes, 0)
          and isnull(p.timeToComplete, 0) = isnull(t.timeToComplete, 0)
          and isnull(p.username, '') = isnull(t.username, '')
          and isnull(p.[InvoiceStatusTypeID], 0) = isnull(t.[InvoiceStatusTypeID], 0)
          and isnull(p.[invoiceStatusTypeNM],'') = isnull(t.[invoiceStatusTypeNM],'')
          and isnull(p.invoiceStatusDT,'19000101') = isnull(t.invoiceStatusDT,'19000101')
          and isnull(p.cmrDeliveryTypeID, 0) = isnull(t.cmrDeliveryTypeID, 0)
          and isnull(p.createDT, '19000101') = isnull(t.createDT, '19000101')
          and isnull(p.statusDT, '19000101') = isnull(t.statusDT, '19000101')
          and isnull(p.conditionNM, '') = isnull(t.conditionNM, '')
          and isnull(p.plannedMedSyncDT, '19000101') = isnull(t.plannedMedSyncDT, '19000101')
          and isnull(p.labNM, '') = isnull(t.labNM, '')
          and isnull(p.currentMedName2, '')  = isnull(t.currentMedName2, '')
          and isnull(p.currentMedGpi2, '') = isnull(t.currentMedGpi2, '')
          and isnull(p.currentMedRxNumber2, '') = isnull(t.currentMedRxNumber2, '')
          and isnull(p.currentMedMetricQuantity2, 0) = isnull(t.currentMedMetricQuantity2, 0)
          and isnull(p.currentMedDaysSupply2, 0) = isnull(t.currentMedDaysSupply2, 0)
          and isnull(p.currentMedPrescriber2, '') = isnull(t.currentMedPrescriber2, '')
          and isnull(p.currentPrescriberNPI2, '') = isnull(t.currentPrescriberNPI2, '')
          and isnull(p.Cognitive_Impairment_Status, '') = isnull(t.Cognitive_Impairment_Status, '')
          and isnull(p.Cognitive_Impairment_Rationale, '') = isnull(t.Cognitive_Impairment_Rationale, '')
          and isnull(p.patTakeAwayDT, '19000101') = isnull(t.patTakeAwayDT, '19000101')
          and isnull(p.recipientNM, '') = isnull(t.recipientNM, '')
          and isnull(p.cmr_recipient_rationale, '') = isnull(t.cmr_recipient_rationale, '')
        )


    create nonclustered index ind_1 on #tempupdate(claimid)


    declare @batch int = 500000
    Declare @mincnt bigint = 1
    Declare @maxcnt bigint = (select top 1 id from #tempupdate order by id desc)
    while (@mincnt <= @maxcnt)
      BEGIN

        update p
        set p.policyid = t.policyid
            , p.policyNM = t.policyNM
            , p.mtmserviceDT = t.mtmserviceDT
            , p.[status] = t.[status]
            , p.patientid = t.patientid
            , p.MemberID = t.MemberID
            , p.MemberFirstNM = t.MemberFirstNM
            , p.MemberlastNM = t.MemberlastNM
            , p.MemberDOB = t.MemberDOB
            , p.MemberGender = t.MemberGender
            , p.MemberPhone = t.MemberPhone
            , p.memberCMSContractNumber = t.memberCMSContractNumber
            , p.memberPBP = t.memberPBP
            , p.centerid = t.centerid
            , p.PharmacyNABP = t.PharmacyNABP
            , p.PharmacyName = t.PharmacyName
            , p.carrier = t.carrier
            , p.account = t.account
            , p.[group] = t.[group]
            , p.PharmacyState = t.PharmacyState
            , p.pharmacistUserID = t.pharmacistUserID
            , p.pharmacistFirstNM = t.pharmacistFirstNM
            , p.pharmacistlastNM = t.pharmacistlastNM
            , p.PharmacistlicenseNumber = t.PharmacistlicenseNumber
            , p.reasonTypeID = t.reasonTypeID
            , p.reason = t.reason
            , p.reasonNM = t.reasonNM
            , p.actiontypeid = t.actiontypeid
            , p.[action] = t.[action]
            , p.actionNM = t.actionNM
            , p.resulttypeid = t.resulttypeid
            , p.[result] = t.[result]
            , p.resultNM = t.resultNM
            , p.ecalevelid = t.ecalevelid
            , p.serveritylevel = t.serveritylevel
            , p.serveritylevelNM = t.serveritylevelNM
            , p.estimated_cost = t.estimated_cost
            , p.AIM = t.AIM
            , p.charges = t.charges
            , p.ECAexplanation = t.ECAexplanation
            , p.additionalnotes = t.additionalnotes
            , p.face2face = t.face2face
            , p.claimfromcmr = t.claimfromcmr
            , p.isTipClaim = t.isTipClaim
            , p.tipResultID = t.tipResultID
            , p.tiptitle = t.tiptitle
            , p.tipidentificationdate = t.tipidentificationdate
            , p.currentMedRxNumber = t.currentMedRxNumber
            , p.currentMedMetricQuantity = t.currentMedMetricQuantity
            , p.currentMedDaysSupply = t.currentMedDaysSupply
            , p.currentMedGpi = t.currentMedGpi
            , p.currentMedName = t.currentMedName
            , p.newMedRxNumber = t.newMedRxNumber
            , p.newMedMetricQuantity = t.newMedMetricQuantity
            , p.newMedDaysSupply = t.newMedDaysSupply
            , p.newMedGpi = t.newMedGpi
            , p.newMedName = t.newMedName
            , p.[Adherence - Too many medications or doses per day] = t.[Adherence - Too many medications or doses per day]
            , p.[Adherence - Forgets to take on routine days] = t.[Adherence - Forgets to take on routine days]
            , p.[Adherence - Forgets to take on non-routine days] = t.[Adherence - Forgets to take on non-routine days]
            , p.[Feels medication is not helping] = t.[Feels medication is not helping]
            , p.[Feels medication is not needed] = t.[Feels medication is not needed]
            , p.[Experienced side effects] = t.[Experienced side effects]
            , p.[Concerned about potential side effects] = t.[Concerned about potential side effects]
            , p.[Medication cost is too high] = t.[Medication cost is too high]
            , p.[Decreased cognitive function] = t.[Decreased cognitive function]
            , p.[Limitations on activities of daily living] = t.[Limitations on activities of daily living]
            , p.[Transportation limitations prevent pharmacy access] = t.[Transportation limitations prevent pharmacy access]
            , p.[Patient taking differently than written directions] = t.[Patient taking differently than written directions]
            , p.[Refill request delay] = t.[Refill request delay]
            , p.[No barrier identified] = t.[No barrier identified]
            , p.[Pharmacy error in directions/delivery/medication] = t.[Pharmacy error in directions/delivery/medication]
            , p.[Forgets to take] = t.[Forgets to take]
            , p.[Unsure how to use medication] = t.[Unsure how to use medication]
            , p.[Unable to swallow or administer] = t.[Unable to swallow or administer]
            , p.[Believes to be adherent] = t.[Believes to be adherent]
            , p.[Patient has no concerns or barriers] = t.[Patient has no concerns or barriers]
            , p.refillpickedup = t.refillpickedup
            , p.[memberRefusalDesc] = t.[memberRefusalDesc]
            , p.[prescriberRefusalDesc] = t.[prescriberRefusalDesc]
            , p.paiddate = t.paiddate
            , p.claimSubmitDT = t.claimSubmitDT
            , p.lastupdatedt = t.lastupdatedt
            , p.documentationUserID = t.documentationUserID
            , p.documentationFirstNM = t.documentationFirstNM
            , p.documentationLastNM = t.documentationLastNM
            , p.documentationRole = t.documentationRole
            , p.pctfillatCenter = t.pctfillatCenter
            , p.pctfillatChain = t.pctfillatChain
            , p.primarypharmacy = t.primarypharmacy
            , p.validated = t.validated
            , p.claimValidationProcessed = t.claimValidationProcessed
            , p.claimValidationPaymentProcessed = t.claimValidationPaymentProcessed
            , p.claimvalidationFee = t.claimValidationFee
            , p.tipDetailID = t.tipDetailID
            , p.healthTestValue = t.healthTestValue
            , p.PCPName = t.PCPName
            , p.pregTestResult= t.pregTestResult
            , p.isLegacyServiceTypeClaim = t.isLegacyServiceTypeClaim
            , p.isEssentialServiceTypeClaim = t.isEssentialServiceTypeClaim
            , p.isStarServiceTypeClaim = t.isStarServiceTypeClaim
            , p.isMedRecServiceTypeClaim = t.isMedRecServiceTypeClaim
            , p.currentMedPrescriber= t.currentMedPrescriber
            , p.currentPrescriberNPI= t.currentPrescriberNPI
            , p.numberOfNotes = t.numberOfNotes
            , p.timeToComplete = t.timeToComplete
            , p.username = t.username
            , p.invoiceStatusTypeID = t.invoiceStatusTypeID
            , p.invoiceStatusTypeNM = t.invoiceStatusTypeNM
            , p.invoiceStatusDT = t.invoiceStatusDT
            , p.cmrDeliveryTypeID = t.cmrDeliveryTypeID
            , p.createDT = t.createDT
            , p.statusDT = t.statusDT
            , p.conditionNM = t.conditionNM
            , p.plannedMedSyncDT = t.plannedMedSyncDT
            , p.labNM = t.labNM
            , p.currentMedName2 = t.currentMedName2
            , p.currentMedGpi2 = t.currentMedGpi2
            , p.currentMedRxNumber2 = t.currentMedRxNumber2
            , p.currentMedMetricQuantity2 = t.currentMedMetricQuantity2
            , p.currentMedDaysSupply2 = t.currentMedDaysSupply2
            , p.currentMedPrescriber2 = t.currentMedPrescriber2
            , p.currentPrescriberNPI2 = t.currentPrescriberNPI2
            , p.Cognitive_Impairment_Status = t.Cognitive_Impairment_Status
            , p.Cognitive_Impairment_Rationale = t.Cognitive_Impairment_Rationale
            , p.patTakeAwayDT = t.patTakeAwayDT
            , p.recipientNM = t.recipientNM
            , p.cmr_recipient_rationale= t.cmr_recipient_rationale
            --select COUNT(*)
        from clientManagerReport p
               join clientManagerReport_staging t on t.claimid = p.claimid
               join #tempupdate u on u.claimid = t.claimid
        where 1=1
          and u.id >= @mincnt
          and u.id < @mincnt+@batch

        set @mincnt = @mincnt+@batch

      end
    ---------


    declare @temp int

    set @temp = (select 1)
    while (@@ROWCOUNT > 0)
      BEGIN

        insert into clientManagerReport (claimid
            , policyid
            , policyNM
            , mtmserviceDT
            , [status]
            , patientid
            , MemberID
            , MemberFirstNM
            , MemberlastNM
            , MemberDOB
            , MemberGender
            , MemberPhone
            , memberCMSContractNumber
            , memberPBP
            , centerid
            , PharmacyNABP
            , PharmacyName
            , carrier
            , account
            , [group]
            , PharmacyState
            , pharmacistUserID
            , pharmacistFirstNM
            , pharmacistlastNM
            , PharmacistlicenseNumber
            , reasonTypeID
            , reason
            , reasonNM
            , actiontypeid
            , [action]
            , actionNM
            , resulttypeid
            , [result]
            , resultNM
            , ecalevelid
            , serveritylevel
            , serveritylevelNM
            , estimated_cost
            , AIM
            , charges
            , ECAexplanation
            , additionalnotes
            , face2face
            , claimfromcmr
            , isTipClaim
            , tipResultID
            , tiptitle
            , tipidentificationdate
            , currentMedRxNumber
            , currentMedMetricQuantity
            , currentMedDaysSupply
            , currentMedGpi
            , currentMedName
            , newMedRxNumber
            , newMedMetricQuantity
            , newMedDaysSupply
            , newMedGpi
            , newMedName
            , [Adherence - Too many medications or doses per day]
            , [Adherence - Forgets to take on routine days]
            , [Adherence - Forgets to take on non-routine days]
            , [Feels medication is not helping]
            , [Feels medication is not needed]
            , [Experienced side effects]
            , [Concerned about potential side effects]
            , [Medication cost is too high]
            , [Decreased cognitive function]
            , [Limitations on activities of daily living]
            , [Transportation limitations prevent pharmacy access]
            , [Patient taking differently than written directions]
            , [Refill request delay]
            , [No barrier identified]
            , [Pharmacy error in directions/delivery/medication]
            , [Believes to be adherent]
            , [Forgets to take]
            , [Patient has no concerns or barriers]
            , [Unsure how to use medication]
            , [Unable to swallow or administer]
            , refillpickedup
            , [memberRefusalDesc]
            , [prescriberRefusalDesc]
            , paiddate
            , claimSubmitDT
            , lastupdatedt
            , documentationUserID
            , documentationFirstNM
            , documentationLastNM
            , documentationRole
            , pctfillatCenter
            , pctfillatChain
            , primarypharmacy
            , validated
            , claimValidationProcessed
            , claimValidationPaymentProcessed
            , claimValidationFee
            , tipDetailID
            , healthTestValue
            , PCPName
            , pregTestResult
            , isLegacyServiceTypeClaim
            , isEssentialServiceTypeClaim
            , isStarServiceTypeClaim
            , isMedRecServiceTypeClaim
            , currentMedPrescriber
            , currentPrescriberNPI
            , numberOfNotes
            , timeToComplete
            , username
            , invoiceStatusTypeID
            , invoiceStatusTypeNM
            , invoiceStatusDT
            , cmrDeliveryTypeID
            , createDT
            , statusDT
            , conditionNM
            , plannedMedSyncDT
            , labNM
            , currentMedName2
            , currentMedGpi2
            , currentMedRxNumber2
            , currentMedMetricQuantity2
            , currentMedDaysSupply2
            , currentMedPrescriber2
            , currentPrescriberNPI2
            , Cognitive_Impairment_Status
            , Cognitive_Impairment_Rationale
            , patTakeAwayDT
            , recipientNM
            , cmr_recipient_rationale
            )
        select top (@batch) claimid
            , policyid
            , policyNM
            , mtmserviceDT
            , [status]
            , patientid
            , MemberID
            , MemberFirstNM
            , MemberlastNM
            , MemberDOB
            , MemberGender
            , MemberPhone
            , memberCMSContractNumber
            , memberPBP
            , centerid
            , PharmacyNABP
            , PharmacyName
            , carrier
            , account
            , [group]
            , PharmacyState
            , pharmacistUserID
            , pharmacistFirstNM
            , pharmacistlastNM
            , PharmacistlicenseNumber
            , reasonTypeID
            , reason
            , reasonNM
            , actiontypeid
            , [action]
            , actionNM
            , resulttypeid
            , [result]
            , resultNM
            , ecalevelid
            , serveritylevel
            , serveritylevelNM
            , estimated_cost
            , AIM
            , charges
            , ECAexplanation
            , additionalnotes
            , face2face
            , claimfromcmr
            , isTipClaim
            , tipResultID
            , tiptitle
            , tipidentificationdate
            , currentMedRxNumber
            , currentMedMetricQuantity
            , currentMedDaysSupply
            , currentMedGpi
            , currentMedName
            , newMedRxNumber
            , newMedMetricQuantity
            , newMedDaysSupply
            , newMedGpi
            , newMedName
            , [Adherence - Too many medications or doses per day]
            , [Adherence - Forgets to take on routine days]
            , [Adherence - Forgets to take on non-routine days]
            , [Feels medication is not helping]
            , [Feels medication is not needed]
            , [Experienced side effects]
            , [Concerned about potential side effects]
            , [Medication cost is too high]
            , [Decreased cognitive function]
            , [Limitations on activities of daily living]
            , [Transportation limitations prevent pharmacy access]
            , [Patient taking differently than written directions]
            , [Refill request delay]
            , [No barrier identified]
            , [Pharmacy error in directions/delivery/medication]
            , [Believes to be adherent]
            , [Forgets to take]
            , [Patient has no concerns or barriers]
            , [Unsure how to use medication]
            , [Unable to swallow or administer]
            , refillpickedup
            , [memberRefusalDesc]
            , [prescriberRefusalDesc]
            , paiddate
            , claimSubmitDT
            , lastupdatedt
            , documentationUserID
            , documentationFirstNM
            , documentationLastNM
            , documentationRole
            , pctfillatCenter
            , pctfillatChain
            , primarypharmacy
            , validated
            , claimValidationProcessed
            , claimValidationPaymentProcessed
            , claimValidationFee
            , tipDetailID
            , healthTestValue
            , PCPName
            , pregTestResult
            , isLegacyServiceTypeClaim
            , isEssentialServiceTypeClaim
            , isStarServiceTypeClaim
            , isMedRecServiceTypeClaim
            , currentMedPrescriber
            , currentPrescriberNPI
            , numberOfNotes
            , timeToComplete
            , username
            , invoiceStatusTypeID
            , invoiceStatusTypeNM
            , invoiceStatusDT
            , cmrDeliveryTypeID
            , createDT
            , statusDT
            , conditionNM
            , plannedMedSyncDT
            , labNM
            , currentMedName2
            , currentMedGpi2
            , currentMedRxNumber2
            , currentMedMetricQuantity2
            , currentMedDaysSupply2
            , currentMedPrescriber2
            , currentPrescriberNPI2
            , Cognitive_Impairment_Status
            , Cognitive_Impairment_Rationale
            , patTakeAwayDT
            , recipientNM
            , cmr_recipient_rationale
        from clientManagerReport_staging t
        where 1=1
          and not exists (
                    select 1
                    from clientManagerReport p
                    where 1=1
                      and t.claimid = p.claimid
            )

      end

    ----------


    set @temp = (select 1)
    while (@@ROWCOUNT > 0)
      BEGIN

        delete top (@batch) p
            --select COUNT(*)
        from clientManagerReport p
        where 1=1
          and not exists (
                    select 1
                    from clientManagerReport_staging t
                    where 1=1
                      and t.claimid = p.claimid
            )

      end

  end