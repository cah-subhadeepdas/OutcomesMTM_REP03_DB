
create proc [dbo].[U_providerRelationshipView]
as
begin
set nocount on;
set xact_abort on;


update pv
set pv.[mtmCenterNumber] = ps.[mtmCenterNumber]
	,pv.[Relationship_ID] = ps.[Relationship_ID]
	,pv.[Relationship_ID_Name] = ps.[Relationship_ID_Name]
	,pv.[Relationship_Type] = ps.[Relationship_Type]
	,pv.[relationShip_Type_Name] = ps.[relationShip_Type_Name]
	,pv.[Effective_From_Date] = ps.[Effective_From_Date]
	,pv.[Effective_Through_Date] = ps.[Effective_Through_Date]
	,pv.[parent_organization_ID] = ps.[parent_organization_ID]
	,pv.[parent_organization_Name] = ps.[parent_organization_Name]
--select count(*)
from outcomesMTM.dbo.providerRelationshipView pv
join outcomesMTM.dbo.providerRelationshipViewStaging ps on ps.mtmCenterNumber = pv.mtmCenterNumber
														and ps.Relationship_ID = pv.Relationship_ID
where 1=1

delete pv
--select count(*)
from outcomesMTM.dbo.providerRelationshipView pv
left join outcomesMTM.dbo.providerRelationshipViewStaging ps on ps.mtmCenterNumber = pv.mtmCenterNumber
														and ps.Relationship_ID = pv.Relationship_ID
where 1=1
and ps.mtmCenterNumber is null


insert into outcomesMTM.dbo.providerRelationshipView ([mtmCenterNumber]
	,[Relationship_ID]
	,[Relationship_ID_Name]
	,[Relationship_Type]
	,[relationShip_Type_Name]
	,[Effective_From_Date]
	,[Effective_Through_Date]
	,[parent_organization_ID]
	,[parent_organization_Name]
)
select ps.[mtmCenterNumber]
	,ps.[Relationship_ID]
	,ps.[Relationship_ID_Name]
	,ps.[Relationship_Type]
	,ps.[relationShip_Type_Name]
	,ps.[Effective_From_Date]
	,ps.[Effective_Through_Date]
	,ps.[parent_organization_ID]
	,ps.[parent_organization_Name]
from outcomesMTM.dbo.providerRelationshipView pv
right join outcomesMTM.dbo.providerRelationshipViewStaging ps on ps.mtmCenterNumber = pv.mtmCenterNumber
															and ps.Relationship_ID = pv.Relationship_ID
where 1=1
and pv.mtmCenterNumber is null





end

