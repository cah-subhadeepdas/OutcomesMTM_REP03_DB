
/****** Object:  StoredProcedure [dbo].[UHC_RetailerKey_OrganizationTips_30_day]    Script Date: 6/15/2018 11:21:42 AM ******/

/*
 Modified as per TC- 1871 to update the chainrollup 
 Updated By: Vishal Deshmukh
 Date: 06/25/2018

*/

CREATE Procedure [dbo].[UHC_RetailerKey_OrganizationTips_30_day]
as 
begin 

if(object_ID('tempdb..#chainRollUp') is not null)
begin
drop table #chainRollUp
end
create table #chainRollUp (
ID int identity (1,1) primary key
, [Organization Category Size] int
, [Organization Name] varchar(100)
, RelationshipID varchar(50)
, NABP varchar(50))
Insert into #ChainRollup select '5','A S MEDICATION SOLUTIONS LLC','702',NULL
Insert into #ChainRollup select '3','ACCREDO HEALTH GROUP INC','392',NULL
Insert into #ChainRollup select '3','Acme Pharmacies','260',NULL
Insert into #ChainRollup select '3','ADVANCED HOME CARE INC','B44',NULL
Insert into #ChainRollup select '5','ADVANCED RX MANAGEMENT','A93',NULL
Insert into #ChainRollup select '2','Ahold Delhaize','233',NULL
Insert into #ChainRollup select '2','Ahold Delhaize','862',NULL
Insert into #ChainRollup select '2','Ahold Delhaize','289',NULL
Insert into #ChainRollup select '2','Ahold Delhaize','415',NULL
Insert into #ChainRollup select '2','Ahold Delhaize','075',NULL
Insert into #ChainRollup select '3','AHS-St. John Pharmacy','671',NULL
Insert into #ChainRollup select '3','AIDS HEALTHCARE FOUNDATION','A23',NULL
Insert into #ChainRollup select '1','Albertsons','929',NULL
Insert into #ChainRollup select '1','Albertsons','003',NULL
Insert into #ChainRollup select '1','Albertsons',NULL,'999572'
Insert into #ChainRollup select '1','Albertsons',NULL,'999573'
Insert into #ChainRollup select '1','Albertsons',NULL,'999574'
Insert into #ChainRollup select '1','Albertsons','156',NULL
Insert into #ChainRollup select '1','Albertsons','301',NULL
Insert into #ChainRollup select '1','Albertsons','B62',NULL
Insert into #ChainRollup select '1','Albertsons','158',NULL
Insert into #ChainRollup select '1','Albertsons','227',NULL
Insert into #ChainRollup select '1','Albertsons','282',NULL
Insert into #ChainRollup select '1','Albertsons','027',NULL
Insert into #ChainRollup select '1','Albertsons','400',NULL
Insert into #ChainRollup select '1','Albertsons',NULL,'999507'
Insert into #ChainRollup select '1','Albertsons',NULL,'999511'
Insert into #ChainRollup select '1','Albertsons',NULL,'999512'
Insert into #ChainRollup select '1','Albertsons',NULL,'999517'
Insert into #ChainRollup select '1','Albertsons','C08',NULL
Insert into #ChainRollup select '1','Albertsons','319',NULL
Insert into #ChainRollup select '1','Albertsons','C31',NULL
Insert into #ChainRollup select '3','ALEGENT RETAIL PHARMACIES','A47',NULL
Insert into #ChainRollup select '3','ALLINA COMMUNITY PHARMACIES','799',NULL
Insert into #ChainRollup select '3','AMBIENT HEALTHCARE INC','B18',NULL
Insert into #ChainRollup select '3','AMERITA INC','969',NULL
Insert into #ChainRollup select '3','APPALACHIAN REG HLTH CARE','492',NULL
Insert into #ChainRollup select '4','Arete Pharmacy','712',NULL
Insert into #ChainRollup select '4','Arete Pharmacy','941',NULL
Insert into #ChainRollup select '4','Arete Pharmacy','967',NULL
Insert into #ChainRollup select '4','Arete Pharmacy','678',NULL
Insert into #ChainRollup select '4','Arete Pharmacy','783',NULL
Insert into #ChainRollup select '4','Arete Pharmacy','426',NULL
Insert into #ChainRollup select '3','ASSOCIATED FRESH MARKET INC','A34',NULL
Insert into #ChainRollup select '3','ASTRUP DRUG INC','634',NULL
Insert into #ChainRollup select '3','Aurora Pharmacy','832',NULL
Insert into #ChainRollup select '3','Balls Food Stores','490',NULL
Insert into #ChainRollup select '3','Bartell Drugs','011',NULL
Insert into #ChainRollup select '3','Baystate Health','719',NULL
Insert into #ChainRollup select '3','BIG Y FOODS INC','835',NULL
Insert into #ChainRollup select '3','Bi-Mart','048',NULL
Insert into #ChainRollup select '3','BioRx','A78',NULL
Insert into #ChainRollup select '3','BRIOVARX LLC','951',NULL
Insert into #ChainRollup select '3','BROCKIE HEALTHCARE INC','538',NULL
Insert into #ChainRollup select '3','Brookshire Brothers','463',NULL
Insert into #ChainRollup select '3','Brookshire Grocery Co.','453',NULL
Insert into #ChainRollup select '4','Cardinal Health','603',NULL
Insert into #ChainRollup select '4','Cardinal Health','A51',NULL
Insert into #ChainRollup select '4','Cardinal Health','931',NULL
Insert into #ChainRollup select '4','Cardinal Health','139',NULL
Insert into #ChainRollup select '4','Cardinal Health','307',NULL
Insert into #ChainRollup select '3','Central Dakota Pharmacys','903',NULL
Insert into #ChainRollup select '3','CHEROKEE NATION HEALTH SERVICES PHA','B17',NULL
Insert into #ChainRollup select '3','CHICKASAW NATION DIVISION OF HEALTH','B07',NULL
Insert into #ChainRollup select '3','Choctaw Nation Healthcare','A11',NULL
Insert into #ChainRollup select '3','CIGNA MEDICAL GROUP PHARMACY','946',NULL
Insert into #ChainRollup select '3','CLEVELAND CLINIC PHARMACIES','A45',NULL
Insert into #ChainRollup select '3','CMC RX STEELE CREEK','A66',NULL
Insert into #ChainRollup select '3','Coborns Inc.','703',NULL
Insert into #ChainRollup select '3','Collier Drug Stores','A84',NULL
Insert into #ChainRollup select '3','COLONIAL MANAGEMENT GROUP LP','992',NULL
Insert into #ChainRollup select '3','COMMUNITY HEALTH CENTERS INC','B23',NULL
Insert into #ChainRollup select '3','Community Health Systems','A26',NULL
Insert into #ChainRollup select '5','Community Independent Pharmacy Network','A96',NULL
Insert into #ChainRollup select '3','CONCORD INC','954',NULL
Insert into #ChainRollup select '3','CONTINUCARE','B22',NULL
Insert into #ChainRollup select '3','COOK COUNTY','B04',NULL
Insert into #ChainRollup select '5','COOPHARMA','942',NULL
Insert into #ChainRollup select '3','CORAM LLC','863',NULL
Insert into #ChainRollup select '2','Costco','299',NULL
Insert into #ChainRollup select '3','COUNTY OF LOS ANGELES DEPARTMENT OF','B45',NULL
Insert into #ChainRollup select '3','CRESCENT HEALTHCARE','833',NULL
Insert into #ChainRollup select '3','CRITICAL CARE SYSTEMS','911',NULL
Insert into #ChainRollup select '1','CVS Pharmacy',NULL,'999104'
Insert into #ChainRollup select '1','CVS Pharmacy',NULL,'999818'
Insert into #ChainRollup select '1','CVS Pharmacy',NULL,'999682'
Insert into #ChainRollup select '1','CVS Pharmacy',NULL,'999690'
Insert into #ChainRollup select '1','CVS Pharmacy',NULL,'999689'
Insert into #ChainRollup select '1','CVS Pharmacy',NULL,'999688'
Insert into #ChainRollup select '1','CVS Pharmacy',NULL,'CVS1EAST'
Insert into #ChainRollup select '1','CVS Pharmacy',NULL,'CVS1WEST'
Insert into #ChainRollup select '1','CVS Pharmacy','177',NULL
Insert into #ChainRollup select '1','CVS Pharmacy','123',NULL
Insert into #ChainRollup select '1','CVS Pharmacy','039',NULL
Insert into #ChainRollup select '1','CVS Pharmacy','782',NULL
Insert into #ChainRollup select '1','CVS Pharmacy','608',NULL
Insert into #ChainRollup select '1','CVS Pharmacy','207',NULL
Insert into #ChainRollup select '1','CVS Pharmacy','673',NULL
Insert into #ChainRollup select '1','CVS Pharmacy','380',NULL
Insert into #ChainRollup select '1','CVS Pharmacy','008',NULL
Insert into #ChainRollup select '3','Dallas Metrocare Services','791',NULL
Insert into #ChainRollup select '3','Denver Health and Hospital Authority','A80',NULL
Insert into #ChainRollup select '2','DEPT OF VETERANS AFFAIRS','869',NULL
Insert into #ChainRollup select '3','DIERBERGS PHARMACY','332',NULL
Insert into #ChainRollup select '3','Discount Drug Mart','044',NULL
Insert into #ChainRollup select '3','DMVA PHARMACIES','B15',NULL
Insert into #ChainRollup select '3','DOCTORS CHOICE PHARMACIES','713',NULL
Insert into #ChainRollup select '2','DOD PHARMACO ECONOMIC CENTER','781',NULL
Insert into #ChainRollup select '3','DSHS PHARMACIES','A02',NULL
Insert into #ChainRollup select '3','Eaton Apothecary','055',NULL
Insert into #ChainRollup select '4','Elevate Provider Network','638',NULL
Insert into #ChainRollup select '4','Elevate Provider Network','904',NULL
Insert into #ChainRollup select '3','Emblem Health','271',NULL
Insert into #ChainRollup select '4','EPIC Pharmacies','455',NULL
Insert into #ChainRollup select '3','ESKENAZI HEALTH','689',NULL
Insert into #ChainRollup select '3','Essentia Health','573',NULL
Insert into #ChainRollup select '3','FAGEN PHARMACY IN','439',NULL
Insert into #ChainRollup select '3','FAIRVIEW HEALTH SERVICES','705',NULL
Insert into #ChainRollup select '3','Fairview Pharmacy Services','898',NULL
Insert into #ChainRollup select '3','Family Pharmacy','511',NULL
Insert into #ChainRollup select '3','FARMACIAS PLAZA','843',NULL
Insert into #ChainRollup select '5','FIRST COAST HEALTH SOLUTIONS','B30',NULL
Insert into #ChainRollup select '3','Fitzgeralds','795',NULL
Insert into #ChainRollup select '3','FLORIDA HEALTH CARE PLAN INC','B49',NULL
Insert into #ChainRollup select '2','freds Pharmacy','345',NULL
Insert into #ChainRollup select '2','freds Pharmacy','934',NULL
Insert into #ChainRollup select '3','Fruth Pharmacy','325',NULL
Insert into #ChainRollup select '3','Genoa, a QoL Healthcare Company ','945',NULL
Insert into #ChainRollup select '5','GERIMED LTC NETWORK INC','913',NULL
Insert into #ChainRollup select '3','GEROULDS PROFESSIONAL PHARMACY INC','A58',NULL
Insert into #ChainRollup select '2','Giant Eagle',NULL,'999650'
Insert into #ChainRollup select '2','Giant Eagle','248',NULL
Insert into #ChainRollup select '3','GOOD DAY PHARMACY','997',NULL
Insert into #ChainRollup select '3','GROUP HEALTH COOPERATIVE','510',NULL
Insert into #ChainRollup select '3','H AND H DRUG STORES INC','828',NULL
Insert into #ChainRollup select '3','HARMONS CITY INC','610',NULL
Insert into #ChainRollup select '3','Harps Food Stores','417',NULL
Insert into #ChainRollup select '3','HARRIS COUNTY HOSPITAL DISTRICT','963',NULL
Insert into #ChainRollup select '3','HARTIG DRUG CO CORP','087',NULL
Insert into #ChainRollup select '3','HARVARD VANGUARD MEDICAL ASSOCIATES','427',NULL
Insert into #ChainRollup select '3','Health Partners','639',NULL
Insert into #ChainRollup select '2','HEB Pharmacy','025',NULL
Insert into #ChainRollup select '3','Henry Ford Health System','655',NULL
Insert into #ChainRollup select '3','Hi-School Pharmacy','092',NULL
Insert into #ChainRollup select '3','HOME CHOICE PARTNERS INC','A38',NULL
Insert into #ChainRollup select '3','HOME SOLUTIONS','A16',NULL
Insert into #ChainRollup select '3','Homeland Pharmacy','309',NULL
Insert into #ChainRollup select '3','Horton & Converse','094',NULL
Insert into #ChainRollup select '3','Humana Pharmacy','A71',NULL
Insert into #ChainRollup select '2','Hy-Vee','097',NULL
Insert into #ChainRollup select '3','I.H.S.','842',NULL
Insert into #ChainRollup select '3','I.H.S.','860',NULL
Insert into #ChainRollup select '3','I.H.S.','865',NULL
Insert into #ChainRollup select '3','I.H.S.','875',NULL
Insert into #ChainRollup select '3','I.H.S.','877',NULL
Insert into #ChainRollup select '3','I.H.S.','906',NULL
Insert into #ChainRollup select '3','I.H.S.','907',NULL
Insert into #ChainRollup select '3','I.H.S.','908',NULL
Insert into #ChainRollup select '3','I.H.S.','918',NULL
Insert into #ChainRollup select '3','IHC Pharmacy Services','695',NULL
Insert into #ChainRollup select '3','INFUSION PARTNERS INC','A03',NULL
Insert into #ChainRollup select '3','Ingles Market Pharmacy','822',NULL
Insert into #ChainRollup select '5','INJURY RX LLC','A68',NULL
Insert into #ChainRollup select '5','INNOVATIX NETWORK LLC','915',NULL
Insert into #ChainRollup select '5','INNOVATIX NETWORK LLC','A00',NULL
Insert into #ChainRollup select '5','INSTY MEDS','872',NULL
Insert into #ChainRollup select '3','INTEGRIS PROHEALTH PHARMACY','B50',NULL
Insert into #ChainRollup select '3','JORDAN DRUG INC','801',NULL
Insert into #ChainRollup select '3','JPS Health Outpatient Pharmacies','B01',NULL
Insert into #ChainRollup select '3','JSA HEALTHCARE CORPORATION','887',NULL
Insert into #ChainRollup select '3','KAISER FOUNDATION HEALTH PLAN MIDAT','A85',NULL
Insert into #ChainRollup select '3','KAISER FOUNDATION HEALTH PLAN OF GE','A27',NULL
Insert into #ChainRollup select '3','KAISER PERMANENTE NCAL','917',NULL
Insert into #ChainRollup select '3','KAISER PERMANENTE SCAL','916',NULL
Insert into #ChainRollup select '3','KING KULLEN PHARMACY CORP','280',NULL
Insert into #ChainRollup select '3','Kinney Drugs, Inc.','109',NULL
Insert into #ChainRollup select '3','Klingensmiths Drug Stores','499',NULL
Insert into #ChainRollup select '2','Kmart','110',NULL
Insert into #ChainRollup select '3','Knight Drugs','379',NULL
Insert into #ChainRollup select '3','Kohlls Pharmacies','481',NULL
Insert into #ChainRollup select '3','KS Management Services','635',NULL
Insert into #ChainRollup select '3','K-VA-T Food Stores','687',NULL
Insert into #ChainRollup select '3','LIFECARE SOLUTIONS INC','A15',NULL
Insert into #ChainRollup select '3','LIFECHEK INC','632',NULL
Insert into #ChainRollup select '3','LIFETIME HEALTH MEDICAL GROUP PHARM','B43',NULL
Insert into #ChainRollup select '3','LINCARE INC','977',NULL
Insert into #ChainRollup select '3','LINS PHARMACY','A86',NULL
Insert into #ChainRollup select '3','LOMA LINDA UNIV MED CTR','804',NULL
Insert into #ChainRollup select '3','M K Stores, Inc. d/b/a Snyder Pharmacy','527',NULL
Insert into #ChainRollup select '3','MACEYS INC','A64',NULL
Insert into #ChainRollup select '3','Manatee County Rural Health Services','899',NULL
Insert into #ChainRollup select '3','Marcs Pharmacy','441',NULL
Insert into #ChainRollup select '3','MARICOPA INTEGRATED HEALTH SYSTEM','930',NULL
Insert into #ChainRollup select '3','MARKET BASKET PHARMACIES','544',NULL
Insert into #ChainRollup select '3','Marshfield clinic','526',NULL
Insert into #ChainRollup select '3','Martins Supermarkets','846',NULL
Insert into #ChainRollup select '3','Maxor National Pharmacy Services','516',NULL
Insert into #ChainRollup select '5','Maxor Xpress','A72',NULL
Insert into #ChainRollup select '3','Mayo Clinic Health System Pharmacy and Home Medical','847',NULL
Insert into #ChainRollup select '3','MAYO CLINIC PHARMACY','B08',NULL
Insert into #ChainRollup select '3','MCHUGH','B20',NULL
Insert into #ChainRollup select '4','McKesson - Access Health','605',NULL
Insert into #ChainRollup select '4','McKesson - Access Health','630',NULL
Insert into #ChainRollup select '4','McKesson - Access Health','841',NULL
Insert into #ChainRollup select '5','MDS RX','B10',NULL
Insert into #ChainRollup select '3','Med-Fast Pharmacy','682',NULL
Insert into #ChainRollup select '3','MEDICINE CHEST PHARMACIES','924',NULL
Insert into #ChainRollup select '5','MEDX SALES','A31',NULL
Insert into #ChainRollup select '2','Meijer','213',NULL
Insert into #ChainRollup select '3','MEMORIAL HEALTHCARE SYSTEM PHARMACI','B48',NULL
Insert into #ChainRollup select '3','MERCY HEALTH SYSTEM RETAIL PHCY','840',NULL
Insert into #ChainRollup select '3','Mercy Pharmacy','709',NULL
Insert into #ChainRollup select '4','MHA Long Term Care Network','905',NULL
Insert into #ChainRollup select '3','MULTICARE OUTPATIENT PHARMACIES','B14',NULL
Insert into #ChainRollup select '3','Muscogee Creek Nation Health System','680',NULL
Insert into #ChainRollup select '5','NATIONS PHARMACEUTICALS LLC','A19',NULL
Insert into #ChainRollup select '5','NCPRX','B13',NULL
Insert into #ChainRollup select '3','NE OH NEIGHBORHOOD HEALTH SRVS','746',NULL
Insert into #ChainRollup select '3','NEIGHBORCARE PHARMACY SERVICES INC','519',NULL
Insert into #ChainRollup select '3','NEW ENGLAND HOME THERAPIES','A25',NULL
Insert into #ChainRollup select '3','NORTHSIDE PHARMACY','770',NULL
Insert into #ChainRollup select '3','NYS OFFICE OF MENTAL HEALTH','953',NULL
Insert into #ChainRollup select '3','OMHSAS BUREAU HOSP OPERATIONS DPW','920',NULL
Insert into #ChainRollup select '3','OMNICARE INC NCS HEALTHCARE LLC','599',NULL
Insert into #ChainRollup select '3','Oncology Pharmacy Services','477',NULL
Insert into #ChainRollup select '3','OPTION CARE ENTERPRISES INC','838',NULL
Insert into #ChainRollup select '3','OWENS PHARMACY','B21',NULL
Insert into #ChainRollup select '3','PARK NICOLLET PHARMACY','341',NULL
Insert into #ChainRollup select '3','PATIENT FIRST CORPORATION','861',NULL
Insert into #ChainRollup select '3','PAYLESS DRUG PHARMACY GROUP LLC','A59',NULL
Insert into #ChainRollup select '3','PEOPLES PHARMACY','757',NULL
Insert into #ChainRollup select '3','PHARMACA INTEGRATIVE PHARMACY','960',NULL
Insert into #ChainRollup select '3','PHARMACY First - Third Party Station','854',NULL
Insert into #ChainRollup select '3','PHARMACY First - Third Party Station','A46',NULL
Insert into #ChainRollup select '3','PHARMACY First - Third Party Station','866',NULL
Insert into #ChainRollup select '3','PHARMACY PLUS INC','575',NULL
Insert into #ChainRollup select '3','PharMerica','752',NULL
Insert into #ChainRollup select '3','PharMerica','631',NULL
Insert into #ChainRollup select '3','PharMerica','686',NULL
Insert into #ChainRollup select '3','PharMerica','754',NULL
Insert into #ChainRollup select '3','PharMerica',NULL,'716211'
Insert into #ChainRollup select '3','PharMerica',NULL,'1567481'
Insert into #ChainRollup select '3','PharMerica',NULL,'2235112'
Insert into #ChainRollup select '3','PharMerica',NULL,'2639649'
Insert into #ChainRollup select '3','PharMerica',NULL,'2642494'
Insert into #ChainRollup select '3','PharMerica',NULL,'3727661'
Insert into #ChainRollup select '3','PharMerica',NULL,'4105311'
Insert into #ChainRollup select '5','PHYSICIANS PHARMACEUTICAL CORP','A83',NULL
Insert into #ChainRollup select '3','PILL BOX DRUGS INC','923',NULL
Insert into #ChainRollup select '3','PLANNED PARENTHOOD MAR MONTE INC','A57',NULL
Insert into #ChainRollup select '3','PLANNED PARENTHOOD OF GREATER OHIO','B00',NULL
Insert into #ChainRollup select '3','PLANNED PARENTHOOD OF GREATER WA AN','B57',NULL
Insert into #ChainRollup select '3','PLANNED PARENTHOOD OF ILLINOIS','B59',NULL
Insert into #ChainRollup select '3','PLANNED PARENTHOOD OF SOUTHWESTERN','B03',NULL
Insert into #ChainRollup select '5','POC MANAGEMENT GROUP LLC','974',NULL
Insert into #ChainRollup select '5','PPOK RxSelect Network','769',NULL
Insert into #ChainRollup select '3','PRESBYTERIAN MEDICAL SERVICES INC','A12',NULL
Insert into #ChainRollup select '3','PRESCRIBEIT RX','912',NULL
Insert into #ChainRollup select '5','PRESCRIPTION PARTNERS','952',NULL
Insert into #ChainRollup select '3','Price Chopper Supermarkets','434',NULL
Insert into #ChainRollup select '3','PRICE CUTTER PHARMACY','701',NULL
Insert into #ChainRollup select '3','PROF SPECIALIZED PHARMACIES LLC','824',NULL
Insert into #ChainRollup select '3','PROFESSIONAL PHARMACY SERVICES INC','480',NULL
Insert into #ChainRollup select '5','PROGRESSIVE PHARMACIES LLC','979',NULL
Insert into #ChainRollup select '3','PUBLIC HEALTH TRUST OF DADE COUNTY','A67',NULL
Insert into #ChainRollup select '1','Publix','302',NULL
Insert into #ChainRollup select '5','QCP NETWORX','B40',NULL
Insert into #ChainRollup select '3','Quick Chek Food Stores','267',NULL
Insert into #ChainRollup select '3','QVL PHARMACY HOLDINGS INC','858',NULL
Insert into #ChainRollup select '3','Raleys/Bel Air Pharmacies','171',NULL
Insert into #ChainRollup select '3','REASOR','B27',NULL
Insert into #ChainRollup select '5','Recept Pharmacy','891',NULL
Insert into #ChainRollup select '3','RECEPT PHARMACY LP','A50',NULL
Insert into #ChainRollup select '3','Red Cross Pharmacy','743',NULL
Insert into #ChainRollup select '3','Redners Markets','852',NULL
Insert into #ChainRollup select '1','Rite Aid','181',NULL
Insert into #ChainRollup select '1','Rite Aid','045',NULL
Insert into #ChainRollup select '1','Rite Aid','056',NULL
Insert into #ChainRollup select '3','Ritzman Pharmacy Inc','424',NULL
Insert into #ChainRollup select '3','Rural Healthcare Inc. ','935',NULL
Insert into #ChainRollup select '3','SAINT JOSEPH MERCY PHARMACY','520',NULL
Insert into #ChainRollup select '2','SAMS CLUB','C11',NULL
Insert into #ChainRollup select '3','SANTA CLARA VALLEY HEALTH AND HOSPI','A37',NULL
Insert into #ChainRollup select '3','Save Mart Supermarkets','310',NULL
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2307610'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2353403'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2319615'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2310770'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2344745'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2310732'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2345696'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2336887'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2303888'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2354734'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2317849'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2366157'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2310100'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2347830'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2354570'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2303903'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2331469'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2353439'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2353427'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2353441'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2353453'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2110182'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2103199'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2332473'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2317685'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'905010'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2323715'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2313031'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2324983'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2701969'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'3428047'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5729744'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5120972'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'3683009'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5647358'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'1015709'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'202135'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'202628'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'202604'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'202173'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'1034432'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5055757'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'3422855'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'714837'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5914141'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5903314'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5918733'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'4589341'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5920891'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'1165718'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'6004713'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5728677'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5920752'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'228608'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5654721'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'6001894'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'723785'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'1490678'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5713183'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'1490767'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5727776'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5728069'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5728071'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5656838'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5728083'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'6002911'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5728362'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5728348'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5728350'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5728336'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5728374'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5657599'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'1565021'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2991099'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'2991950'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5659858'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'3729538'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'3729639'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'360951'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'361042'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'361054'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5622881'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5640378'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5628017'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'1720069'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'135144'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5636711'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'1240946'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'1934036'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5630442'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5133789'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'1565069'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'6000880'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'6000878'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'355936'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'3990769'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'3995428'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5720734'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'1566073'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'1931876'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5653767'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'4446793'
Insert into #ChainRollup select '3','Sav-Mor Drug Stores',NULL,'5723475'
Insert into #ChainRollup select '3','Schnuck Markets, Inc.','133',NULL
Insert into #ChainRollup select '3','Seip Drug LLC','968',NULL
Insert into #ChainRollup select '2','Shopko',NULL,'999974'
Insert into #ChainRollup select '2','Shopko',NULL,'999957'
Insert into #ChainRollup select '2','Shopko','246',NULL
Insert into #ChainRollup select '2','Southeastern Grocers','315',NULL
Insert into #ChainRollup select '2','Southeastern Grocers','292',NULL
Insert into #ChainRollup select '3','SpartanNash','320',NULL
Insert into #ChainRollup select '3','SpartanNash',NULL,'2365460'
Insert into #ChainRollup select '3','SpartanNash',NULL,'2372150'
Insert into #ChainRollup select '3','STAR DISCOUNT PHARMACY INC','998',NULL
Insert into #ChainRollup select '3','STONER DRUG CO','943',NULL
Insert into #ChainRollup select '3','SUNCOAST COMMUNITY HEALTH CENTERS I','B41',NULL
Insert into #ChainRollup select '3','SUPERVALU','410',NULL
Insert into #ChainRollup select '3','SUPERVALU','285',NULL
Insert into #ChainRollup select '5','SWIFT RX LLC','A74',NULL
Insert into #ChainRollup select '3','Tampa Family Health Centers','A24',NULL
Insert into #ChainRollup select '5','TEMPEST MED','A79',NULL
Insert into #ChainRollup select '1','The Kroger Co.','108',NULL
Insert into #ChainRollup select '1','The Kroger Co.','199',NULL
Insert into #ChainRollup select '1','The Kroger Co.','273',NULL
Insert into #ChainRollup select '1','The Kroger Co.','043',NULL
Insert into #ChainRollup select '1','The Kroger Co.','495',NULL
Insert into #ChainRollup select '1','The Kroger Co.','069',NULL
Insert into #ChainRollup select '1','The Kroger Co.','071',NULL
Insert into #ChainRollup select '1','The Kroger Co.','817',NULL
Insert into #ChainRollup select '1','The Kroger Co.','602',NULL
Insert into #ChainRollup select '1','The Kroger Co.','A65',NULL
Insert into #ChainRollup select '1','The Kroger Co.','B67',NULL
Insert into #ChainRollup select '1','The Kroger Co.','113',NULL
Insert into #ChainRollup select '1','The Kroger Co.',NULL,'999546'
Insert into #ChainRollup select '1','The Kroger Co.',NULL,'999548'
Insert into #ChainRollup select '1','The Kroger Co.',NULL,'999549'
Insert into #ChainRollup select '1','The Kroger Co.',NULL,'999667'
Insert into #ChainRollup select '1','The Kroger Co.',NULL,'999668'
Insert into #ChainRollup select '1','The Kroger Co.',NULL,'999670'
Insert into #ChainRollup select '1','The Kroger Co.',NULL,'999671'
Insert into #ChainRollup select '1','The Kroger Co.',NULL,'999672'
Insert into #ChainRollup select '1','The Kroger Co.',NULL,'999673'
Insert into #ChainRollup select '1','The Kroger Co.',NULL,'999674'
Insert into #ChainRollup select '1','The Kroger Co.',NULL,'999669'
Insert into #ChainRollup select '1','The Kroger Co.',NULL,'999317'
Insert into #ChainRollup select '3','THE METROHEALTH SYSTEM PHARMACY','B61',NULL
Insert into #ChainRollup select '3','Thrifty White Pharmacy',NULL,'999656'
Insert into #ChainRollup select '3','Thrifty White Pharmacy','216',NULL
Insert into #ChainRollup select '3','Times Supermarket','372',NULL
Insert into #ChainRollup select '5','TN MENTAL HLTH AND DEV DISABILITIES','921',NULL
Insert into #ChainRollup select '3','Tops Markets, LLC','978',NULL
Insert into #ChainRollup select '3','TriHealth','900',NULL
Insert into #ChainRollup select '3','U SAVE PHARMACY','808',NULL
Insert into #ChainRollup select '3','UCDHS PHARMACIES','B12',NULL
Insert into #ChainRollup select '3','UCSD Medical Center Pharmacies','715',NULL
Insert into #ChainRollup select '3','Univ of Missouri Hosp and Clinic','691',NULL
Insert into #ChainRollup select '3','University of Kansas Hospital Pharmacy','A87',NULL
Insert into #ChainRollup select '3','University of Utah Hospital','744',NULL
Insert into #ChainRollup select '3','UofV Virginia Medical Centers','A98',NULL
Insert into #ChainRollup select '3','US BIOSERVICES CORPORATION','758',NULL
Insert into #ChainRollup select '3','UW HEALTH PHARMACY SERVICES','700',NULL
Insert into #ChainRollup select '3','VA DMHMRSAS','914',NULL
Insert into #ChainRollup select '5','VANTAGE RX DISPENSING SERVICES LLC','989',NULL
Insert into #ChainRollup select '3','Virginia Commenealth University Hospital','696',NULL
Insert into #ChainRollup select '3','VIRGINIA MASON MEDICAL CTR','654',NULL
Insert into #ChainRollup select '2','Wakefern','A33',NULL
Insert into #ChainRollup select '2','Wakefern','197',NULL
Insert into #ChainRollup select '2','Wakefern','613',NULL
Insert into #ChainRollup select '2','Wakefern','618',NULL
Insert into #ChainRollup select '2','Wakefern','619',NULL
Insert into #ChainRollup select '2','Wakefern','620',NULL
Insert into #ChainRollup select '2','Wakefern','621',NULL
Insert into #ChainRollup select '2','Wakefern','622',NULL
Insert into #ChainRollup select '2','Wakefern','640',NULL
Insert into #ChainRollup select '2','Wakefern','894',NULL
Insert into #ChainRollup select '1','Walgreens Co. ','226',NULL
Insert into #ChainRollup select '1','Walgreens Co. ','A10',NULL
Insert into #ChainRollup select '1','Walgreens Co. ','A13',NULL
Insert into #ChainRollup select '1','Walmart','229',NULL
Insert into #ChainRollup select '3','WALTER LAGESTEE INCORPORATED','A97',NULL
Insert into #ChainRollup select '3','WEBER AND JUDD COMPANY INC','649',NULL
Insert into #ChainRollup select '3','Wegmans Food Markets, Inc','256',NULL
Insert into #ChainRollup select '3','Weis Markets','232',NULL
Insert into #ChainRollup select '3','Yakima Valley Farm Workers Clinic','987',NULL
Insert into #ChainRollup select '3','YOKES FOODS INC','534',NULL




