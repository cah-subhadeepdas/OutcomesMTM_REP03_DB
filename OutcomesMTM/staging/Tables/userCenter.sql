CREATE TABLE [staging].[userCenter] (
    [userCenterID]     INT  NOT NULL,
    [userID]           INT  NOT NULL,
    [centerID]         INT  NOT NULL,
    [requestDT]        DATE NOT NULL,
    [approved]         BIT  NOT NULL,
    [approvedDT]       DATE NULL,
    [approvedByUserID] INT  NULL,
    [active]           BIT  NOT NULL,
    [Rejected]         BIT  NOT NULL,
    [RejectedDT]       DATE NULL,
    [Selected]         BIT  NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_UserCenter_UserCenterID]
    ON [staging].[userCenter]([userCenterID] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_UserCenter_userID_centerID_approved_active_selected]
    ON [staging].[userCenter]([userID] ASC, [centerID] ASC, [approved] ASC, [active] ASC, [Selected] ASC);

