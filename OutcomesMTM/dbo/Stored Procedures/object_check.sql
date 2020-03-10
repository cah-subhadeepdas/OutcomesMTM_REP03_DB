



CREATE procedure [dbo].[object_check]
@object varchar(1000)
as 
begin
set nocount on;
set xact_abort on;

--declare @object varchar(1000) = 'tiprx'

--drop table #return
create table #return (

id int identity(1,1) primary key 
, searchname varchar(1000)
, objectid int
, dbname varchar(1000)
, name varchar(1000) 
, sqltext varchar(max) 

)

declare @db table (

id int identity(1,1) primary key
, dbname varchar(1000)

)
insert into @db (dbname)   
select name  
from sys.databases
where 1=1 

declare @cnt int, @sql varchar(8000), @db_name varchar(1000) 
set @cnt = 1 
while(@cnt <= (select count(*) from @db))
begin 

set @db_name = (select dbname from @db where 1=1 and @cnt = id)

set @sql = ' insert into #return (searchname, objectid, dbname, name, sqltext) '+
' SELECT '+''''+@object+''''+','+'o.id,'+''''+@db_name+''''+','+'o.name,'+'text '+
' from '+@db_name+'.dbo.syscomments c '+ 
' JOIN '+@db_name+'.dbo.sysobjects o ON o.id=c.id '+
' where 1=1 '+ 
' and text like '+''''+'%'+@object+'%'+''''

set @cnt = @cnt + 1

print(@sql)
exec(@sql) 
end 

select * from #return
drop table #return

end 




