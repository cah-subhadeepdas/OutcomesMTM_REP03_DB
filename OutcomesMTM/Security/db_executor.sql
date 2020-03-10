CREATE ROLE [db_executor]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [db_executor] ADD MEMBER [FUSE\gLGP-SQLDDLDevsOCREPDB];


GO
ALTER ROLE [db_executor] ADD MEMBER [report_user];


GO
ALTER ROLE [db_executor] ADD MEMBER [FUSE\gLGP-SQLReadWriteOCREPDB];


GO
ALTER ROLE [db_executor] ADD MEMBER [FUSE\gLGP-SQLSysAdminocrepdb];


GO
ALTER ROLE [db_executor] ADD MEMBER [connect_lnksvr];


GO
ALTER ROLE [db_executor] ADD MEMBER [FUSE\gLGP-SQLReadOnlyOCREPDB];