if(object_ID('tempdb..#org') is not null)
begin
drop table #org
end
create table #org (
orgID int identity (1,1) primary key
, [Organization Name] varchar(100)
, [Organization Category Size] int
)
insert into #org ([Organization Name], [Organization Category Size])
select distinct [organization Name]
, [Organization Category Size] 
from #chainrollup
where 1=1 


if(object_ID('tempdb..#Org2Center') is not null)
begin
drop table #Org2Center
end
create table #org2Center(
orgID int 
, centerid int
, NCPDP_NABP varchar (50) 
primary key (orgid, centerid) 
)
;with ch as (

       select cr.[Organization Name]
          , p.centerid
          , p.NCPDP_NABP 
       from #chainRollUp cr
       join OutcomesMTM.dbo.chain c on c.chainCode = cr.RelationshipID 
       join outcomesmtm.dbo.pharmacychain pc on pc.chainid = c.chainid
       join outcomesmtm.dbo.pharmacy p on p.centerid = pc.centerid and p.active=1
       where 1=1

),
ph as (

       select cr.[Organization Name], p.centerid, p.NCPDP_NABP
       from #chainRollUp cr
       join outcomesmtm.dbo.pharmacy p on p.NCPDP_NABP = cr.NABP and p.active=1
       where 1=1


)
insert into #Org2Center (orgid, centerid, NCPDP_NABP) 
select o.orgid, t.centerid, t.NCPDP_NABP  
from (
		select ch.[Organization Name], ch.centerid, ch.NCPDP_NABP
		from ch
		where 1=1
		union
		select ph.[Organization Name], ph.centerid, ph.NCPDP_NABP
		from ph
		where 1=1
) t
join #org o on o.[Organization Name] = t.[Organization Name]
where 1=1





