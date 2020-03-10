CREATE TABLE [dbo].[serviceType] (
    [serviceTypeID] SMALLINT     NOT NULL,
    [serviceType]   VARCHAR (50) NULL,
    CONSTRAINT [PK_serviceType] PRIMARY KEY CLUSTERED ([serviceTypeID] ASC) WITH (FILLFACTOR = 80)
);

