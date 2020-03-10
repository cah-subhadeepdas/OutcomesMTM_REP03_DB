CREATE TABLE [dbo].[claimQuestionAnswers] (
    [claimQuestionAnswerId] INT           NOT NULL,
    [claimId]               INT           NOT NULL,
    [claimQuestionId]       INT           NOT NULL,
    [answer]                VARCHAR (511) NULL,
    CONSTRAINT [claim_question_answer_id_pk] PRIMARY KEY CLUSTERED ([claimQuestionAnswerId] ASC)
);

