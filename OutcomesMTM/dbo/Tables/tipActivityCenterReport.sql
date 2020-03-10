CREATE TABLE [dbo].[tipActivityCenterReport] (
    [tipActivityReportID]                         INT           IDENTITY (1, 1) NOT NULL,
    [tipresultstatuscenterID]                     INT           NULL,
    [tipresultstatusid]                           INT           NULL,
    [patientid]                                   INT           NULL,
    [centerid]                                    INT           NULL,
    [tipdetailid]                                 INT           NULL,
    [policyid]                                    INT           NULL,
    [tiptype]                                     VARCHAR (100) NULL,
    [30dayrule]                                   TINYINT       NULL,
    [TIP Opportunities]                           TINYINT       NULL,
    [TIP Activity]                                TINYINT       NULL,
    [Approved TIPs]                               TINYINT       NULL,
    [Pending Approval TIPs]                       TINYINT       NULL,
    [Review/resubmit TIPs]                        TINYINT       NULL,
    [Rejected TIPs]                               TINYINT       NULL,
    [Unfinished TIPs]                             TINYINT       NULL,
    [No intervention Necessary TIPs]              TINYINT       NULL,
    [Completed TIPs]                              TINYINT       NULL,
    [Successful TIPs]                             TINYINT       NULL,
    [Successful Approved TIPs]                    TINYINT       NULL,
    [Successful Pending Approval TIPs]            TINYINT       NULL,
    [Unsuccessful TIPs]                           TINYINT       NULL,
    [Prescriber Refusal TIPs]                     TINYINT       NULL,
    [Unable to reach prescriber after 3 attempts] TINYINT       NULL,
    [Patient Refusal TIPs]                        TINYINT       NULL,
    [Patient Unable to Reach TIPs]                TINYINT       NULL,
    [primaryPharmacy]                             TINYINT       NULL,
    [activeasof]                                  DATE          NULL,
    [activethru]                                  DATE          NULL,
    [currently active]                            INT           NULL,
    [withdrawn]                                   INT           NULL,
    [chainid]                                     INT           NULL,
    [Successful Paid TIPs]                        INT           DEFAULT ((0)) NOT NULL,
    [patientid_all]                               VARCHAR (50)  NULL,
    [policyname]                                  VARCHAR (100) NULL,
    [chainnm]                                     VARCHAR (50)  NULL,
    [centername]                                  VARCHAR (100) NULL,
    [ncpdp_nabp]                                  VARCHAR (50)  NULL,
    [parent_organization_id]                      VARCHAR (6)   NULL,
    [parent_organization_name]                    VARCHAR (35)  NULL,
    [relationship_id]                             VARCHAR (7)   NULL,
    [relationship_id_name]                        VARCHAR (35)  NULL,
    [relationship_type]                           VARCHAR (3)   NULL,
    [tiptitle]                                    VARCHAR (100) NULL,
    [expired]                                     BIT           NULL,
    CONSTRAINT [PK_tipActivityCenterReport] PRIMARY KEY CLUSTERED ([tipActivityReportID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [ind_centerid]
    ON [dbo].[tipActivityCenterReport]([centerid] ASC)
    INCLUDE([activeasof], [activethru]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_tipdetailid]
    ON [dbo].[tipActivityCenterReport]([tipdetailid] ASC)
    INCLUDE([activeasof], [activethru]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_tipresultstatuscenterid]
    ON [dbo].[tipActivityCenterReport]([tipresultstatuscenterID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_policyid_activeasof_activethru]
    ON [dbo].[tipActivityCenterReport]([policyid] ASC, [activeasof] ASC, [activethru] ASC) WITH (FILLFACTOR = 80);

