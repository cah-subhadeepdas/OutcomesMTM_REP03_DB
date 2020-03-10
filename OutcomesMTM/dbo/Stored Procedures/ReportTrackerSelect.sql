create procedure dbo.ReportTrackerSelect
as

begin

SELECT [JobID]
      ,[JobName]
      ,[LastRunDateTime]
      ,[LastRunStatus]
      ,[LastRunDuration (HH:MM:SS)]
      ,[LastRunStatusMessage]
      ,[NextRunDateTime]
  FROM [Maintenance].[dbo].[ReportTracker]
order by LastRunStatus asc

end 