--dbo.MFLScores table contains every Monster Football League (MFL) Scores
--One column from the Excel file contains the date of the game, Winning team, and the losing team all combined.

SELECT TOP 5 *
FROM MFLScores

--We will create 3 new fields in the table to sepearate that information

ALTER TABLE projectportfolio.dbo.MFLScores
ADD GameYear INT;

ALTER TABLE dbo.MFLScores
ADD WinningTeam NVarchar(255);

ALTER TABLE dbo.MFLScores
ADD LosingTeam NVarchar(255);

--Finding and updating the WinningTeam column from the LastGame column
SELECT
 SUBSTRING(LastGame, 1, CHARINDEX(' vs. ', LastGame) - 1) AS WinningTeam
FROM MFLScores;

UPDATE MFLScores
SET WinningTeam = SUBSTRING(LastGame, 1, CHARINDEX(' vs. ', LastGame) - 1)

--Finding and updating the LosingTeam column from the LastGame column
SELECT
SUBSTRING(LastGame, CHARINDEX(' vs. ', LastGame) + 5, CHARINDEX(', ', LastGame) - (CHARINDEX(' vs. ', LastGame) + 5)) AS LosingTeam
FROM MFLScores

UPDATE MFLScores
SET LosingTeam = SUBSTRING(LastGame, CHARINDEX(' vs. ', LastGame) + 5, CHARINDEX(', ', LastGame) - (CHARINDEX(' vs. ', LastGame) + 5))

SELECT YEAR(CONVERT(DATE, SUBSTRING(LastGame, CHARINDEX(', ', LastGame) + 2, LEN(LastGame)), 107)) AS GameYear
FROM projectportfolio.dbo.MFLScores;


UPDATE projectportfolio.dbo.MFLScores
SET GameYear = YEAR(CONVERT(DATE, SUBSTRING(LastGame, CHARINDEX(', ', LastGame) + 2, LEN(LastGame)), 107))

--Checking the data to ensure the new fields are correct. Also sorting by the latest GameDate
SELECT *
FROM projectportfolio.dbo.MFLScores
ORDER BY GameYear DESC



--I need to create a new table with Team Demographics in order to perform some Joins
CREATE TABLE projectportfolio.dbo.TeamDemographics (
    Code VARCHAR(3) PRIMARY KEY,
    City VARCHAR(255),
    Name VARCHAR(255),
    State VARCHAR(2),
    Conference VARCHAR(4)
   
);

--This inserts all 24 teams into the TeamDemographics table
Insert into TeamDemographics VALUES 
('NYK', 'New York', 'Krakens', 'NY', 'East'),
('CHC', 'Chicago', 'Chupacabras', 'IL', 'East'),
('LAL', 'Los Angeles', 'Lycans', 'CA', 'West'),
('SFS', 'San Francisco', 'Specters', 'CA', 'West'),
('MIM', 'Miami', 'Mummies', 'FL', 'East'),
('DAD', 'Dallas', 'Dragons', 'TX', 'West'),
('SES', 'Seattle', 'Sasquatches', 'WA', 'West'),
('DED', 'Denver', 'Doppelgangers', 'CO', 'West'),
('BOB', 'Boston', 'Banshees', 'MA', 'East'),
('PHP', 'Philadelphia', 'Phantoms', 'PA', 'East'),
('NON', 'New Orleans', 'Nightcrawlers', 'LA', 'East'),
('LVV', 'Las Vegas', 'Vampires', 'NV', 'West'),
('ATG', 'Atlanta', 'Gargoyles', 'GA', 'East'),
('HOH', 'Houston', 'Harpies', 'TX', 'West'),
('DEW', 'Detroit', 'Wendigos', 'MI', 'East'),
('PHX', 'Phoenix', 'Phoenixes', 'AZ', 'West'),
('NAN', 'Nashville', 'Nymphs', 'TN', 'East'),
('SDS', 'San Diego', 'Sirens', 'CA', 'West'),
('POP', 'Portland', 'Poltergeists', 'OR', 'West'),
('BAB', 'Baltimore', 'Basilisks', 'MD', 'East'),
('MPM', 'Minneapolis', 'Minotaurs', 'MN', 'West'),
('ORO', 'Orlando', 'Orcs', 'FL', 'East'),
('AUA', 'Austin', 'Abominables', 'TX', 'East'),
('STS', 'St Louis', 'Strigas', 'MO', 'West');

