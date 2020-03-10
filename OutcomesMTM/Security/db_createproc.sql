CREATE ROLE [db_createproc]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [db_createproc] ADD MEMBER [FUSE\gLGP-SQLDDLDevsOCREPDB];

