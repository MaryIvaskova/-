USE BowlingLeague;
GO

--------------------------------------------------------------
-- 1) Прізвища трьох капітанів, чиї команди виграли найбільше матчів
--------------------------------------------------------------
SELECT 'Завдання 1 – Три капітани з найбільшою кількістю виграних матчів' AS [Завдання];
WITH GameWins AS (
  SELECT mg.MatchID, mg.WinningTeamID, COUNT(*) AS GamesWon
  FROM Match_Games mg
  GROUP BY mg.MatchID, mg.WinningTeamID
),
MatchWinner AS (
  SELECT gw.MatchID,
         gw.WinningTeamID AS TeamID
  FROM GameWins gw
  WHERE gw.GamesWon = (
    SELECT MAX(gw2.GamesWon) FROM GameWins gw2 WHERE gw2.MatchID = gw.MatchID
  )
)
SELECT TOP 3 b.BowlerLastName AS CaptainLastName, COUNT(*) AS MatchWins
FROM MatchWinner mw
JOIN Teams t     ON t.TeamID = mw.TeamID
JOIN Bowlers b   ON b.BowlerID = t.CaptainID
GROUP BY b.BowlerLastName
ORDER BY MatchWins DESC, CaptainLastName;
GO


--------------------------------------------------------------
-- 2) Який номер доріжки «приносить перемогу» — парний чи непарний
--------------------------------------------------------------
SELECT 'Завдання 2 – Який тип доріжки приносить перемогу (парна/непарна)' AS [Завдання];
WITH GameWins AS (
  SELECT mg.MatchID, mg.WinningTeamID, COUNT(*) AS GamesWon
  FROM Match_Games mg
  GROUP BY mg.MatchID, mg.WinningTeamID
),
MatchWinner AS (
  SELECT gw.MatchID,
         gw.WinningTeamID AS TeamID
  FROM GameWins gw
  WHERE gw.GamesWon = (
    SELECT MAX(gw2.GamesWon) FROM GameWins gw2 WHERE gw2.MatchID = gw.MatchID
  )
)
SELECT CASE WHEN mw.TeamID = tm.OddLaneTeamID THEN 'Непарна'
            WHEN mw.TeamID = tm.EvenLaneTeamID THEN 'Парна'
       END AS LaneParity,
       COUNT(*) AS MatchWins
FROM MatchWinner mw
JOIN Tourney_Matches tm ON tm.MatchID = mw.MatchID
GROUP BY CASE WHEN mw.TeamID = tm.OddLaneTeamID THEN 'Непарна'
              WHEN mw.TeamID = tm.EvenLaneTeamID THEN 'Парна' END
ORDER BY MatchWins DESC;
GO


--------------------------------------------------------------
-- 3) Дати турнірів, у яких перемогла команда «Marlins»
--------------------------------------------------------------
SELECT 'Завдання 3 – Турніри, де перемогла команда Marlins' AS [Завдання];
WITH GameWins AS (
  SELECT mg.MatchID, mg.WinningTeamID, COUNT(*) AS GamesWon
  FROM Match_Games mg
  GROUP BY mg.MatchID, mg.WinningTeamID
),
MatchWinner AS (
  SELECT gw.MatchID,
         gw.WinningTeamID AS TeamID
  FROM GameWins gw
  WHERE gw.GamesWon = (
    SELECT MAX(gw2.GamesWon) FROM GameWins gw2 WHERE gw2.MatchID = gw.MatchID
  )
),
TournamentTeamWins AS (
  SELECT tm.TourneyID, mw.TeamID, COUNT(*) AS MatchWinsInTourney
  FROM MatchWinner mw
  JOIN Tourney_Matches tm ON tm.MatchID = mw.MatchID
  GROUP BY tm.TourneyID, mw.TeamID
),
TournamentChampion AS (
  SELECT ttw.TourneyID, ttw.TeamID, ttw.MatchWinsInTourney,
         RANK() OVER (PARTITION BY ttw.TourneyID ORDER BY ttw.MatchWinsInTourney DESC) AS rnk
  FROM TournamentTeamWins ttw
)
SELECT t.TourneyDate, t.TourneyLocation
FROM TournamentChampion tc
JOIN Teams x ON x.TeamID = tc.TeamID
JOIN Tournaments t ON t.TourneyID = tc.TourneyID
WHERE tc.rnk = 1
  AND x.TeamName = 'Marlins'
ORDER BY t.TourneyDate DESC;
GO


--------------------------------------------------------------
-- 4) Рейтинг гравців: TotalScore / GamesBowled порівняти з CurrentAverage
--------------------------------------------------------------
SELECT 'Завдання 4 – Рейтинг гравців і перевірка CurrentAverage' AS [Завдання];
SELECT b.BowlerLastName, b.BowlerFirstName,
       CAST(b.TotalScore * 1.0 / NULLIF(b.GamesBowled,0) AS DECIMAL(10,2)) AS CalcAverage,
       b.CurrentAverage,
       (CASE WHEN b.CurrentAverage = CAST(b.TotalScore * 1.0 / NULLIF(b.GamesBowled,0) AS DECIMAL(10,2))
             THEN 'Співпадає' ELSE 'Відрізняється' END) AS CheckMatch
FROM Bowlers b
ORDER BY b.BowlerLastName, b.BowlerFirstName;
GO


