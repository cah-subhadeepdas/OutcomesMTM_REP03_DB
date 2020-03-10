


CREATE     procedure [cms].[I_SnapshotTracker] @DataSetTypeID int, @ClientID int , @ContractYear int
as

IF NOT EXISTS ( 
	SELECT * FROM [cms].[CMS_SnapshotTracker] 
	WHERE		  [DataSetTypeID] = @DataSetTypeID 
	AND			  [ClientID] = @ClientID
	AND			  [ContractYear] = @ContractYear
	AND			YEAR([ActiveThruDT]) = 9999
	)

		INSERT INTO [cms].[CMS_SnapshotTracker]
           (
				[DataSetTypeID]
           ,	[ClientID]
           ,	[ContractYear]
            )
		VALUES
           (	@DataSetTypeID
           ,	@ClientID
           ,	@ContractYear
            )

       


