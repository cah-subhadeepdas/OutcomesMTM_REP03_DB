CREATE TABLE [dbo].[MTMOpportunitiesReportRank] (
    [MTMOpportunitiesReportRankID] INT NOT NULL,
    [patientid]                    INT NULL,
    [centerid]                     INT NULL,
    [Rank]                         INT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_MTMOpportunitiesReportRank_patientID_centerID]
    ON [dbo].[MTMOpportunitiesReportRank]([patientid] ASC, [centerid] ASC);

