






CREATE VIEW [dbo].[Patient_2019_Test]
AS


		SELECT *
		FROM (
				SELECT *, ranker = ROW_NUMBER() OVER (PARTITION BY t.patientid ORDER BY t.ActiveAsOf DESC)
				FROM OutcomesMTM.dbo.PatientDim t
				WHERE 1=1
				AND ISNULL(t.activeThru,GETDATE()) >= '2019-11-01'
				AND  t.ActiveAsOf < '2020-01-01'
                --or(t.activeThru is Null and t.activeThru >'2018-01-01' )
				
		) ptd
		WHERE 1=1
		AND ptd.ranker = 1



