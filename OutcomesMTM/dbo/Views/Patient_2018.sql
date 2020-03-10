




CREATE VIEW [dbo].[Patient_2018]
AS


		select *
		from (
				select *, ranker = ROW_NUMBER() over (partition by t.patientid order by t.ActiveAsOf desc)
				from OutcomesMTM.dbo.PatientDim t
				where 1=1
				and Isnull(t.activeThru,getdate()) >'2018-01-01'
				and  t.ActiveAsOf < '2019-01-01'
                --or(t.activeThru is Null and t.activeThru >'2018-01-01' )
				
		) ptd
		where 1=1
		and ptd.ranker = 1



