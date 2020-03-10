


CREATE VIEW dbo.PatientAdditionalInfo_Humana
AS

	select 
		PatientID = ptai.PatientID
		, PlatformCode = ptai.additionalinfoxml.value('PlatformCode[1]','varchar(2)')
		, SourceCode = ptai.additionalinfoxml.value('SourceCode[1]','varchar(2)')
		, ActiveFrom = ptai.ActiveAsOf
		, ActiveThru = isnull(ptai.ActiveThru,'9999-12-31')
	from outcomesmtm.dbo.patientAdditionalInfoDim ptai
	where 1=1
	--and pt.ActiveThru >= '2016-01-01'
	--and pt.ActiveAsOf < '2017-01-01'