if(object_ID('tempdb..#pharmacy') is not null)
begin
drop table #pharmacy
end

select o.[Organization Name]
,o.orgid 
into #pharmacy
from #org o



if(object_ID('tempdb..#NeedsRefill') is not null)
begin
drop table #NeedsRefill
end
Select p.orgid,
--p.centerid
'Needs Refill' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Needs Refill Opportunities]
, isnull(t1.[Count of Opportunities > 7 days],0) as [Needs Refill opportunities w/ Aging Criteria]
, isnull(t1.[Count of Completed TIPs],0) as [Needs Refill Completed]
, isnull(t1.[Count of Successful TIPs],0) as [Needs Refill Success]
, isnull(cv.[Count of Validated Claims],0) as [Needs Refill Validated]
, isnull(t1.[% Completed],0.00) as [Needs Refill Completion %]
, isnull(t1.[% Success],0.00) as [Needs Refill Success %]
, ISNULL(cast((cast(cv.[Count of Validated Claims] as decimal)*100/NULLIF(cast(t1.[Count of Successful TIPs] as decimal), 0)) as decimal (5,2)), 0) as [Needs Refill Validation Rate %]
, isnull(t1.[Count of Active TIPs],0) as [Needs Refill Count of Active TIPs Opportunities]
, isnull(t1.[% Net Effective],0.00) as [Needs Refill NER]

