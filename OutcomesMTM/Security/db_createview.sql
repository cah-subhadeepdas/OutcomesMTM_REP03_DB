CREATE ROLE [db_createview]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [db_createview] ADD MEMBER [FUSE\gLGP-SQLDDLDevsOCREPDB];

