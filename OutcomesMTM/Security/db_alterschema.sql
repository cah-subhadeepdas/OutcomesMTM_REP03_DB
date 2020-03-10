CREATE ROLE [db_alterschema]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [db_alterschema] ADD MEMBER [FUSE\gLGP-SQLDDLDevsOCREPDB];

