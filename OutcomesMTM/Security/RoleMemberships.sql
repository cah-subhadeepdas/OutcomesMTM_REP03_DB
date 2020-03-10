ALTER ROLE [db_owner] ADD MEMBER [application_user];


GO
ALTER ROLE [db_owner] ADD MEMBER [connect_deploy];


GO
ALTER ROLE [db_owner] ADD MEMBER [FUSE\s-sqla-POCINGP01];


GO
ALTER ROLE [db_owner] ADD MEMBER [flywaysql];


GO
ALTER ROLE [db_backupoperator] ADD MEMBER [NT AUTHORITY\SYSTEM];


GO
ALTER ROLE [db_datareader] ADD MEMBER [SSIS_user];


GO
ALTER ROLE [db_datareader] ADD MEMBER [FUSE\gLGP-SQLDDLDevsOCREPDB];


GO
ALTER ROLE [db_datareader] ADD MEMBER [admin_user];


GO
ALTER ROLE [db_datareader] ADD MEMBER [report_user];


GO
ALTER ROLE [db_datareader] ADD MEMBER [FUSE\gLGP-SQLReadWriteOCREPDB];


GO
ALTER ROLE [db_datareader] ADD MEMBER [FUSE\gLGP-SQLSysAdminocrepdb];


GO
ALTER ROLE [db_datareader] ADD MEMBER [connect_lnksvr];


GO
ALTER ROLE [db_datareader] ADD MEMBER [FUSE\gLGP-SQLReadOnlyOCREPDB];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [SSIS_user];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [FUSE\gLGP-SQLDDLDevsOCREPDB];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [admin_user];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [FUSE\gLGP-SQLReadWriteOCREPDB];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [FUSE\gLGP-SQLSysAdminocrepdb];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [connect_lnksvr];

