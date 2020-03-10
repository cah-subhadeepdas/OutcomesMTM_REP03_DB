



CREATE PROCEDURE [dbo].[S_ApprovalReportEligibilityMonthly]
AS
BEGIN

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @currentDate DATE=GETDATE()
	,@startDate DATE

	SELECT @startdate=DATEADD(MONTH, -11, DATEADD(MM, DATEDIFF(MM, 0, @currentDate), 0))

	DECLARE @tblDateList TABLE
	(
		monthDate DATE
	);
	WITH cteDateList AS
	(
		SELECT @startdate AS monthDate
		UNION ALL
		SELECT DATEADD(MONTH, 1, monthDate) AS monthDate
		FROM cteDateList
		WHERE DATEADD(MONTH, 1, monthDate) <= @currentDate
	)

	INSERT INTO @tblDateList
	SELECT monthDate
	FROM cteDateList

	INSERT INTO @tblDateList
	SELECT @currentDate
	WHERE NOT EXISTS
	(
		SELECT monthDate
		FROM @tblDateList
		WHERE monthDate=@currentDate
	)

	SELECT 3 AS outcomesSystemID
	,pt.PolicyID
	,dl.monthDate
	,CASE WHEN CAST(ISNULL(pt.plantermdate, '99991231') AS DATE) > dl.monthDate
		 THEN 1
		 ELSE 0
	 END AS planActive
	,COUNT(DISTINCT pt.PatientID) AS patientCount
	FROM @tblDateList AS dl
	JOIN outcomesMTM.dbo.patientDim AS pt ON dl.monthDate BETWEEN pt.activeAsOf AND ISNULL(pt.activeThru, dl.monthDate)
	GROUP BY pt.PolicyID
	,dl.monthDate
	,CASE WHEN CAST(ISNULL(pt.plantermdate, '99991231') AS DATE) > dl.monthDate
		 THEN 1
		 ELSE 0
	 END

END



