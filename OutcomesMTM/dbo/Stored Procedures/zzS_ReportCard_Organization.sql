






create   proc [dbo].[zzS_ReportCard_Organization] 
as 
begin 


DECLARE @BEGIN VARCHAR(10)
DECLARE @END VARCHAR(10)


SET @BEGIN = case when month(getdate()) = 1 then cast(year(getdate()) - 1 as varchar(4)) + '0101' else cast(year(getdate()) as varchar(4)) + '0101' end  --// Beginning of year (if current month is Jan. then beginning of last year)
SET @END =  cast(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as date)	 		--end of last month 



---------------------------------------------------------------------------------------------------------
--------------------------CHAINS
---------------------------------------------------------------------------------------------------------
--Below temp table was provided by Network Performance
if(object_ID('tempdb..#chainRollUp') is not null)
begin
drop table #chainRollUp
end
create table #chainRollUp (
ID int identity (1,1) primary key
, Preferred int
, [Organization Category Size] int
, [Organization Name] varchar(100)
, RelationshipID varchar(50)
, NABP varchar(50))

insert into #chainrollup select 0  ,  5  ,  'A S MEDICATION SOLUTIONS LLC'  ,  '702'  ,  NULL
insert into #chainrollup select 0  ,  NULL  ,  'AADP'  ,  '936'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'ACCREDO HEALTH GROUP INC'  ,  '392'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Acme Pharmacies'  ,  '260'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'ADVANCED HOME CARE INC'  ,  'B44'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'ADVANCED RX MANAGEMENT'  ,  'A93'  ,  NULL
insert into #chainrollup select 1  ,  2  ,  'Ahold USA'  ,  '289'  ,  NULL
insert into #chainrollup select 1  ,  2  ,  'Ahold USA'  ,  '415'  ,  NULL
insert into #chainrollup select 1  ,  2  ,  'Ahold USA'  ,  '075'  ,  NULL
insert into #chainrollup select 1  ,  3  ,  'Delhaize'  ,  '233'  ,  NULL
insert into #chainrollup select 1  ,  3  ,  'Delhaize'  ,  '862'  ,  NULL
insert into #chainrollup select 1  ,  2  ,  'Ahold Delhaize'  ,  '289'  ,  NULL
insert into #chainrollup select 1  ,  2  ,  'Ahold Delhaize'  ,  '415'  ,  NULL
insert into #chainrollup select 1  ,  2  ,  'Ahold Delhaize'  ,  '075'  ,  NULL
insert into #chainrollup select 1  ,  2  ,  'Ahold Delhaize'  ,  '233'  ,  NULL
insert into #chainrollup select 1  ,  2  ,  'Ahold Delhaize'  ,  '862'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'AHS-St. John Pharmacy'  ,  '671'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'AIDS HEALTHCARE FOUNDATION'  ,  'A23'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  '929'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  '003'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  NULL  ,  '999572'
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  NULL  ,  '999573'
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  NULL  ,  '999574'
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  '156'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  '301'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  'B62'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  '158'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  '227'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  '282'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  '027'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  '400'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  NULL  ,  '999507'
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  NULL  ,  '999511'
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  NULL  ,  '999512'
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  NULL  ,  '999517'
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  'C08'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  '319'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Albertsons'  ,  'C31'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'ALEGENT RETAIL PHARMACIES'  ,  'A47'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'ALLINA COMMUNITY PHARMACIES'  ,  '799'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'AMBIENT HEALTHCARE INC'  ,  'B18'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'American Pharmacy Network Solutions'  ,  '841'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Elevate Provider Network'  ,  '638'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Elevate Provider Network'  ,  '904'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'AMERITA INC'  ,  '969'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'APPALACHIAN REG HLTH CARE'  ,  '492'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Arete Pharmacy'  ,  '712'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Arete Pharmacy'  ,  '941'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Arete Pharmacy'  ,  '967'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Arete Pharmacy'  ,  '426'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Arete Pharmacy'  ,  '678'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Arete Pharmacy'  ,  '783'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'ASSOCIATED FRESH MARKET INC'  ,  'A34'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'ASTRUP DRUG INC'  ,  '634'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Aurora Pharmacy'  ,  '832'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Bartell Drugs'  ,  '011'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Baystate Health'  ,  '719'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'BIG Y FOODS INC'  ,  '835'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Bi-Mart'  ,  '048'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'BioRx'  ,  'A78'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'BRIOVARX LLC'  ,  '951'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'BROCKIE HEALTHCARE INC'  ,  '538'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Brookshire Brothers'  ,  '463'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Brookshire Grocery Co.'  ,  '453'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Cardinal Health'  ,  '603'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Cardinal Health'  ,  'A51'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Cardinal Health'  ,  '931'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Cardinal Health'  ,  '139'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Cardinal Health'  ,  '307'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Cardinal Health LeaderNET'  ,  '603'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Cardinal Health LeaderNET'  ,  'A51'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Cardinal Health Managed Care Connection'  ,  '931'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Cardinal Health Medicap/Medicine Shoppe'  ,  '139'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'Cardinal Health Medicap/Medicine Shoppe'  ,  '307'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Central Dakota Pharmacys'  ,  '903'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'CHEROKEE NATION HEALTH SERVICES PHA'  ,  'B17'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'CHICKASAW NATION DIVISION OF HEALTH'  ,  'B07'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Choctaw Nation Healthcare'  ,  'A11'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'CIGNA MEDICAL GROUP PHARMACY'  ,  '946'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'CLEVELAND CLINIC PHARMACIES'  ,  'A45'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'CMC RX STEELE CREEK'  ,  'A66'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Coborns Inc.'  ,  '703'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Collier Drug Stores'  ,  'A84'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'COLONIAL MANAGEMENT GROUP LP'  ,  '992'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'COMMUNITY HEALTH CENTERS INC'  ,  'B23'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Community Health Systems'  ,  'A26'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'Community Independent Pharmacy Network'  ,  'A96'  ,  NULL
insert into #chainrollup select 0  ,  NULL  ,  'COMPLETE CLAIMS PROCESSING INC'  ,  'A06'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'CONCORD INC'  ,  '954'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'CONTINUCARE'  ,  'B22'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'COOK COUNTY'  ,  'B04'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'COOPHARMA'  ,  '942'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'CORAM LLC'  ,  '863'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Costco'  ,  '299'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'COUNTY OF LOS ANGELES DEPARTMENT OF'  ,  'B45'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'CRESCENT HEALTHCARE'  ,  '833'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'CRITICAL CARE SYSTEMS'  ,  '911'  ,  NULL
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  NULL  ,  '999104'
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  NULL  ,  '999818'
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  NULL  ,  '999682'
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  NULL  ,  '999690'
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  NULL  ,  '999689'
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  NULL  ,  '999688'
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  NULL  ,  'CVS1EAST'
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  NULL  ,  'CVS1WEST'
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  '177'  ,  NULL
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  '123'  ,  NULL
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  '039'  ,  NULL
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  '782'  ,  NULL
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  '608'  ,  NULL
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  '207'  ,  NULL
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  '673'  ,  NULL
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  '380'  ,  NULL
insert into #chainrollup select 0  ,  1  ,  'CVS Pharmacy'  ,  '008'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Dallas Metrocare Services'  ,  '791'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Denver Health and Hospital Authority'  ,  'A80'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'DEPT OF VETERANS AFFAIRS'  ,  '869'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'DIERBERGS PHARMACY'  ,  '332'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Discount Drug Mart'  ,  '044'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'DMVA PHARMACIES'  ,  'B15'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'DOCTORS CHOICE PHARMACIES'  ,  '713'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'DOD PHARMACO ECONOMIC CENTER'  ,  '781'  ,  NULL
insert into #chainrollup select 0  ,  NULL  ,  'DRDISPENSE'  ,  'A28'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'DSHS PHARMACIES'  ,  'A02'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Eaton Apothecary'  ,  '055'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Emblem Health'  ,  '271'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'EPIC Pharmacies'  ,  '455'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'ESKENAZI HEALTH'  ,  '689'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Essentia Health'  ,  '573'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'FAGEN PHARMACY IN'  ,  '439'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'FAIRVIEW HEALTH SERVICES'  ,  '705'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Fairview Pharmacy Services'  ,  '898'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Family Pharmacy'  ,  '511'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'FARMACIAS PLAZA'  ,  '843'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'FIRST COAST HEALTH SOLUTIONS'  ,  'B30'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Fitzgeralds'  ,  '795'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'FLORIDA HEALTH CARE PLAN INC'  ,  'B49'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Balls Food Stores'  ,  '490'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'fred''s Pharmacy'  ,  '345'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'fred''s Pharmacy'  ,  '934'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Fruth Pharmacy'  ,  '325'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'GERIMED LTC NETWORK INC'  ,  '913'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'GEROULDS PROFESSIONAL PHARMACY INC'  ,  'A58'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Giant Eagle'  ,  '248'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Giant Eagle'  ,  NULL  ,  '999650'
insert into #chainrollup select 0  ,  3  ,  'GOOD DAY PHARMACY'  ,  '997'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'GROUP HEALTH COOPERATIVE'  ,  '510'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'H AND H DRUG STORES INC'  ,  '828'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'HARMONS CITY INC'  ,  '610'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Harps Food Stores'  ,  '417'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'HARRIS COUNTY HOSPITAL DISTRICT'  ,  '963'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'HARTIG DRUG CO CORP'  ,  '087'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'HARVARD VANGUARD MEDICAL ASSOCIATES'  ,  '427'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Health Partners'  ,  '639'  ,  NULL
insert into #chainrollup select 1  ,  2  ,  'HEB Pharmacy'  ,  '025'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Henry Ford Health System'  ,  '655'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Hi-School Pharmacy'  ,  '092'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'HOME CHOICE PARTNERS INC'  ,  'A38'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'HOME SOLUTIONS'  ,  'A16'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Homeland Pharmacy'  ,  '309'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Horton & Converse'  ,  '094'  ,  NULL
insert into #chainrollup select 1  ,  2  ,  'Hy-Vee'  ,  '097'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'I.H.S.'  ,  '842'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'I.H.S.'  ,  '860'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'I.H.S.'  ,  '865'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'I.H.S.'  ,  '875'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'I.H.S.'  ,  '877'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'I.H.S.'  ,  '906'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'I.H.S.'  ,  '907'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'I.H.S.'  ,  '908'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'I.H.S.'  ,  '918'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'IHC Pharmacy Services'  ,  '695'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'INFUSION PARTNERS INC'  ,  'A03'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Ingles Market Pharmacy'  ,  '822'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'INJURY RX LLC'  ,  'A68'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'INNOVATIX NETWORK LLC'  ,  '915'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'INNOVATIX NETWORK LLC'  ,  'A00'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'INSTY MEDS'  ,  '872'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'INTEGRIS PROHEALTH PHARMACY'  ,  'B50'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'JORDAN DRUG INC'  ,  '801'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'JPS Health Outpatient Pharmacies'  ,  'B01'  ,  NULL
insert into #chainrollup select 0  ,  NULL  ,  'JRX'  ,  'A91'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'JSA HEALTHCARE CORPORATION'  ,  '887'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Kmart'  ,  '110'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'KAISER FOUNDATION HEALTH PLAN MIDAT'  ,  'A85'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'KAISER FOUNDATION HEALTH PLAN OF GE'  ,  'A27'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'KAISER PERMANENTE NCAL'  ,  '917'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'KAISER PERMANENTE SCAL'  ,  '916'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'KING KULLEN PHARMACY CORP'  ,  '280'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Kinney Drugs, Inc.'  ,  '109'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Klingensmiths Drug Stores'  ,  '499'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Knight Drugs'  ,  '379'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Kohlls Pharmacies'  ,  '481'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'KS Management Services'  ,  '635'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'K-VA-T Food Stores'  ,  '687'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'LIFECARE SOLUTIONS INC'  ,  'A15'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'LIFECHEK INC'  ,  '632'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'LIFETIME HEALTH MEDICAL GROUP PHARM'  ,  'B43'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'LINCARE INC'  ,  '977'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'LINS PHARMACY'  ,  'A86'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'LOMA LINDA UNIV MED CTR'  ,  '804'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'M K Stores, Inc. d/b/a Snyder Pharmacy'  ,  '527'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'MACEYS INC'  ,  'A64'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Manatee County Rural Health Services'  ,  '899'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Marc''s Pharmacy'  ,  '441'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'MARICOPA INTEGRATED HEALTH SYSTEM'  ,  '930'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'MARKET BASKET PHARMACIES'  ,  '544'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Marshfield clinic'  ,  '526'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Martins Supermarkets'  ,  '846'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Maxor National Pharmacy Services'  ,  '516'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'Maxor Xpress'  ,  'A72'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Mayo Clinic Health System Pharmacy and Home Medical'  ,  '847'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'MAYO CLINIC PHARMACY'  ,  'B08'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'MCHUGH'  ,  'B20'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'McKesson - Access Health'  ,  '605'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'McKesson - Access Health'  ,  '630'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'McKesson - Access Health'  ,  '841'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'MDS RX'  ,  'B10'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Med-Fast Pharmacy'  ,  '682'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'MEDICINE CHEST PHARMACIES'  ,  '924'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'MEDX SALES'  ,  'A31'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Meijer'  ,  '213'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'MEMORIAL HEALTHCARE SYSTEM PHARMACI'  ,  'B48'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'MERCY HEALTH SYSTEM RETAIL PHCY'  ,  '840'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Mercy Pharmacy'  ,  '709'  ,  NULL
insert into #chainrollup select 0  ,  4  ,  'MHA Long Term Care Network'  ,  '905'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'MULTICARE OUTPATIENT PHARMACIES'  ,  'B14'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Muscogee Creek Nation Health System'  ,  '680'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'NATIONS PHARMACEUTICALS LLC'  ,  'A19'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'NCPRX'  ,  'B13'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'NE OH NEIGHBORHOOD HEALTH SRVS'  ,  '746'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'NEIGHBORCARE PHARMACY SERVICES INC'  ,  '519'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'NEW ENGLAND HOME THERAPIES'  ,  'A25'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'NORTHSIDE PHARMACY'  ,  '770'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'NYS OFFICE OF MENTAL HEALTH'  ,  '953'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'OMHSAS BUREAU HOSP OPERATIONS DPW'  ,  '920'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'OMNICARE INC NCS HEALTHCARE LLC'  ,  '599'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Oncology Pharmacy Services'  ,  '477'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'OPTION CARE ENTERPRISES INC'  ,  '838'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'OWENS PHARMACY'  ,  'B21'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PARK NICOLLET PHARMACY'  ,  '341'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PATIENT FIRST CORPORATION'  ,  '861'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PAYLESS DRUG PHARMACY GROUP LLC'  ,  'A59'  ,  NULL
insert into #chainrollup select 0  ,  NULL  ,  'PBA HEALTH TRINET'  ,  '909'  ,  NULL
insert into #chainrollup select 0  ,  NULL  ,  'PBA HEALTH TRINET'  ,  '540'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PEOPLES PHARMACY'  ,  '757'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PHARMACA INTEGRATIVE PHARMACY'  ,  '960'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PHARMACY First - Third Party Station'  ,  '854'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PHARMACY First - Third Party Station'  ,  'A46'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PHARMACY First - Third Party Station'  ,  '866'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PHARMACY PLUS INC'  ,  '575'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PharMerica'  ,  '752'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PharMerica'  ,  '631'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PharMerica'  ,  '686'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PharMerica'  ,  '754'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PharMerica'  ,  NULL  ,  '0716211'
insert into #chainrollup select 0  ,  3  ,  'PharMerica'  ,  NULL  ,  '1567481'
insert into #chainrollup select 0  ,  3  ,  'PharMerica'  ,  NULL  ,  '2235112'
insert into #chainrollup select 0  ,  3  ,  'PharMerica'  ,  NULL  ,  '2639649'
insert into #chainrollup select 0  ,  3  ,  'PharMerica'  ,  NULL  ,  '2642494'
insert into #chainrollup select 0  ,  3  ,  'PharMerica'  ,  NULL  ,  '3727661'
insert into #chainrollup select 0  ,  3  ,  'PharMerica'  ,  NULL  ,  '4105311'
insert into #chainrollup select 0  ,  5  ,  'PHYSICIANS PHARMACEUTICAL CORP'  ,  'A83'  ,  NULL
insert into #chainrollup select 0  ,  NULL  ,  'PHYSICIANS TOTAL CARE'  ,  '727'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PILL BOX DRUGS INC'  ,  '923'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PLANNED PARENTHOOD MAR MONTE INC'  ,  'A57'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PLANNED PARENTHOOD OF GREATER OHIO'  ,  'B00'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PLANNED PARENTHOOD OF GREATER WA AN'  ,  'B57'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PLANNED PARENTHOOD OF ILLINOIS'  ,  'B59'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PLANNED PARENTHOOD OF SOUTHWESTERN'  ,  'B03'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'POC MANAGEMENT GROUP LLC'  ,  '974'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'PPOK RxSelect Network'  ,  '769'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PRESBYTERIAN MEDICAL SERVICES INC'  ,  'A12'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PRESCRIBEIT RX'  ,  '912'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'PRESCRIPTION PARTNERS'  ,  '952'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Price Chopper Supermarkets'  ,  '434'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PRICE CUTTER PHARMACY'  ,  '701'  ,  NULL
insert into #chainrollup select 0  ,  NULL  ,  'PROCLAIM PHYSICIAN SERVICES'  ,  'A77'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PROF SPECIALIZED PHARMACIES LLC'  ,  '824'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PROFESSIONAL PHARMACY SERVICES INC'  ,  '480'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'PROGRESSIVE PHARMACIES LLC'  ,  '979'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'PUBLIC HEALTH TRUST OF DADE COUNTY'  ,  'A67'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Publix'  ,  '302'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'QCP NETWORX'  ,  'B40'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Genoa, a QoL Healthcare Company '  ,  '945'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Quick Chek Food Stores'  ,  '267'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'QVL PHARMACY HOLDINGS INC'  ,  '858'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Raleys/Bel Air Pharmacies'  ,  '171'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'REASOR'  ,  'B27'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'Recept Pharmacy'  ,  '891'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'RECEPT PHARMACY LP'  ,  'A50'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Red Cross Pharmacy'  ,  '743'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Redners Markets'  ,  '852'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Humana Pharmacy'  ,  'A71'  ,  NULL
insert into #chainrollup select 0  ,  1  ,  'Rite Aid'  ,  '181'  ,  NULL
insert into #chainrollup select 0  ,  1  ,  'Rite Aid'  ,  '045'  ,  NULL
insert into #chainrollup select 0  ,  1  ,  'Rite Aid'  ,  '056'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Ritzman Pharmacy Inc'  ,  '424'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Rural Healthcare Inc. '  ,  '935'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'SAINT JOSEPH MERCY PHARMACY'  ,  '520'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'SAMS CLUB'  ,  'C11'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'SANTA CLARA VALLEY HEALTH AND HOSPI'  ,  'A37'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Save Mart Supermarkets'  ,  '310'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2378366'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2310009'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2356283'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2333095'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2342638'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2307191'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2371069'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2368252'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2344163'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2360028'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2363137'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2366993'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2344593'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2350899'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2364696'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2307610'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2354126'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2372643'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2366626'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2338689'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2353403'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2319615'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2310770'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2344745'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2370182'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2310732'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2345696'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2336887'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2303888'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2354734'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2317849'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2366157'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2310100'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2347830'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2354570'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2303903'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2331469'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2353439'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2353427'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2353441'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2353453'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2320923'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2363000'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2363238'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2368327'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2380602'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2344620'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2360701'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2330102'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2308054'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2110182'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2103199'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2310667'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2332473'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2317685'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0905010'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2323715'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2313031'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2324983'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2701969'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3428047'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5729744'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5120972'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3681841'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3681093'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3678882'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3683009'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5647358'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '1015709'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2312623'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0202135'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0202628'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0202604'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0202173'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '1034432'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5055757'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3422855'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0714837'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5914141'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5903314'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5918733'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '4589341'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5920891'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '1165718'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3941158'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3945194'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3993032'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3996660'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '6000929'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3915305'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '6004713'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5728677'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5920752'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0228608'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5654721'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '6001894'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0723785'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '1490678'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5713183'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '1490767'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5727776'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5728069'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5728071'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5656838'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5728083'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '6002911'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5728362'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5728348'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5728350'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5728336'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5728374'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5657599'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '1565021'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2991099'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '2991950'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5659858'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3729538'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3729639'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0360951'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0361042'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0361054'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5622881'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5640378'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5628017'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '1720069'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0135144'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5636711'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '1240946'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '1934036'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5630442'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5133789'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '1565069'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '6000880'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '6000878'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '0355936'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3990769'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '3995428'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5720734'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '1566073'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '1931876'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5653767'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '4446793'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5723475'
insert into #chainrollup select 0  ,  3  ,  'Sav-Mor Drug Stores'  ,  NULL  ,  '5728728'
insert into #chainrollup select 0  ,  3  ,  'Schnuck Markets, Inc.'  ,  '133'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Seip Drug LLC'  ,  '968'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Shopko'  ,  '246'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Shopko'  ,  NULL  ,  '999974'
insert into #chainrollup select 0  ,  2  ,  'Shopko'  ,  NULL  ,  '999957'
insert into #chainrollup select 0  ,  2  ,  'Wakefern'  ,  'A33'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Wakefern'  ,  '197'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Wakefern'  ,  '613'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Wakefern'  ,  '618'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Wakefern'  ,  '619'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Wakefern'  ,  '620'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Wakefern'  ,  '621'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Wakefern'  ,  '622'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Wakefern'  ,  '640'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Wakefern'  ,  '894'  ,  NULL
insert into #chainrollup select 0  ,  NULL  ,  'SMART ID WORKS LLC'  ,  'A75'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Southeastern Grocers'  ,  '315'  ,  NULL
insert into #chainrollup select 0  ,  2  ,  'Southeastern Grocers'  ,  '292'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  '320'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2305274'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2311924'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2312952'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2317344'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2342703'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2342979'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2343452'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2344137'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2345456'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2347359'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2348527'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2352526'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2353340'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2354277'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2354316'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2355281'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2355534'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2361056'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2362729'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2363339'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2364177'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2364292'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2364381'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2365460'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2365939'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2366246'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2368973'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2368985'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2368997'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369002'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369014'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369026'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369038'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369040'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369052'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369064'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369076'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369088'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369280'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369696'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369711'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369723'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369735'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369747'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369759'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2369761'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2371110'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2372047'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2372059'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2372061'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2372073'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2372085'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2372097'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2372100'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2372112'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2372124'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2372150'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2372477'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2372934'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2373633'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2375839'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2377441'
insert into #chainrollup select 0  ,  3  ,  'SpartanNash'  ,  NULL  ,  '2378203'
insert into #chainrollup select 0  ,  3  ,  'STAR DISCOUNT PHARMACY INC'  ,  '998'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'STONER DRUG CO'  ,  '943'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'SUNCOAST COMMUNITY HEALTH CENTERS I'  ,  'B41'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'SUPERVALU'  ,  '410'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'SUPERVALU'  ,  '285'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'SWIFT RX LLC'  ,  'A74'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Tampa Family Health Centers'  ,  'A24'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'TEMPEST MED'  ,  'A79'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  '108'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  '113'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  '199'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  '273'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  '043'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  '495'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  '069'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  '071'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  '817'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  '602'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  'A65'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  'B67'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  NULL  ,  '999546'
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  NULL  ,  '999548'
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  NULL  ,  '999549'
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  NULL  ,  '999667'
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  NULL  ,  '999668'
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  NULL  ,  '999670'
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  NULL  ,  '999671'
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  NULL  ,  '999672'
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  NULL  ,  '999673'
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  NULL  ,  '999674'
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  NULL  ,  '999669'
insert into #chainrollup select 1  ,  1  ,  'The Kroger Co.'  ,  NULL  ,  '999317'
insert into #chainrollup select 0  ,  3  ,  'THE METROHEALTH SYSTEM PHARMACY'  ,  'B61'  ,  NULL
insert into #chainrollup select 1  ,  3  ,  'Thrifty White Pharmacy'  ,  '216'  ,  NULL
insert into #chainrollup select 1  ,  3  ,  'Thrifty White Pharmacy'  ,  NULL  ,  '999656'
insert into #chainrollup select 0  ,  3  ,  'Times Supermarket'  ,  '372'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'TN MENTAL HLTH AND DEV DISABILITIES'  ,  '921'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Tops Markets, LLC'  ,  '978'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'TriHealth'  ,  '900'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'U SAVE PHARMACY'  ,  '808'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'UCDHS PHARMACIES'  ,  'B12'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'UCSD Medical Center Pharmacies'  ,  '715'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Univ of Missouri Hosp and Clinic'  ,  '691'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'University of Kansas Hospital Pharmacy'  ,  'A87'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'University of Utah Hospital'  ,  '744'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'UofV Virginia Medical Centers'  ,  'A98'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'US BIOSERVICES CORPORATION'  ,  '758'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'UW HEALTH PHARMACY SERVICES'  ,  '700'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'VA DMHMRSAS'  ,  '914'  ,  NULL
insert into #chainrollup select 0  ,  5  ,  'VANTAGE RX DISPENSING SERVICES LLC'  ,  '989'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Virginia Commenealth University Hospital'  ,  '696'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'VIRGINIA MASON MEDICAL CTR'  ,  '654'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Walgreens Co. '  ,  '226'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Walgreens Co. '  ,  'A10'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Walgreens Co. '  ,  'A13'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Walmart'  ,  '229'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Walmart Stores Inc'  ,  '229'  ,  NULL
insert into #chainrollup select 1  ,  1  ,  'Walmart Stores Inc'  ,  'C11'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'WALTER LAGESTEE INCORPORATED'  ,  'A97'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'WEBER AND JUDD COMPANY INC'  ,  '649'  ,  NULL
insert into #chainrollup select 1  ,  3  ,  'Wegmans Food Markets, Inc'  ,  '256'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Weis Markets'  ,  '232'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'Yakima Valley Farm Workers Clinic'  ,  '987'  ,  NULL
insert into #chainrollup select 0  ,  3  ,  'YOKES FOODS INC'  ,  '534'  ,  NULL
insert into #chainrollup select NULL ,  NULL,   'PPOK TRINET'    ,   '540'   ,   NULL
insert into #chainrollup select NULL ,  NULL,   'PPOK TRINET'    ,   '909'   ,   NULL
insert into #chainrollup select NULL ,  NULL,   'PPOK TRINET'    ,   'B50'   ,   NULL
insert into #chainrollup select NULL ,  NULL,   'PPOK TRINET'    ,   '769'   ,   NULL






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
       join outcomesMTM.dbo.chain c on c.chainCode = cr.RelationshipID 
       join outcomesMTM.dbo.pharmacychain pc on pc.chainid = c.chainid
       join outcomesMTM.dbo.pharmacy p on p.centerid = pc.centerid
       where 1=1

),
ph as (

       select cr.[Organization Name], p.centerid, p.NCPDP_NABP
       from #chainRollUp cr
       join outcomesMTM.dbo.pharmacy p on p.NCPDP_NABP = cr.NABP
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

-----------------------------------------------------------------------------------------------------------

----------------------------------------------



select o.orgID
, oc.CenterCount
, o.[Organization Name]
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
from #org o
left join (

	select o.orgID, count(distinct oc.centerID) as [CenterCount]
	from #org2Center oc
	join #org o on o.orgID = oc.orgID
	where 1=1
	group by o.orgID

) oc on oc.orgID = o.orgID
left join (

		select o.orgID
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
		from (	
			select row_number() over (partition by oc.orgID, tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
			, tacr.centerid
			, oc.orgID
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
			from outcomesMTM.dbo.tipActivityCenterReport tacr
			join #org2Center oc on oc.centerid = tacr.centerID
			where 1=1
			and tacr.policyid not in (574, 575, 298)
			and tacr.primaryPharmacy = 1 
			and tacr.activethru >= @BEGIN
			and tacr.activeasof <= @END
		   	AND ((tacr.activethru <= @END AND (tacr.[completed tips] = 1 or tacr.[unfinished tips] = 1 or tacr.[review/resubmit tips] = 1 or tacr.[rejected tips] = 1)) 
			OR datediff(day, case when tacr.activeasof > @BEGIN then tacr.activeasof else @BEGIN end, case when tacr.activethru > @END then @END else tacr.activethru end) > 30)
		) ta
		join #org o on o.orgID = ta.orgID
		where 1=1
		and ta.Rank = 1
		group by o.orgID

) t1 on t1.orgID = o.orgID
left join (

		select --u.centerID	
		 u.orgID				
		, count(distinct u.PatientID) as CMROpportunity
		, sum(u.CMROffered) as CMROffered				
		, sum(u.CMRCompleted) as completedCMRs
		, case when count(distinct u.PatientID) = 0 then 0 else cast((cast(sum(u.CMROffered) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,2)) end as percentCMRoffered
		, case when sum(u.CMROffered) = 0 then 0 else cast((cast(sum(u.CMRCompleted) as decimal))/(cast(sum(u.CMROffered) as decimal)) as decimal(5,2)) end as percentCMRcompletion
		, case when count(distinct u.PatientID) = 0 then 0 else cast((cast(sum(u.CMRCompleted) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,2)) end as [CMRNetEffectiveRate]	
	    --, case when count(distinct u.PatientID) = 0 or sum(u.CMROffered) = 0 then 0 else (cast((cast(sum(u.CMRCompleted) as decimal))/(cast(sum(u.CMROffered) as decimal)) as decimal(5,2)) *	cast((cast(sum(u.CMROffered) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,2))) end as [CMRNetEffectiveRate]	
		from (
			 select row_number() over (partition by rp.patientID, oc.orgID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
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
            from vw_CMRActivityReport rp
			join #org2Center oc on oc.centerid = rp.centerid
            join patientDim pd on pd.patientKey = rp.patientKey
            join policy p on p.policyID = rp.policyID
            join pharmacy ph on ph.centerID = rp.centerID
            left join chain c on c.chainID = rp.chainID
            
            where 1=1
            AND isNull(rp.activethru, '99991231') >= @BEGIN
            AND rp.activeasof <= @END
			and rp.primaryPharmacy = 1 
                --30 day include
                AND (
                        (rp.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, @END) >= 30)
                        OR
                        (rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, CASE WHEN rp.activethru > @END THEN @END ELSE rp.activethru END) >= 30)
                        OR
                        (rp.mtmServiceDT BETWEEN @BEGIN AND @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6))
                        AND
                        (rp.claimcenterID = rp.centerid)
                    )
		) u
		where 1 = 1
		and u.rank = 1
		group by orgID	

) c1 on c1.orgID = o.orgID
left join (		

		select oc.orgID, count(distinct pt.patientID) as [EligiblePatient]
		from outcomesMTM.dbo.patientMTMCenterDim pm
		join #org2Center oc on oc.centerid = pm.centerid
		join (

			select distinct pt.patientID
			--select count(distinct pt.patientID)
			from outcomesMTM.dbo.patientDim pt
			where 1=1
			and isnull(pt.activethru, '99991231') >= @BEGIN
			and pt.policyid not in (574 ,575 ,298)
			and pt.activeasof <= @END

		) pt on pt.patientID = pm.patientid
		where 1=1
		and isnull(pm.activethru, '99991231') >= @BEGIN
		and pm.activeasof <= @END
		group by oc.orgID

) p1 on p1.orgID = o.orgID
left join (

		select v.orgID
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
		from (
			select c.claimID
			, oc.orgID
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
			from outcomesMTM.dbo.ClaimActivityReport c
			join #org2Center oc on oc.NCPDP_NABP = c.[MTM CenterID]
			where 1=1
			and c.mtmServiceDT between @BEGIN and @END
			and c.statusID not in (3,5)
			and c.policyID not in (574 ,575 ,298)
		) v
		where 1=1
		group by v.orgID

) r1 on r1.orgID = o.orgID
where 1=1
order by o.orgID



end








