CREATE TABLE [staging].[ZZ_TempPatientIDKeep_20180226] (
    [patientid] INT NOT NULL
);


GO
CREATE CLUSTERED INDEX [cl_pid]
    ON [staging].[ZZ_TempPatientIDKeep_20180226]([patientid] ASC);

