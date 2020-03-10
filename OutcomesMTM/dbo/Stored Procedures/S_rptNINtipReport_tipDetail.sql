
CREATE procedure [dbo].[S_rptNINtipReport_tipDetail]
as
begin
set nocount on;
set xact_abort on;

select td.tipdetailid
	, td.tiptitle
from staging.TIPDetail_tip td
where 1=1
order by td.tiptitle


END

