CREATE TABLE [staging].[roleType] (
    [roleTypeID]     INT           NOT NULL,
    [roleTypeNM]     VARCHAR (200) NOT NULL,
    [roleTypeDesc]   VARCHAR (500) NULL,
    [createDT]       DATE          NOT NULL,
    [createBy]       VARCHAR (200) NOT NULL,
    [modDT]          DATE          NULL,
    [modBy]          VARCHAR (200) NULL,
    [active]         BIT           NOT NULL,
    [Display]        BIT           NOT NULL,
    [internal]       BIT           NOT NULL,
    [roleTypeTypeID] INT           NULL
);

