create procedure dbo.GetRemoteDBObjects_QueriedWithLinkedServer
AS
begin


drop table if exists #LinkedServers
create table #LinkedServers (
id int identity(1,1),
srv_name varchar(100),
srv_Providername varchar(100),
srv_Product varchar(100),
srv_datasource varchar(100),
srv_providerstring varchar(100),
srv_location varchar(100),
srv_cat varchar(100) )

insert into #LinkedServers (srv_name , srv_Providername , srv_Product , srv_datasource , srv_providerstring , srv_location , srv_cat)
exec sp_linkedservers

drop table if exists #LinkedServerQueries
create table #LinkedServerQueries (id int identity(1,1), LinkedServer varchar(100) , Query varchar(max) )

declare @counter int = 1;
while ( @counter <= (select count(*) from #LinkedServers) )
begin 
	insert into #LinkedServerQueries (LinkedServer , Query)
	select x.srv_name , s.text --SPLIT_DELIMITED_STRING(s.text, x.srv_name)
	from syscomments s cross join (select * from #LinkedServers where id = @counter) x
	where 1=1
	and charindex(x.srv_name , s.TEXT) > 1


	set @counter = @counter + 1
end 

--select * from #LinkedServerQueries
drop table if exists #LinkedServerReferenceTablesNotUnique
create table #LinkedServerReferenceTablesNotUnique (id int identity(1,1), LinkedServer varchar(100) , ReferencedDBObject varchar(100) )

declare @count int = 1;
while ( @count <= (select count(*) from #LinkedServerQueries) )
begin 
	declare @Param_RemoteQuery varchar(max) = (select query from #LinkedServerQueries where id = @count)
	declare @Param_searchRemoteQueriesByLinkedServer varchar(max) = (select LinkedServer from #LinkedServerQueries where id = @count)

	insert into #LinkedServerReferenceTablesNotUnique (LinkedServer , ReferencedDBObject)
	SELECT @Param_searchRemoteQueriesByLinkedServer as LinkedServer , VALUE as ReferencedDBObject   FROM   [DBO].SPLIT_DELIMITED_STRING(@Param_RemoteQuery , @Param_searchRemoteQueriesByLinkedServer)


	set @count = @count + 1
	 
end

drop table if exists #LinkedServerReferenceTables
select distinct LinkedServer , ReferencedDBObject 
into #LinkedServerReferenceTables 
from #LinkedServerReferenceTablesNotUnique

select 'LinkedServerRemoteDBObject' , LinkedServer , replace(replace(ReferencedDBObject, '[' , ''), ']', '') as ReferencedDBObject 
from #LinkedServerReferenceTables 

end