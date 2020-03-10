












CREATE proc [dbo].[S_ReportCard_Client_bak_01072020] 
as 
begin 


DECLARE @BEGIN VARCHAR(10)
DECLARE @END VARCHAR(10)


SET @BEGIN =  case when month(getdate()) = 1 then cast(year(getdate()) - 1 as varchar(4)) + '-01-01' else cast(year(getdate()) as varchar(4)) + '-01-01' end  --// Beginning of year (if current month is Jan. then beginning of last year)		
SET @END =  cast(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as date)	 		--end of last month


---------------------------------------------------------------------------------------------------------
--------------------------CHAINS
---------------------------------------------------------------------------------------------------------
--Below temp TABLE was provided by Network Performance
DROP TABLE IF EXISTS #chainRollUp
CREATE TABLE #chainRollUp 
(
	ID int identity (1,1) primary key
	, Preferred int
	, [Organization Category Size] int
	, [Organization Name] varchar(100)
	, RelationshipID varchar(50)
	, NABP varchar(50)
)

-- TC- 2808: Information is getting FROM Attachment file 'Chain Rollup 2019 Updates.xlsx' - [sheet 2] by Shane Hallengren
INSERT INTO #chainrollup SELECT 0 , 5 , 'A S MEDICATION SOLUTIONS LLC' , '702' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'ACCREDO HEALTH GROUP INC' , '392' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Acme Pharmacies' , '260' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'ADVANCED HOME CARE INC' , 'B44' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'ADVANCED RX MANAGEMENT' , 'A93' , NULL
INSERT INTO #chainrollup SELECT 1 , 2 , 'Ahold Delhaize' , '233' , NULL
INSERT INTO #chainrollup SELECT 1 , 2 , 'Ahold Delhaize' , '862' , NULL
INSERT INTO #chainrollup SELECT 1 , 2 , 'Ahold Delhaize' , '289' , NULL
INSERT INTO #chainrollup SELECT 1 , 2 , 'Ahold Delhaize' , '415' , NULL
INSERT INTO #chainrollup SELECT 1 , 2 , 'Ahold Delhaize' , '075' , NULL
INSERT INTO #chainrollup SELECT 1 , 2 , 'Ahold USA' , '289' , NULL
INSERT INTO #chainrollup SELECT 1 , 2 , 'Ahold USA' , '415' , NULL
INSERT INTO #chainrollup SELECT 1 , 2 , 'Ahold USA' , '075' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'AHS-St. John Pharmacy' , '671' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'AIDS HEALTHCARE FOUNDATION' , 'A23' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , '929' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , '003' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , NULL , 999572
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , NULL , 999573
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , NULL , 999574
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , '156' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , '301' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , 'B62' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , '158' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , '227' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , '282' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , '027' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , '400' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , NULL , 999507
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , NULL , 999511
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , NULL , 999512
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , NULL , 999517
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , 'C08' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , '319' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Albertsons' , 'C31' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'ALEGENT RETAIL PHARMACIES' , 'A47' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'ALLINA COMMUNITY PHARMACIES' , '799' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'AMBIENT HEALTHCARE INC' , 'B18' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'American Pharmacy Network Solutions' , '841' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'AMERITA INC' , '969' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'APPALACHIAN REG HLTH CARE' , '492' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Arete Pharmacy' , '712' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Arete Pharmacy' , '941' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Arete Pharmacy' , '967' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Arete Pharmacy' , '678' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Arete Pharmacy' , '783' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Arete Pharmacy' , '426' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'ASSOCIATED FRESH MARKET INC' , 'A34' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'ASTRUP DRUG INC' , '634' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Aurora Pharmacy' , '832' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Balls Food Stores' , '490' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Bartell Drugs' , '011' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Baystate Health' , '719' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'BIG Y FOODS INC' , '835' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Bi-Mart' , '048' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'BioRx' , 'A78' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'BRIOVARX LLC' , '951' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'BROCKIE HEALTHCARE INC' , '538' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Brookshire Brothers' , '463' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Brookshire Grocery Co.' , '453' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Cardinal Health' , '603' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Cardinal Health' , 'A51' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Cardinal Health' , '931' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Cardinal Health' , '139' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Cardinal Health' , '307' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Cardinal Health' , 'C16' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Cardinal Health LeaderNET' , '603' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Cardinal Health LeaderNET' , 'A51' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Cardinal Health Managed Care Connection' , '931' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Cardinal Health Medicap/Medicine Shoppe' , '139' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Cardinal Health Medicap/Medicine Shoppe' , '307' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Central Dakota Pharmacys' , '903' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'CHEROKEE NATION HEALTH SERVICES PHA' , 'B17' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'CHICKASAW NATION DIVISION OF HEALTH' , 'B07' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Choctaw Nation Healthcare' , 'A11' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'CIGNA MEDICAL GROUP PHARMACY' , '946' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'CLEVELAND CLINIC PHARMACIES' , 'A45' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'CMC RX STEELE CREEK' , 'A66' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Coborns Inc.' , '703' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Collier Drug Stores' , 'A84' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'COLONIAL MANAGEMENT GROUP LP' , '992' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'COMMUNITY HEALTH CENTERS INC' , 'B23' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Community Health Systems' , 'A26' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'Community Independent Pharmacy Network' , 'A96' , NULL
INSERT INTO #chainrollup SELECT 0 , NULL , 'COMPLETE CLAIMS PROCESSING INC' , 'A06' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'CONCORD INC' , '954' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'COOK COUNTY' , 'B04' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'COOPHARMA' , '942' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'CORAM LLC' , '863' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Costco' , '299' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'COUNTY OF LOS ANGELES DEPARTMENT OF' , 'B45' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'CRESCENT HEALTHCARE' , '833' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'CRITICAL CARE SYSTEMS' , '911' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , NULL , 999104
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , NULL , 999818
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , NULL , 999682
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , NULL , 999690
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , NULL , 999689
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , NULL , 999688
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , '177' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , '123' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , '039' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , '782' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , '608' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , '207' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , '673' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , '380' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'CVS Pharmacy' , '008' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Dallas Metrocare Services' , '791' , NULL
INSERT INTO #chainrollup SELECT 1 , 3 , 'Delhaize' , '233' , NULL
INSERT INTO #chainrollup SELECT 1 , 3 , 'Delhaize' , '862' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Denver Health and Hospital Authority' , 'A80' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'DEPT OF VETERANS AFFAIRS' , '869' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'DIERBERGS PHARMACY' , '332' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Discount Drug Mart' , '044' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'DMVA PHARMACIES' , 'B15' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'DOCTORS CHOICE PHARMACIES' , '713' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'DOD PHARMACO ECONOMIC CENTER' , '781' , NULL
INSERT INTO #chainrollup SELECT 0 , NULL , 'DRDISPENSE' , 'A28' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'DSHS PHARMACIES' , 'A02' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Eaton Apothecary' , '055' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Elevate Provider Network' , '638' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Elevate Provider Network' , '904' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Elevate Provider Network' , '626' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Emblem Health' , '271' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'EPIC Pharmacy Network' , '455' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'ESKENAZI HEALTH' , '689' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Essentia Health' , '573' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'FAIRVIEW HEALTH SERVICES' , '705' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Fairview Pharmacy Services' , '898' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Family Pharmacy' , '511' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'FARMACIAS PLAZA' , '843' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'FIRST COAST HEALTH SOLUTIONS' , 'B30' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Fitzgeralds' , '795' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'FLORIDA HEALTH CARE PLAN INC' , 'B49' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'fred''s Pharmacy' , '345' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'fred''s Pharmacy' , '934' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Fruth Pharmacy' , '325' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Genoa Healthcare' , '945' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'GERIMED LTC NETWORK INC' , '913' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'GEROULDS PROFESSIONAL PHARMACY INC' , 'A58' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Giant Eagle' , NULL , 999650
INSERT INTO #chainrollup SELECT 0 , 2 , 'Giant Eagle' , '248' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'GOOD DAY PHARMACY' , '997' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'GROUP HEALTH COOPERATIVE' , '510' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'H AND H DRUG STORES INC' , '828' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'HARMONS CITY INC' , '610' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Harps Food Stores' , '417' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'HARRIS COUNTY HOSPITAL DISTRICT' , '963' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'HARTIG DRUG CO CORP' , '087' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'HARVARD VANGUARD MEDICAL ASSOCIATES' , '427' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Health Mart Atlas' , '605' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Health Mart Atlas' , '630' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'Health Mart Atlas' , '841' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Health Partners' , '639' , NULL
INSERT INTO #chainrollup SELECT 1 , 2 , 'HEB Pharmacy' , '025' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Henry Ford Health System' , '655' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Hi-School Pharmacy' , '092' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'HOME CHOICE PARTNERS INC' , 'A38' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Homeland Pharmacy' , '309' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Horton & Converse' , '094' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Humana Pharmacy' , 'A71' , NULL
INSERT INTO #chainrollup SELECT 1 , 2 , 'Hy-Vee' , '097' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'I.H.S.' , '842' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'I.H.S.' , '860' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'I.H.S.' , '865' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'I.H.S.' , '875' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'I.H.S.' , '877' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'I.H.S.' , '906' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'I.H.S.' , '907' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'I.H.S.' , '908' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'I.H.S.' , '918' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'IHC Pharmacy Services' , '695' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'INFUSION PARTNERS INC' , 'A03' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Ingles Market Pharmacy' , '822' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'INJURY RX LLC' , 'A68' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'INNOVATIX NETWORK LLC' , '915' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'INNOVATIX NETWORK LLC' , 'A00' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'INSTY MEDS' , '872' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'INTEGRIS PROHEALTH PHARMACY' , 'B50' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'JORDAN DRUG INC' , '801' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'JPS Health Outpatient Pharmacies' , 'B01' , NULL
INSERT INTO #chainrollup SELECT 0 , NULL , 'JRX' , 'A91' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'KAISER FOUNDATION HEALTH PLAN MIDAT' , 'A85' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'KAISER FOUNDATION HEALTH PLAN OF GE' , 'A27' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'KAISER PERMANENTE NCAL' , '917' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'KAISER PERMANENTE SCAL' , '916' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'KING KULLEN PHARMACY CORP' , '280' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Kinney Drugs, Inc.' , '109' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Klingensmiths Drug Stores' , '499' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Kmart' , '110' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Kohlls Pharmacies' , '481' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'KS Management Services' , '635' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'K-VA-T Food Stores' , '687' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'LINCARE INC' , '977' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'LINS PHARMACY' , 'A86' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'LOMA LINDA UNIV MED CTR' , '804' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'M K Stores, Inc. d/b/a Snyder Pharmacy' , '527' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'MACEYS INC' , 'A64' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Manatee County Rural Health Services' , '899' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Marc''s Pharmacy' , '441' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'MARICOPA INTEGRATED HEALTH SYSTEM' , '930' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'MARKET BASKET PHARMACIES' , '544' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Marshfield clinic' , '526' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Martins Supermarkets' , '846' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Maxor National Pharmacy Services' , '516' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'Maxor Xpress' , 'A72' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Mayo Clinic Health System Pharmacy and Home Medical' , '847' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'MAYO CLINIC PHARMACY' , 'B08' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'MCHUGH' , 'B20' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'MDS RX' , 'B10' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Med-Fast Pharmacy' , '682' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'MEDICINE CHEST PHARMACIES' , '924' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'MEDX SALES' , 'A31' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Meijer' , '213' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'MEMORIAL HEALTHCARE SYSTEM PHARMACI' , 'B48' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'MERCY HEALTH SYSTEM RETAIL PHCY' , '840' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Mercy Pharmacy' , '709' , NULL
INSERT INTO #chainrollup SELECT 0 , 4 , 'MHA Long Term Care Network' , '905' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'MULTICARE OUTPATIENT PHARMACIES' , 'B14' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Muscogee Creek Nation Health System' , '680' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'NATIONS PHARMACEUTICALS LLC' , 'A19' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'NCPRX' , 'B13' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'NE OH NEIGHBORHOOD HEALTH SRVS' , '746' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'NEW ENGLAND HOME THERAPIES' , 'A25' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'NORTHSIDE PHARMACY' , '770' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'NYS OFFICE OF MENTAL HEALTH' , '953' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'OMHSAS BUREAU HOSP OPERATIONS DPW' , '920' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Omnicare' , '599' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Omnicare' , '519' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Oncology Pharmacy Services' , '477' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'OPTION CARE ENTERPRISES INC' , '838' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'OWENS PHARMACY' , 'B21' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PARK NICOLLET PHARMACY' , '341' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PATIENT FIRST CORPORATION' , '861' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PAYLESS DRUG PHARMACY GROUP LLC' , 'A59' , NULL
INSERT INTO #chainrollup SELECT 0 , NULL , 'PBA HEALTH TRINET' , '909' , NULL
INSERT INTO #chainrollup SELECT 0 , NULL , 'PBA HEALTH TRINET' , '540' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PEOPLES PHARMACY' , '757' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PHARMACA INTEGRATIVE PHARMACY' , '960' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Pharmacy First' , '854' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Pharmacy First' , 'A46' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Pharmacy First' , '866' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PHARMACY PLUS INC' , '575' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PharMerica' , '752' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PharMerica' , '631' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PharMerica' , '686' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PharMerica' , '754' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'PHYSICIANS PHARMACEUTICAL CORP' , 'A83' , NULL
INSERT INTO #chainrollup SELECT 0 , NULL , 'PHYSICIANS TOTAL CARE' , '727' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PILL BOX DRUGS INC' , '923' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PLANNED PARENTHOOD MAR MONTE INC' , 'A57' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PLANNED PARENTHOOD OF GREATER OHIO' , 'B00' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PLANNED PARENTHOOD OF GREATER WA AN' , 'B57' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PLANNED PARENTHOOD OF ILLINOIS' , 'B59' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PLANNED PARENTHOOD OF SOUTHWESTERN' , 'B03' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'POC MANAGEMENT GROUP LLC' , '974' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'PPOK RxSELECT Network' , '769' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PRESBYTERIAN MEDICAL SERVICES INC' , 'A12' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PRESCRIBEIT RX' , '912' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'PRESCRIPTION PARTNERS' , '952' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Price Chopper Supermarkets' , '434' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PRICE CUTTER PHARMACY' , '701' , NULL
INSERT INTO #chainrollup SELECT 0 , NULL , 'PROCLAIM PHYSICIAN SERVICES' , 'A77' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PROF SPECIALIZED PHARMACIES LLC' , '824' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'PROGRESSIVE PHARMACIES LLC' , '979' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'PUBLIC HEALTH TRUST OF DADE COUNTY' , 'A67' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Publix' , '302' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'QCP NETWORX' , 'B40' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Quick Chek Food Stores' , '267' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Raleys/Bel Air Pharmacies' , '171' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'REASOR' , 'B27' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'Recept Pharmacy' , '891' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'RECEPT PHARMACY LP' , 'A50' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Red Cross Pharmacy' , '743' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Redners Markets' , '852' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'Rite Aid' , '181' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'Rite Aid' , '045' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'Rite Aid' , '056' , NULL
INSERT INTO #chainrollup SELECT 0 , 1 , 'Rite Aid' , NULL , 99A350
INSERT INTO #chainrollup SELECT 0 , 1 , 'Rite Aid' , NULL , 99A351
INSERT INTO #chainrollup SELECT 0 , 3 , 'Ritzman Pharmacy Inc' , '424' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Rural Healthcare Inc. ' , '935' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'SAINT JOSEPH MERCY PHARMACY' , '520' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'SAMS CLUB' , 'C11' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'SANTA CLARA VALLEY HEALTH AND HOSPI' , 'A37' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Save Mart Supermarkets' , '310' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , '596' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , '979' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , '980' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2110182
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2372528
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 3727344
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2333095
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2701969
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2380602
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2383420
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2378366
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2310009
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2385195
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2307191
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2360701
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2371069
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2368252
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2360028
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2344163
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2363137
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2350899
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2370524
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2363000
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2344593
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2384662
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2310667
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2364696
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2384232
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2368327
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2372643
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2354126
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2366626
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2338689
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2356283
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2320923
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2366993
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2363238
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2344620
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2330102
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2308054
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2306214
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2306226
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2344884
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2363288
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 3900164
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 3915305
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 3941158
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 3945194
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 3946994
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 3996660
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 6000929
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 3678882
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 3681093
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 3681841
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 3993032
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2342638
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 2370182
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 5660875
INSERT INTO #chainrollup SELECT 0 , 3 , 'Sav-Mor Drug Stores' , NULL , 5735127
INSERT INTO #chainrollup SELECT 0 , 3 , 'Schnuck Markets, Inc.' , '133' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Seip Drug LLC' , '968' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Shopko' , NULL , 999974
INSERT INTO #chainrollup SELECT 0 , 2 , 'Shopko' , NULL , 999957
INSERT INTO #chainrollup SELECT 0 , 2 , 'Shopko' , '246' , NULL
INSERT INTO #chainrollup SELECT 0 , NULL , 'SMART ID WORKS LLC' , 'A75' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Southeastern Grocers' , '315' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Southeastern Grocers' , '292' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , '320' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2305274
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2311924
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2312952
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2317344
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2342703
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2342979
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2343452
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2344137
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2345456
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2347359
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2348527
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2352526
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2353340
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2354277
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2354316
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2355281
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2355534
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2361056
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2362729
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2363339
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2364177
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2364292
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2364381
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2365939
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2366246
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2368973
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2368985
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2368997
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369002
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369014
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369026
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369038
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369040
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369052
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369064
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369076
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369088
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369280
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369696
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369711
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369723
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369735
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369747
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369759
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2369761
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2371110
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2372047
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2372059
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2372061
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2372073
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2372085
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2372097
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2372100
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2372112
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2372124
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2372477
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2372934
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2373633
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2375839
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2377441
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 2378203
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 99A160
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 99A217
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 99A246
INSERT INTO #chainrollup SELECT 0 , 3 , 'SpartanNash' , NULL , 99A247
INSERT INTO #chainrollup SELECT 0 , 3 , 'STAR DISCOUNT PHARMACY INC' , '998' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'STONER DRUG CO' , '943' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'SUNCOAST COMMUNITY HEALTH CENTERS I' , 'B41' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'SUPERVALU' , '410' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'SUPERVALU' , '285' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'SWIFT RX LLC' , 'A74' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Tampa Family Health Centers' , 'A24' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'TEMPEST MED' , 'A79' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'The Kroger Co.' , '108' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'The Kroger Co.' , '199' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'The Kroger Co.' , '273' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'The Kroger Co.' , '043' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'The Kroger Co.' , '495' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'The Kroger Co.' , '069' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'The Kroger Co.' , '071' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'The Kroger Co.' , '817' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'The Kroger Co.' , '602' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'The Kroger Co.' , 'A65' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'The Kroger Co.' , 'B67' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'The Kroger Co.' , '113' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'THE METROHEALTH SYSTEM PHARMACY' , 'B61' , NULL
INSERT INTO #chainrollup SELECT 1 , 3 , 'Thrifty White Pharmacy' , NULL , 999656
INSERT INTO #chainrollup SELECT 1 , 3 , 'Thrifty White Pharmacy' , '216' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Times Supermarket' , '372' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'TN MENTAL HLTH AND DEV DISABILITIES' , '921' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Tops Markets, LLC' , '978' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'TriHealth' , '900' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'U SAVE PHARMACY' , '808' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'UCDHS PHARMACIES' , 'B12' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'UCSD Medical Center Pharmacies' , '715' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Univ of Missouri Hosp and Clinic' , '691' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'University of Kansas Hospital Pharmacy' , 'A87' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'University of Utah Hospital' , '744' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'UofV Virginia Medical Centers' , 'A98' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'US BIOSERVICES CORPORATION' , '758' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'UW HEALTH PHARMACY SERVICES' , '700' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'VA DMHMRSAS' , '914' , NULL
INSERT INTO #chainrollup SELECT 0 , 5 , 'VANTAGE RX DISPENSING SERVICES LLC' , '989' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Virginia Commenealth University Hospital' , '696' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'VIRGINIA MASON MEDICAL CTR' , '654' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Wakefern' , 'A33' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Wakefern' , '197' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Wakefern' , '613' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Wakefern' , '618' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Wakefern' , '619' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Wakefern' , '620' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Wakefern' , '621' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Wakefern' , '622' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Wakefern' , '640' , NULL
INSERT INTO #chainrollup SELECT 0 , 2 , 'Wakefern' , '894' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Walgreens Co. ' , '226' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Walgreens Co. ' , 'A10' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Walgreens Co. ' , 'A13' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Walmart' , '229' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Walmart' , NULL , 99A298
INSERT INTO #chainrollup SELECT 1 , 1 , 'Walmart Stores Inc' , 'C11' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Walmart Stores Inc' , '229' , NULL
INSERT INTO #chainrollup SELECT 1 , 1 , 'Walmart Stores Inc' , NULL , 99A298
INSERT INTO #chainrollup SELECT 0 , 3 , 'WEBER AND JUDD COMPANY INC' , '649' , NULL
INSERT INTO #chainrollup SELECT 1 , 3 , 'Wegmans Food Markets, Inc' , '256' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Weis Markets' , '232' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'Yakima Valley Farm Workers Clinic' , '987' , NULL
INSERT INTO #chainrollup SELECT 0 , 3 , 'YOKES FOODS INC' , '534' , NULL


