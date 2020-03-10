


CREATE   VIEW [cms].[vw_Snapshot]
AS

	SELECT 
		[SnapshotID]
		,[DataSetTypeID]
		,[ClientID]
		,[ContractYear]
		,[ActiveFromDT]
		,[ActiveThruDT]
	--// select *
	FROM [OutcomesMTM].[cms].[CMS_SnapshotTracker]
	WHERE 1=1
	AND LastRunStatus = 0
	AND ActiveThruDT > getdate()

