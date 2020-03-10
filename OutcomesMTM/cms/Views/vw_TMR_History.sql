

CREATE     VIEW [cms].[vw_TMR_History]

AS


	select tmr.*, s.IsCurrent
	from OutcomesMTM.cms.TMR tmr
	join (
		select s.*, IsCurrent = case when s.ActiveThruDT > getdate() then 1 else 0 end
		from OutcomesMTM.cms.CMS_SnapshotTracker s
		where 1=1
		and s.DataSetTypeID = 3
		and s.LastRunStatus = 1
	) s
		on s.SnapshotID = tmr.SnapshotID