DROP TABLE IF EXISTS #org
CREATE TABLE #org 
(
		orgID int identity (1,1) primary key
		, [Organization Name] varchar(100)
		, [Organization Category Size] int
)
INSERT INTO #org ([Organization Name], [Organization Category Size])
SELECT	DISTINCT [organization Name]
		, [Organization Category Size] 
FROM	#chainrollup
WHERE	1=1 


DROP TABLE IF EXISTS #Org2Center
CREATE TABLE #org2Center 
(
		orgID int 
		, centerid int
		, NCPDP_NABP varchar (50) 
		primary key (orgid, centerid) 
)
;with ch as 
(

		SELECT	cr.[Organization Name]
				, p.centerid
				, p.NCPDP_NABP 
		FROM	#chainRollUp cr
				join outcomesMTM.dbo.chain c with(nolock) on c.chainCode = cr.RelationshipID 
				join outcomesMTM.dbo.pharmacychain pc with(nolock) on pc.chainid = c.chainid
				join outcomesMTM.dbo.pharmacy p with(nolock) on p.centerid = pc.centerid
		WHERE	1=1

),
ph as 
(

		SELECT	cr.[Organization Name]
				, p.centerid
				, p.NCPDP_NABP
		FROM	#chainRollUp cr
				join outcomesMTM.dbo.pharmacy p with(nolock) on p.NCPDP_NABP = cr.NABP
		WHERE	1=1
)

