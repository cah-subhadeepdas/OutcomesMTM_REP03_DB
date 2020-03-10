CREATE procedure [dbo].[I_ReportExportLog]
	  @ReportExtractID int
	, @ReportRangeFromDT datetime
	, @ReportRangeThruDT datetime
	, @ReportRunStartDT datetime
	, @ReportRunFinishDT datetime


AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


	insert into ReportExtractLog
	(
		  ReportExtractID
		, ReportRangeFromDT
		, ReportRangeThruDT
		, ReportRunStartDT
		, ReportRunFinishDT
	)
	output 
		  inserted.ReportExtractLogID
		, inserted.ReportExtractID
		, inserted.ReportRangeFromDT
		, inserted.ReportRangeThruDT
		, inserted.ReportRunStartDT
		, inserted.ReportRunFinishDT
	values 
	(
		  @ReportExtractID
		, @ReportRangeFromDT
		, @ReportRangeThruDT
		, @ReportRunStartDT
		, @ReportRunFinishDT
	)


END


