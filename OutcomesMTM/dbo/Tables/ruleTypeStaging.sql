CREATE TABLE [dbo].[ruleTypeStaging] (
    [ruletypeid] SMALLINT      NOT NULL,
    [ruletype]   VARCHAR (100) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[ruleTypeStaging]([ruletypeid] ASC);