INSERT INTO #Org2Center (orgid, centerid, NCPDP_NABP) 
SELECT	o.orgid
		, t.centerid
		, t.NCPDP_NABP  
FROM 
	(
		SELECT	ch.[Organization Name]
				, ch.centerid
				, ch.NCPDP_NABP
		FROM	ch
		WHERE	1=1
		UNION
		SELECT	ph.[Organization Name]
				, ph.centerid
				, ph.NCPDP_NABP
		FROM	ph
		WHERE	1=1
	)	t
	join #org o on o.[Organization Name] = t.[Organization Name]
WHERE	1=1

--------------------------------------------------------------------
DROP TABLE IF EXISTS #tempClient
CREATE TABLE #tempClient 
(
		clientID int identity (1,1) primary key
		, clientName varchar(100)
)

-- TC- 2808: Information is getting FROM Attachment file '2019 Client Grouping.xlsx' - [sheet 1] by Shane Hallengren
insert into #tempClient select 'Aetna Better Health of Kansas'
insert into #tempClient select 'Aetna Better Health of Louisiana'
insert into #tempClient select 'Aetna Better Health of Virginia'
insert into #tempClient select 'Amerigroup Louisiana'
insert into #tempClient select 'Amerigroup Texas'
insert into #tempClient select 'ArchCare'
insert into #tempClient select 'Asuris Northwest Health - H5010'
insert into #tempClient select 'Asuris Northwest Health - S5609'
insert into #tempClient select 'Regence BlueCross BlueShield of Oregon - H3817'
insert into #tempClient select 'Regence BlueCross BlueShield of Oregon - H6237'
insert into #tempClient select 'Regence BlueCross BlueShield of Utah - H4605'
insert into #tempClient select 'Regence BlueShield - H1997'
insert into #tempClient select 'Regence BlueShield - H5009'
insert into #tempClient select 'Regence BlueShield of Idaho - H1304'
insert into #tempClient select 'Regence BlueShield of Idaho - H1969'
insert into #tempClient select 'Regence BlueShield of Idaho or Regence BlueCross BlueShield of Utah (S5916)'
insert into #tempClient select 'ATRIO Health Plans'
insert into #tempClient select 'AultCare Commercial'
insert into #tempClient select 'BCBS ND'
insert into #tempClient select 'BCBS Rhode Island Medicare BlueCHiP'
insert into #tempClient select 'BCBSSC'
insert into #tempClient select 'Blue MedicareRx Group NEJE'
insert into #tempClient select 'Blue Shield 65 Plus MAPD'
insert into #tempClient select 'Blue Shield of California PDP'
insert into #tempClient select 'Buckeye Health Medicaid'
insert into #tempClient select 'CareOregon Medicaid'
insert into #tempClient select 'CareOregon Medicare'
insert into #tempClient select 'CareSource Advantage Ohio H6396'
insert into #tempClient select 'CareSource Georgia Medicaid'
insert into #tempClient select 'CareSource Indiana Exchange - Just4Me'
insert into #tempClient select 'CareSource Indiana Medicaid - HHW'
insert into #tempClient select 'CareSource Indiana Medicaid - HIP'
insert into #tempClient select 'CareSource Kentucky Exchange - Just4Me'
insert into #tempClient select 'CareSource Kentucky Health'
insert into #tempClient select 'CareSource Kentucky Medicaid'
insert into #tempClient select 'CareSource Medicaid'
insert into #tempClient select 'CareSource MyCare Ohio'
insert into #tempClient select 'CareSource Ohio Exchange – Just4Me'
insert into #tempClient select 'CareSource West Virginia Exchange - Just4Me'
insert into #tempClient select 'CCHP'
insert into #tempClient select 'ClearStone'
insert into #tempClient select 'Community Health Group'
insert into #tempClient select 'Denver Health'
insert into #tempClient select 'Devoted Health'
insert into #tempClient select 'EnvolveRx'
insert into #tempClient select 'Health Partners Medicaid'
insert into #tempClient select 'Health Partners Medicare'
insert into #tempClient select 'Humana EMTM'
insert into #tempClient select 'Humana MAPD'
insert into #tempClient select 'Humana PDP'
insert into #tempClient select 'IMCare Classic Itasca'
insert into #tempClient select 'Kroger Employee Health Plan'
insert into #tempClient select 'Kroger Prescription Plans - KT054'
insert into #tempClient select 'Kroger Prescription Plans - KT125'
insert into #tempClient select 'Kroger Prescription Plans - KT158'
insert into #tempClient select 'Kroger Prescription Plans - KT845'
insert into #tempClient select 'Martin''s Point'
insert into #tempClient select 'Medica'
insert into #tempClient select 'MHS Indiana'
insert into #tempClient select 'Nebraska Total Care'
insert into #tempClient select 'Neighborhood Health Plan of Rhode Island'
insert into #tempClient select 'Paramount'
insert into #tempClient select 'Premera Blue Cross'
insert into #tempClient select 'PrimeTime Health Plan HMO'
insert into #tempClient select 'Priority Health Medicare'
insert into #tempClient select 'Priority Health Non Medicare'
insert into #tempClient select 'Quartz MN Commercial'
insert into #tempClient select 'Security Health Medicare Advantage Plans'
insert into #tempClient select 'Senior Preferred'
insert into #tempClient select 'Senior Whole Health Medicare- H2224'
insert into #tempClient select 'Senior Whole Health Medicare- H5992'
insert into #tempClient select 'Senior Whole Health Medicare- H8851'
insert into #tempClient select 'SilverScript'
insert into #tempClient select 'Spectral Solutions - America''s 1st Choice of SC'
insert into #tempClient select 'Spectral Solutions - Freedom Health'
insert into #tempClient select 'Spectral Solutions - Optimum Health'
insert into #tempClient select 'Ucare Medicaid'
insert into #tempClient select 'Ucare Medicare'
insert into #tempClient select 'UHC Nebraska Medicaid'
insert into #tempClient select 'UHC Ohio Medicaid'
insert into #tempClient select 'UHG CMR'
insert into #tempClient select 'UnitedHealthcare Stars'
insert into #tempClient select 'WellCare'



