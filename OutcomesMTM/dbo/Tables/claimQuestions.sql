CREATE TABLE [dbo].[claimQuestions] (
    [claimQuestionId] INT           NOT NULL,
    [reasonTypeId]    INT           NOT NULL,
    [actionTypeId]    INT           NOT NULL,
    [resultTypeId]    INT           NOT NULL,
    [question]        VARCHAR (255) NOT NULL,
    [questionType]    VARCHAR (20)  NOT NULL,
    [answerList]      VARCHAR (511) NULL,
    [tipOnly]         BIT           NULL,
    [activeAsOf]      DATE          NOT NULL,
    [activeThru]      DATE          NULL,
    [sortOrder]       INT           NOT NULL,
    [groupId]         INT           NULL,
    CONSTRAINT [claim_question_id_pk] PRIMARY KEY CLUSTERED ([claimQuestionId] ASC)
);

