CREATE TABLE [dbo].[serviceTypeStaging] (
    [serviceTypeID] SMALLINT     NOT NULL,
    [serviceType]   VARCHAR (50) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[serviceTypeStaging]([serviceTypeID] ASC);