-- TC- 2808: Information is getting FROM Attachment file '2019 Client Grouping.xlsx' - [sheet 1] by Shane Hallengren
DROP TABLE IF EXISTS #tempPolicy
CREATE TABLE #tempPolicy 
(
		ID int identity (1,1) primary key
		, clientID int
		, policyID int
)


insert into #tempPolicy SELECT	1	,	942
insert into #tempPolicy SELECT	2	,	815
insert into #tempPolicy SELECT	3	,	816
insert into #tempPolicy SELECT	4	,	391
insert into #tempPolicy SELECT	5	,	384
insert into #tempPolicy SELECT	6	,	817
insert into #tempPolicy SELECT	7	,	860
insert into #tempPolicy SELECT	8	,	863
insert into #tempPolicy SELECT	9	,	857
insert into #tempPolicy SELECT	10	,	861
insert into #tempPolicy SELECT	11	,	858
insert into #tempPolicy SELECT	12	,	856
insert into #tempPolicy SELECT	13	,	859
insert into #tempPolicy SELECT	14	,	854
insert into #tempPolicy SELECT	15	,	855
insert into #tempPolicy SELECT	16	,	864
insert into #tempPolicy SELECT	17	,	624
insert into #tempPolicy SELECT	17	,	625
insert into #tempPolicy SELECT	17	,	626
insert into #tempPolicy SELECT	17	,	627
insert into #tempPolicy SELECT	18	,	356
insert into #tempPolicy SELECT	18	,	408
insert into #tempPolicy SELECT	18	,	438
insert into #tempPolicy SELECT	19	,	357
insert into #tempPolicy SELECT	20	,	506
insert into #tempPolicy SELECT	21	,	818
insert into #tempPolicy SELECT	21	,	819
insert into #tempPolicy SELECT	21	,	820
insert into #tempPolicy SELECT	22	,	827
insert into #tempPolicy SELECT	23	,	396
insert into #tempPolicy SELECT	24	,	397
insert into #tempPolicy SELECT	25	,	751
insert into #tempPolicy SELECT	26	,	587
insert into #tempPolicy SELECT	27	,	578
insert into #tempPolicy SELECT	27	,	579
insert into #tempPolicy SELECT	28	,	758
insert into #tempPolicy SELECT	29	,	807
insert into #tempPolicy SELECT	30	,	577
insert into #tempPolicy SELECT	31	,	756
insert into #tempPolicy SELECT	32	,	755
insert into #tempPolicy SELECT	33	,	576
insert into #tempPolicy SELECT	34	,	909
insert into #tempPolicy SELECT	35	,	390
insert into #tempPolicy SELECT	36	,	378
insert into #tempPolicy SELECT	37	,	498
insert into #tempPolicy SELECT	38	,	459
insert into #tempPolicy SELECT	39	,	671
insert into #tempPolicy SELECT	40	,	663
insert into #tempPolicy SELECT	41	,	821
insert into #tempPolicy SELECT	41	,	822
insert into #tempPolicy SELECT	41	,	823
insert into #tempPolicy SELECT	42	,	499
insert into #tempPolicy SELECT	43	,	749
insert into #tempPolicy SELECT	44	,	952
insert into #tempPolicy SELECT	45	,	754
insert into #tempPolicy SELECT	45	,	768
insert into #tempPolicy SELECT	45	,	773
insert into #tempPolicy SELECT	45	,	774
insert into #tempPolicy SELECT	45	,	775
insert into #tempPolicy SELECT	45	,	776
insert into #tempPolicy SELECT	45	,	777
insert into #tempPolicy SELECT	45	,	778
insert into #tempPolicy SELECT	45	,	779
insert into #tempPolicy SELECT	45	,	781
insert into #tempPolicy SELECT	45	,	784
insert into #tempPolicy SELECT	45	,	785
insert into #tempPolicy SELECT	45	,	787
insert into #tempPolicy SELECT	45	,	788
insert into #tempPolicy SELECT	45	,	789
insert into #tempPolicy SELECT	45	,	790
insert into #tempPolicy SELECT	45	,	791
insert into #tempPolicy SELECT	45	,	792
insert into #tempPolicy SELECT	45	,	793
insert into #tempPolicy SELECT	45	,	892
insert into #tempPolicy SELECT	45	,	893
insert into #tempPolicy SELECT	45	,	894
insert into #tempPolicy SELECT	45	,	895
insert into #tempPolicy SELECT	45	,	896
insert into #tempPolicy SELECT	45	,	897
insert into #tempPolicy SELECT	45	,	898
insert into #tempPolicy SELECT	45	,	899
insert into #tempPolicy SELECT	45	,	900
insert into #tempPolicy SELECT	45	,	901
insert into #tempPolicy SELECT	45	,	902
insert into #tempPolicy SELECT	45	,	903
insert into #tempPolicy SELECT	45	,	904
insert into #tempPolicy SELECT	45	,	917
insert into #tempPolicy SELECT	45	,	1026
insert into #tempPolicy SELECT	46	,	383
insert into #tempPolicy SELECT	47	,	435
insert into #tempPolicy SELECT	48	,	735
insert into #tempPolicy SELECT	48	,	736
insert into #tempPolicy SELECT	48	,	737
insert into #tempPolicy SELECT	48	,	738
insert into #tempPolicy SELECT	49	,	262
insert into #tempPolicy SELECT	49	,	602
insert into #tempPolicy SELECT	49	,	606
insert into #tempPolicy SELECT	49	,	607
insert into #tempPolicy SELECT	49	,	635
insert into #tempPolicy SELECT	49	,	636
insert into #tempPolicy SELECT	49	,	639
insert into #tempPolicy SELECT	49	,	642
insert into #tempPolicy SELECT	49	,	643
insert into #tempPolicy SELECT	49	,	644
insert into #tempPolicy SELECT	49	,	645
insert into #tempPolicy SELECT	49	,	648
insert into #tempPolicy SELECT	49	,	649
insert into #tempPolicy SELECT	49	,	650
insert into #tempPolicy SELECT	49	,	652
insert into #tempPolicy SELECT	49	,	653
insert into #tempPolicy SELECT	49	,	655
insert into #tempPolicy SELECT	49	,	656
insert into #tempPolicy SELECT	49	,	657
insert into #tempPolicy SELECT	49	,	659
insert into #tempPolicy SELECT	49	,	661
insert into #tempPolicy SELECT	49	,	866
insert into #tempPolicy SELECT	49	,	867
insert into #tempPolicy SELECT	49	,	868
insert into #tempPolicy SELECT	49	,	869
insert into #tempPolicy SELECT	49	,	870
insert into #tempPolicy SELECT	49	,	871
insert into #tempPolicy SELECT	49	,	872
insert into #tempPolicy SELECT	49	,	873
insert into #tempPolicy SELECT	49	,	874
insert into #tempPolicy SELECT	49	,	875
insert into #tempPolicy SELECT	49	,	876
insert into #tempPolicy SELECT	49	,	877
insert into #tempPolicy SELECT	49	,	878
insert into #tempPolicy SELECT	49	,	928
insert into #tempPolicy SELECT	49	,	929
insert into #tempPolicy SELECT	49	,	930
insert into #tempPolicy SELECT	49	,	931
insert into #tempPolicy SELECT	49	,	932
insert into #tempPolicy SELECT	49	,	933
insert into #tempPolicy SELECT	49	,	934
insert into #tempPolicy SELECT	49	,	935
insert into #tempPolicy SELECT	49	,	936
insert into #tempPolicy SELECT	50	,	937
insert into #tempPolicy SELECT	50	,	938
insert into #tempPolicy SELECT	50	,	939
insert into #tempPolicy SELECT	51	,	824
insert into #tempPolicy SELECT	52	,	629
insert into #tempPolicy SELECT	53	,	757
insert into #tempPolicy SELECT	54	,	923
insert into #tempPolicy SELECT	55	,	905
insert into #tempPolicy SELECT	56	,	906
insert into #tempPolicy SELECT	57	,	811
insert into #tempPolicy SELECT	57	,	825
insert into #tempPolicy SELECT	57	,	945
insert into #tempPolicy SELECT	58	,	850
insert into #tempPolicy SELECT	58	,	851
insert into #tempPolicy SELECT	58	,	852
insert into #tempPolicy SELECT	58	,	943
insert into #tempPolicy SELECT	58	,	944
insert into #tempPolicy SELECT	59	,	767
insert into #tempPolicy SELECT	59	,	769
insert into #tempPolicy SELECT	59	,	770
insert into #tempPolicy SELECT	60	,	764
insert into #tempPolicy SELECT	61	,	953
insert into #tempPolicy SELECT	62	,	954
insert into #tempPolicy SELECT	62	,	955
insert into #tempPolicy SELECT	63	,	828
insert into #tempPolicy SELECT	63	,	946
insert into #tempPolicy SELECT	64	,	351
insert into #tempPolicy SELECT	65	,	920
insert into #tempPolicy SELECT	65	,	921
insert into #tempPolicy SELECT	65	,	1022
insert into #tempPolicy SELECT	66	,	581
insert into #tempPolicy SELECT	66	,	727
insert into #tempPolicy SELECT	67	,	927
insert into #tempPolicy SELECT	68	,	253
insert into #tempPolicy SELECT	69	,	744
insert into #tempPolicy SELECT	69	,	745
insert into #tempPolicy SELECT	70	,	1023
insert into #tempPolicy SELECT	71	,	925
insert into #tempPolicy SELECT	72	,	926
insert into #tempPolicy SELECT	73	,	829
insert into #tempPolicy SELECT	74	,	293
insert into #tempPolicy SELECT	75	,	291
insert into #tempPolicy SELECT	76	,	292
insert into #tempPolicy SELECT	77	,	1025
insert into #tempPolicy SELECT	78	,	632
insert into #tempPolicy SELECT	78	,	633
insert into #tempPolicy SELECT	78	,	743
insert into #tempPolicy SELECT	78	,	918
insert into #tempPolicy SELECT	79	,	783
insert into #tempPolicy SELECT	80	,	924
insert into #tempPolicy SELECT	81	,	592
insert into #tempPolicy SELECT	81	,	599
insert into #tempPolicy SELECT	81	,	617
insert into #tempPolicy SELECT	81	,	618
insert into #tempPolicy SELECT	81	,	674
insert into #tempPolicy SELECT	81	,	676
insert into #tempPolicy SELECT	81	,	677
insert into #tempPolicy SELECT	81	,	678
insert into #tempPolicy SELECT	81	,	679
insert into #tempPolicy SELECT	81	,	680
insert into #tempPolicy SELECT	81	,	681
insert into #tempPolicy SELECT	81	,	682
insert into #tempPolicy SELECT	81	,	683
insert into #tempPolicy SELECT	81	,	685
insert into #tempPolicy SELECT	81	,	686
insert into #tempPolicy SELECT	81	,	687
insert into #tempPolicy SELECT	81	,	688
insert into #tempPolicy SELECT	81	,	689
insert into #tempPolicy SELECT	81	,	690
insert into #tempPolicy SELECT	81	,	691
insert into #tempPolicy SELECT	81	,	692
insert into #tempPolicy SELECT	81	,	693
insert into #tempPolicy SELECT	81	,	694
insert into #tempPolicy SELECT	81	,	695
insert into #tempPolicy SELECT	81	,	696
insert into #tempPolicy SELECT	81	,	698
insert into #tempPolicy SELECT	81	,	699
insert into #tempPolicy SELECT	81	,	700
insert into #tempPolicy SELECT	81	,	701
insert into #tempPolicy SELECT	81	,	702
insert into #tempPolicy SELECT	81	,	703
insert into #tempPolicy SELECT	81	,	704
insert into #tempPolicy SELECT	81	,	705
insert into #tempPolicy SELECT	81	,	706
insert into #tempPolicy SELECT	81	,	707
insert into #tempPolicy SELECT	81	,	708
insert into #tempPolicy SELECT	81	,	710
insert into #tempPolicy SELECT	81	,	711
insert into #tempPolicy SELECT	81	,	713
insert into #tempPolicy SELECT	81	,	715
insert into #tempPolicy SELECT	81	,	716
insert into #tempPolicy SELECT	81	,	717
insert into #tempPolicy SELECT	81	,	718
insert into #tempPolicy SELECT	81	,	808
insert into #tempPolicy SELECT	81	,	881
insert into #tempPolicy SELECT	81	,	882
insert into #tempPolicy SELECT	81	,	883
insert into #tempPolicy SELECT	81	,	884
insert into #tempPolicy SELECT	81	,	885
insert into #tempPolicy SELECT	81	,	886
insert into #tempPolicy SELECT	81	,	887
insert into #tempPolicy SELECT	81	,	888
insert into #tempPolicy SELECT	81	,	889
insert into #tempPolicy SELECT	81	,	890
insert into #tempPolicy SELECT	81	,	891
insert into #tempPolicy SELECT	81	,	1016
insert into #tempPolicy SELECT	81	,	1017
insert into #tempPolicy SELECT	81	,	1018
insert into #tempPolicy SELECT	81	,	1019
insert into #tempPolicy SELECT	81	,	1020
insert into #tempPolicy SELECT	81	,	1021
insert into #tempPolicy SELECT	82	,	940
insert into #tempPolicy SELECT	82	,	941
insert into #tempPolicy SELECT	82	,	956
insert into #tempPolicy SELECT	82	,	957
insert into #tempPolicy SELECT	82	,	958
insert into #tempPolicy SELECT	82	,	959
insert into #tempPolicy SELECT	82	,	960
insert into #tempPolicy SELECT	82	,	961
insert into #tempPolicy SELECT	82	,	962
insert into #tempPolicy SELECT	82	,	963
insert into #tempPolicy SELECT	82	,	964
insert into #tempPolicy SELECT	82	,	965
insert into #tempPolicy SELECT	82	,	966
insert into #tempPolicy SELECT	82	,	967
insert into #tempPolicy SELECT	82	,	968
insert into #tempPolicy SELECT	82	,	969
insert into #tempPolicy SELECT	82	,	970
insert into #tempPolicy SELECT	82	,	971
insert into #tempPolicy SELECT	82	,	972
insert into #tempPolicy SELECT	82	,	973
insert into #tempPolicy SELECT	82	,	974
insert into #tempPolicy SELECT	82	,	975
insert into #tempPolicy SELECT	82	,	976
insert into #tempPolicy SELECT	82	,	977
insert into #tempPolicy SELECT	82	,	978
insert into #tempPolicy SELECT	82	,	979
insert into #tempPolicy SELECT	82	,	980
insert into #tempPolicy SELECT	82	,	981
insert into #tempPolicy SELECT	82	,	982
insert into #tempPolicy SELECT	82	,	983
insert into #tempPolicy SELECT	82	,	984
insert into #tempPolicy SELECT	82	,	985
insert into #tempPolicy SELECT	82	,	986
insert into #tempPolicy SELECT	82	,	987
insert into #tempPolicy SELECT	82	,	988
insert into #tempPolicy SELECT	82	,	989
insert into #tempPolicy SELECT	82	,	990
insert into #tempPolicy SELECT	82	,	991
insert into #tempPolicy SELECT	82	,	992
insert into #tempPolicy SELECT	82	,	993
insert into #tempPolicy SELECT	82	,	994
insert into #tempPolicy SELECT	82	,	995
insert into #tempPolicy SELECT	82	,	996
insert into #tempPolicy SELECT	82	,	997
insert into #tempPolicy SELECT	82	,	998
insert into #tempPolicy SELECT	82	,	999
insert into #tempPolicy SELECT	82	,	1000
insert into #tempPolicy SELECT	82	,	1001
insert into #tempPolicy SELECT	82	,	1002
insert into #tempPolicy SELECT	82	,	1003
insert into #tempPolicy SELECT	82	,	1004
insert into #tempPolicy SELECT	82	,	1005
insert into #tempPolicy SELECT	82	,	1006
insert into #tempPolicy SELECT	82	,	1007
insert into #tempPolicy SELECT	82	,	1008
insert into #tempPolicy SELECT	82	,	1009
insert into #tempPolicy SELECT	82	,	1010
insert into #tempPolicy SELECT	82	,	1011
insert into #tempPolicy SELECT	82	,	1012
insert into #tempPolicy SELECT	82	,	1013
insert into #tempPolicy SELECT	82	,	1014
insert into #tempPolicy SELECT	82	,	1015
insert into #tempPolicy SELECT	83	,	812
insert into #tempPolicy SELECT	83	,	813
insert into #tempPolicy SELECT	83	,	830
insert into #tempPolicy SELECT	83	,	831
insert into #tempPolicy SELECT	83	,	832
insert into #tempPolicy SELECT	83	,	833
insert into #tempPolicy SELECT	83	,	834
insert into #tempPolicy SELECT	83	,	835
insert into #tempPolicy SELECT	83	,	836
insert into #tempPolicy SELECT	83	,	838
insert into #tempPolicy SELECT	83	,	839
insert into #tempPolicy SELECT	83	,	840
insert into #tempPolicy SELECT	83	,	841
insert into #tempPolicy SELECT	83	,	843
insert into #tempPolicy SELECT	83	,	844
insert into #tempPolicy SELECT	83	,	845
insert into #tempPolicy SELECT	83	,	846
insert into #tempPolicy SELECT	83	,	847
insert into #tempPolicy SELECT	83	,	848
insert into #tempPolicy SELECT	83	,	849
insert into #tempPolicy SELECT	83	,	947
insert into #tempPolicy SELECT	83	,	948
insert into #tempPolicy SELECT	83	,	949
insert into #tempPolicy SELECT	83	,	950
insert into #tempPolicy SELECT	83	,	951



