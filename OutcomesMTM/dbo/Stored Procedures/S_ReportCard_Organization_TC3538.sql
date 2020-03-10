

CREATE     proc [dbo].[S_ReportCard_Organization_TC3538] 
as 
begin 

DECLARE @BEGIN datetime2(3)
DECLARE @end datetime2(3)


--SET @BEGIN = CAST(case when month(getdate()) = 1 then cast(year(getdate()) - 1 as varchar(4)) + '0101' else cast(year(getdate()) as varchar(4)) + '0101' end as DATE) --// Beginning of year (if current month is Jan. then beginning of last year)
--SET @end =  cast(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as date)	 		--end of last month 


set @BEGIN = '2019-01-01 00:00:00.000'
set @end = '2019-12-31 23:59:59.599'



---------------------------------------------------------------------------------------------------------
--------------------------CHAINS
---------------------------------------------------------------------------------------------------------
--Below temp table was provided by Network Performance

drop table if exists #chainRollUp
create table #chainRollUp 
(
	ID int identity (1,1) primary key
	, Preferred int
	, [Organization Category Size] int
	, [Organization Name] varchar(100)
	, RelationshipID varchar(50)
	, NABP varchar(50)
)

insert into #chainrollup select 0,5,'A S MEDICATION SOLUTIONS LLC','702',NULL
insert into #chainrollup select 0,3,'ACCREDO HEALTH GROUP INC','392',NULL
insert into #chainrollup select 0,3,'Acme Pharmacies','260',NULL
insert into #chainrollup select 0,3,'ADVANCED HOME CARE INC','B44',NULL
insert into #chainrollup select 0,5,'ADVANCED RX MANAGEMENT','A93',NULL
insert into #chainrollup select 1,2,'Ahold Delhaize','233',NULL
insert into #chainrollup select 1,2,'Ahold Delhaize','862',NULL
insert into #chainrollup select 1,2,'Ahold Delhaize','289',NULL
insert into #chainrollup select 1,2,'Ahold Delhaize','415',NULL
insert into #chainrollup select 1,2,'Ahold Delhaize','075',NULL
insert into #chainrollup select 1,2,'Ahold USA','289',NULL
insert into #chainrollup select 1,2,'Ahold USA','415',NULL
insert into #chainrollup select 1,2,'Ahold USA','075',NULL
insert into #chainrollup select 0,3,'AHS-St. John Pharmacy','671',NULL
insert into #chainrollup select 0,3,'AIDS HEALTHCARE FOUNDATION','A23',NULL
insert into #chainrollup select 1,1,'Albertsons','929',NULL
insert into #chainrollup select 1,1,'Albertsons','003',NULL
insert into #chainrollup select 1,1,'Albertsons','NULL','999572'
insert into #chainrollup select 1,1,'Albertsons','NULL','999573'
insert into #chainrollup select 1,1,'Albertsons','NULL','999574'
insert into #chainrollup select 1,1,'Albertsons','156',NULL
insert into #chainrollup select 1,1,'Albertsons','301',NULL
insert into #chainrollup select 1,1,'Albertsons','B62',NULL
insert into #chainrollup select 1,1,'Albertsons','158',NULL
insert into #chainrollup select 1,1,'Albertsons','227',NULL
insert into #chainrollup select 1,1,'Albertsons','282',NULL
insert into #chainrollup select 1,1,'Albertsons','027',NULL
insert into #chainrollup select 1,1,'Albertsons','400',NULL
insert into #chainrollup select 1,1,'Albertsons','NULL','999507'
insert into #chainrollup select 1,1,'Albertsons','NULL','999511'
insert into #chainrollup select 1,1,'Albertsons','NULL','999512'
insert into #chainrollup select 1,1,'Albertsons','NULL','999517'
insert into #chainrollup select 1,1,'Albertsons','C08',NULL
insert into #chainrollup select 1,1,'Albertsons','319',NULL
insert into #chainrollup select 1,1,'Albertsons','C31',NULL
insert into #chainrollup select 0,3,'ALEGENT RETAIL PHARMACIES','A47',NULL
insert into #chainrollup select 0,3,'ALLINA COMMUNITY PHARMACIES','799',NULL
insert into #chainrollup select 0,3,'AMBIENT HEALTHCARE INC','B18',NULL
insert into #chainrollup select 0,4,'American Pharmacy Network Solutions','841',NULL
insert into #chainrollup select 0,3,'AMERITA INC','969',NULL
insert into #chainrollup select 0,3,'APPALACHIAN REG HLTH CARE','492',NULL
insert into #chainrollup select 0,4,'Arete Pharmacy','712',NULL
insert into #chainrollup select 0,4,'Arete Pharmacy','941',NULL
insert into #chainrollup select 0,4,'Arete Pharmacy','967',NULL
insert into #chainrollup select 0,4,'Arete Pharmacy','678',NULL
insert into #chainrollup select 0,4,'Arete Pharmacy','783',NULL
insert into #chainrollup select 0,4,'Arete Pharmacy','426',NULL
insert into #chainrollup select 0,3,'ASSOCIATED FRESH MARKET INC','A34',NULL
insert into #chainrollup select 0,3,'ASTRUP DRUG INC','634',NULL
insert into #chainrollup select 0,3,'Aurora Pharmacy','832',NULL
insert into #chainrollup select 0,3,'Balls Food Stores','490',NULL
insert into #chainrollup select 0,3,'Bartell Drugs','011',NULL
insert into #chainrollup select 0,3,'Baystate Health','719',NULL
insert into #chainrollup select 0,3,'BIG Y FOODS INC','835',NULL
insert into #chainrollup select 0,3,'Bi-Mart','048',NULL
insert into #chainrollup select 0,3,'BioRx','A78',NULL
insert into #chainrollup select 0,3,'BRIOVARX LLC','951',NULL
insert into #chainrollup select 0,3,'BROCKIE HEALTHCARE INC','538',NULL
insert into #chainrollup select 0,3,'Brookshire Brothers','463',NULL
insert into #chainrollup select 0,3,'Brookshire Grocery Co.','453',NULL
insert into #chainrollup select 0,4,'Cardinal Health','603',NULL
insert into #chainrollup select 0,4,'Cardinal Health','A51',NULL
insert into #chainrollup select 0,4,'Cardinal Health','931',NULL
insert into #chainrollup select 0,4,'Cardinal Health','139',NULL
insert into #chainrollup select 0,4,'Cardinal Health','307',NULL
insert into #chainrollup select 0,4,'Cardinal Health','C16',NULL
insert into #chainrollup select 0,4,'Cardinal Health LeaderNET','603',NULL
insert into #chainrollup select 0,4,'Cardinal Health LeaderNET','A51',NULL
insert into #chainrollup select 0,4,'Cardinal Health Managed Care Connection','931',NULL
insert into #chainrollup select 0,4,'Cardinal Health Medicap/Medicine Shoppe','139',NULL
insert into #chainrollup select 0,4,'Cardinal Health Medicap/Medicine Shoppe','307',NULL
insert into #chainrollup select 0,3,'Central Dakota Pharmacys','903',NULL
insert into #chainrollup select 0,3,'CHEROKEE NATION HEALTH SERVICES PHA','B17',NULL
insert into #chainrollup select 0,3,'CHICKASAW NATION DIVISION OF HEALTH','B07',NULL
insert into #chainrollup select 0,3,'Choctaw Nation Healthcare','A11',NULL
insert into #chainrollup select 0,3,'CIGNA MEDICAL GROUP PHARMACY','946',NULL
insert into #chainrollup select 0,3,'CLEVELAND CLINIC PHARMACIES','A45',NULL
insert into #chainrollup select 0,3,'CMC RX STEELE CREEK','A66',NULL
insert into #chainrollup select 0,3,'Coborns Inc.','703',NULL
insert into #chainrollup select 0,3,'Collier Drug Stores','A84',NULL
insert into #chainrollup select 0,3,'COLONIAL MANAGEMENT GROUP LP','992',NULL
insert into #chainrollup select 0,3,'COMMUNITY HEALTH CENTERS INC','B23',NULL
insert into #chainrollup select 0,3,'Community Health Systems','A26',NULL
insert into #chainrollup select 0,5,'Community Independent Pharmacy Network','A96',NULL
insert into #chainrollup select 0,NULL,'COMPLETE CLAIMS PROCESSING INC','A06',NULL
insert into #chainrollup select 0,3,'CONCORD INC','954',NULL
insert into #chainrollup select 0,3,'COOK COUNTY','B04',NULL
insert into #chainrollup select 0,5,'COOPHARMA','942',NULL
insert into #chainrollup select 0,3,'CORAM LLC','863',NULL
insert into #chainrollup select 0,2,'Costco','299',NULL
insert into #chainrollup select 0,3,'COUNTY OF LOS ANGELES DEPARTMENT OF','B45',NULL
insert into #chainrollup select 0,3,'CRESCENT HEALTHCARE','833',NULL
insert into #chainrollup select 0,3,'CRITICAL CARE SYSTEMS','911',NULL
insert into #chainrollup select 0,1,'CVS Pharmacy','NULL','999104'
insert into #chainrollup select 0,1,'CVS Pharmacy','NULL','999818'
insert into #chainrollup select 0,1,'CVS Pharmacy','NULL','999682'
insert into #chainrollup select 0,1,'CVS Pharmacy','NULL','999690'
insert into #chainrollup select 0,1,'CVS Pharmacy','NULL','999689'
insert into #chainrollup select 0,1,'CVS Pharmacy','NULL','999688'
insert into #chainrollup select 0,1,'CVS Pharmacy','177',NULL
insert into #chainrollup select 0,1,'CVS Pharmacy','123',NULL
insert into #chainrollup select 0,1,'CVS Pharmacy','039',NULL
insert into #chainrollup select 0,1,'CVS Pharmacy','782',NULL
insert into #chainrollup select 0,1,'CVS Pharmacy','608',NULL
insert into #chainrollup select 0,1,'CVS Pharmacy','207',NULL
insert into #chainrollup select 0,1,'CVS Pharmacy','673',NULL
insert into #chainrollup select 0,1,'CVS Pharmacy','380',NULL
insert into #chainrollup select 0,1,'CVS Pharmacy','008',NULL
insert into #chainrollup select 0,3,'Dallas Metrocare Services','791',NULL
insert into #chainrollup select 1,3,'Delhaize','233',NULL
insert into #chainrollup select 1,3,'Delhaize','862',NULL
insert into #chainrollup select 0,3,'Denver Health and Hospital Authority','A80',NULL
insert into #chainrollup select 0,2,'DEPT OF VETERANS AFFAIRS','869',NULL
insert into #chainrollup select 0,3,'DIERBERGS PHARMACY','332',NULL
insert into #chainrollup select 0,3,'Discount Drug Mart','044',NULL
insert into #chainrollup select 0,3,'DMVA PHARMACIES','B15',NULL
insert into #chainrollup select 0,3,'DOCTORS CHOICE PHARMACIES','713',NULL
insert into #chainrollup select 0,2,'DOD PHARMACO ECONOMIC CENTER','781',NULL
insert into #chainrollup select 0,NULL,'DRDISPENSE','A28',NULL
insert into #chainrollup select 0,3,'DSHS PHARMACIES','A02',NULL
insert into #chainrollup select 0,3,'Eaton Apothecary','055',NULL
insert into #chainrollup select 0,4,'Elevate Provider Network','638',NULL
insert into #chainrollup select 0,4,'Elevate Provider Network','904',NULL
insert into #chainrollup select 0,4,'Elevate Provider Network','626',NULL
insert into #chainrollup select 0,3,'Emblem Health','271',NULL
insert into #chainrollup select 0,4,'EPIC Pharmacy Network','455',NULL
insert into #chainrollup select 0,3,'ESKENAZI HEALTH','689',NULL
insert into #chainrollup select 0,3,'Essentia Health','573',NULL
insert into #chainrollup select 0,3,'FAIRVIEW HEALTH SERVICES','705',NULL
insert into #chainrollup select 0,3,'Fairview Pharmacy Services','898',NULL
insert into #chainrollup select 0,3,'Family Pharmacy','511',NULL
insert into #chainrollup select 0,3,'FARMACIAS PLAZA','843',NULL
insert into #chainrollup select 0,5,'FIRST COAST HEALTH SOLUTIONS','B30',NULL
insert into #chainrollup select 0,3,'Fitzgeralds','795',NULL
insert into #chainrollup select 0,3,'FLORIDA HEALTH CARE PLAN INC','B49',NULL
insert into #chainrollup select 0,2,'frednulls Pharmacy','345',NULL
insert into #chainrollup select 0,2,'frednulls Pharmacy','934',NULL
insert into #chainrollup select 0,3,'Fruth Pharmacy','325',NULL
insert into #chainrollup select 0,3,'Genoa Healthcare','945',NULL
insert into #chainrollup select 0,5,'GERIMED LTC NETWORK INC','913',NULL
insert into #chainrollup select 0,3,'GEROULDS PROFESSIONAL PHARMACY INC','A58',NULL
insert into #chainrollup select 0,2,'Giant Eagle','NULL','999650'
insert into #chainrollup select 0,2,'Giant Eagle','248',NULL
insert into #chainrollup select 0,3,'GOOD DAY PHARMACY','997',NULL
insert into #chainrollup select 0,3,'GROUP HEALTH COOPERATIVE','510',NULL
insert into #chainrollup select 0,3,'H AND H DRUG STORES INC','828',NULL
insert into #chainrollup select 0,3,'HARMONS CITY INC','610',NULL
insert into #chainrollup select 0,3,'Harps Food Stores','417',NULL
insert into #chainrollup select 0,3,'HARRIS COUNTY HOSPITAL DISTRICT','963',NULL
insert into #chainrollup select 0,3,'HARTIG DRUG CO CORP','087',NULL
insert into #chainrollup select 0,3,'HARVARD VANGUARD MEDICAL ASSOCIATES','427',NULL
insert into #chainrollup select 0,4,'Health Mart Atlas','605',NULL
insert into #chainrollup select 0,4,'Health Mart Atlas','630',NULL
insert into #chainrollup select 0,4,'Health Mart Atlas','841',NULL
insert into #chainrollup select 0,3,'Health Partners','639',NULL
insert into #chainrollup select 1,2,'HEB Pharmacy','025',NULL
insert into #chainrollup select 0,3,'Henry Ford Health System','655',NULL
insert into #chainrollup select 0,3,'Hi-School Pharmacy','092',NULL
insert into #chainrollup select 0,3,'HOME CHOICE PARTNERS INC','A38',NULL
insert into #chainrollup select 0,3,'Homeland Pharmacy','309',NULL
insert into #chainrollup select 0,3,'Horton & Converse','094',NULL
insert into #chainrollup select 0,3,'Humana Pharmacy','A71',NULL
insert into #chainrollup select 1,2,'Hy-Vee','097',NULL
insert into #chainrollup select 0,3,'I.H.S.','842',NULL
insert into #chainrollup select 0,3,'I.H.S.','860',NULL
insert into #chainrollup select 0,3,'I.H.S.','865',NULL
insert into #chainrollup select 0,3,'I.H.S.','875',NULL
insert into #chainrollup select 0,3,'I.H.S.','877',NULL
insert into #chainrollup select 0,3,'I.H.S.','906',NULL
insert into #chainrollup select 0,3,'I.H.S.','907',NULL
insert into #chainrollup select 0,3,'I.H.S.','908',NULL
insert into #chainrollup select 0,3,'I.H.S.','918',NULL
insert into #chainrollup select 0,3,'IHC Pharmacy Services','695',NULL
insert into #chainrollup select 0,3,'INFUSION PARTNERS INC','A03',NULL
insert into #chainrollup select 0,3,'Ingles Market Pharmacy','822',NULL
insert into #chainrollup select 0,5,'INJURY RX LLC','A68',NULL
insert into #chainrollup select 0,5,'INNOVATIX NETWORK LLC','915',NULL
insert into #chainrollup select 0,5,'INNOVATIX NETWORK LLC','A00',NULL
insert into #chainrollup select 0,5,'INSTY MEDS','872',NULL
insert into #chainrollup select 0,3,'INTEGRIS PROHEALTH PHARMACY','B50',NULL
insert into #chainrollup select 0,3,'JORDAN DRUG INC','801',NULL
insert into #chainrollup select 0,3,'JPS Health Outpatient Pharmacies','B01',NULL
insert into #chainrollup select 0,NULL,'JRX','A91',NULL
insert into #chainrollup select 0,3,'KAISER FOUNDATION HEALTH PLAN MIDAT','A85',NULL
insert into #chainrollup select 0,3,'KAISER FOUNDATION HEALTH PLAN OF GE','A27',NULL
insert into #chainrollup select 0,3,'KAISER PERMANENTE NCAL','917',NULL
insert into #chainrollup select 0,3,'KAISER PERMANENTE SCAL','916',NULL
insert into #chainrollup select 0,3,'KING KULLEN PHARMACY CORP','280',NULL
insert into #chainrollup select 0,3,'Kinney Drugs, Inc.','109',NULL
insert into #chainrollup select 0,3,'Klingensmiths Drug Stores','499',NULL
insert into #chainrollup select 0,2,'Kmart','110',NULL
insert into #chainrollup select 0,3,'Kohlls Pharmacies','481',NULL
insert into #chainrollup select 0,3,'KS Management Services','635',NULL
insert into #chainrollup select 0,3,'K-VA-T Food Stores','687',NULL
insert into #chainrollup select 0,3,'LINCARE INC','977',NULL
insert into #chainrollup select 0,3,'LINS PHARMACY','A86',NULL
insert into #chainrollup select 0,3,'LOMA LINDA UNIV MED CTR','804',NULL
insert into #chainrollup select 0,3,'M K Stores, Inc. d/b/a Snyder Pharmacy','527',NULL
insert into #chainrollup select 0,3,'MACEYS INC','A64',NULL
insert into #chainrollup select 0,3,'Manatee County Rural Health Services','899',NULL
insert into #chainrollup select 0,3,'Marcnulls Pharmacy','441',NULL
insert into #chainrollup select 0,3,'MARICOPA INTEGRATED HEALTH SYSTEM','930',NULL
insert into #chainrollup select 0,3,'MARKET BASKET PHARMACIES','544',NULL
insert into #chainrollup select 0,3,'Marshfield clinic','526',NULL
insert into #chainrollup select 0,3,'Martins Supermarkets','846',NULL
insert into #chainrollup select 0,3,'Maxor National Pharmacy Services','516',NULL
insert into #chainrollup select 0,5,'Maxor Xpress','A72',NULL
insert into #chainrollup select 0,3,'Mayo Clinic Health System Pharmacy and Home Medical','847',NULL
insert into #chainrollup select 0,3,'MAYO CLINIC PHARMACY','B08',NULL
insert into #chainrollup select 0,3,'MCHUGH','B20',NULL
insert into #chainrollup select 0,5,'MDS RX','B10',NULL
insert into #chainrollup select 0,3,'Med-Fast Pharmacy','682',NULL
insert into #chainrollup select 0,3,'MEDICINE CHEST PHARMACIES','924',NULL
insert into #chainrollup select 0,5,'MEDX SALES','A31',NULL
insert into #chainrollup select 0,2,'Meijer','213',NULL
insert into #chainrollup select 0,3,'MEMORIAL HEALTHCARE SYSTEM PHARMACI','B48',NULL
insert into #chainrollup select 0,3,'MERCY HEALTH SYSTEM RETAIL PHCY','840',NULL
insert into #chainrollup select 0,3,'Mercy Pharmacy','709',NULL
insert into #chainrollup select 0,4,'MHA Long Term Care Network','905',NULL
insert into #chainrollup select 0,3,'MULTICARE OUTPATIENT PHARMACIES','B14',NULL
insert into #chainrollup select 0,3,'Muscogee Creek Nation Health System','680',NULL
insert into #chainrollup select 0,5,'NATIONS PHARMACEUTICALS LLC','A19',NULL
insert into #chainrollup select 0,5,'NCPRX','B13',NULL
insert into #chainrollup select 0,3,'NE OH NEIGHBORHOOD HEALTH SRVS','746',NULL
insert into #chainrollup select 0,3,'NEW ENGLAND HOME THERAPIES','A25',NULL
insert into #chainrollup select 0,3,'NORTHSIDE PHARMACY','770',NULL
insert into #chainrollup select 0,3,'NYS OFFICE OF MENTAL HEALTH','953',NULL
insert into #chainrollup select 0,3,'OMHSAS BUREAU HOSP OPERATIONS DPW','920',NULL
insert into #chainrollup select 0,3,'Omnicare','599',NULL
insert into #chainrollup select 0,3,'Omnicare','519',NULL
insert into #chainrollup select 0,3,'Oncology Pharmacy Services','477',NULL
insert into #chainrollup select 0,3,'OPTION CARE ENTERPRISES INC','838',NULL
insert into #chainrollup select 0,3,'OWENS PHARMACY','B21',NULL
insert into #chainrollup select 0,3,'PARK NICOLLET PHARMACY','341',NULL
insert into #chainrollup select 0,3,'PATIENT FIRST CORPORATION','861',NULL
insert into #chainrollup select 0,3,'PAYLESS DRUG PHARMACY GROUP LLC','A59',NULL
insert into #chainrollup select 0,NULL,'PBA HEALTH TRINET','909',NULL
insert into #chainrollup select 0,NULL,'PBA HEALTH TRINET','540',NULL
insert into #chainrollup select 0,3,'PEOPLES PHARMACY','757',NULL
insert into #chainrollup select 0,3,'PHARMACA INTEGRATIVE PHARMACY','960',NULL
insert into #chainrollup select 0,3,'Pharmacy First','854',NULL
insert into #chainrollup select 0,3,'Pharmacy First','A46',NULL
insert into #chainrollup select 0,3,'Pharmacy First','866',NULL
insert into #chainrollup select 0,3,'PHARMACY PLUS INC','575',NULL
insert into #chainrollup select 0,3,'PharMerica','752',NULL
insert into #chainrollup select 0,3,'PharMerica','631',NULL
insert into #chainrollup select 0,3,'PharMerica','686',NULL
insert into #chainrollup select 0,3,'PharMerica','754',NULL
insert into #chainrollup select 0,5,'PHYSICIANS PHARMACEUTICAL CORP','A83',NULL
insert into #chainrollup select 0,NULL,'PHYSICIANS TOTAL CARE','727',NULL
insert into #chainrollup select 0,3,'PILL BOX DRUGS INC','923',NULL
insert into #chainrollup select 0,3,'PLANNED PARENTHOOD MAR MONTE INC','A57',NULL
insert into #chainrollup select 0,3,'PLANNED PARENTHOOD OF GREATER OHIO','B00',NULL
insert into #chainrollup select 0,3,'PLANNED PARENTHOOD OF GREATER WA AN','B57',NULL
insert into #chainrollup select 0,3,'PLANNED PARENTHOOD OF ILLINOIS','B59',NULL
insert into #chainrollup select 0,3,'PLANNED PARENTHOOD OF SOUTHWESTERN','B03',NULL
insert into #chainrollup select 0,5,'POC MANAGEMENT GROUP LLC','974',NULL
insert into #chainrollup select 0,5,'PPOK RxSelect Network','769',NULL
insert into #chainrollup select 0,3,'PRESBYTERIAN MEDICAL SERVICES INC','A12',NULL
insert into #chainrollup select 0,3,'PRESCRIBEIT RX','912',NULL
insert into #chainrollup select 0,5,'PRESCRIPTION PARTNERS','952',NULL
insert into #chainrollup select 0,3,'Price Chopper Supermarkets','434',NULL
insert into #chainrollup select 0,3,'PRICE CUTTER PHARMACY','701',NULL
insert into #chainrollup select 0,NULL,'PROCLAIM PHYSICIAN SERVICES','A77',NULL
insert into #chainrollup select 0,3,'PROF SPECIALIZED PHARMACIES LLC','824',NULL
insert into #chainrollup select 0,5,'PROGRESSIVE PHARMACIES LLC','979',NULL
insert into #chainrollup select 0,3,'PUBLIC HEALTH TRUST OF DADE COUNTY','A67',NULL
insert into #chainrollup select 1,1,'Publix','302',NULL
insert into #chainrollup select 0,5,'QCP NETWORX','B40',NULL
insert into #chainrollup select 0,3,'Quick Chek Food Stores','267',NULL
insert into #chainrollup select 0,3,'Raleys/Bel Air Pharmacies','171',NULL
insert into #chainrollup select 0,3,'REASOR','B27',NULL
insert into #chainrollup select 0,5,'Recept Pharmacy','891',NULL
insert into #chainrollup select 0,3,'RECEPT PHARMACY LP','A50',NULL
insert into #chainrollup select 0,3,'Red Cross Pharmacy','743',NULL
insert into #chainrollup select 0,3,'Redners Markets','852',NULL
insert into #chainrollup select 0,1,'Rite Aid','181',NULL
insert into #chainrollup select 0,1,'Rite Aid','045',NULL
insert into #chainrollup select 0,1,'Rite Aid','056',NULL
insert into #chainrollup select 0,1,'Rite Aid','NULL','99A350'
insert into #chainrollup select 0,1,'Rite Aid','NULL','99A351'
insert into #chainrollup select 0,3,'Ritzman Pharmacy Inc','424',NULL
insert into #chainrollup select 0,3,'Rural Healthcare Inc. ','935',NULL
insert into #chainrollup select 0,3,'SAINT JOSEPH MERCY PHARMACY','520',NULL
insert into #chainrollup select 0,2,'SAMS CLUB','C11',NULL
insert into #chainrollup select 0,3,'SANTA CLARA VALLEY HEALTH AND HOSPI','A37',NULL
insert into #chainrollup select 0,3,'Save Mart Supermarkets','310',NULL
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','596',NULL
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','979',NULL
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','980',NULL
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2110182'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2372528'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','3727344'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2333095'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2701969'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2380602'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2383420'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2378366'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2310009'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2385195'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2307191'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2360701'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2371069'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2368252'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2360028'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2344163'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2363137'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2350899'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2370524'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2363000'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2344593'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2384662'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2310667'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2364696'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2384232'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2368327'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2372643'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2354126'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2366626'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2338689'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2356283'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2320923'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2366993'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2363238'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2344620'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2330102'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2308054'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2306214'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2306226'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2344884'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2363288'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','3900164'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','3915305'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','3941158'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','3945194'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','3946994'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','3996660'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','6000929'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','3678882'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','3681093'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','3681841'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','3993032'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2342638'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','2370182'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','5660875'
insert into #chainrollup select 0,3,'Sav-Mor Drug Stores','NULL','5735127'
insert into #chainrollup select 0,3,'Schnuck Markets, Inc.','133',NULL
insert into #chainrollup select 0,3,'Seip Drug LLC','968',NULL
insert into #chainrollup select 0,2,'Shopko','NULL','999974'
insert into #chainrollup select 0,2,'Shopko','NULL','999957'
insert into #chainrollup select 0,2,'Shopko','246',NULL
insert into #chainrollup select 0,NULL,'SMART ID WORKS LLC','A75',NULL
insert into #chainrollup select 0,2,'Southeastern Grocers','315',NULL
insert into #chainrollup select 0,2,'Southeastern Grocers','292',NULL
insert into #chainrollup select 0,3,'SpartanNash','320',NULL
insert into #chainrollup select 0,3,'SpartanNash','NULL','2305274'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2311924'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2312952'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2317344'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2342703'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2342979'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2343452'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2344137'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2345456'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2347359'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2348527'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2352526'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2353340'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2354277'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2354316'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2355281'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2355534'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2361056'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2362729'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2363339'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2364177'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2364292'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2364381'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2365939'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2366246'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2368973'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2368985'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2368997'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369002'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369014'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369026'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369038'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369040'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369052'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369064'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369076'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369088'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369280'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369696'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369711'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369723'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369735'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369747'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369759'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2369761'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2371110'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2372047'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2372059'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2372061'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2372073'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2372085'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2372097'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2372100'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2372112'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2372124'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2372477'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2372934'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2373633'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2375839'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2377441'
insert into #chainrollup select 0,3,'SpartanNash','NULL','2378203'
insert into #chainrollup select 0,3,'SpartanNash','NULL','99A160'
insert into #chainrollup select 0,3,'SpartanNash','NULL','99A217'
insert into #chainrollup select 0,3,'SpartanNash','NULL','99A246'
insert into #chainrollup select 0,3,'SpartanNash','NULL','99A247'
insert into #chainrollup select 0,3,'STAR DISCOUNT PHARMACY INC','998',NULL
insert into #chainrollup select 0,3,'STONER DRUG CO','943',NULL
insert into #chainrollup select 0,3,'SUNCOAST COMMUNITY HEALTH CENTERS I','B41',NULL
insert into #chainrollup select 0,3,'SUPERVALU','410',NULL
insert into #chainrollup select 0,3,'SUPERVALU','285',NULL
insert into #chainrollup select 0,5,'SWIFT RX LLC','A74',NULL
insert into #chainrollup select 0,3,'Tampa Family Health Centers','A24',NULL
insert into #chainrollup select 0,5,'TEMPEST MED','A79',NULL
insert into #chainrollup select 1,1,'The Kroger Co.','108',NULL
insert into #chainrollup select 1,1,'The Kroger Co.','199',NULL
insert into #chainrollup select 1,1,'The Kroger Co.','273',NULL
insert into #chainrollup select 1,1,'The Kroger Co.','043',NULL
insert into #chainrollup select 1,1,'The Kroger Co.','495',NULL
insert into #chainrollup select 1,1,'The Kroger Co.','069',NULL
insert into #chainrollup select 1,1,'The Kroger Co.','071',NULL
insert into #chainrollup select 1,1,'The Kroger Co.','817',NULL
insert into #chainrollup select 1,1,'The Kroger Co.','602',NULL
insert into #chainrollup select 1,1,'The Kroger Co.','A65',NULL
insert into #chainrollup select 1,1,'The Kroger Co.','B67',NULL
insert into #chainrollup select 1,1,'The Kroger Co.','113',NULL
insert into #chainrollup select 0,3,'THE METROHEALTH SYSTEM PHARMACY','B61',NULL
insert into #chainrollup select 1,3,'Thrifty White Pharmacy','NULL','999656'
insert into #chainrollup select 1,3,'Thrifty White Pharmacy','216',NULL
insert into #chainrollup select 0,3,'Times Supermarket','372',NULL
insert into #chainrollup select 0,5,'TN MENTAL HLTH AND DEV DISABILITIES','921',NULL
insert into #chainrollup select 0,3,'Tops Markets, LLC','978',NULL
insert into #chainrollup select 0,3,'TriHealth','900',NULL
insert into #chainrollup select 0,3,'U SAVE PHARMACY','808',NULL
insert into #chainrollup select 0,3,'UCDHS PHARMACIES','B12',NULL
insert into #chainrollup select 0,3,'UCSD Medical Center Pharmacies','715',NULL
insert into #chainrollup select 0,3,'Univ of Missouri Hosp and Clinic','691',NULL
insert into #chainrollup select 0,3,'University of Kansas Hospital Pharmacy','A87',NULL
insert into #chainrollup select 0,3,'University of Utah Hospital','744',NULL
insert into #chainrollup select 0,3,'UofV Virginia Medical Centers','A98',NULL
insert into #chainrollup select 0,3,'US BIOSERVICES CORPORATION','758',NULL
insert into #chainrollup select 0,3,'UW HEALTH PHARMACY SERVICES','700',NULL
insert into #chainrollup select 0,3,'VA DMHMRSAS','914',NULL
insert into #chainrollup select 0,5,'VANTAGE RX DISPENSING SERVICES LLC','989',NULL
insert into #chainrollup select 0,3,'Virginia Commenealth University Hospital','696',NULL
insert into #chainrollup select 0,3,'VIRGINIA MASON MEDICAL CTR','654',NULL
insert into #chainrollup select 0,2,'Wakefern','A33',NULL
insert into #chainrollup select 0,2,'Wakefern','197',NULL
insert into #chainrollup select 0,2,'Wakefern','613',NULL
insert into #chainrollup select 0,2,'Wakefern','618',NULL
insert into #chainrollup select 0,2,'Wakefern','619',NULL
insert into #chainrollup select 0,2,'Wakefern','620',NULL
insert into #chainrollup select 0,2,'Wakefern','621',NULL
insert into #chainrollup select 0,2,'Wakefern','622',NULL
insert into #chainrollup select 0,2,'Wakefern','640',NULL
insert into #chainrollup select 0,2,'Wakefern','894',NULL
insert into #chainrollup select 1,1,'Walgreens Co. ','226',NULL
insert into #chainrollup select 1,1,'Walgreens Co. ','A10',NULL
insert into #chainrollup select 1,1,'Walgreens Co. ','A13',NULL
insert into #chainrollup select 1,1,'Walmart','229',NULL
insert into #chainrollup select 1,1,'Walmart','NULL','99A298'
insert into #chainrollup select 1,1,'Walmart Stores Inc','C11',NULL
insert into #chainrollup select 1,1,'Walmart Stores Inc','229',NULL
insert into #chainrollup select 1,1,'Walmart Stores Inc','NULL','99A298'
insert into #chainrollup select 0,3,'WEBER AND JUDD COMPANY INC','649',NULL
insert into #chainrollup select 1,3,'Wegmans Food Markets, Inc','256',NULL
insert into #chainrollup select 0,3,'Weis Markets','232',NULL
insert into #chainrollup select 0,3,'Yakima Valley Farm Workers Clinic','987',NULL
insert into #chainrollup select 0,3,'YOKES FOODS INC','534',NULL

