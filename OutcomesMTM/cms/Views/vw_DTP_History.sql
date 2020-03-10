



CREATE   VIEW cms.vw_DTP_History

AS

	select dtp.*, IsCurrent = 1
	from cms.DTP dtp

