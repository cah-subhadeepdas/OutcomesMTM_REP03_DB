



CREATE     VIEW [dbo].[Audit_IdentificationRx]
AS

	select
		PatientID = rrd.PatientID
		, IdentificationRunID = rrd.IdentificationRunID
		, IdentificationDetailTypeID = rrd.IdentificationDetailTypeID
		, RxID = rxd.RxID
		, RxDate = rxd.RxDate
		, PatientCopay = rxd.PatientCopay
		, ClientPayment = rxd.ClientPayment
		, NDC = rxd.NDC
		, GPI = d.GPI
		, Product_Name = d.Product_Name
		, MnDrugCode = d.MnDrugCode
		--// select top 100 *
	--from staging.RRD__71CC74B9FD5A4785ACA67514F564D6BF rrd  --OutcomesMTM.staging.RRD__TEST02 rrd
	from [AOCWPAPSQL02].outcomes.dbo.IdentificationRunResultDetail rrd
	--join staging.IdentificationRun r
	join [AOCWPAPSQL02].outcomes.dbo.IdentificationRun r
		on r.IdentificationRunID = rrd.IdentificationRunID
	join OutcomesMTM.dbo.prescriptionDim rxd with (nolock)
		on rxd.RxID = rrd.IdentificationDetailID
	left join OutcomesMTM.dbo.Drug d
		on d.NDC = rxd.NDC
	where 1=1
	and	r.RunDate >= rxd.activeAsOf
	and r.RunDate < isnull(rxd.activeThru,'9999-12-31')

