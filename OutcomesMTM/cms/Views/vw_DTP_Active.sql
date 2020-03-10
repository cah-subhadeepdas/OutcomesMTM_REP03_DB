
CREATE   VIEW cms.vw_DTP_Active

AS

	select dtp.*
	from cms.vw_DTP_History dtp
	where 1=1
	and dtp.IsCurrent = 1