-------------------------------------------------------------------------------------


/*
if(object_ID('tempdb..#ReportCard') is not null)
begin
drop TABLE #ReportCard
end
CREATE TABLE #ReportCard (
[Organization Name] varchar(100)
, [ClientName] varchar(100)
, [TIP Opportunities] int
, [Completed TIPs] int
, [TIPCompletionRate] decimal (5,2)
, [Successful TIPs] int
, [TIPSuccessfulRate] decimal (5,2)
, [NetEffectiveRate] decimal (5,4)
, [Star TIPs Opportunity] int
, [Star Completed TIPs] int
, [StarTIPCompletionRate] decimal (5,2)
, [Star Successful TIPs] int
, [StarTIPSuccessfulRate] decimal (5,2)
, [StarNetEffectiveRate] decimal (5,4)
, [Cost TIPs Opportunity] int
, [Cost Completed TIPs] int
, [CostTIPCompletionRate] decimal (5,2)
, [Cost Successful TIPs] int
, [CostTIPSuccessfulRate] decimal (5,2)
, [CostNetEffectiveRate] decimal (5,4)
, [Quality TIPs Opportunity] int
, [Quality Completed TIPs] int
, [QualityTIPCompletionRate] decimal (5,2)
, [Quality Successful TIPs] int
, [QualityTIPSuccessfulRate] decimal (5,2)
, [QualityNetEffectiveRate] decimal (5,4)
, [CMROpportunity] int
, [CMROffered] int
, [percentCMROffered] decimal (5,2)
, [completedCMRs] int
, [percentCMRCompletion] decimal (5,2)
, [CMRNetEffectiveRate] decimal (5,4)
, [EligiblePatient] int
, [claimSubmitted] int
, [DTPClaims] int
, [ValidationOpportunity] int
, [ValidationSuccess] int
, [PatientConsults] int
, [PatientRefusals] int
, [PatientUnableToReach] int
, [PrescriberConsults] int
, [PrescriberRefusals] int
, [PrescriberUnableToReach] int)
*/


