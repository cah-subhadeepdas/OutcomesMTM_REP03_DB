Create      Procedure [cms].[GetCIDCY](
@ClientID int output, @ContractYear varchar(4) output)
AS

Begin

--Declare @ClientID int , @ContractYear varchar(4) 
select @ClientID = res.clientID, 
@ContractYear = res.contractyear 
from 

--select res.clientid, 
--res.contractyear from 
(
	select distinct 
		bm.ClientID, 
		bm.ContractYear, 
		ranker = ROW_NUMBER() over(order by bm.snapshotid desc)
	from 
	--cmsETL.FileLoad fl 
	--join cmsETL.BeneficiarySF_IngestLog inglog 
	--on inglog.FileID =fl.FileID
	--join 
	cms.vw_CMS bm 
	--on bm.PatientID = inglog.OMTM_ID
) res 
where res.ranker =1

Select ClientID = @clientID    
, CY = @ContractYear 
END