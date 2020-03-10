CREATE TABLE [dbo].[claimMedication] (
    [claimMedicationID]     INT           NOT NULL,
    [claimID]               INT           NOT NULL,
    [claimMedicationTypeID] INT           NOT NULL,
    [productName]           VARCHAR (300) NOT NULL,
    [gpi]                   VARCHAR (100) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [NC_claimMedication_claimid]
    ON [dbo].[claimMedication]([claimID] ASC);

