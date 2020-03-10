
CREATE procedure [dbo].[S_rptNINtipReport_client]
as
begin
set nocount on;
set xact_abort on;


select cl.clientID
, cl.clientName
from client cl
where 1=1
order by cl.clientName


END

