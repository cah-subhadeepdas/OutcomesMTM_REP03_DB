



CREATE VIEW [dbo].[Patient_2017]
AS


		select *
		from (
				select *, ranker = ROW_NUMBER() over (partition by ptd.patientid order by ptd.ActiveAsOf desc)
				from OutcomesMTM.dbo.PatientDim ptd
				where 1=1
				and ptd.ActiveThru > '2017-01-01'
				and ptd.ActiveAsOf < '2018-01-01'
		) ptd
		where 1=1
		and ptd.ranker = 1



