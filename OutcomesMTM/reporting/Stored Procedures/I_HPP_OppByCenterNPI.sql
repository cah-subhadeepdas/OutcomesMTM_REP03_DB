


CREATE   PROCEDURE reporting.[I_HPP_OppByCenterNPI]
AS
BEGIN

    TRUNCATE TABLE [dbo].[HPP_OpportunitiesByCenter_WO_NPI]
    INSERT INTO [dbo].[HPP_OpportunitiesByCenter_WO_NPI]
    (
        [NCPDP],
        [NPI],
        [RELATIONSHIP ID],
        [RELATIONSHIP NAME],
        [PHARMACY NAME],
        [PHARMACY TYPE],
        [ADDRESS],
        [CITY],
        [STATE],
        [ZIP CODE],
        [PHONE],
        [FAX],
        [CONTRACTED],
        [TRAINED RPHS],
        [TOTALPATIENTS],
        [TOTALPRIMARYPATIENTS],
        [TOTAL CMR OPPORTUNITIES],
        [TOTAL PRIMARY CMR OPPORTUNITIES],
        [CMRS SCHEDULED],
        [TIP OPPORTUNITIES],
        [PRIMARY TIP OPPORTUNITIES],
        [UNFINISHED CLAIMS],
        [REVIEW RESUBMIT],
        [Loaddate]
    )
    SELECT replace(replace(replace([NCPDP],char(9),''),char(10),''),char(13),'') AS [NCPDP],
           replace(replace(replace(ph.NPI,char(9),''),char(10),''),char(13),'') AS [NPI],
           replace(replace(replace([RELATIONSHIP ID],char(9),''),char(10),''),char(13),'') AS [RELATIONSHIP ID],
           replace(replace(replace([RELATIONSHIP NAME],char(9),''),char(10),''),char(13),'') AS [RELATIONSHIP NAME],
           replace(replace(replace([PHARMACY NAME],char(9),''),char(10),''),char(13),'') AS [PHARMACY NAME],
           replace(replace(replace([PHARMACY TYPE],char(9),''),char(10),''),char(13),'') AS [PHARMACY TYPE],
           replace(replace(replace([ADDRESS],char(9),''),char(10),''),char(13),'') AS [ADDRESS],
           replace(replace(replace([CITY],char(9),''),char(10),''),char(13),'') AS [CITY],
           replace(replace(replace([STATE],char(9),''),char(10),''),char(13),'') AS [STATE],
           replace(replace(replace([ZIP CODE],char(9),''),char(10),''),char(13),'') AS [ZIP CODE],
           replace(replace(replace(ph.PHONE,char(9),''),char(10),''),char(13),'') AS [PHONE],
           replace(replace(replace(ph.FAX,char(9),''),char(10),''),char(13),'') AS [FAX],
           replace(replace(replace(ph.contracted,char(9),''),char(10),''),char(13),'') AS [CONTRACTED],
           replace(replace(replace([TRAINED RPHS],char(9),''),char(10),''),char(13),'') AS [TRAINED RPHS],
           replace(replace(replace([TOTALPATIENTS],char(9),''),char(10),''),char(13),'') AS [TOTALPATIENTS],
           replace(replace(replace([TOTALPRIMARYPATIENTS],char(9),''),char(10),''),char(13),'') AS [TOTALPRIMARYPATIENTS],
           replace(replace(replace([TOTAL CMR OPPORTUNITIES],char(9),''),char(10),''),char(13),'') AS [TOTAL CMR OPPORTUNITIES],
           replace(replace(replace([TOTAL PRIMARY CMR OPPORTUNITIES],char(9),''),char(10),''),char(13),'') AS [TOTAL PRIMARY CMR OPPORTUNITIES],
           replace(replace(replace([CMRS SCHEDULED],char(9),''),char(10),''),char(13),'') AS [CMRS SCHEDULED],
           replace(replace(replace([TIP OPPORTUNITIES],char(9),''),char(10),''),char(13),'') AS [TIP OPPORTUNITIES],
           replace(replace(replace([PRIMARY TIP OPPORTUNITIES],char(9),''),char(10),''),char(13),'') AS [PRIMARY TIP OPPORTUNITIES],
           replace(replace(replace([UNFINISHED CLAIMS],char(9),''),char(10),''),char(13),'') AS [UNFINISHED CLAIMS],
           replace(replace(replace([REVIEW RESUBMIT],char(9),''),char(10),''),char(13),'') AS [REVIEW RESUBMIT],
           Loaddate = GETDATE()
    FROM [staging].[HPP_OpportunitiesByCenter_WO_NPI] stg
        LEFT JOIN OutcomesMTM.dbo.pharmacy ph
            ON RIGHT('0000000' + stg.ncpdp, 7) = RIGHT('0000000' + RTRIM(ph.NCPDP_NABP), 7)
    WHERE 1 = 1;
END;


