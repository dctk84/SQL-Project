
---------------------------------------------------------------Remove column1, Unnamed_0---------------------------------------------------------------
ALTER TABLE FactSwap
DROP COLUMN column1, Unnamed_0;

---------------------------------------------------------------Create DimWallets table---------------------------------------------------------------
WITH Result AS 
	(SELECT *,
		ROW_NUMBER () OVER (PARTITION BY WalletsAddress ORDER BY OS) AS sq_num
	FROM 
		FactSwap)
SELECT
	WalletsAddress AS [WalletsAddress],
	platform AS [Platform],
	country_code AS [CountriesCode],
	os AS [OS]
INTO 
	DimWallets
FROM 
	Result
WHERE
	sq_num = 1;

-- Set Primary Key of DimWallets
ALTER TABLE DimWallets
ALTER COLUMN WalletsAddress int NOT NULL;

ALTER TABLE DimWallets
ADD CONSTRAINT dim_wallets_pk PRIMARY KEY (WalletsAddress);

--------------------------------------------------------------- Create DimCountries Table ---------------------------------------------------------------
SELECT DISTINCT 
	country_code AS [CountriesCode],
	country AS [Country],
	latitude_average AS [LatitudeAverage],
	longtitude_average AS [LongtitudeAverage]
INTO
	[DimCountries]
FROM 
	FactSwap;

-- Set Primary Key of Countries 
ALTER TABLE DimCountries
ALTER COLUMN CountriesCode nvarchar(50) NOT NULL;

ALTER TABLE DimCountries
ADD CONSTRAINT dim_countries_pk PRIMARY KEY (CountriesCode);

--------------------------------------------------------------- Create DimTokens Table ---------------------------------------------------------------
WITH Source AS 
	(SELECT 
		SourceToken, 
		source_kind,
		source_anchor
	FROM
		FactSwap),
Dest AS
	(SELECT
		DestToken,
		dest_kind,
		dest_anchor
	FROM
		FactSwap),
UnionTable AS 
	(SELECT 
		SourceToken AS TokensID, 
		source_kind AS TokensKind, 
		source_anchor AS TokensAnchor 
	FROM 
		Source
UNION
	SELECT * FROM Dest)
SELECT *
INTO DimTokens
FROM UnionTable;

 -- Set Primary Key of DimTokens
 ALTER TABLE DimTokens
 ALTER COLUMN TokensID int NOT NULL;

 ALTER TABLE DimTokens
 ADD CONSTRAINT pk_dim_tokens PRIMARY KEY (TokensID);

--------------------------------------------------------------- Create Date Table ---------------------------------------------------------------
SELECT DISTINCT
	Date AS DateKey,
	DAY(Date) AS Day,
	MONTH(Date) AS Month,
	YEAR(Date) AS Year,
	CASE	
		WHEN DatePART(DW, Date) = 1 THEN 'Sunday'
		WHEN DatePART(DW, Date) = 2 THEN 'Monday'
		WHEN DatePART(DW, Date) = 3 THEN 'Tuesday'
		WHEN DatePART(DW, Date) = 4 THEN 'Wednesday'
		WHEN DatePART(DW, Date) = 5 THEN 'Thursday'
		WHEN DatePART(DW, Date) = 6 THEN 'Friday'
		WHEN DatePART(DW, Date) = 7 THEN 'Saturday'
	END AS Weekday
INTO DimDate
FROM FactSwap;

---- Set Primary Key of DimDate
ALTER TABLE DimDate
ALTER COLUMN DateKey Date NOT NULL;

ALTER TABLE DimDate
ADD CONSTRAINT pk_dim_Date PRIMARY KEY (DateKey);

--------------------------------------------------------------- Create FactPrice ---------------------------------------------------------------
WITH SourceToken AS
	(SELECT DISTINCT 
		SourceToken AS TokensID,
		Date AS DateKey,
		source_price AS Price
	FROM
		FactSwap),
DestToken AS
	(SELECT DISTINCT
		DestToken AS TokensID,
		Date AS DateKey,
		dest_price AS Price
	FROM 
		FactSwap),
UnionTable1 AS
	(SELECT DISTINCT
		TokensID,
		DateKey,
		Price
	FROM
		SourceToken
	UNION
	SELECT DISTINCT
		TokensID,
		DateKey,
		Price
	FROM
		DestToken)
SELECT 
	TokensID,
	DateKey,
	AVG(Price) AS Price
INTO
	FactPrice
FROM
	UnionTable1
GROUP BY
	TokensID,
	DateKey;

-- Set Primary Key of FactPrice
ALTER TABLE FactPrice
ALTER COLUMN DateKey Date NOT NULL;

ALTER TABLE FactPrice
ALTER COLUMN TokensID int NOT NULL;

ALTER TABLE FactPrice
ADD CONSTRAINT fact_price_pk PRIMARY KEY (TokensID, DateKey);

--------------------------------------------------------------- Modify Swap Table ---------------------------------------------------------------
ALTER TABLE FactSwap
DROP COLUMN source_price,dest_price,latitude_average, longitude_average,country,source_anchor,dest_anchor,source_kind,dest_kind,os,country_code, platform;

ALTER TABLE FactSwap
ADD Fees AS Volume*0.02;

------------------------------------------------ Set Foreign Key connect FactSwap to DimWallets --------------------------------------------------------------------
ALTER TABLE FactSwap
ADD CONSTRAINT fk_fact_swap_dim_wallet Foreign Key (WalletsAddress) REFERENCES DimWallets (WalletsAddress);

------------------------------------------------ Set Foreign Key connect FactSwap to DimTokens ----------------------------------------------------
ALTER TABLE FactSwap
ADD CONSTRAINT fk_fact_swap_dim_token1 Foreign Key (SourceToken) REFERENCES DimTokens (TokensID);

ALTER TABLE FactSwap
ADD CONSTRAINT fk_fact_swap_dim_token2 Foreign Key (DestToken) REFERENCES DimTokens (TokensID);

------------------------------------------------ Set Foreign Key connect FactSwap to DimDate ----------------------------------------------------
ALTER TABLE FactSwap
ADD CONSTRAINT fk_fact_swap_dim_date Foreign Key (Date) REFERENCES DimDate (DateKey);

------------------------------------------------ Set Foreign Key connect FactPrice to DimTokens ----------------------------------------------------
ALTER TABLE FactPrice
ADD CONSTRAINT fk_fact_price_dim_token Foreign Key (TokensID) REFERENCES DimTokens (TokensID);

------------------------------------------------ Set Foreign Key connect FactPrice to DimDate ----------------------------------------------------
ALTER TABLE FactPrice
ADD CONSTRAINT fk_fact_price_dim_date Foreign Key (DateKey) REFERENCES DimDate (DateKey);

------------------------------------------------ Set Foreign Key connect DimWallets to DimCountries ----------------------------------------------------
ALTER TABLE DimWallets
ADD CONSTRAINT fk_dim_wallets_dim_countries Foreign Key (CountriesCode) REFERENCES DimCountries (CountriesCode);

------------------------------------------------ Do requirments ----------------------------------------------------------------------------------------
SELECT * FROM FactPrice;