into #NeedsRefill
from #org p
 join
(
	select t.orgid
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[7dayTip]) as decimal) as [Count of Opportunities > 7 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[7dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[7dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*,oc.orgid
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 7 then 1 else 0 end as [7dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID
		join #org2center oc on ta.centerid=oc.centerid
		join #org o on oc.orgid=o.orgid
		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (1761,1760,1759)
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh
		--and o.orgid=3
	) t

	where 1 = 1
	and t.Rank = 1
	group by t.orgid--,t.tiptitle
) t1 on p.orgID = t1.orgID

left join 
(
select orgid
--, cast(sum(a.[Count of Validation]) as decimal) as [Count of Validation]
, cast(sum(a.[Count of Validated Claims]) as decimal) as [Count of Validated Claims]

from (

		select t.orgid 
		--, cast(sum(t.ValidatedClaims) as decimal) as [Count of Validation]
		, cast(sum(t.validate) as decimal) as [Count of Validated Claims]
		from (

				select c.claimID
				, case when cv.validated = 1 and cv.payable = 1 and cv.processed = 1
						then 1 else 0 end as ValidatedClaims
				, case when cv.validated = 1 then 1 else 0 end as Validate
				, oc.orgID
				, cv.validated
				from dbo.claim c
				join staging.claimvalidation cv on cv.claimID = c.claimID
				join #org2Center oc on oc.centerID = c.centerID
				join dbo.policy po on po.policyID = c.policyid
				join dbo.contract co on co.ContractID = po.contractID
				join dbo.client cl on cl.clientID = co.ClientID
				where 1=1
				and c.tipdetailid in (1761,1760,1759)
                --and c.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
				and c.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh
				and cl.clientID = 105
				and c.statusID = 6
				and cv.active = 1
				and (year(cast(c.mtmserviceDT as date)) = year(cast(getdate() as date))
					or (cast(c.mtmserviceDT as date) is null))

		) t
		join #org o on o.orgid = t.orgid 
		where 1 = 1
		group by t.orgID
		
)a
group by a.orgid
)cv on cv.orgid=p.orgid
where 1 = 1



if(object_ID('tempdb..#Needs90Day') is not null)
begin
drop table #Needs90Day
end
Select p.orgid,
 'Needs 90 Day Fill' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Needs 90 Day Fill Opportunities]
, isnull(t1.[Count of Opportunities > 30 days],0) as [Needs 90 Day Fill Opportunities w/ Aging Criteria]
, isnull(t1.[Count of Completed TIPs],0) as [Needs 90 Day Fill Completed]
, isnull(t1.[Count of Successful TIPs],0) as [Needs 90 Day Fill Success]
, isnull(cv.[Count of Validated Claims],0) as [Needs 90 Day Fill Validated]
, isnull(t1.[% Completed],0.00) as [Needs 90 Day Fill Completion %]
, isnull(t1.[% Success],0.00) as [Needs 90 Day Fill Success %]
,ISNULL(cast((cast(cv.[Count of Validated Claims] as decimal)*100/NULLIF(cast(t1.[Count of Successful TIPs] as decimal), 0)) as decimal (5,2)), 0) as [Needs 90 Day Fill Validation Rate %]
, isnull(t1.[Count of Active TIPs],0) as [Needs 90 Day Fill Active TIPs opportunities]
, isnull(t1.[% Net Effective],0.00) as [Needs 90 Day Fill NER]

into #Needs90Day
from #org p
 join
(
	select t.orgID
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[30dayTip]) as decimal) as [Count of Opportunities > 30 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*,oc.orgid
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30 then 1 else 0 end as [30dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID
		join #org2center oc on oc.centerid=ta.centerid
		join #org o on o.orgid=oc.orgid

		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (318,319,320,1857,1858,1859)
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh

	) t

	where 1 = 1
	and t.Rank = 1
	group by t.orgID--,t.tiptitle
) t1 on p.orgID = t1.orgid