/* This section has been commenting out on 04/01/2019
--select * From #org
--select * from #tempClient
--		SELECT	[Organization Name]
--				, c.clientName
--		FROM	#org o
--				join  #tempClient c on o.orgID = c.clientID

*/

DROP TABLE IF EXISTS #v
SELECT	*
INTO	#v
FROM 
	(
		SELECT	[Organization Name]
				, c.clientName
		FROM	#org o
				, #tempClient c
		WHERE	1=1
	)	v
CREATE CLUSTERED INDEX IDX ON #v ([Organization Name], [clientName])

DROP TABLE IF EXISTS #t1
SELECT	*
INTO #t1
FROM
	(
		SELECT	o.[Organization Name]
				, ta.clientName
				--, ta.centerid
				, cast(sum(ta.[TIP Opportunities]) as decimal) as [TIP Opportunities]
				, cast(sum(ta.[Completed TIPs]) as decimal) as [Completed TIPs]
				, isnull(cast((cast(sum(ta.[Completed TIPs]) as decimal)/nullif(cast(sum(ta.[TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0) as TIPCompletionRate
				, cast(sum(ta.[Successful TIPs]) as decimal) as [Successful TIPs]
				, isnull(cast((cast(sum(ta.[Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as TIPSuccessfulRate
				, isnull(cast((cast(sum(ta.[Successful TIPs]) as decimal)/nullif(cast(sum(ta.[TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0) as NetEffectiveRate
				-------
				, cast(sum(ta.[Cost TIPs Opportunity]) as decimal) as [Cost TIPs Opportunity]
				, cast(sum(ta.[Cost Completed TIPs]) as decimal) as [Cost Completed TIPs]
				, isnull(cast((cast(sum(ta.[Cost Completed TIPs]) as decimal)/nullif(cast(sum(ta.[Cost TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as CostTIPCompletionRate
				, cast(sum(ta.[Cost Successful TIPs]) as decimal) as [Cost Successful TIPs]
				, isnull(cast((cast(sum(ta.[Cost Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Cost Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as CostTIPSuccessfulRate
				, isnull(cast((cast(sum(ta.[Cost Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Cost TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as CostNetEffectiveRate
				-------
				, cast(sum(ta.[Star TIPs Opportunity]) as decimal) as [Star TIPs Opportunity]
				, cast(sum(ta.[Star Completed TIPs]) as decimal) as [Star Completed TIPs]
				, isnull(cast((cast(sum(ta.[Star Completed TIPs]) as decimal)/nullif(cast(sum(ta.[Star TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as StarTIPCompletionRate
				, cast(sum(ta.[Star Successful TIPs]) as decimal) as [Star Successful TIPs]
				, isnull(cast((cast(sum(ta.[Star Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Star Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as StarTIPSuccessfulRate
				, isnull(cast((cast(sum(ta.[Star Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Star TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as StarNetEffectiveRate
				--------
				, cast(sum(ta.[Quality TIPs Opportunity]) as decimal) as [Quality TIPs Opportunity]
				, cast(sum(ta.[Quality Completed TIPs]) as decimal) as [Quality Completed TIPs]
				, isnull(cast((cast(sum(ta.[Quality Completed TIPs]) as decimal)/nullif(cast(sum(ta.[Quality TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as QualityTIPCompletionRate
				, cast(sum(ta.[Quality Successful TIPs]) as decimal) as [Quality Successful TIPs]
				, isnull(cast((cast(sum(ta.[Quality Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Quality Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as QualityTIPSuccessfulRate
				, isnull(cast((cast(sum(ta.[Quality Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Quality TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as QualityNetEffectiveRate
		FROM 
			(	
				SELECT	row_number() over (partition by oc.orgID, tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
						, tacr.centerid
						, oc.orgID
						, pcl.clientName
						, tacr.[TIP Opportunities]
						, CASE WHEN tacr.activethru > @END THEN 0 ELSE tacr.[Completed TIPs] END AS [Completed TIPs]
						, CASE WHEN tacr.activethru > @END THEN 0 ELSE tacr.[Successful TIPs] END AS [Successful TIPs]
						, case when tacr.tiptype = 'COST' then 1 else 0 end as [Cost TIPs Opportunity]
						, case when tacr.tiptype = 'COST' and tacr.activethru <= @END then tacr.[Completed TIPs] else 0 end as [Cost Completed TIPs]
						, case when tacr.tiptype = 'COST' and tacr.activethru <= @END then tacr.[Successful TIPs] else 0 end as [Cost Successful TIPs]
						, case when tacr.tiptype = 'STAR' then 1 else 0 end as [Star TIPs Opportunity]
						, case when tacr.tiptype = 'STAR' and tacr.activethru <= @END then tacr.[Completed TIPs] else 0 end as [Star Completed TIPs]
						, case when tacr.tiptype = 'STAR' and tacr.activethru <= @END then tacr.[Successful TIPs] else 0 end as [Star Successful TIPs]
						, case when tacr.tiptype = 'QUALITY' then 1 else 0 end as [Quality TIPs Opportunity]
						, case when tacr.tiptype = 'QUALITY' and tacr.activethru <= @END then tacr.[Completed TIPs] else 0 end as [Quality Completed TIPs]
						, case when tacr.tiptype = 'QUALITY' and tacr.activethru <= @END then tacr.[Successful TIPs] else 0 end as [Quality Successful TIPs]
				FROM	outcomesMTM.dbo.tipActivityCenterReport tacr with(nolock)
						join #org2Center oc on oc.centerid = tacr.centerID
						join 
							(
								SELECT	po.policyID
										, cl.clientID
										, cl.clientName
								FROM	#tempPolicy po
										join #tempClient cl on cl.clientID = po.clientID
								WHERE	1=1
							)	pcl on pcl.policyID = tacr.policyid
						--join outcomesMTM.dbo.Policy po on po.policyID = tacr.policyid
						--join outcomesMTM.dbo.Contract co on co.contractID = po.contractID
						--join outcomesMTM.dbo.Client cl on cl.clientID = co.clientID
				WHERE	1=1
						and tacr.primaryPharmacy = 1 
						and tacr.activethru >= @BEGIN
						and tacr.activeasof <= @END
						AND ((tacr.activethru <= @END AND (tacr.[completed tips] = 1 or tacr.[unfinished tips] = 1 or tacr.[review/resubmit tips] = 1 or tacr.[rejected tips] = 1)) 
							OR datediff(day, case when tacr.activeasof > @BEGIN then tacr.activeasof else @BEGIN end, case when tacr.activethru > @END then @END else tacr.activethru end) > 30)
			)	ta
				join #org o on o.orgID = ta.orgID
		WHERE	1=1
				and ta.Rank = 1
		GROUP BY o.[Organization Name], ta.clientName
	)   t1
CREATE NONCLUSTERED INDEX NIDX ON #t1 ([Organization Name], [clientName]) include 
([TIP Opportunities], [Completed TIPs], TIPCompletionRate, [Successful TIPs], TIPSuccessfulRate
, NetEffectiveRate, [Star TIPs Opportunity], [Star Completed TIPs], StarTIPCompletionRate, [Star Successful TIPs]
, StarTIPSuccessfulRate, StarNetEffectiveRate, [Cost TIPs Opportunity], [Cost Completed TIPs], CostTIPCompletionRate
, [Cost Successful TIPs], CostTIPSuccessfulRate, CostNetEffectiveRate, [Quality TIPs Opportunity], [Quality Completed TIPs]
, QualityTIPCompletionRate, [Quality Successful TIPs], QualityTIPSuccessfulRate, QualityNetEffectiveRate)


DROP TABLE IF EXISTS #c1
SELECT	*
INTO	#c1
FROM
	(
		SELECT	--u.centerID	
				o.[Organization Name]
				, u.clientName				
				, count(DISTINCT u.PatientID) as CMROpportunity
				, sum(u.CMROffered) as CMROffered				
				, sum(u.CMRCompleted) as completedCMRs
				, case when count(DISTINCT u.PatientID) = 0 then 0 else cast((cast(sum(u.CMROffered) as decimal))/(cast(count(DISTINCT u.PatientID) as decimal)) as decimal(5,2)) end as percentCMRoffered
				, case when sum(u.CMROffered) = 0 then 0 else cast((cast(sum(u.CMRCompleted) as decimal))/(cast(sum(u.CMROffered) as decimal)) as decimal(5,2)) end as percentCMRcompletion
				, case when count(DISTINCT u.PatientID) = 0 then 0 else cast((cast(sum(u.CMRCompleted) as decimal))/(cast(count(DISTINCT u.PatientID) as decimal)) as decimal(5,2)) end as [CMRNetEffectiveRate]	
				--, case when count(DISTINCT u.PatientID) = 0 or sum(u.CMROffered) = 0 then 0 else (cast((cast(sum(u.CMRCompleted) as decimal))/(cast(sum(u.CMROffered) as decimal)) as decimal(5,2)) *	cast((cast(sum(u.CMROffered) as decimal))/(cast(count(DISTINCT u.PatientID) as decimal)) as decimal(5,2))) end as [CMRNetEffectiveRate]	
		FROM 
			(
				SELECT	row_number() over (partition by rp.patientID, oc.orgID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
						, rp.PatientID
						, rp.PolicyID
						, rp.CMSContractNumber
						, oc.orgID
						, rp.centerid
						, rp.chainid
						, rp.primaryPharmacy
						, rp.CMREligible
						, rp.mtmServiceDT
						, rp.resultTypeID
						, rp.cmrDeliveryTypeID
						, rp.statusID
						, rp.paid
						, rp.Language
						, rp.activeAsOF
						, rp.activeThru
						, pcl.clientName
						, case when rp.outcomesTermDate between @BEGIN and @END AND isNull(rp.mtmServiceDT, '99991231') not between @BEGIN and @END THEN 1 ELSE 0 END as Termed
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12) AND rp.chainID = rp.claimChainID  THEN 1 ELSE 0 END as CMROffered
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END as CMRCompleted
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 12 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as PatientRefused
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 18 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as UnableToReachPatient
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 5 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRWithDrugProblems
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 6 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRWithoutDrugProblems
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.cmrDeliveryTypeID = 1 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRFace2Face
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.cmrDeliveryTypeID = 2 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRPhone
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.cmrDeliveryTypeID = 3 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRTelehealth
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.chainID <> rp.claimChainID THEN 1 ELSE 0 END as CMRMissed
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 5 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END as CMRRejected
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 2 AND rp.chainID = rp.claimChainID AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRPendingApproval
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 6 and rp.paid = 0 AND rp.chainID = rp.claimChainID AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRApprovedPendingPayment
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 6 and rp.paid = 1 AND rp.chainID = rp.claimChainID AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRApprovedPaid
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.Language = 'EN' AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END EnglishSPT
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.Language = 'SP' AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END SpanishSPT
						, case when rp.mtmServiceDT between @BEGIN and @END AND rp.chainID = rp.claimChainID THEN cast(rp.postHospitalDischarge as int) ELSE 0 END as postHospitalDischarge
				FROM	vw_CMRActivityReport rp with(nolock)
						join #org2Center oc on oc.centerid = rp.centerid
						join patientDim pd  with(nolock) on pd.patientKey = rp.patientKey
						join policy p  with(nolock) on p.policyID = rp.policyID
						join pharmacy ph  with(nolock) on ph.centerID = rp.centerID
						join 
							(
								SELECT	po.policyID
										, cl.clientID
										, cl.clientName
								FROM	#tempPolicy po
										join #tempClient cl on cl.clientID = po.clientID
								WHERE	1=1
							)	pcl on pcl.policyID = rp.policyid
						left join outcomesMTM.dbo.chain c with(nolock) on c.chainid = rp.chainid     
				WHERE	1=1    
						AND isNull(rp.activethru, '99991231') >= @BEGIN
						AND rp.activeasof <= @END
						and rp.primaryPharmacy = 1 --or (rp.primaryPharmacy = 0 and case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12, 18) AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END = 1))
							--30 day include
						AND 
							(
								(rp.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, @END) >= 30)
								OR
								(rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, CASE WHEN rp.activethru > @END THEN @END ELSE rp.activethru END) >= 30)
								OR
								(rp.mtmServiceDT BETWEEN @BEGIN AND @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6))
								AND
								(rp.claimcenterID = rp.centerid)
							)
			)	u   
				join #org o on o.orgID = u.orgID
		WHERE	1 = 1   
				and u.rank = 1
		GROUP BY o.[Organization Name], u.clientName
	)	c1
CREATE NONCLUSTERED INDEX NIDX ON #c1 ([Organization Name], [clientName]) include 
(CMROpportunity, CMROffered, percentCMRoffered, completedCMRs, percentCMRcompletion, CMRNetEffectiveRate)


DROP TABLE IF EXISTS #p1
SELECT	*
INTO	#p1
FROM 
	(
		SELECT	o.[Organization Name]
				, pt.clientName
				, count(DISTINCT pt.patientID) as [EligiblePatient]
		FROM	outcomesMTM.dbo.patientMTMCenterDim pm with(nolock)
				join #org2Center oc on oc.centerid = pm.centerid
				join 
					(
						SELECT	DISTINCT pt.patientID
								, pcl.clientName
						--SELECT count(DISTINCT pt.patientID)
						FROM	outcomesMTM.dbo.patientDim pt with(nolock)
								join 
									(
										SELECT	po.policyID
												, cl.clientID
												, cl.clientName
										FROM	#tempPolicy po
												join #tempClient cl on cl.clientID = po.clientID
										WHERE	1=1
									)	pcl on pcl.policyID = pt.policyid
						WHERE	1=1
								and isnull(pt.activethru, '99991231') >= @BEGIN
								and pt.policyid not in (574 ,575 ,298)
								and pt.activeasof <= @END
					)	pt on pt.patientID = pm.patientid
				join #org o on o.orgID = oc.orgID
		WHERE	1=1
				and isnull(pm.activethru, '99991231') >= @BEGIN
				and pm.activeasof <= @END
		GROUP BY o.[Organization Name], pt.clientName
	)	p1
CREATE NONCLUSTERED INDEX NIDX ON #p1 ([Organization Name], [clientName]) include (EligiblePatient)

DROP TABLE IF EXISTS #r1
SELECT	*
INTO	#r1
FROM 
	(
		SELECT	o.[Organization Name]
				, v.clientName
				, sum(v.claimSubmitted) as claimSubmitted
				, sum(v.DTPClaims) as DTPClaims
				, isnull(cast((cast(sum(v.DTPClaims) as decimal)/nullif(cast(sum(v.claimSubmitted) as decimal), 0)) as decimal (5,2)), 0) as [DTPpercentage]
				, sum(v.[ValidationOpportunity]) as [ValidationOpportunity]
				, sum(v.[ValidationSuccess]) as [ValidationSuccess]
				, sum(v.[PatientConsults]) as [PatientConsults]
				, sum(v.[PatientRefusals]) as [PatientRefusals]
				, sum(v.[PatientUnableToReach]) as [PatientUnableToReach]
				, isnull(cast((cast(sum(v.[PatientRefusals]) as decimal) + cast(sum(v.[PatientUnableToReach]) as decimal))/ nullif(cast(sum(v.[PatientConsults]) as decimal), 0) as decimal (5,2)), 0) as [PatientSuccessRate]
				, sum(v.[PrescriberConsults]) as [PrescriberConsults]
				, sum(v.[PrescriberRefusals]) as [PrescriberRefusals]
				, sum(v.[PrescriberUnableToReach]) as [PrescriberUnableToReach]
				, isnull(cast((cast(sum(v.[PrescriberRefusals]) as decimal) + cast(sum(v.[PrescriberUnableToReach]) as decimal))/ nullif(cast(sum(v.[PrescriberConsults]) as decimal), 0) as decimal (5,2)), 0) as [PrescriberSuccessRate]
		FROM 
			(
				SELECT	c.claimID
						, oc.orgID
						, pcl.clientName
						, c.[MTM CenterID]
						, 1 as claimSubmitted
						, case when c.resulttypeID not in (12, 13, 16, 18) and c.actiontypeID <> 3 then 1 else 0 end as [DTPClaims]
						, case when c.validated is not null then 1 else 0 end as [ValidationOpportunity]
						, case when c.validated = 1 then 1 else 0 end as [ValidationSuccess]
						, case when c.actiontypeID in (1, 2, 3, 17) then 1 else 0 end as [PatientConsults]
						, case when c.actiontypeID in (1, 2, 3, 17) and c.resulttypeID = 12 then 1 else 0 end as [PatientRefusals]
						, case when c.actiontypeID in (1, 2, 3, 17) and c.resulttypeID = 18 then 1 else 0 end as [PatientUnableToReach]
						, case when c.actiontypeID = 4 then 1 else 0 end as [PrescriberConsults]
						, case when c.actiontypeID = 4 and c.resulttypeID = 13 then 1 else 0 end as [PrescriberRefusals]
						, case when c.actiontypeID = 4 and c.resulttypeID = 16 then 1 else 0 end as [PrescriberUnableToReach]
				FROM	outcomesMTM.dbo.ClaimActivityReport c with(nolock)
						join #org2Center oc on oc.NCPDP_NABP = c.[MTM CenterID]
						join 
							(
								SELECT	po.policyID
										, cl.clientID
										, cl.clientName
								FROM	#tempPolicy po
										join #tempClient cl on cl.clientID = po.clientID
								WHERE	1=1
							)	pcl on pcl.policyID = c.policyid
				WHERE	1=1
						and c.mtmServiceDT between @BEGIN and @END
						and c.statusID not in (3,5)
			)	v
				join #org o on o.orgID = v.orgID
		WHERE	1=1
		GROUP BY o.[Organization Name], v.clientName
	)	r1
CREATE NONCLUSTERED INDEX NIDX ON #r1 ([Organization Name], [clientName]) include 
(claimSubmitted, DTPClaims, ValidationOpportunity, ValidationSuccess, PatientConsults
, PatientRefusals, PatientUnableToReach, PrescriberConsults, PrescriberRefusals, PrescriberUnableToReach)


SELECT	v.[Organization Name]
		, v.clientName
		, t1.[TIP Opportunities]
		, t1.[Completed TIPs]
		, t1.TIPCompletionRate
		, t1.[Successful TIPs]
		, t1.TIPSuccessfulRate
		, t1.NetEffectiveRate
		, t1.[Star TIPs Opportunity]
		, t1.[Star Completed TIPs]
		, t1.StarTIPCompletionRate
		, t1.[Star Successful TIPs]
		, t1.StarTIPSuccessfulRate
		, t1.StarNetEffectiveRate
		, t1.[Cost TIPs Opportunity]
		, t1.[Cost Completed TIPs]
		, t1.CostTIPCompletionRate
		, t1.[Cost Successful TIPs]
		, t1.CostTIPSuccessfulRate
		, t1.CostNetEffectiveRate
		, t1.[Quality TIPs Opportunity]
		, t1.[Quality Completed TIPs]
		, t1.QualityTIPCompletionRate
		, t1.[Quality Successful TIPs]
		, t1.QualityTIPSuccessfulRate
		, t1.QualityNetEffectiveRate
		, c1.CMROpportunity
		, c1.CMROffered
		, c1.percentCMRoffered
		, c1.completedCMRs
		, c1.percentCMRcompletion
		, c1.CMRNetEffectiveRate
		, p1.EligiblePatient
		, r1.claimSubmitted
		, r1.DTPClaims
		, r1.ValidationOpportunity
		, r1.ValidationSuccess
		, r1.PatientConsults
		, r1.PatientRefusals
		, r1.PatientUnableToReach
		, r1.PrescriberConsults
		, r1.PrescriberRefusals
		, r1.PrescriberUnableToReach
FROM	#v v
		left join #t1 t1 on t1.[Organization Name] = v.[Organization Name] and t1.clientName = v.clientName
		left join #c1 c1 on c1.[Organization Name] = v.[Organization Name] and c1.clientName = v.clientName
		left join #p1 p1 on p1.[Organization Name] = v.[Organization Name] and p1.clientName = v.clientName
		left join #r1 r1 on r1.[Organization Name] = v.[Organization Name] and r1.clientName = v.clientName
WHERE 1=1
order by v.[Organization Name], v.clientName


end











