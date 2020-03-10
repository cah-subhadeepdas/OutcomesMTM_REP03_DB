
CREATE procedure [dbo].[S_rptNINtipReport_policy]
@clientID VARCHAR(MAX)
as
begin
set nocount on;
set xact_abort on;

select po.policyID
	,po.policyName
	,cl.clientName + ' - (' + CAST(po.policyID as varchar(50)) + ') - ' + po.policyName AS policyDisplayName
from policy po
join contract co on co.contractID = po.contractID
join client cl on cl.clientID = co.clientID
join DelimitedSplit8K(@clientID, ',') d ON cl.clientID = d.Item
where 1=1
order by cl.clientname, po.policyname


END

