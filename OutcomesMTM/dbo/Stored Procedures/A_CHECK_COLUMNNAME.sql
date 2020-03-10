
CREATE procedure [dbo].[A_CHECK_COLUMNNAME]
@column varchar(1000)
as 
begin
set nocount on;
set xact_abort on;


--replace with permenant table if needed
IF OBJECT_ID('tempdb..##TEMPCOLUMNLOG') IS NOT NULL
BEGIN
	drop table ##TEMPCOLUMNLOG
END

--drop table ##tempcolumnlog
create Table ##tempcolumnlog (

dbname varchar(1000)
, tablename varchar(1000)
, columnname varchar(1000)

)

--drop table #tempdatabases
create table #tempdatabases (

id int identity(1,1),
dbname varchar(100)

)
insert into #tempdatabases
SELECT name
FROM sys.databases
where 1=1 
and name not in ('master','tempdb','msdb','model')

--select * from #tempdatabases

declare @dbcnt int,@dbname varchar(4000),@SQL varchar(8000)

set @dbcnt = 1
while (@dbcnt <= (select COUNT(*) from #tempdatabases))
begin 

set @dbname = (select dbname from #tempdatabases where 1=1 and id = @dbcnt)

set @SQL = isnull(@sql,'') + ' use ' + @dbname + '; ' +
' insert into ##tempcolumnlog (dbname, tablename, columnname) '+
' select distinct '+''''+@dbname+''''+' as dbname, table_name, '+''''+@column+''''+
' from information_schema.columns '+ 
' where 1=1 '+ 
' and column_name = '+''''+@column+'''' 


set @dbcnt = @dbcnt + 1

end 

print(@sql)
exec (@sql) 

drop table #tempdatabases

select * from ##tempcolumnlog order by dbname, tablename

IF OBJECT_ID('tempdb..##TEMPCOLUMNLOG') IS NOT NULL
BEGIN
	drop table ##TEMPCOLUMNLOG
END

end 