left join 
(
select orgid
--, cast(sum(a.[Count of Validation]) as decimal) as [Count of Validation]
, cast(sum(a.[Count of Validated Claims]) as decimal) as [Count of Validated Claims]
from (

		select t.orgid 
		--, cast(sum(t.ValidatedClaims) as decimal) as [Count of Validation]
		, cast(sum(t.validate) as decimal) as [Count of Validated Claims]
		from (

				select c.claimID
				, case when cv.validated = 1 and cv.payable = 1 and cv.processed = 1
						then 1 else 0 end as ValidatedClaims
				, case when cv.validated = 1 then 1 else 0 end as Validate
				, oc.orgID
				, cv.validated
				from dbo.claim c
				join staging.claimvalidation cv on cv.claimID = c.claimID
				join #org2Center oc on oc.centerID = c.centerID
				join dbo.policy po on po.policyID = c.policyid
				join dbo.contract co on co.ContractID = po.contractID
				join dbo.client cl on cl.clientID = co.ClientID
				where 1=1
				and c.tipdetailid in (318,319,320,1857,1858,1859)
                --and c.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
				and c.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh
				and cl.clientID = 105
				and c.statusID = 6
				and cv.active = 1
				and (year(cast(c.mtmserviceDT as date)) = year(cast(getdate() as date))
					or (cast(c.mtmserviceDT as date) is null))

		) t
		join #org o on o.orgid = t.orgid 
		where 1 = 1
		group by t.orgID
		
)a
group by a.orgid
)cv on cv.orgid=p.orgid
where 1 = 1



if(object_ID('tempdb..#NeedsDrugTherapyStatinDiabetes') is not null)
begin
drop table #NeedsDrugTherapyStatinDiabetes
end

Select p.orgid,
 'Needs Drug Therapy -Statin-Diabetes' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Needs Drug Therapy - Statin - Diabetes Opportunities]
, isnull(t1.[Count of Opportunities > 30 days],0) as [Needs Drug Therapy - Statin - Diabetes Opportunities w/ Aging Criteria]
, isnull(t1.[Count of Completed TIPs],0) as [Needs Drug Therapy - Statin - Diabetes Completed]
, isnull(t1.[Count of Successful TIPs],0) as [Needs Drug Therapy - Statin - Diabetes Success]
, isnull(cv.[Count of Validated Claims],0) as [Needs Drug Therapy - Statin - Diabetes Validated]
, isnull(t1.[% Completed],0.00) as [Needs Drug Therapy - Statin - Diabetes Completion %]
, isnull(t1.[% Success],0.00) as [Needs Drug Therapy - Statin - Diabetes Success %]
,ISNULL(cast((cast(cv.[Count of Validated Claims] as decimal)*100/NULLIF(cast(t1.[Count of Successful TIPs] as decimal), 0)) as decimal (5,2)), 0) as [Needs Drug Therapy - Statin - Diabetes Validation Rate %]
, isnull(t1.[Count of Active TIPs],0) as [Needs Drug Therapy - Statin - Diabetes Active TIPs Opportunities]
, isnull(t1.[% Net Effective],0.00) as [Needs Drug Therapy - Statin - Diabetes NER]

into #NeedsDrugTherapyStatinDiabetes
from #org p
 join
(
	select t.orgid
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[30dayTip]) as decimal) as [Count of Opportunities > 30 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*,oc.orgid
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30 then 1 else 0 end as [30dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID
		join #org2center oc on oc.centerid=ta.centerid
		join #org o on o.orgid=oc.orgid
		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (650) --(246,244,247)
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh

	) t

	where 1 = 1
	and t.Rank = 1
	group by t.orgid--,t.tiptitle
) t1 on p.orgID = t1.orgID

left join 
(
select orgid
--, cast(sum(a.[Count of Validation]) as decimal) as [Count of Validation]
, cast(sum(a.[Count of Validated Claims]) as decimal) as [Count of Validated Claims]

from (

		select t.orgid 
		--, cast(sum(t.ValidatedClaims) as decimal) as [Count of Validation]
		, cast(sum(t.validate) as decimal) as [Count of Validated Claims]
		from (

				select c.claimID
				, case when cv.validated = 1 and cv.payable = 1 and cv.processed = 1
						then 1 else 0 end as ValidatedClaims
				, case when cv.validated = 1 then 1 else 0 end as Validate
				, oc.orgID
				, cv.validated
				from dbo.claim c
				join staging.claimvalidation cv on cv.claimID = c.claimID
				join #org2Center oc on oc.centerID = c.centerID
				join dbo.policy po on po.policyID = c.policyid
				join dbo.contract co on co.ContractID = po.contractID
				join dbo.client cl on cl.clientID = co.ClientID
				where 1=1
				and c.tipdetailid in (650) --(246,244,247)
				--and c.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
				and c.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh
				and cl.clientID = 105
				and c.statusID = 6
				and cv.active = 1
				and (year(cast(c.mtmserviceDT as date)) = year(cast(getdate() as date))
					or (cast(c.mtmserviceDT as date) is null))

		) t
		join #org o on o.orgid = t.orgid 
		where 1 = 1
		group by t.orgID
		
)a
group by a.orgid
)cv on cv.orgid=p.orgid
where 1 = 1

if(object_ID('tempdb..#NeedsDrugTherapyStatinCVD') is not null)
begin
drop table #NeedsDrugTherapyStatinCVD
end

Select p.orgid
, 'Needs Drug Therapy-Statin-CVD' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Needs Drug Therapy - Statin - CVD Opportunities]
, isnull(t1.[Count of Opportunities > 30 days],0) as [Needs Drug Therapy - Statin - CVD Opportunities w/ Aging Criteria]
, isnull(t1.[Count of Completed TIPs],0) as [Needs Drug Therapy - Statin - CVD Completed]
, isnull(t1.[Count of Successful TIPs],0) as [Needs Drug Therapy - Statin - CVD Success]
, isnull(cv.[Count of Validated Claims],0) as [Needs Drug Therapy - Statin - CVD Validated]
, isnull(t1.[% Completed],0.00) as [Needs Drug Therapy - Statin - CVD Completion %]
, isnull(t1.[% Success],0.00) as [Needs Drug Therapy - Statin - CVD Success %]
, ISNULL(cast((cast(cv.[Count of Validated Claims] as decimal)*100/NULLIF(cast(t1.[Count of Successful TIPs] as decimal), 0)) as decimal (5,2)), 0) as [Needs Drug Therapy - Statin - CVD Validation Rate %]
, isnull(t1.[Count of Active TIPs],0) as [Needs Drug Therapy - Statin - CVD Active TIPs Opportunities]
, isnull(t1.[% Net Effective],0.00) as [Needs Drug Therapy - Statin - CVD NER]
into #NeedsDrugTherapyStatinCVD
--from outcomesMTM.dbo.pharmacy p 
from #org p
 join
