CREATE TABLE [staging].[Patient_TIPTrending] (
    [ID]                                      INT             IDENTITY (1, 1) NOT NULL,
    [PolicyID]                                INT             NULL,
    [ClientID]                                INT             NULL,
    [PolicyName]                              VARCHAR (50)    NULL,
    [ClientName]                              VARCHAR (50)    NULL,
    [Count Of Active Patients]                BIGINT          NULL,
    [Count Of Active patients At MTM Centers] BIGINT          NULL,
    [Count Of TIP Opportunities YTD]          BIGINT          NULL,
    [Count Of Active TIPS]                    BIGINT          NULL,
    [Count Of WithDrawn TIPS]                 BIGINT          NULL,
    [Count Of Expired TIPS]                   BIGINT          NULL,
    [Count OF Active TIPS With GPI]           BIGINT          NULL,
    [Count of 01 Optout patients]             BIGINT          NULL,
    [Count of 02 Optout patients]             BIGINT          NULL,
    [Count of 03 Optout patients]             BIGINT          NULL,
    [Count of 99 Optout patients]             BIGINT          NULL,
    [Count Of CMR Eligible patients]          BIGINT          NULL,
    [TIP Opportunites Per Active patients]    DECIMAL (18, 3) NULL,
    [Stage Load Date]                         DATE            DEFAULT (getdate()) NULL
);

