
Create   Procedure cms.S_ChangeFile_RPT 
 @ClientID int
, @ContractYear char(4) =''
, @ContratNumber varchar(5)

AS
BEGIN


	IF isnull(@ContractYear,'') = ''
		SET @ContractYear = ( select top 1 ContractYear from cms.vw_Snapshot s order by ContractYear desc )
		
	

select 
	cf.OMTM_ID
	, cf.MemberID
	, cf.ContractNumber
	, cf.ChangeActivity
	, cf.ChangeDetail
	, cf.ChangeDate
from cms.vw_ChangeFile cf
where 1=1
and cf.ClientID = @ClientID
and cf.ContractYear = @ContractYear
and cf.ContractNumber = @ContratNumber

End
