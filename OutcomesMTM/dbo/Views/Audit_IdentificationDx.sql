


CREATE     VIEW [dbo].[Audit_IdentificationDx]
AS

	select
		PatientID = rrd.PatientID
		, IdentificationRunID = rrd.IdentificationRunID
		, DxID = rrd.IdentificationDetailID
		, DxTitle = dx.DxTitle
	--select top 100 *
	--from staging.RRD__71CC74B9FD5A4785ACA67514F564D6BF rrd
	from [AOCWPAPSQL02].outcomes.dbo.IdentificationRunResultDetail rrd
	join staging.DxStates dx
		on dx.DxStateID = rrd.IdentificationDetailID
	where 1=1
	and rrd.IdentificationDetailTypeID = 4