Select * 
FROM dbo.TeamDemographics
Order BY Conference,
		 Code

--To make joins easier, I will also add a column in the TeamDemographics table that combines city and name.
ALTER TABLE dbo.TeamDemographics
ADD FullTeamName NVarchar(255);

SELECT CONCAT(City, ' ',Name)
FROM dbo.TeamDemographics

UPDATE dbo.TeamDemographics
SET FullTeamName = CONCAT(City, ' ',Name)



SELECT a.*, b.Code
FROM dbo.MFLScores a
LEFT JOIN dbo.TeamDemographics b
ON a.WinningTeam = b.FullTeamName
WHERE b.code is NULL

--Some teams are missing a code since their name doesn't match the current team name.
--I will create 2 new fields in the MFLScores table as WinningTeamCode and LosingTeamCode to help with joins 
ALTER TABLE dbo.MFLScores
ADD WinningTeamCode NVarchar(3);

ALTER TABLE dbo.MFLScores
ADD LosingTeamCode NVarchar(3);

--I will need to update the WinningTeamCode to equal the TeamDemographicsCode where MFLScores.WinningTeam = FullTeamName from the TeamDemographics table
UPDATE MFLScores
SET MFLScores.WinningTeamCode = TeamDemographics.Code
FROM dbo.MFLScores
JOIN dbo.TeamDemographics
ON MFLScores.WinningTeam = TeamDemographics.FullTeamName

SELECT * 
FROM MFLScores

UPDATE MFLScores
SET MFLScores.LosingTeamCode = TeamDemographics.Code
FROM dbo.MFLScores
JOIN dbo.TeamDemographics
ON MFLScores.LosingTeam = TeamDemographics.FullTeamName

--I will need to find the missing winning team codes and assign them a value to match the modern team names.
SELECT DISTINCT(WinningTEAM), WinningTeamCode
FROM MFLScores
WHERE WinningTeamCode is Null
ORDER BY WinningTeam

--Updating WinningTeamCodes to be associated with their modern team names.
UPDATE dbo.MFLScores
SET WinningTeamCode = 
    CASE 
        WHEN WinningTeam = 'Los Angeles Strigas' THEN 'STS'
        WHEN WinningTeam = 'Tennessee Harpies' THEN 'HOH'
        ELSE WinningTeamCode -- Keep the original value for other cases
    END
WHERE WinningTeam IN ('Los Angeles Strigas', 'Tennessee Harpies');

SELECT DISTINCT(WinningTeam), WinningTeamCode
FROM MFLScores
WHERE WinningTeamCode IN ('STS','HOH')


--Doing the same for LosingTeam
SELECT DISTINCT(LosingTeam), LosingTeamCode
FROM MFLScores
WHERE LosingTeamCode is Null
ORDER BY LosingTeam

UPDATE dbo.MFLScores
SET LosingTeamCode = 
    CASE 
        WHEN LosingTeam = 'Los Angeles Strigas' THEN 'STS'
        WHEN LosingTeam = 'Tennessee Harpies' THEN 'HOH'
        ELSE LosingTeamCode -- Keep the original value for other cases
    END
WHERE LosingTeam IN ('Los Angeles Strigas', 'Tennessee Harpies');

SELECT DISTINCT(LosingTeam), LosingTeamCode
FROM MFLScores
WHERE LosingTeamCode IN ('STS','HOH')

--Created TotalScore calculated column to find highest scoring game
Select WinningTeam, LosingTeam, GameYear, PtsW, PtsL,(PtsW + PtsL) AS TotalScore
FROM MFLScores
Order By TotalScore DESC

--Created PointDifferential calculated column to find the biggest blowout game
Select TOP 1 WinningTeam, LosingTeam, GameYear, PtsW, PtsL, (PtsW - PtsL) AS PointDifferential
FROM MFLScores
Order By PointDifferential DESC