create nonclustered index NC_chainrollup on #chainrollup (RelationshipID , NABP) 



drop table if exists #org
create table #org 
(
	orgID int identity (1,1) primary key
	, [Organization Name] varchar(100)
	, [Organization Category Size] int
)
insert into #org ([Organization Name], [Organization Category Size])
select	distinct [organization Name]
		, [Organization Category Size] 
from	#chainrollup
where	1=1 



drop table if exists #Org2Center
;with ch as 
(
    select	cr.[Organization Name]
			, p.centerid
			, p.NCPDP_NABP 
    from	#chainRollUp cr
			join outcomesMTM.dbo.chain c on c.chainCode = cr.RelationshipID 
			join outcomesMTM.dbo.pharmacychain pc on pc.chainid = c.chainid
			join outcomesMTM.dbo.pharmacy p on p.centerid = pc.centerid
    where	1=1 

),
ph as 
(
    select	cr.[Organization Name]
			, p.centerid
			, p.NCPDP_NABP
    from	#chainRollUp cr
			join outcomesMTM.dbo.pharmacy p on p.NCPDP_NABP = cr.NABP
)

SELECT	*
INTO	#Org2Center 
FROM
(
	select	o.orgid
			, o.[Organization Name]
			, t.centerid
			, t.NCPDP_NABP  
	from 
		(
			select	ch.[Organization Name]
					, ch.centerid
					, ch.NCPDP_NABP
			from	ch
			where	1=1
			union
			select	ph.[Organization Name]
					, ph.centerid
					, ph.NCPDP_NABP
			from	ph
			where	1=1
		) t
		join #org o on o.[Organization Name] = t.[Organization Name]
	where	1=1
)	Org2Center
create clustered index IDX on #Org2Center (NCPDP_NABP, [Organization Name], orgid)
 

