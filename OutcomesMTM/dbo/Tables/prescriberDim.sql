CREATE TABLE [dbo].[prescriberDim] (
    [prescriberKey]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [prid]                 BIGINT        NOT NULL,
    [ClientID]             INT           NOT NULL,
    [PrescriberID]         VARCHAR (50)  NOT NULL,
    [PrescriberFirstName]  VARCHAR (50)  NULL,
    [PrescriberLastName]   VARCHAR (50)  NULL,
    [PrescriberAddress1]   VARCHAR (100) NULL,
    [PrescriberAddress2]   VARCHAR (100) NULL,
    [PrescriberCity]       VARCHAR (50)  NULL,
    [PrescriberState]      VARCHAR (50)  NULL,
    [PrescriberZip]        VARCHAR (50)  NULL,
    [PrescriberFax]        VARCHAR (50)  NULL,
    [PrescriberPhone]      VARCHAR (50)  NULL,
    [prescriberTypeID]     TINYINT       NOT NULL,
    [changeDate]           DATETIME      NOT NULL,
    [enterpriseChangeDate] DATETIME      NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_prescriberDim_prid]
    ON [dbo].[prescriberDim]([prid] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [NC_prescriberDim_clientID_prescriberID]
    ON [dbo].[prescriberDim]([ClientID] ASC, [PrescriberID] ASC) WITH (FILLFACTOR = 80);