--Using a CTE to see all games that ended in a tie
WITH PointDifferentialCTE AS (
    SELECT WinningTeam, LosingTeam, GameYear, PtsW, PtsL, (PtsW - PtsL) AS PointDifferential
    FROM MFLScores
)
SELECT *
FROM PointDifferentialCTE
WHERE PointDifferential = 0
ORDER BY GameYear DESC

--Creating a query to show total wins and losses WinLossRatio to be used in our visualization tools
SELECT *,
      CAST(((Wins * 1.0) / NULLIF((Wins + Losses), 0) * 100) AS DECIMAL(10, 3)) AS WinLossRatio
FROM (
    SELECT
        t.Code AS TeamCode,
        t.City AS TeamCity,
        t.Name AS TeamName,
        t.State AS TeamState,
        t.Conference AS TeamConference,
		n.GameYear,
        COUNT(CASE WHEN t.Code = n.WinningTeamCode THEN 1 END) AS Wins,
        COUNT(CASE WHEN t.Code = n.LosingTeamCode THEN 1 END) AS Losses
    FROM dbo.TeamDemographics t
    LEFT JOIN dbo.MFLScores n ON t.Code = n.WinningTeamCode OR t.Code = n.LosingTeamCode
    GROUP BY
        t.Code, t.City, t.Name, t.State, t.Conference, n.Gameyear
) AS Subquery
ORDER BY GameYear, WinLossRatio DESC;

--Now I will assign a ranking for the 2022 season to determine the top 5 teams from each conference.
--I will also add point differential to calculate point differential as a tie breaker.
SELECT *,
      CAST(((Wins * 1.0) / NULLIF((Wins + Losses), 0) * 100) AS DECIMAL(10, 3)) AS WinLossRatio,
	  ROW_NUMBER() OVER (PARTITION BY TeamConference, GameYear ORDER BY Wins DESC, PointDifferential DESC) AS ConferenceRank	  
FROM (
    SELECT
        t.Code AS TeamCode,
        t.City AS TeamCity,
        t.Name AS TeamName,
        t.State AS TeamState,
        t.Conference AS TeamConference,
		n.GameYear,
        COUNT(CASE WHEN t.Code = n.WinningTeamCode THEN 1 END) AS Wins,
        COUNT(CASE WHEN t.Code = n.LosingTeamCode THEN 1 END) AS Losses,
		SUM(CASE WHEN t.code = n.WinningTEAMCode THEN n.ptsw END) + SUM(CASE WHEN t.code = n.LosingTEAMCode THEN n.ptsl END) AS PointsScored,
		SUM(CASE WHEN t.code = n.WinningTEAMCode THEN n.ptsl END) + SUM(CASE WHEN t.code = n.LosingTEAMCode THEN n.ptsw END) AS PointsAllowed,
		(SUM(CASE WHEN t.code = n.WinningTEAMCode THEN n.ptsw END) + SUM(CASE WHEN t.code = n.LosingTEAMCode THEN n.ptsl END))
		-(SUM(CASE WHEN t.code = n.WinningTEAMCode THEN n.ptsl END) + SUM(CASE WHEN t.code = n.LosingTEAMCode THEN n.ptsw END)) AS PointDifferential
    FROM dbo.TeamDemographics t
    LEFT JOIN dbo.MFLScores n ON t.Code = n.WinningTeamCode OR t.Code = n.LosingTeamCode
	WHERE GameYear = 2022
    GROUP BY
        t.Code, t.City, t.Name, t.State, t.Conference, n.Gameyear
) AS Subquery

ORDER BY TeamConference;

--The Baltimore Basilisks and Orlando Orcs are tied at wins and point differential for the last spot in the east.
--I will check on any head to head matchups to determine a winner.

SELECT *
FROM dbo.MFLScores
WHERE
    (WinningTeam = 'Baltimore Basilisks' OR WinningTeam = 'Orlando Orcs')
    AND
    (LosingTeam = 'Baltimore Basilisks' OR LosingTeam = 'Orlando Orcs')
	AND Gameyear = 2022;


Select * 
FROM projectportfolio.dbo.MFLScores
WHERE GameYear = 2022
Order By 








