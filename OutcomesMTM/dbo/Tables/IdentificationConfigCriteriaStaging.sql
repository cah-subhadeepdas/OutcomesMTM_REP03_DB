CREATE TABLE [dbo].[IdentificationConfigCriteriaStaging] (
    [IdentificationConfigCriteriaID] INT             NOT NULL,
    [IdentificationConfigID]         INT             NOT NULL,
    [DxMinCount]                     INT             NULL,
    [RxGPIlength]                    INT             NULL,
    [RxLookbackbyMonth]              INT             NULL,
    [RxMinCount]                     INT             NULL,
    [RxCostLookbackbyMonth]          INT             NULL,
    [RxCost]                         DECIMAL (20, 2) NULL,
    [TipMinCount]                    INT             NULL,
    [FrequencybyMonth]               INT             NULL,
    [ageDependent]                   BIT             NULL,
    [minAge]                         TINYINT         NULL,
    [maxAge]                         TINYINT         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[IdentificationConfigCriteriaStaging]([IdentificationConfigCriteriaID] ASC);