-----------------------------------------------------------------------------------------------------------
-- TIP section --
-----------------------------------------------------------------------------------------------------------

-- Tip completed at patient's Primary Pharmacy
drop table if exists #TIPPrimaryPharmacy
select	*
into	#TIPPrimaryPharmacy
from
	(

		select	row_number() over (partition by oc.orgID, tacr.ncpdp_nabp, tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
				, tacr.centerid
				, tacr.patientid

				-- Primary Tier --
				, oc.orgID					as [Primary OrgID]
				, tacr.[TIP Opportunities]	as [Primary OrgID TIP Opportunities]
				, case	when tacr.activethru <= cast(@end as date) THEN tacr.[Completed TIPs] 
						else 0 end			as [Primary OrgID TIPs Completed]
				, case	when tacr.activethru <= cast(@end as date) THEN tacr.[Successful TIPs] 
						else 0  end			as [Primary OrgID TIPs Successful]
				, case	when tacr.tiptype in ('COST', 'QUALITY') then 1 
						else 0 end			as [Primary OrgID Cost Quality TIP Opportunities] 
				, case	when tacr.tiptype in ('COST', 'QUALITY') and tacr.activethru <= cast(@end as date) then tacr.[Completed TIPs] 
						else 0 end			as [Primary OrgID Cost Quality TIPs Completed]			
				, case	when tacr.tiptype in ('COST', 'QUALITY') and tacr.activethru <= cast(@end as date) then tacr.[Successful TIPs] 
						else 0 end			as [Primary OrgID Cost Quality TIPs Successful]		
				, case	when tacr.tiptype = 'STAR' then 1 
						else 0 end			as [Primary OrgID Star TIP Opportunities]														
				, case	when tacr.tiptype = 'STAR' and tacr.activethru <= cast(@end as date) then tacr.[Completed TIPs] 
						else 0 end			as [Primary OrgID Star TIPs Completed]
				, case	when tacr.tiptype = 'STAR' and tacr.activethru <= cast(@end as date) then tacr.[Successful TIPs] 
						else 0 end			as [Primary OrgID Star TIPs Successful]

				-- Service Tier --
				, null						as [Service OrgID]
				, 0							as [Service OrgID TIP Opportunities]																													
				, 0							as [Service OrgID TIPs Completed]
				, 0							as [Service OrgID TIPs Successful]
				, 0							as [Service OrgID Cost Quality TIP Opportunities] 
				, 0							as [Service OrgID Cost Quality TIPs Completed]
				, 0							as [Service OrgID Cost Quality TIPs Successful]
				, 0							as [Service OrgID Star TIP Opportunities]
				, 0							as [Service OrgID Star TIPs Completed]
				, 0							as [Service OrgID Star TIPs Successful]

		from	outcomesMTM.dbo.tipActivityCenterReport tacr
				join #org2Center oc on oc.centerid = tacr.centerid  
		where	1=1
				and tacr.policyid not in (574, 575, 298)
				and tacr.primaryPharmacy = 1 
				and isnull(tacr.activethru, cast(@end as date)) between cast(@BEGIN as date) and cast(@end as date) 
				and tacr.activeasof between cast(@BEGIN as date) and cast(@end as date)
				AND (
						(
							tacr.activethru <= cast(@end as date) 
							AND (tacr.[completed tips] = 1)
						) 
						OR datediff(day, case when tacr.activeasof > cast(@BEGIN as date) then tacr.activeasof else cast(@BEGIN as date) end, case when tacr.activethru > cast(@end as date) then cast(@end as date) else tacr.activethru end) > 7
					)		
	)	TIP
where TIP.rank = 1


-- Tip completed at patient's non Primary Pharmacy, but OrgID of service pharmacy equals to OrgID of patient's Primary Pharmacy  
DROP table if exists #TIP_InChain_Pharmacy
select	*    
into	#TIP_InChain_Pharmacy
from
	(
		select	row_number() over (partition by oc.orgID, tacr.ncpdp_nabp, tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
				, tacr.centerid
				, tacr.patientid

				-- Primary Tier --
				, org2.orgID				as [Primary OrgID]
				, tacr.[TIP Opportunities]	as [Primary OrgID TIP Opportunities]
				, case	when tacr.activethru <= cast(@end as date) THEN tacr.[Completed TIPs] 
						else 0 end			as [Primary OrgID TIPs Completed]
				, case	when tacr.activethru <= cast(@end as date) THEN tacr.[Successful TIPs] 
						else 0  end			as [Primary OrgID TIPs Successful]
				, case	when tacr.tiptype in ('COST', 'QUALITY') then 1 
						else 0 end			as [Primary OrgID Cost Quality TIP Opportunities] 
				, case	when tacr.tiptype in ('COST', 'QUALITY') and tacr.activethru <= cast(@end as date) then tacr.[Completed TIPs] 
						else 0 end			as [Primary OrgID Cost Quality TIPs Completed]		
				, case	when tacr.tiptype in ('COST', 'QUALITY') and tacr.activethru <= cast(@end as date) then tacr.[Successful TIPs] 
						else 0 end			as [Primary OrgID Cost Quality TIPs Successful]		
				, case	when tacr.tiptype = 'STAR' then 1 
						else 0 end			as [Primary OrgID Star TIPs Opportunity]														
				, case	when tacr.tiptype = 'STAR' and tacr.activethru <= cast(@end as date) then tacr.[Completed TIPs] 
						else 0 end			as [Primary OrgID Star TIPs Completed]
				, case	when tacr.tiptype = 'STAR' and tacr.activethru <= cast(@end as date) then tacr.[Successful TIPs] 
						else 0 end			as [Primary OrgID Star TIPs Successful]

				--Service Tier --
				, null						as [Service OrgID]	
				, 0							as [Service OrgID TIP Opportunities]																													
				, 0							as [Service OrgID TIPs Completed]
				, 0							as [Service OrgID TIPs Successful]
				, 0							as [Service OrgID Cost Quality TIP Opportunities] 
				, 0							as [Service OrgID Cost Quality TIPs Completed]
				, 0							as [Service OrgID Cost Quality TIPs Successful]
				, 0							as [Service OrgID Star TIP Opportunities]
				, 0							as [Service OrgID Star TIPs Completed]
				, 0							as [Service OrgID Star TIPs Successful]

		from	outcomesMTM.dbo.tipActivityCenterReport tacr
				join #org2Center oc on oc.centerid = tacr.centerid  
				left join [dbo].patientMTMCenterDim ppd on ppd.patientid = tacr.patientid and  tacr.activethru between ppd.activeAsOf and ISNULL(ppd.activeThru, '9999-12-31') and ppd.primaryPharmacy = 1
				JOIN #Org2Center org2 ON org2.centerid = ppd.centerid and org2.orgID = oc.orgID

		where	1=1
				and tacr.policyid not in (574, 575, 298)
				and tacr.primaryPharmacy = 0 
				and isnull(tacr.activethru, cast(@end as date)) between cast(@BEGIN as date) and cast(@end as date) 
				and tacr.activeasof between cast(@BEGIN as date) and cast(@end as date)
				and tacr.[completed tips] = 1
				and tacr.[Successful TIPs] = 1
	)	TIP
where TIP.rank = 1


-- Tip completed at patient's non Primary Pharmacy, and OrgID of service pharmacy not equal to OrgID of patient's Primary Pharmacy 
drop table if exists #TIP_OutChain_Pharmacy
select	*
into	#TIP_OutChain_Pharmacy
from
	(
		select	row_number() over (partition by oc.orgID, tacr.ncpdp_nabp, tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
				, tacr.centerid
				, tacr.patientid

				-- Primary Tier --
				, org2.orgID				as [Primary OrgID]	
				, 1							as [Primary OrgID TIP Opportunities]	
				, 0							as [Primary OrgID TIPs Completed]
				, 0							as [Primary OrgID TIPs Successful]
				, case	when tacr.tiptype in ('COST', 'QUALITY') then 1 
						else 0 end								as [Primary OrgID Cost Quality TIP Opportunities] 
				, 0							as [Primary OrgID Cost Quality TIPs Completed]
				, 0							as [Primary OrgID Cost Quality TIPs Successful]
				, case	when tacr.tiptype = 'STAR' then 1 
						else 0 end								as [Primary OrgID Star TIPs Opportunity]
				, 0							as [Primary OrgID Star TIPs Completed]
				, 0							as [Primary OrgID Star TIPs Successful]	

				-- Service Tier --
				, oc.orgID					as [Service OrgID]
				, 1							as [Service OrgID TIP Opportunities]			
				, case	when tacr.activethru <= cast(@end as date) THEN tacr.[Completed TIPs] 
						else 0 end			as [Service OrgID TIPs Completed]
				, case	when tacr.activethru <= cast(@end as date) THEN tacr.[Successful TIPs] 
						else 0 end			as [Service OrgID TIPs Successful]
				, case	when tacr.tiptype in ('COST', 'QUALITY') then 1 
						else 0 end			as [Service OrgID Cost Quality TIP Opportunities] 
				, case	when tacr.tiptype in ('COST', 'QUALITY') and tacr.activethru <= cast(@end as date) then tacr.[Completed TIPs] 
						else 0 end			as [Service OrgID Cost Quality TIPs Completed]		
				, case	when tacr.tiptype in ('COST', 'QUALITY') and tacr.activethru <= cast(@end as date) then tacr.[Successful TIPs] 
						else 0 end			as [Service OrgID Cost Quality TIPs Successful]		

				, case	when tacr.tiptype = 'STAR' then 1 
						else 0 end			as [Service OrgID Star TIP Opportunities]														
				, case	when tacr.tiptype = 'STAR' and tacr.activethru <= cast(@end as date) then tacr.[Completed TIPs] 
						else 0 end			as [Service OrgID Star TIPs Completed]
				, case	when tacr.tiptype = 'STAR' and tacr.activethru <= cast(@end as date) then tacr.[Successful TIPs] 
						else 0 end			as [Service OrgID Star TIPs Successful]

		from	outcomesMTM.dbo.tipActivityCenterReport tacr
				join #org2Center oc on oc.centerid = tacr.centerid  
				left join [dbo].patientMTMCenterDim ppd on ppd.patientid = tacr.patientid and  tacr.activethru between ppd.activeAsOf and ISNULL(ppd.activeThru, '9999-12-31') and ppd.primaryPharmacy = 1
				JOIN #Org2Center org2 ON org2.centerid = ppd.centerid and org2.orgID <> oc.orgID		
		where	1=1
				and tacr.policyid not in (574, 575, 298)
				and tacr.primaryPharmacy = 0 
				and isnull(tacr.activethru, @end) between cast(@BEGIN as date) and cast(@end as date) 
				and tacr.activeasof between cast(@BEGIN as date) and cast(@end as date)
				and tacr.[completed tips] = 1
				and tacr.[Successful TIPs] = 1
	)	TIP
where TIP.rank = 1


-- Union All TIPs
DROP TABLE IF EXISTS #UnionTIP
SELECT	*
INTO	#UnionTIP
FROM
	(
		SELECT	*
		FROM	#TIPPrimaryPharmacy t 
		UNION ALL
		SELECT	*
		FROM	#TIP_InChain_Pharmacy t 
		UNION ALL
		SELECT	*
		FROM	#TIP_OutChain_Pharmacy t 
	)	TIP


-- Sum All TIPs by Primary OrgID and Service OrgID
drop table if exists #TIPCount
select	*
into	#TIPCount
from
	(
		select	f.[Primary OrgID]											as [OrgID]
				, sum(f.[Primary OrgID TIP Opportunities])					as [TIP Opportunities]
				, sum(f.[Primary OrgID TIPs Completed])						as [TIPs Completed]
				, sum(f.[Primary OrgID TIPs Successful])					as [TIPs Successful]
				, sum(f.[Primary OrgID Cost Quality TIP Opportunities])		as [Cost Quality TIP Opportunities]
				, sum(f.[Primary OrgID Cost Quality TIPs Completed])		as [Cost Quality TIPs Completed]
				, sum(f.[Primary OrgID Cost Quality TIPs Successful])		as [Cost Quality TIPs Successful]
				, sum(f.[Primary OrgID Star TIP Opportunities])				as [Star TIP Opportunities]
				, sum(f.[Primary OrgID Star TIPs Completed])				as [Star TIPs Completed]
				, sum(f.[Primary OrgID Star TIPs Successful])				as [Star TIPs Successful]
		from	#UnionTIP f
		where	f.[Primary OrgID] is not null
		group by f.[Primary OrgID]
		union all
		select	f.[Service OrgID]											as [OrgID]
				, sum(f.[Service OrgID TIP Opportunities])					as [TIP Opportunities]
				, sum(f.[Service OrgID TIPs Completed])						as [TIPs Completed]
				, sum(f.[Service OrgID TIPs Successful])					as [TIPs Successful]
				, sum(f.[Service OrgID Cost Quality TIP Opportunities])		as [Cost Quality TIP Opportunities]
				, sum(f.[Service OrgID Cost Quality TIPs Completed])		as [Cost Quality TIPs Completed]
				, sum(f.[Service OrgID Cost Quality TIPs Successful])		as [Cost Quality TIPs Successful]
				, sum(f.[Service OrgID Star TIP Opportunities])				as [Star TIP Opportunities]
				, sum(f.[Service OrgID Star TIPs Completed])				as [Star TIPs Completed]
				, sum(f.[Service OrgID Star TIPs Successful])				as [Star TIPs Successful]
		from	#UnionTIP f
		where	f.[Service OrgID] is not null
		group by f.[Service OrgID]
	)	TIP


-- Sum TIPs by OrgID
drop table if exists #TIPCount_Sum
select	*
into	#TIPCount_Sum
from
(
select	OrgID
		, sum([TIP Opportunities])	as [TIP Opportunities]
		, sum([TIPs Completed])		as [TIPs Completed]
		, sum([TIPs Successful])	as [TIPs Successful]
		, case	when sum([TIP Opportunities]) = 0 then '0.00%'
				else CONVERT(varchar, isnull(cast((cast(sum([TIPs Completed]) as decimal) * 100/nullif(cast(sum([TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0)) + '%' end as [TIP Completion Rate]
		, case	when sum([TIPs Completed]) = 0 then '0.00%'
				else CONVERT(varchar, isnull(cast((cast(sum([TIPs Successful]) as decimal) * 100/nullif(cast(sum([TIPs Completed]) as decimal), 0)) as decimal (5,2)), 0)) + '%' end as [TIP Success Rate]
		, case	when sum([TIP Opportunities]) = 0 then '0.00%'
				else CONVERT(varchar, isnull(cast((cast(sum([TIPs Successful]) as decimal) * 100/nullif(cast(sum([TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0)) + '%' end as [TIP Net Effective Rate]
		, sum([Cost Quality TIP Opportunities])	as [Cost Quality TIP Opportunities]
		, sum([Cost Quality TIPs Completed])	as [Cost Quality TIPs Completed]
		, sum([Cost Quality TIPs Successful])	as [Cost Quality TIPs Successful]
		, case	when sum([Cost Quality TIP Opportunities]) = 0 then '0.00%'
				else CONVERT(varchar, isnull(cast((cast(sum([Cost Quality TIPs Completed]) as decimal) * 100/nullif(cast(sum([Cost Quality TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0)) + '%' end as [Cost Quality TIP Completion Rate]
		, case	when sum([Cost Quality TIPs Completed]) = 0 then '0.00%'
				else CONVERT(varchar, isnull(cast((cast(sum([Cost Quality TIPs Successful]) as decimal) * 100/nullif(cast(sum([Cost Quality TIPs Completed]) as decimal), 0)) as decimal (5,2)), 0)) + '%' end as [Cost Quality TIP Success Rate]
		, case	when sum([Cost Quality TIP Opportunities]) = 0 then '0.00%'
				else CONVERT(varchar, isnull(cast((cast(sum([Cost Quality TIPs Successful]) as decimal) * 100/nullif(cast(sum([Cost Quality TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0)) + '%' end as [Cost Quality TIP Net Effective Rate]		
		, sum([Star TIP Opportunities])			as [Star TIP Opportunities]
		, sum([Star TIPs Completed])			as [Star TIPs Completed]
		, sum([Star TIPs Successful])			as [Star TIPs Successful]
		, case	when sum([Star TIP Opportunities]) = 0 then '0.00%'
				else CONVERT(varchar, isnull(cast((cast(sum([Star TIPs Completed]) as decimal) * 100/nullif(cast(sum([Star TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0)) + '%' end as [Star TIP Completion Rate]
		, case	when sum([Star TIPs Completed]) = 0 then '0.00%'
				else CONVERT(varchar, isnull(cast((cast(sum([Star TIPs Successful]) as decimal) * 100/nullif(cast(sum([Star TIPs Completed]) as decimal), 0)) as decimal (5,2)), 0)) + '%' end as [Star TIPs Success Rate]
		, case	when sum([Star TIP Opportunities]) = 0 then '0.00%'
				else CONVERT(varchar, isnull(cast((cast(sum([Star TIPs Successful]) as decimal) * 100/nullif(cast(sum([Star TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0)) + '%' end as [Star TIP Net Effective Rate]
from	#TIPCount
group by OrgID
)	TIP


-----------------------------------------------------------------------------------------------------------
-- CMR section --
-----------------------------------------------------------------------------------------------------------

-- CMR completed at patient's Primary Pharmacy
DROP TABLE IF EXISTS #CMR_PrimaryPharmacy
SELECT	*
INTO	#CMR_PrimaryPharmacy
FROM
	(
		select	row_number() over (partition by rp.patientID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank

				-- Primary Tier --
				, rp.patientid

				, oc.orgID					as [Primary OrgID]
				, 1							as [Primary OrgID CMR Opportunities]
				, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) and ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'')THEN 1 
						else 0 end			as [Primary OrgID CMRs Attempted]
				, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') and rp.resultTypeID not in (12, 13, 16, 18) THEN 1 
						else 0 end			as [Primary OrgID CMRs Successful]

				-- Service Tier --
				, null						as [Service OrgID]
				, 0							as [Service OrgID CMR Opportunities]
				, 0							as [Service OrgID CMRs Attempted]
				, 0							as [Service OrgID CMRs Successful]
		from	vw_CMRActivityReport rp
				join #org2Center oc on oc.centerid = rp.centerid
		where	1=1
				AND rp.activeAsOF between @BEGIN and @end
				AND isNull(cast(rp.activethru as date), '9999-12-31') >= @BEGIN
				AND cast(rp.activeAsOF as date) <= isNull(rp.activethru, '9999-12-31')
				AND isNULL(rp.mtmServiceDT, '9999-12-31') > rp.activeAsOF 
				and (rp.mtmServiceDT is null or rp.mtmServiceDT between @BEGIN and @end)
				AND (
						(
							DATEDIFF(DAY, rp.activeasof, isNull(rp.activethru, @end)) >= 30 --and rp.mtmServiceDT is null
						)
						or
						(
							rp.mtmServiceDT is not null AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) --and DATEDIFF(DAY, rp.activeasof, rp.mtmServiceDT) < 30
						)

					)

	)	CMR
where	CMR.rank = 1


-- CMR completed at patient's non Primary Pharmacy, but OrgID of service pharmacy equals to OrgID of patient's Primary Pharmacy  
DROP table if exists #CMR_InChain_Pharmacy
select	* 
into	#CMR_InChain_Pharmacy
from
	(
		select	row_number() over (partition by rp.patientID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
				, rp.patientid

				-- Primary Tier --
				, org2.orgID				as [Primary OrgID]
				, 1							as [Primary OrgID CMR Opportunities]
				, case when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 else 0 end as [Primary OrgID CMRs Attempted]
				, case when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') and rp.resultTypeID not in (12, 13, 16, 18) THEN 1 else 0 end as [Primary OrgID CMRs Successful]
				
				-- Service Tier --
				, null						as [Service OrgID]
				, 0							as [Service OrgID CMR Opportunities]
				, 0							as [Service OrgID CMRs Attempted]
				, 0							as [Service OrgID CMRs Successful]

		from	vw_CMRActivityReport rp
				join #org2Center oc on oc.centerid = rp.centerid
				left join [dbo].[patientPrimaryPharmacyDim] ppd on ppd.patientid = rp.patientid and  rp.activethru between ppd.activeAsOf and ISNULL(ppd.activeThru, '9999-12-31') and ppd.primaryPharmacy = 1
				JOIN #Org2Center org2 ON org2.centerid = ppd.centerid and org2.orgID = oc.orgID
		where	1=1
				AND isNull(rp.activethru, @end) >= @BEGIN
				AND rp.activeasof <= @end
				and rp.primaryPharmacy = 0 
				AND rp.resultTypeID not in (12, 13, 16, 18)
				and rp.mtmServiceDT between @BEGIN and @end 
				AND rp.statusID in (2, 6) 
				and rp.resultTypeID in (5, 6) 
				AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'')
	)	CMR
where	CMR.rank = 1


-- CMR completed at patient's non Primary Pharmacy, and OrgID of service pharmacy not equal to OrgID of patient's Primary Pharmacy 
DROP TABLE IF EXISTS #CMR_OutChain_Pharmacy
SELECT	*
INTO	#CMR_OutChain_Pharmacy
FROM
	(
		select	row_number() over (partition by rp.patientID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
				, rp.patientid

				-- Primary Tier --
				, org2.orgID				as [Primary OrgID]
				, 1							as [Primary OrgID CMR Opportunities]
				, 0							as [Primary OrgID CMRs Attempted]
				, 0							as [Primary OrgID CMRs Successful]

				-- Service Tier --
				, oc.orgID					as [Service OrgID]
				, 1							as [Service OrgID CMR Opportunities]
				, case when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 else 0 end as [Service OrgID CMRs Attempted]
				, case when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') and rp.resultTypeID not in (12, 13, 16, 18) THEN 1 else 0 end as [Service OrgID CMRs Successful]
				--, rp.*
		from	vw_CMRActivityReport rp
				join #org2Center oc on oc.centerid = rp.centerid
				--left join [dbo].[patientPrimaryPharmacyDim] ppd on ppd.patientid = rp.patientid and  rp.activethru between ppd.activeAsOf and ISNULL(ppd.activeThru, '9999-12-31') and ppd.primaryPharmacy = 1
				left join [dbo].patientMTMCenterDim ppd on ppd.patientid = rp.patientid and  rp.mtmServiceDT between ppd.activeAsOf and ISNULL(ppd.activeThru, '9999-12-31') and ppd.primaryPharmacy = 1
				JOIN #Org2Center org2 ON org2.centerid = ppd.centerid and org2.orgID <> oc.orgID		
		where	1=1
				AND isNull(rp.activethru, @end) >= @BEGIN
				AND rp.activeasof <= @end
				and rp.primaryPharmacy = 0 
				AND rp.resultTypeID not in (12, 13, 16, 18)
				and rp.mtmServiceDT between @BEGIN and @end 
				AND rp.statusID in (2, 6) 
				and rp.resultTypeID in (5, 6) 
				AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'')
	)	CMR
where	CMR.rank = 1




DROP TABLE IF EXISTS #UnionCMR
SELECT	*
INTO	#UnionCMR
FROM
	(
		SELECT	*
		FROM	#CMR_PrimaryPharmacy 
		UNION ALL
		SELECT	*
		FROM	#CMR_InChain_Pharmacy
		UNION ALL
		SELECT	*
		FROM	#CMR_OutChain_Pharmacy 
	)	CMR


drop table if exists #CMRCount
select	*
into	#CMRCount
from
	(
		select	f.[Primary OrgID]							as [OrgID]
				, sum(f.[Primary OrgID CMR Opportunities])	as [CMR Opportunities]
				, sum(f.[Primary OrgID CMRs Attempted])		as [CMRs Attempted]
				, sum(f.[Primary OrgID CMRs Successful])	as [CMRs Successful]
		from	#UnionCMR f
		where	f.[Primary OrgID] is not null 
		group by f.[Primary OrgID] 
		union all
		select	f.[Service OrgID]							as [OrgID]
				, sum(f.[Service OrgID CMR Opportunities])	as [CMR Opportunities]
				, sum(f.[Service OrgID CMRs Attempted])		as [CMRs Attempted]
				, sum(f.[Service OrgID CMRs Successful])	as [CMRs Successful]
		from	#UnionCMR f
		where	f.[Service OrgID] is not null 
		group by f.[Service OrgID]
	)	CMR


drop table if exists #CMRCount_Sum
select	*
into	#CMRCount_Sum
from
(
select	OrgID
		, sum([CMR Opportunities])		as [CMR Opportunities]
		, sum([CMRs Attempted])			as [CMRs Attempted]
		, sum([CMRs Successful])		as [CMRs Successful]
		, case	when sum([CMR Opportunities]) = 0 then '0.00%'
				else CONVERT(varchar, isnull(cast((cast(sum([CMRs Attempted]) as decimal) * 100/nullif(cast(sum([CMR Opportunities]) as decimal), 0)) as decimal(5,2)),0)) + '%'   end as [CMR Attempt Rate]
		, case	when sum([CMRs Attempted]) = 0 then '0.00%'	
				else CONVERT(varchar, isnull(cast((cast(sum([CMRs Successful]) as decimal) * 100/nullif(cast(sum([CMRs Attempted]) as decimal), 0)) as decimal(5,2)),0)) + '%'   end as [CMR Success Rate]
		, case	when sum([CMR Opportunities]) = 0 then '0.00%'	
				else CONVERT(varchar, isnull(cast((cast(sum([CMRs Successful]) as decimal) * 100/nullif(cast(sum([CMR Opportunities]) as decimal),0)) as decimal(5,2)),0)) + '%'  end as [CMR Completion Rate]	
from	#CMRCount
group by OrgID
)	CMR


-----------------------------------------------------------------------------------------------------------
-- AMP section --
-----------------------------------------------------------------------------------------------------------
drop table if exists #AMP_Checkpoint
create table #AMP_Checkpoint
(
	TotalOpportunities_CheckpointCount int null, 
	TotalCompleted_CheckpointCount int null, 
	TotalSuccessful_CheckpointCount int null , 
	PatientID int null , 
	PatientID_ALL varchar(100) null , 
	orgID int null 
)


if MONTH(@BEGIN) in (1,2,3) 
BEGIN
insert into #AMP_Checkpoint ( TotalOpportunities_CheckpointCount , TotalCompleted_CheckpointCount , TotalSuccessful_CheckpointCount , PatientID , PatientID_ALL ,  orgID )
SELECT	
					  rp.TotalOpportunities_CheckpointCount --sum(rp.TotalOpportunities_CheckpointCount)  as TotalOpportunities_CheckpointCount
					, rp.TotalCompleted_CheckpointCount --sum(rp.TotalCompleted_CheckpointCount) as TotalCompleted_CheckpointCount
					, rp.TotalSuccessful_CheckpointCount --sum(rp.TotalSuccessful_CheckpointCount) as TotalSuccessful_CheckpointCount
					, Pat.PatientID
					, rp.patientid_all
					, oc.orgID				

	FROM	dbo.ampcheckpoint_previousyear rp with(nolock)					
					join policy p  with(nolock) on p.policyID = rp.policyID					
					join #org2Center oc on oc.ncpdp_nabp = rp.ncpdp_nabp
					left join (
								select 	pt.PatientID , pt.PatientID_All , pt.PolicyID , ranker = ROW_NUMBER() over (partition by pt.PatientID order by pt.ActiveAsOf desc)
								from outcomesmtm.dbo.patientdim pt			
								where 1=1								
								and pt.OutcomesEligibilityDate >= @BEGIN
								and pt.OutcomesEligibilityDate <= @end
							  ) Pat 	
							    on Pat.PatientID_All = rp.PatientID_All 	
								--and Pat.PolicyID = rp.PolicyID	
								and Pat.ranker = 1
			
			WHERE	1=1  
			--group by  rp.patientid_all , oc.orgID	
				
end	
else --if MONTH(@BEGIN) NOT in (1,2,3)
BEGIN
insert into #AMP_Checkpoint (TotalOpportunities_CheckpointCount , TotalCompleted_CheckpointCount , TotalSuccessful_CheckpointCount , PatientID , PatientID_ALL ,  orgID )
SELECT	
					  rp.TotalOpportunities_CheckpointCount --sum(rp.TotalOpportunities_CheckpointCount)  as TotalOpportunities_CheckpointCount
					, rp.TotalCompleted_CheckpointCount --sum(rp.TotalCompleted_CheckpointCount) as TotalCompleted_CheckpointCount
					, rp.TotalSuccessful_CheckpointCount --sum(rp.TotalSuccessful_CheckpointCount) as TotalSuccessful_CheckpointCount
					, Pat.PatientID
					, rp.patientid_all
					, oc.orgID				
				

	FROM	dbo.ampcheckpoint_currentyear rp with(nolock)					
					join policy p  with(nolock) on p.policyID = rp.policyID					
					join #org2Center oc on oc.ncpdp_nabp = rp.ncpdp_nabp
					left join (
								select 	pt.PatientID , pt.PatientID_All , pt.PolicyID , ranker = ROW_NUMBER() over (partition by pt.PatientID order by pt.ActiveAsOf desc)
								from outcomesmtm.dbo.patientdim pt			
								where 1=1								
								and pt.OutcomesEligibilityDate >= @BEGIN
								and pt.OutcomesEligibilityDate <= @end
							  ) Pat 	
							    on Pat.PatientID_All = rp.PatientID_All 	
								--and Pat.PolicyID = rp.PolicyID	
								and Pat.ranker = 1
			
			WHERE	1=1  
			--group by  rp.patientid_all , oc.orgID	
end


	drop table if exists #AMP_Checkpoint_PatientSummary
	select 
					sum(rp.TotalOpportunities_CheckpointCount)  as TotalOpportunities_CheckpointCount
					, sum(rp.TotalCompleted_CheckpointCount) as TotalCompleted_CheckpointCount
					, sum(rp.TotalSuccessful_CheckpointCount) as TotalSuccessful_CheckpointCount					
					, rp.patientid_all
					, rp.orgID
	into #AMP_Checkpoint_PatientSummary
	from #AMP_Checkpoint rp
	group by  rp.patientid_all , rp.orgID


	drop table if exists #AMP_Final
	select orgID
		
		, [AMP Checkpoint Opportunities]
		, [AMP Checkpoints Completed]
		, [AMP Checkpoints Successful]		
		, case when [AMP Checkpoint Opportunities] > 0  then cast(FORMAT(([AMP Checkpoints Completed] * 100.0/[AMP Checkpoint Opportunities]) , 'N2') as varchar(50) ) + '%' else '0 %' end as [AMP Checkpoint Completion Rate]
		, case when [AMP Checkpoints Completed] > 0 then cast(FORMAT(([AMP Checkpoints Successful] * 100.0/[AMP Checkpoints Completed]) , 'N2') as varchar(50) ) + '%' else '0 %' end as [AMP Checkpoint Success Rate]
		, case when [AMP Checkpoint Opportunities] > 0  then cast(FORMAT(([AMP Checkpoints Successful] * 100.0/[AMP Checkpoint Opportunities]) , 'N2') as varchar(50) ) + '%' else '0 %' end as [AMP Checkpoint Net Effective Rate]
	into #AMP_Final
	from 
	(
		select			o.orgID
						
						, sum(AMP.TotalOpportunities_CheckpointCount) as [AMP Checkpoint Opportunities]
						, sum(AMP.TotalCompleted_CheckpointCount) as [AMP Checkpoints Completed]
						, sum(AMP.TotalSuccessful_CheckpointCount) as [AMP Checkpoints Successful]
				
				
		--from #AMP_Checkpoint	AMP
		from #AMP_Checkpoint_PatientSummary AMP

		join #org o on o.orgID = AMP.orgID		
		group by  o.orgID
	) AMP_Summarized

	

-- Final Query
select	o.orgID
		, oc.CenterCount
		, o.[Organization Name]

		, t1.[TIP Opportunities]
		, t1.[TIPs Completed]		as [TIPs Completed]
		, t1.[TIP Completion Rate]	as [TIP Completion Rate]
		, t1.[TIPs Successful]		as [TIPs Successful]
		, t1.[TIP Success Rate]		as [TIP Success Rate]
		, t1.[TIP Net Effective Rate]		as [TIP Net Effective Rate]

		, [Cost Quality TIP Opportunities]
		, [Cost Quality TIPs Completed]
		, [Cost Quality TIP Completion Rate]

		, [Cost Quality TIPs Successful]
		, [Cost Quality TIP Success Rate]
		, [Cost Quality TIP Net Effective Rate]

		, t1.[Star TIP Opportunities]
		, t1.[Star TIPs Completed]		as [Star TIPs Completed]
		, t1.[Star TIP Completion Rate]	as [Star TIP Completion Rate]	
		, t1.[Star TIPs Successful]		as [Star TIPs Successful]
		, t1.[Star TIPs Success Rate]	as [Start TIPs Success Rate]
		, t1.[Star TIP Net Effective Rate]	as [Star TIP Net Effective Rate]

		, c1.[CMR Opportunities]	as [CMR Opportunities]
		, c1.[CMRs Attempted]		as [CMRs Attempted]
		, c1.[CMR Attempt Rate]		as [CMR Attempt Rate]
		, c1.[CMRs Successful]		as [CMRs Successful]
		, c1.[CMR Success Rate]		as [CMR Success Rate]
		, c1.[CMR Completion Rate]	as [CMR Completion Rate]

		, a1.[AMP Checkpoint Opportunities]
		, a1.[AMP Checkpoints Completed]
		, a1.[AMP Checkpoints Successful]
		, a1.[AMP Checkpoint Completion Rate]
		, a1.[AMP Checkpoint Success Rate]
		, a1.[AMP Checkpoint Net Effective Rate]	

		, pv.[Patient Volume]
		, pa.[Patient Activity]

from	#org o
		left join 
		(

			select	o.orgID
					, count(distinct oc.centerID) as [CenterCount]
			from	#org2Center oc
					join #org o on o.orgID = oc.orgID
			where	1=1
			group by o.orgID
		)	oc on oc.orgID = o.orgID
		left join #TIPCount_Sum t1 on t1.OrgID = o.orgID 
		left join #CMRCount_Sum c1 on c1.orgID = o.orgID
		left join #AMP_Final a1 on a1.orgID = o.orgID
		left join 
		(
			select	pv.[Primary OrgID]
					, count(distinct pv.patientID) as [Patient Volume]
			from
			(
				select	tip.[Primary OrgID]
						, tip.patientid
				from	#UnionTIP tip
				union all
				select	cmr.[Primary OrgID]
						, cmr.patientid
				from	#UnionCMR cmr
				--union all
				--select amp.orgID as [Primary OrgID]
				--		, amp.PatientID  
				--from #AMP_Checkpoint amp 
				--where amp.TotalOpportunities_CheckpointCount > 0 and amp.PatientID is not null					
			)	pv
			group by pv.[Primary OrgID]
		)	pv on [Primary OrgID] = o.orgid
		left join 
		(
			select	pa.[Primary OrgID]
					, count(distinct pa.patientID) as [Patient Activity]
			from
			(
				select	tip.[Primary OrgID]
						, tip.patientid
				from	#UnionTIP tip
				where	tip.[Primary OrgID TIPs Completed] = 1 or tip.[Service OrgID TIPs Completed] = 1
				union all
				select	cmr.[Primary OrgID]
						, cmr.patientid
				from	#UnionCMR cmr
				where	cmr.[Primary OrgID CMRs Attempted] = 1 or cmr.[Service OrgID CMRs Attempted] = 1
				--union all
				--select amp.orgID as [Primary OrgID]
				--		, amp.PatientID  
				--from #AMP_Checkpoint amp 
				--where amp.TotalCompleted_CheckpointCount > 0 and amp.PatientID is not null
			)	pa
			group by pa.[Primary OrgID]
		)	pa on pa.[Primary OrgID] = o.orgid

where	1=1
order by o.orgID



end