(
	select t.orgid
	--,t.tiptitle
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[30dayTip]) as decimal) as [Count of Opportunities > 30 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*,oc.orgid
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30 then 1 else 0 end as [30dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID
		join #org2center oc on oc.centerid=ta.centerid
		join #org o on o.orgid=oc.orgid

		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (1901) 
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh

	) t

	where 1 = 1
	and t.Rank = 1
	group by t.orgid--,t.tiptitle
) t1 on p.orgID = t1.orgID

left join 
(
select orgid
--, cast(sum(a.[Count of Validation]) as decimal) as [Count of Validation]
, cast(sum(a.[Count of Validated Claims]) as decimal) as [Count of Validated Claims]

from (

		select t.orgid 
		--, cast(sum(t.ValidatedClaims) as decimal) as [Count of Validation]
		, cast(sum(t.validate) as decimal) as [Count of Validated Claims]
		from (

				select c.claimID
				, case when cv.validated = 1 and cv.payable = 1 and cv.processed = 1
						then 1 else 0 end as ValidatedClaims
				, case when cv.validated = 1 then 1 else 0 end as Validate
				, oc.orgID
				, cv.validated
				from dbo.claim c
				join staging.claimvalidation cv on cv.claimID = c.claimID
				join #org2Center oc on oc.centerID = c.centerID
				join dbo.policy po on po.policyID = c.policyid
				join dbo.contract co on co.ContractID = po.contractID
				join dbo.client cl on cl.clientID = co.ClientID
				where 1=1
				and c.tipdetailid in (1901) --(246,244,247)
				--and c.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
				and c.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh
				and cl.clientID = 105
				and c.statusID = 6
				and cv.active = 1
				and (year(cast(c.mtmserviceDT as date)) = year(cast(getdate() as date))
					or (cast(c.mtmserviceDT as date) is null))

		) t
		join #org o on o.orgid = t.orgid 
		where 1 = 1
		group by t.orgID
		
)a
group by a.orgid
)cv on cv.orgid=p.orgid
where 1 = 1



if(object_ID('tempdb..#SuboptimalDrug') is not null)
begin
drop table #SuboptimalDrug
end

Select p.orgid
, 'Suboptimal Drug - Low-Intensity Statin - CVD' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Suboptimal Drug - Low-Intensity Statin - CVD Opportunities]
, isnull(t1.[Count of Opportunities > 30 days],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Opportunities w/ Aging Criteria]
, isnull(t1.[Count of Completed TIPs],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Completed]
, isnull(t1.[Count of Successful TIPs],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Success]
, isnull(cv.[Count of Validated Claims],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Validated]
, isnull(t1.[% Completed],0.00) as [Suboptimal Drug - Low-Intensity Statin - CVD Completion %]
, isnull(t1.[% Success],0.00) as [Suboptimal Drug - Low-Intensity Statin - CVD Success %]
, isnull(t1.[Count of Active TIPs],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Active TIPs Opportunities]
, ISNULL(cast((cast(cv.[Count of Validated Claims] as decimal)*100/NULLIF(cast(t1.[Count of Successful TIPs] as decimal), 0)) as decimal (5,2)), 0) as [Suboptimal Drug - Low-Intensity Statin - CVD Validation Rate %]
, isnull(t1.[% Net Effective],0.00) as [Suboptimal Drug - Low-Intensity Statin - CVD NER]
into #SuboptimalDrug
--from outcomesMTM.dbo.pharmacy p 
 from #org p
 join
(
	select t.orgID
	--,t.tiptitle
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[30dayTip]) as decimal) as [Count of Opportunities > 30 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*,oc.orgID
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30 then 1 else 0 end as [30dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID
		join #org2center oc on oc.centerid=ta.centerid
		join #org o on o.orgid=oc.orgid
		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (1904) 
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh

	) t

	where 1 = 1
	and t.Rank = 1
	group by t.orgid--,t.tiptitle
) t1 on p.orgID = t1.orgID


left join 
(
select orgid
--, cast(sum(a.[Count of Validation]) as decimal) as [Count of Validation]
, cast(sum(a.[Count of Validated Claims]) as decimal) as [Count of Validated Claims]

from (

		select t.orgid 
		--, cast(sum(t.ValidatedClaims) as decimal) as [Count of Validation]
		, cast(sum(t.validate) as decimal) as [Count of Validated Claims]
		from (

				select c.claimID
				, case when cv.validated = 1 and cv.payable = 1 and cv.processed = 1
						then 1 else 0 end as ValidatedClaims
				, case when cv.validated = 1 then 1 else 0 end as Validate
				, oc.orgID
				, cv.validated
				from dbo.claim c
				join staging.claimvalidation cv on cv.claimID = c.claimID
				join #org2Center oc on oc.centerID = c.centerID
				join dbo.policy po on po.policyID = c.policyid
				join dbo.contract co on co.ContractID = po.contractID
				join dbo.client cl on cl.clientID = co.ClientID
				where 1=1
				and c.tipdetailid in (1904) --(246,244,247)
				--and c.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
				and c.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh
				and cl.clientID = 105
				and c.statusID = 6
				and cv.active = 1
				and (year(cast(c.mtmserviceDT as date)) = year(cast(getdate() as date))
					or (cast(c.mtmserviceDT as date) is null))

		) t
		join #org o on o.orgid = t.orgid 
		where 1 = 1
		group by t.orgID
		
)a
group by a.orgid
)cv on cv.orgid=p.orgid
where 1 = 1



if(object_ID('tempdb..#NeedsMedSync') is not null)
begin
drop table #NeedsMedSync
end

Select
p.orgid
, 'Needs Medication Synchronization' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Needs Medication Synchronization Opportunities]
, isnull(t1.[Count of Opportunities > 30 days],0) as [Needs Medication Synchronization Opportunities w/ Aging Criteria]
, isnull(t1.[Count of Completed TIPs],0) as [Needs Medication Synchronization Completed]
, isnull(t1.[Count of Successful TIPs],0) as [Needs Medication Synchronization Success]
, isnull(cv.[Count of Validated Claims],0) as [Needs Medication Synchronization Validated]
, isnull(t1.[% Completed],0.00) as [Needs Medication Synchronization Completion %]
, isnull(t1.[% Success],0.00) as [Needs Medication Synchronization Success %]
, ISNULL(cast((cast(cv.[Count of Validated Claims] as decimal)*100/NULLIF(cast(t1.[Count of Successful TIPs] as decimal), 0)) as decimal (5,2)), 0) as [Needs Medication Synchronization Validation Rate %]
, isnull(t1.[Count of Active TIPs],0) as [Needs Medication Synchronization Active TIPs Opportunities]
, isnull(t1.[% Net Effective],0.00) as [Needs Medication Synchronization NER]

into #NeedsMedSync
--from outcomesMTM.dbo.pharmacy p 
from #org p
 join
(
	select t.orgID
	--,t.tiptitle
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[30dayTip]) as decimal) as [Count of Opportunities > 30 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*,oc.orgid
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30 then 1 else 0 end as [30dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID
		join #org2center oc on oc.centerid=ta.centerid
		join #org o on o.orgid=oc.orgid

		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (1768)
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh

	) t

	where 1 = 1
	and t.Rank = 1
	group by t.orgid--,t.tiptitle
) t1 on p.orgID = t1.orgid

left join 
(
select orgid
--, cast(sum(a.[Count of Validation]) as decimal) as [Count of Validation]
, cast(sum(a.[Count of Validated Claims]) as decimal) as [Count of Validated Claims]

from (

		select t.orgid 
		--, cast(sum(t.ValidatedClaims) as decimal) as [Count of Validation]
		, cast(sum(t.validate) as decimal) as [Count of Validated Claims]
		from (

				select c.claimID
				, case when cv.validated = 1 and cv.payable = 1 and cv.processed = 1
						then 1 else 0 end as ValidatedClaims
				, case when cv.validated = 1 then 1 else 0 end as Validate
				, oc.orgID
				, cv.validated
				from dbo.claim c
				join staging.claimvalidation cv on cv.claimID = c.claimID
				join #org2Center oc on oc.centerID = c.centerID
				join dbo.policy po on po.policyID = c.policyid
				join dbo.contract co on co.ContractID = po.contractID
				join dbo.client cl on cl.clientID = co.ClientID
				where 1=1
				and c.tipdetailid in (1768)
				--and c.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
				and c.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh
				and cl.clientID = 105
				and c.statusID = 6
				and cv.active = 1
				and (year(cast(c.mtmserviceDT as date)) = year(cast(getdate() as date))
					or (cast(c.mtmserviceDT as date) is null))

		) t
		join #org o on o.orgid = t.orgid 
		where 1 = 1
		group by t.orgID
		
)a
group by a.orgid
)cv on cv.orgid=p.orgid
where 1 = 1







if(object_ID('tempdb..#AdherenceMonitoring') is not null)
begin
drop table #AdherenceMonitoring
end

