
/****** OBJECT:  VIEW [DBO].[VW_DAILYMTMOPPORTUNITIESFORCLIENT]   SCRIPT DATE: 6/15/2018 2:48:36 PM 
AUTHOR: VISHAL DESHMUKH
CREATED THIS VIEW FOR REQUEST TC-1763. THIS IS A GENERALIZED VIEW, SO THAT THIS CAN BE USED FOR SIMILAR REQUESTS WHEN RELATIONSHIPID'S ARE PROVIDED. 
THE VIEW VW_CLIENTMTMOPPORTUNITIESREPORT GIVES THE RESULT FOR DIFFERENT POLICES AND CENTERS.  ******/



CREATE VIEW  [DBO].[vw_DailyMtmOpportunities] 
as



SELECT       F.NABP AS NCPDP,
	         F.RELATIONSHIP_ID AS [RELATIONSHIP ID],
             F.RELATIONSHIP_ID_NAME AS [RELATIONSHIP NAME],
             F.PHARMACY_NAME AS [PHARMACY NAME],
             F.ADDRESS AS [ADDRESS],
             F.CITY AS [CITY],
             F.STATE AS [STATE],
             F.ZIPCODE AS [ZIP CODE],
             F.PHONE AS [PHONE],
             F.FAX AS [FAX],
             F.CONTRACTED AS [CONTRACTED],
             F.[TRAINED RPHS] AS [TRAINED RPHS],
             F.[TRAINED TECHS] AS [TRAINED TECHS],
             F.[TOTALPATIENTS] AS [TOTALPATIENTS] ,
             F.[TOTALPRIMARYPATIENTS] AS [TOTALPRIMARYPATIENTS],
             F.[TOTAL CMRS] AS [TOTAL CMRS],
			 F.[TOTAL PRIMARY CMRS] AS [TOTAL PRIMARY CMRS],
			 F.[CMRS SCHEDULED] AS [CMRS SCHEDULED],
			 F.[POTENTIAL CMR REVENUE] AS [POTENTIAL CMR REVENUE],
             F.[POTENTIAL CMR REVENUE PRIMARY] AS  [POTENTIAL CMR REVENUE PRIMARY],
             F.[TOTALTIPS] AS [TOTALTIPS],
             F.[TOTALPRIMARYTIPS] AS [TOTALPRIMARYTIPS],
             F.[POTENTIALTIPREVENUE] AS [POTENTIALTIPREVENUE],
             F.[POTENTIALTIPREVENUEPRIMARY] AS [POTENTIALTIPREVENUEPRIMARY],
             F.[UNFINISHED CLAIMS] AS [UNFINISHED CLAIMS],
             F.[REVIEW/RESUBMIT] AS [REVIEW/RESUBMIT],
             F.[QA ZONE] AS [QA ZONE],
             F.[DTP %] AS [DTP %],
             F.[6 MONTH CLAIM HISTORY] AS [6 MONTH CLAIM HISTORY]

      FROM
        (SELECT T.CENTERID,
                T.NABP,
                T.PHARMACY_NAME,
                T.PHARMACY_TYPE,
                T.ADDRESS,
                T.CITY,
                T.STATE,
                T.ZIPCODE,
                T.PHONE,
                T.FAX,
                T.CONTRACTED,
                T.RELATIONSHIP_ID,
                T.RELATIONSHIP_ID_NAME,
                AVG(T.[TRAINED RPHS]) AS [TRAINED RPHS],
                AVG(T.[TRAINED TECHS]) AS [TRAINED TECHS],
                SUM(T.[TOTALPATIENTS]) AS [TOTALPATIENTS],
                SUM(T.[TOTALPRIMARYPATIENTS]) AS [TOTALPRIMARYPATIENTS],
                SUM(T.[TOTAL CMRS]) AS [TOTAL CMRS],
                SUM(T.[POTENTIAL CMR REVENUE]) AS [POTENTIAL CMR REVENUE],
                SUM(T.[TOTAL PRIMARY CMRS]) AS [TOTAL PRIMARY CMRS],
                SUM(T.[POTENTIAL CMR REVENUE PRIMARY]) AS [POTENTIAL CMR REVENUE PRIMARY],
                SUM(T.[CMRS SCHEDULED]) AS [CMRS SCHEDULED],
                SUM(T.[TOTALTIPS]) AS [TOTALTIPS],
                SUM(T.[TOTALPRIMARYTIPS]) AS [TOTALPRIMARYTIPS],
                SUM(T.[POTENTIALTIPREVENUE]) AS [POTENTIALTIPREVENUE],
                SUM(T.[POTENTIALTIPREVENUEPRIMARY]) AS [POTENTIALTIPREVENUEPRIMARY],
                SUM(T.[UNFINISHED CLAIMS]) AS [UNFINISHED CLAIMS],
                SUM(T.[REVIEW/RESUBMIT]) AS [REVIEW/RESUBMIT],
                MAX(T.[QA ZONE]) AS [QA ZONE],
                MAX(T.[DTP %]) AS [DTP %],
                MAX(T.[6 MONTH CLAIM HISTORY]) AS [6 MONTH CLAIM HISTORY]
         FROM
           (SELECT M.CENTERID,
                   M.POLICYID,
                   M.[TRAINED RPHS],
                   M.[TRAINED TECHS],
                   M.[TOTALPATIENTS],
                   M.[TOTALPRIMARYPATIENTS],
                   M.[TOTAL CMRS],
                   M.[POTENTIAL CMR REVENUE],
                   M.[TOTAL PRIMARY CMRS],
                   M.[POTENTIAL CMR REVENUE PRIMARY],
                   M.[CMRS SCHEDULED],
                   M.[TOTALTIPS],
                   M.[TOTALPRIMARYTIPS],
                   M.[POTENTIALTIPREVENUE],
                   M.[POTENTIALTIPREVENUEPRIMARY],
                   M.[UNFINISHED CLAIMS],
                   M.[REVIEW/RESUBMIT],
                   M.[QA ZONE],
                   M.[DTP %],
                   M.[6 MONTH CLAIM HISTORY],
                   M.NABP,
                   M.PHARMACY_NAME,
                   M.PHARMACY_TYPE,
                   M.ADDRESS,
                   M.CITY,
                   M.STATE,
                   M.ZIPCODE,
                   M.PHONE,
                   M.FAX,
				   CASE WHEN M.CONTRACTED ='TRUE' THEN 1 ELSE 0 END AS CONTRACTED,
                   CONVERT(NVARCHAR(100),M. RELATIONSHIP_ID) AS RELATIONSHIP_ID ,
                   CONVERT(NVARCHAR(1000),M.RELATIONSHIP_ID_NAME) AS RELATIONSHIP_ID_NAME
            FROM OUTCOMESMTM.DBO.VW_CLIENTMTMOPPORTUNITIESREPORT M WITH (NOLOCK)
			WHERE 1=1
            ) T
         GROUP BY T.CENTERID,
                  T.NABP,
                  T.PHARMACY_NAME,
                  T.PHARMACY_TYPE,
                  T.ADDRESS,
                  T.CITY,
                  T.STATE,
                  T.ZIPCODE,
                  T.PHONE,
                  T.FAX,
                  T.CONTRACTED,
                  T.RELATIONSHIP_ID,
                  T.RELATIONSHIP_ID_NAME
) F


