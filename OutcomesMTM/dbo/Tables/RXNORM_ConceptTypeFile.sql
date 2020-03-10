CREATE TABLE [dbo].[RXNORM_ConceptTypeFile] (
    [rxxcncptid]      INT          IDENTITY (1, 1) NOT NULL,
    [fileid]          INT          NOT NULL,
    [concept_type_id] INT          NOT NULL,
    [transaction_cd]  VARCHAR (1)  NULL,
    [description]     VARCHAR (34) NULL,
    [reserve]         VARCHAR (24) NULL,
    [Active]          BIT          NOT NULL,
    [CreateDate]      DATETIME     CONSTRAINT [DF__RXNORM_ConceptTypeFile__CreateDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [UNC__RXNORM_ConceptTypeFile__fileid__concept_type_id] UNIQUE NONCLUSTERED ([fileid] ASC, [concept_type_id] ASC)
);

