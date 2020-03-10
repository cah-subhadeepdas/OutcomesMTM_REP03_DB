






CREATE VIEW [dbo].[Patient_2016]
AS


		select *
		from (
				select *, ranker = ROW_NUMBER() over (partition by ptd.patientid order by ptd.ActiveAsOf desc)
				from OutcomesMTM.dbo.PatientDim ptd with (nolock)
				where 1=1
				and ptd.ActiveThru > '2016-01-01'
				and ptd.ActiveAsOf < '2017-01-01'
				 and year(OutcomesEligibilityDate)='2016'
		) ptd
		where 1=1
		and ptd.ranker = 1