Select p.orgid
, 'Adherence Monitoring' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Adherence Monitoring Opportunities]
, isnull(t1.[Count of Opportunities > 30 days],0) as [Adherence Monitoring Opportunities w/ Aging Criteria]
, isnull(t1.[Count of Completed TIPs],0) as [Adherence Monitoring Completed]
, isnull(t1.[Count of Successful TIPs],0) as[Adherence Monitoring Success]
, isnull(cv.[Count of Validated Claims],0) as [Adherence Monitoring Validated]
, isnull(t1.[% Completed],0.00) as [Adherence Monitoring Completion %]
, isnull(t1.[% Success],0.00) as [Adherence Monitoring Success %]
, ISNULL(cast((cast(cv.[Count of Validated Claims] as decimal)*100/NULLIF(cast(t1.[Count of Successful TIPs] as decimal), 0)) as decimal (5,2)), 0) as [Adherence Monitoring Validation Rate %]
, isnull(t1.[Count of Active TIPs],0) as [Adherence Monitoring Active TIPs Opportunities]
, isnull(t1.[% Net Effective],0.00) as [Adherence Monitoring NER]

into #AdherenceMonitoring
--from outcomesMTM.dbo.pharmacy p 
from #org p
 join
(
	select t.orgid
	--,t.tiptitle
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[30dayTip]) as decimal) as [Count of Opportunities > 30 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*,oc.orgid
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30 then 1 else 0 end as [30dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID
		join #org2center oc on oc.centerid=ta.centerid
		join #org o on o.orgid=oc.orgid

		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (393,394,395)
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh

	) t

	where 1 = 1
	and t.Rank = 1
	group by t.orgID--,t.tiptitle
) t1 on p.orgID = t1.orgID

left join 
(
select orgid
--, cast(sum(a.[Count of Validation]) as decimal) as [Count of Validation]
, cast(sum(a.[Count of Validated Claims]) as decimal) as [Count of Validated Claims]

from (

		select t.orgid 
		--, cast(sum(t.ValidatedClaims) as decimal) as [Count of Validation]
		, cast(sum(t.validate) as decimal) as [Count of Validated Claims]
		from (

				select c.claimID
				, case when cv.validated = 1 and cv.payable = 1 and cv.processed = 1
						then 1 else 0 end as ValidatedClaims
				, case when cv.validated = 1 then 1 else 0 end as Validate
				, oc.orgID
				, cv.validated
				from dbo.claim c
				join staging.claimvalidation cv on cv.claimID = c.claimID
				join #org2Center oc on oc.centerID = c.centerID
				join dbo.policy po on po.policyID = c.policyid
				join dbo.contract co on co.ContractID = po.contractID
				join dbo.client cl on cl.clientID = co.ClientID
				where 1=1
				and c.tipdetailid in (393,394,395)
				--and c.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
				and c.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh
				and cl.clientID = 105
				and c.statusID = 6
				and cv.active = 1
				and (year(cast(c.mtmserviceDT as date)) = year(cast(getdate() as date))
					or (cast(c.mtmserviceDT as date) is null))

		) t
		join #org o on o.orgid = t.orgid 
		where 1 = 1
		group by t.orgID
		
)a
group by a.orgid
)cv on cv.orgid=p.orgid
where 1 = 1



--in future if logic for Total Net Effective rate is provided, alter the table to store decimal value, the current value is nvarchar

Truncate table  [dbo].[UHC_RetailerKey_OrganizationTIPs_30day] 
Insert into  [dbo].[UHC_RetailerKey_OrganizationTIPs_30day] 
([File Delivery Date],
[Rank],
[Organization Name],
[Total Net-Effective Rate],
[Needs Refill NER],
[Needs 90 Day Fill NER],
[Needs Drug Therapy - Statin - Diabetes NER],
[Needs Drug Therapy - Statin - CVD NER],
[Suboptimal Drug - Low-Intensity Statin - CVD NER],
[Needs Medication Synchronization NER],
[Adherence Monitoring NER],
[Needs Refill],
[Needs Refill Opportunities],
[Needs Refill opportunities w/ Aging Criteria],
[Needs Refill Completed],
[Needs Refill Success],
[Needs Refill Validated],
[Needs Refill Count of Active TIPs Opportunities],
[Needs Refill Completion %],
[Needs Refill Success %],
[Needs Refill Validation Rate %],
[Needs 90 Day Fill],
[Needs 90 Day Fill Opportunities],
[Needs 90 Day Fill Opportunities w/ Aging Criteria],
[Needs 90 Day Fill Completed],
[Needs 90 Day Fill Success],
[Needs 90 Day Fill Validated],
[Needs 90 Day Fill Active TIPs opportunities],
[Needs 90 Day Fill Completion %],
[Needs 90 Day Fill Success %],
[Needs 90 Day Fill Validation Rate %],
[Needs Drug Therapy - Statin - Diabetes],
[Needs Drug Therapy - Statin - Diabetes Opportunities],
[Needs Drug Therapy - Statin - Diabetes Opportunities w/ Aging Criteria],
[Needs Drug Therapy - Statin - Diabetes Completed],
[Needs Drug Therapy - Statin - Diabetes Success],
[Needs Drug Therapy - Statin - Diabetes Validated],
[Needs Drug Therapy - Statin - Diabetes Active TIPs Opportunities],
[Needs Drug Therapy - Statin - Diabetes Completion %],
[Needs Drug Therapy - Statin - Diabetes Success %],
[Needs Drug Therapy - Statin - Diabetes Validation Rate %],
[Needs Drug Therapy - Statin - CVD],
[Needs Drug Therapy - Statin - CVD Opportunities],
[Needs Drug Therapy - Statin - CVD Opportunities w/ Aging Criteria],
[Needs Drug Therapy - Statin - CVD Completed],
[Needs Drug Therapy - Statin - CVD Success],
[Needs Drug Therapy - Statin - CVD Validated],
[Needs Drug Therapy - Statin - CVD Active TIPs Opportunities],
[Needs Drug Therapy - Statin - CVD Completion %],
[Needs Drug Therapy - Statin - CVD Success %],
[Needs Drug Therapy - Statin - CVD Validation Rate %],
[Suboptimal Drug - Low-Intensity Statin - CVD],
[Suboptimal Drug - Low-Intensity Statin - CVD Opportunities],
[Suboptimal Drug - Low-Intensity Statin - CVD Opportunities w/ Aging Criteria],
[Suboptimal Drug - Low-Intensity Statin - CVD Completed],
[Suboptimal Drug - Low-Intensity Statin - CVD Success],
[Suboptimal Drug - Low-Intensity Statin - CVD Validated],
[Suboptimal Drug - Low-Intensity Statin - CVD Active TIPs Opportunities],
[Suboptimal Drug - Low-Intensity Statin - CVD Completion %],
[Suboptimal Drug - Low-Intensity Statin - CVD Success %],
[Suboptimal Drug - Low-Intensity Statin - CVD Validation Rate %],
[Needs Medication Synchronization],
[Needs Medication Synchronization Opportunities],
[Needs Medication Synchronization Opportunities w/ Aging Criteria],
[Needs Medication Synchronization Completed],
[Needs Medication Synchronization Success],
[Needs Medication Synchronization Validated],
[Needs Medication Synchronization Active TIPs Opportunities],
[Needs Medication Synchronization Completion %],
[Needs Medication Synchronization Success %],
[Needs Medication Synchronization Validation Rate %],
[Adherence Monitoring],
[Adherence Monitoring Opportunities],
[Adherence Monitoring Opportunities w/ Aging Criteria],
[Adherence Monitoring Completed],
[Adherence Monitoring Success],
[Adherence Monitoring Validated],
[Adherence Monitoring Active TIPs Opportunities],
[Adherence Monitoring Completion %],
[Adherence Monitoring Success %],
[Adherence Monitoring Validation Rate %]
)

select 
 cast (getdate() as date) as [File Delivery Date]
 ,'' as [Rank]
 ----,cast(oc.orgid as nvarchar(50)) as Orgid
 ,cast(oc.[Organization Name] as nvarchar(200)) as [Organization Name]
, cast('' as nvarchar(10))as [Total Net-Effective Rate]
, isnull(cast(NR.[Needs Refill NER] as decimal(5,2)),0.00) as  [Needs Refill NER]
, isnull(cast(NND.[Needs 90 Day Fill NER] as decimal(5,2)),0.00) as  [Needs 90 Day Fill NER]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes NER] as decimal(5,2)),0.00) as  [Needs Drug Therapy - Statin - Diabetes NER]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD NER] as decimal(5,2)),0.00) as  [Needs Drug Therapy - Statin - CVD NER]
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD NER] as decimal(5,2)),0.00) as  [Suboptimal Drug - Low-Intensity Statin - CVD NER]
, isnull(cast(NMS.[Needs Medication Synchronization NER] as decimal(5,2)),0.00) as  [Needs Medication Synchronization NER]
, isnull(cast(AM.[Adherence Monitoring NER] as decimal(5,2)),0.00) as  [Adherence Monitoring NER]

 ,isNull(NR.tiptitle,'Needs Refill') as [Needs Refill]
