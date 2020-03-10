CREATE TABLE [dbo].[ReportExtractLog] (
    [ReportExtractLogID] INT      IDENTITY (1, 1) NOT NULL,
    [ReportExtractID]    INT      NULL,
    [ReportRangeFromDT]  DATETIME NULL,
    [ReportRangeThruDT]  DATETIME NULL,
    [ReportRunStartDT]   DATETIME NULL,
    [ReportRunFinishDT]  DATETIME NULL,
    PRIMARY KEY CLUSTERED ([ReportExtractLogID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK__ReportExtractLog__ReportExtractID] FOREIGN KEY ([ReportExtractID]) REFERENCES [dbo].[ReportExtract] ([ReportExtractID]) ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX__ReportExtractLog__ReportExtractID__ReportRunStartDT__ReportRunFinishDT]
    ON [dbo].[ReportExtractLog]([ReportExtractID] ASC, [ReportRunStartDT] ASC, [ReportRunFinishDT] ASC)
    INCLUDE([ReportRangeFromDT], [ReportRangeThruDT]) WITH (FILLFACTOR = 80);

