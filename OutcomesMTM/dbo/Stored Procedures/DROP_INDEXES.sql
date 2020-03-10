

CREATE PROCEDURE [dbo].[DROP_INDEXES]
@dbName varchar(1000) = ''
,@tableName varchar(1000)  
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

if(not exists (select 1 from sys.databases where 1=1 and @dbname = name)) 
begin 
	set @dbname = ''
end 

declare @SQL varchar(max) 

if(object_id('tempdb..#dropIndexes') is not null)
drop table #dropIndexes
create table #dropIndexes (

id int identity(1,1) primary key 
, IndexName varchar(8000)
, dbname varchar(8000)
, schemaName varchar(8000)
, objectName varchar(8000)
)


set @sql = 
' insert into #dropIndexes (IndexName, dbname, schemaName, objectName) '+
' SELECT i.name, '+''''+@dbName+''''+',schema_name(o.schema_id)'+', o.name'+
' FROM '+@dbName+'.sys.indexes i '+ 
' join '+@dbName+'.sys.objects o on i.object_id = o.object_id '+ 
' where 1=1 '+
' and o.name ='+''''+@tableName+''''
--print(@sql) 
exec (@sql)

--select * from #dropIndexes

declare @cnt int = 1
while(@cnt <= (select isnull(count(*),0) from #dropIndexes))
begin 

set @SQL = ' Drop INDEX ' + 
			(select '['+indexName+']' from #dropIndexes i 
				where 1=1 
				and id = @cnt) +
			' ON ' + 
		    (select case when @dbName <> '' 
					     then (select '['+dbname+']' from #dropIndexes i 
				               where 1=1 and id = @cnt) + '.'
					     else @dbName end) 
			+
			(select '['+schemaName+']' from #dropIndexes i 
				where 1=1 
				and id = @cnt) + '.' +
			(select '['+[objectName]+']' from #dropIndexes i 
				where 1=1 
				and id = @cnt) +' ;'
--print(@SQL)
exec(@SQL) 

set @cnt = @cnt + 1

end 

drop table #dropIndexes

END