, isnull(cast(NR.[Needs Refill Opportunities] as int), 0) as [Needs Refill Opportunities]
, isnull(cast(NR.[Needs Refill opportunities w/ Aging Criteria]as int),0) as [Needs Refill opportunities w/ Aging Criteria]
, isnull(cast(NR.[Needs Refill Completed] as int),0) as [Needs Refill Completed]
, isnull(cast(NR.[Needs Refill Success] as int),0) as [Needs Refill Success]
, isnull(cast(NR.[Needs Refill Validated] as int),0)  as [Needs Refill Validated]
, isnull(cast(NR.[Needs Refill Count of Active TIPs Opportunities] as int),0) as [Needs Refill Count of Active TIPs Opportunities]
, isnull(cast(NR.[Needs Refill Completion %] as decimal(5,2)),0.00) as [Needs Refill Completion %]
, isnull(cast(NR.[Needs Refill Success %] as decimal (5,2)) ,0.00) as [Needs Refill Success %]
, isnull(cast(NR.[Needs Refill Validation Rate %] as decimal(5,2)),0.00) as  [Needs Refill Validation Rate %]


, isNull(NND.tiptitle,'Needs 90 Day Fill') as [Needs 90 Day Fill]
, isnull(cast(NND.[Needs 90 Day Fill Opportunities] as int), 0) as [Needs 90 Day Fill Opportunities]
, isnull(cast(NND.[Needs 90 Day Fill Opportunities w/ Aging Criteria] as int),0) as [Needs 90 Day Fill Opportunities w/ Aging Criteria]
, isnull(cast(NND.[Needs 90 Day Fill Completed] as int),0) as [Needs 90 Day Fill Completed]
, isnull(cast(NND.[Needs 90 Day Fill Success] as int),0) as [Needs 90 Day Fill Success]
, isnull(cast(NND.[Needs 90 Day Fill Validated] as int),0) as [Needs 90 Day Fill Validated]
, isnull(cast(NND.[Needs 90 Day Fill Active TIPs opportunities] as int),0) as [Needs 90 Day Fill Active TIPs opportunities]
, isnull(cast(NND.[Needs 90 Day Fill Completion %] as decimal(5,2)),0.00) as [Needs 90 Day Fill Completion %]
, isnull(cast(NND.[Needs 90 Day Fill Success %] as decimal (5,2)) ,0.00) as [Needs 90 Day Fill Success %]
, isnull(cast(NND.[Needs 90 Day Fill Validation Rate %] as decimal(5,2)),0.00) as  [Needs 90 Day Fill Validation Rate %]


, isNull(NDTSD.tiptitle,'Needs Drug Therapy -Statin-Diabetes') as [Needs Drug Therapy - Statin - Diabetes]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes Opportunities] as int), 0) as [Needs Drug Therapy - Statin - Diabetes Opportunities]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes Opportunities w/ Aging Criteria] as int),0) as [Needs Drug Therapy - Statin - Diabetes Opportunities w/ Aging Criteria]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes Completed] as int),0) as [Needs Drug Therapy - Statin - Diabetes Completed]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes Success]as int),0) as [Needs Drug Therapy - Statin - Diabetes Success]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes Validated] as int),0) as [Needs Drug Therapy - Statin - Diabetes Validated]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes Active TIPs Opportunities]as int),0) as [Needs Drug Therapy - Statin - Diabetes Active TIPs Opportunities]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes Completion %] as decimal(5,2)),0.00) as [Needs Drug Therapy - Statin - Diabetes Completion %]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes Success %] as decimal (5,2)) ,0.00) as [Needs Drug Therapy - Statin - Diabetes Success %]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes Validation Rate %] as decimal(5,2)),0.00) as  [Needs Drug Therapy - Statin - Diabetes Validation Rate %]


, isNull(NDTSC.tiptitle,'Needs Drug Therapy-Statin-CVD') as [Needs Drug Therapy - Statin - CVD]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD Opportunities] as int), 0) as [Needs Drug Therapy - Statin - CVD Opportunities]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD Opportunities w/ Aging Criteria] as int),0) as [Needs Drug Therapy - Statin - CVD Opportunities w/ Aging Criteria]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD Completed] as int),0) as [Needs Drug Therapy - Statin - CVD Completed]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD Success] as int),0) as [Needs Drug Therapy - Statin - CVD Success]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD Validated] as int),0) as [Needs Drug Therapy - Statin - CVD Validated]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD Active TIPs Opportunities] as int),0) as [Needs Drug Therapy - Statin - CVD Active TIPs Opportunities]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD Completion %] as decimal(5,2)),0.00) as [Needs Drug Therapy - Statin - CVD Completion %]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD Success %] as decimal (5,2)) ,0.00) as [Needs Drug Therapy - Statin - CVD Success %]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD Validation Rate %] as decimal(5,2)),0.00) as  [Needs Drug Therapy - Statin - CVD Validation Rate %]

, isNull(SD.tiptitle,'Suboptimal Drug - Low-Intensity Statin - CVD') as [Suboptimal Drug - Low-Intensity Statin - CVD]
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Opportunities] as int), 0) as [Suboptimal Drug - Low-Intensity Statin - CVD Opportunities]
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Opportunities w/ Aging Criteria] as int),0) as [Suboptimal Drug - Low-Intensity Statin - CVD Opportunities w/ Aging Criteria]  
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Completed] as int),0) as [Suboptimal Drug - Low-Intensity Statin - CVD Completed]
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Success] as int),0) as [Suboptimal Drug - Low-Intensity Statin - CVD Success]
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Validated] as int),0) as [Suboptimal Drug - Low-Intensity Statin - CVD Validated]
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Active TIPs Opportunities] as int), 0) as [Suboptimal Drug - Low-Intensity Statin - CVD Active TIPs Opportunities]
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Completion %] as decimal(5,2)),0.00) as [Suboptimal Drug - Low-Intensity Statin - CVD Completion %]
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Success %] as decimal (5,2)) ,0.00) as [Suboptimal Drug - Low-Intensity Statin - CVD Success %]
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Validation Rate %] as decimal(5,2)),0.00) as  [Suboptimal Drug - Low-Intensity Statin - CVD Validation Rate %]

, isnull(NMS.tiptitle,'Needs Medication Synchronization') as [Needs Medication Synchronization]
, isnull(cast(NMS.[Needs Medication Synchronization Opportunities] as int),0) as [Needs Medication Synchronization Opportunities]
, isnull(cast(NMS.[Needs Medication Synchronization Opportunities w/ Aging Criteria] as int),0) as [Needs Medication Synchronization Opportunities w/ Aging Criteria]
, isnull(cast(NMS.[Needs Medication Synchronization Completed] as int),0) as [Needs Medication Synchronization Completed]
, isnull(cast(NMS.[Needs Medication Synchronization Success] as int),0) as [Needs Medication Synchronization Success]
, isnull(cast(NMS.[Needs Medication Synchronization Validated] as int),0) as [Needs Medication Synchronization Validated]
, isnull(cast(NMS.[Needs Medication Synchronization Active TIPs Opportunities] as int),0) as [Needs Medication Synchronization Active TIPs Opportunities]
, isnull(cast(NMS.[Needs Medication Synchronization Completion %] as decimal(5,2)),0.00) as [Needs Medication Synchronization Completion %]
, isnull(cast(NMS.[Needs Medication Synchronization Success %] as decimal (5,2)) ,0.00) as [Needs Medication Synchronization Success %]
, isnull(cast(NMS.[Needs Medication Synchronization Validation Rate %] as decimal(5,2)),0.00) as  [Needs Medication Synchronization Validation Rate %]


, isNull(AM.tiptitle,'Adherence Monitoring') as [Adherence Monitoring]
, isnull(cast(AM.[Adherence Monitoring Opportunities] as int), 0) as [Adherence Monitoring Opportunities]
, isnull(cast(AM.[Adherence Monitoring Opportunities w/ Aging Criteria]as int),0) as [Adherence Monitoring Opportunities w/ Aging Criteria]
, isnull(cast(AM.[Adherence Monitoring Completed] as int),0) as [Adherence Monitoring Completed]
, isnull(cast(AM.[Adherence Monitoring Success]as int),0) as [Adherence Monitoring Success]
, isnull(cast(AM.[Adherence Monitoring Validated]as int),0) as [Adherence Monitoring Validated]
, isnull(cast(AM.[Adherence Monitoring Active TIPs Opportunities]as int),0) as [Adherence Monitoring Active TIPs Opportunities]
, isnull(cast(AM.[Adherence Monitoring Completion %] as decimal(5,2)),0.00) as [Adherence Monitoring Completion %]
, isnull(cast(AM.[Adherence Monitoring Success %] as decimal (5,2)) ,0.00) as [Adherence Monitoring Success %]
, isnull(cast(AM.[Adherence Monitoring Validation Rate %] as decimal(5,2)),0.00) as  [Adherence Monitoring Validation Rate %]


from #org oc
left join #NeedsMedSync NMS on NMS.orgID=oc.orgID
left join #AdherenceMonitoring AM on AM.orgID=oc.orgID
left join #Needs90Day NND on NND.orgID = oc.orgID
left join #NeedsDrugTherapyStatinCVD NDTSC on NDTSC.orgID=oc.orgID
left join #NeedsDrugTherapyStatinDiabetes NDTSD on NDTSD.orgID=oc.orgID 
left join #NeedsRefill NR on NR.orgID=oc.orgID
left join #SuboptimalDrug SD on SD.orgID=oc.orgID



END

