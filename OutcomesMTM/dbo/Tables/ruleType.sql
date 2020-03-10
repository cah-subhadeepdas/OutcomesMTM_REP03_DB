CREATE TABLE [dbo].[ruleType] (
    [ruletypeid] SMALLINT      NOT NULL,
    [ruletype]   VARCHAR (100) NULL,
    CONSTRAINT [PK_ruletype] PRIMARY KEY CLUSTERED ([ruletypeid] ASC) WITH (FILLFACTOR = 80)
);

