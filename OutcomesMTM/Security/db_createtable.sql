CREATE ROLE [db_createtable]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [db_createtable] ADD MEMBER [FUSE\gLGP-SQLDDLDevsOCREPDB];

