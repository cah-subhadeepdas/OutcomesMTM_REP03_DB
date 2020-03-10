CREATE   VIEW cms.vw_TMR_Active

AS

	select tmr.*
	from cms.vw_TMR_History tmr
	where 1=1
	and tmr.IsCurrent = 1


