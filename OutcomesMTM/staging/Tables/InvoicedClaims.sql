CREATE TABLE [staging].[InvoicedClaims] (
    [ID]                   INT            IDENTITY (1, 1) NOT NULL,
    [Transaction Type ID]  INT            NULL,
    [Claim ID]             INT            NULL,
    [MTM Service Date]     DATETIME       NULL,
    [Policy ID]            INT            NULL,
    [Policy Name]          VARCHAR (500)  NULL,
    [NCPDP]                VARCHAR (500)  NULL,
    [Pharmacy Name]        VARCHAR (8000) NULL,
    [Reason Code]          INT            NULL,
    [Action Code]          INT            NULL,
    [Result Code]          INT            NULL,
    [TIP DETAIL ID NUMBER] VARCHAR (50)   NULL,
    [Tip Title]            VARCHAR (5000) NULL,
    [SAP Customer ID]      VARCHAR (5000) NULL,
    [Invoice #]            VARCHAR (500)  NULL,
    [Invoice Date]         DATE           NULL,
    [Invoice Amount]       VARCHAR (100)  NULL,
    [Transactional Fee]    VARCHAR (100)  NULL,
    [RecordType]           INT            NULL,
    [File Load Date]       DATETIME       DEFAULT (getdate()) NULL
);