--------------------------------------------------------------
-- 5) Гравці з якого штату найуспішніші
--------------------------------------------------------------
SELECT 'Завдання 5 – Найуспішніший штат за кількістю виграних ігор' AS [Завдання];
SELECT TOP 1 b.BowlerState, COUNT(*) AS IndividualGameWins
FROM Bowler_Scores bs
JOIN Bowlers b ON b.BowlerID = bs.BowlerID
WHERE bs.WonGame = 1
GROUP BY b.BowlerState
ORDER BY IndividualGameWins DESC, b.BowlerState;
GO


--------------------------------------------------------------
-- 6) Для кожної команди – кількість перемог і поразок за історію клубу
--------------------------------------------------------------
SELECT 'Завдання 6 – Перемоги та поразки кожної команди' AS [Завдання];
WITH TeamGameWins AS (
  SELECT mg.WinningTeamID AS TeamID, COUNT(*) AS WonGames
  FROM Match_Games mg
  GROUP BY mg.WinningTeamID
),
TeamGamePlays AS (
  SELECT tm.OddLaneTeamID AS TeamID, COUNT(*)*3 AS GamesPlayed
  FROM Tourney_Matches tm GROUP BY tm.OddLaneTeamID
  UNION ALL
  SELECT tm.EvenLaneTeamID AS TeamID, COUNT(*)*3 AS GamesPlayed
  FROM Tourney_Matches tm GROUP BY tm.EvenLaneTeamID
),
TeamTotals AS (
  SELECT TeamID, SUM(GamesPlayed) AS GamesPlayed
  FROM TeamGamePlays GROUP BY TeamID
)
SELECT t.TeamName,
       COALESCE(w.WonGames,0) AS WonGames,
       (COALESCE(tp.GamesPlayed,0) - COALESCE(w.WonGames,0)) AS LostGames
FROM Teams t
LEFT JOIN TeamTotals    tp ON tp.TeamID = t.TeamID
LEFT JOIN TeamGameWins  w  ON w.TeamID  = t.TeamID
ORDER BY WonGames DESC, LostGames ASC, t.TeamName;
GO


--------------------------------------------------------------
-- 7) Команда з найбільшою кількістю перемог у турнірах "Imperial Lanes"
--------------------------------------------------------------
SELECT 'Завдання 7 – Найуспішніша команда на Imperial Lanes' AS [Завдання];
WITH GameWins AS (
  SELECT mg.MatchID, mg.WinningTeamID, COUNT(*) AS GamesWon
  FROM Match_Games mg
  GROUP BY mg.MatchID, mg.WinningTeamID
),
MatchWinner AS (
  SELECT gw.MatchID, gw.WinningTeamID AS TeamID
  FROM GameWins gw
  WHERE gw.GamesWon = (
    SELECT MAX(gw2.GamesWon) FROM GameWins gw2 WHERE gw2.MatchID = gw.MatchID
  )
),
TournamentTeamWins AS (
  SELECT tm.TourneyID, mw.TeamID, COUNT(*) AS MatchWinsInTourney
  FROM MatchWinner mw
  JOIN Tourney_Matches tm ON tm.MatchID = mw.MatchID
  GROUP BY tm.TourneyID, mw.TeamID
),
TournamentChampion AS (
  SELECT ttw.TourneyID, ttw.TeamID,
         RANK() OVER (PARTITION BY ttw.TourneyID ORDER BY ttw.MatchWinsInTourney DESC) AS rnk
  FROM TournamentTeamWins ttw
)
SELECT TOP 1 x.TeamName, COUNT(*) AS TournamentWinsAtImperial
FROM TournamentChampion tc
JOIN Tournaments t ON t.TourneyID = tc.TourneyID
JOIN Teams x       ON x.TeamID    = tc.TeamID
WHERE tc.rnk = 1
  AND t.TourneyLocation = 'Imperial Lanes'
GROUP BY x.TeamName
ORDER BY TournamentWinsAtImperial DESC, x.TeamName;
GO


--------------------------------------------------------------
-- 8) Гравці з RawScore 135–140 і HandicapScore на 25–35% вище
--------------------------------------------------------------
SELECT 'Завдання 8 – Гравці з RawScore 135–140 і HandicapScore на 25–35% вище' AS [Завдання];
SELECT b.BowlerLastName, b.BowlerFirstName, t.TeamName,
       bs.RawScore, bs.HandicapScore
FROM Bowler_Scores bs
JOIN Bowlers b ON b.BowlerID = bs.BowlerID
JOIN Teams t   ON t.TeamID    = b.TeamID
WHERE bs.RawScore BETWEEN 135 AND 140
  AND bs.HandicapScore BETWEEN bs.RawScore * 1.25 AND bs.RawScore * 1.35
ORDER BY b.BowlerLastName, b.BowlerFirstName;
GO


--------------------------------------------------------------
-- 9) Зі скількох матчів складається кожен турнір
--     і зі скількох ігор складається кожен матч
--------------------------------------------------------------
SELECT 'Завдання 9 – Кількість матчів у турнірах і кількість ігор у матчах' AS [Завдання];

-- 9a) Кількість матчів у кожному турнірі
SELECT t.TourneyID, t.TourneyDate, t.TourneyLocation,
       COUNT(*) AS MatchesPerTournament
FROM Tournaments t
JOIN Tourney_Matches tm ON tm.TourneyID = t.TourneyID
GROUP BY t.TourneyID, t.TourneyDate, t.TourneyLocation
ORDER BY t.TourneyID;

-- 9b) Кількість ігор у кожному матчі
SELECT mg.MatchID, COUNT(*) AS GamesPerMatch
FROM Match_Games mg
GROUP BY mg.MatchID
ORDER BY mg.MatchID;
GO