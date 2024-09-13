DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Referee;
DROP TABLE IF EXISTS Player; 
DROP TABLE IF EXISTS Coach;
DROP TABLE IF EXISTS Team; 
DROP TABLE IF EXISTS Stadium;
DROP TABLE IF EXISTS FootballLeague;
DROP VIEW IF EXISTS TopScorers;
DROP VIEW IF EXISTS HighestPaidPlayers;
DROP VIEW IF EXISTS CoachesRank;
DROP VIEW IF EXISTS LeagueRanking;
DROP VIEW IF EXISTS MatchHistory;
DROP PROCEDURE IF EXISTS AddNewPlayer;
DROP PROCEDURE IF EXISTS TransferPlayer;
DROP PROCEDURE IF EXISTS RemovePlayer;
DROP PROCEDURE IF EXISTS PlayerScores;
DROP FUNCTION IF EXISTS PlayerCount;


CREATE TABLE FootballLeague
	(LeagueID		DECIMAL(3,0),
    LeagueName		VARCHAR(15),
    PRIMARY KEY(LeagueID)
    );
    
CREATE TABLE Stadium
	(StadiumID		DECIMAL(3,0),
    StadiumName		VARCHAR(15),
    Location		VARCHAR(15),
    Capacity		DECIMAL(10,0),
    PRIMARY KEY(StadiumId)
    );
 
CREATE TABLE Team 
	(TeamID				DECIMAL(3,0),
    TeamName			VARCHAR(15),
    Points				DECIMAL(2,0),
    TeamWins			DECIMAL(2,0),
    TeamLosses			DECIMAL(2,0),
    TeamDraws			DECIMAL(2,0),
    TeamGoals			DECIMAL(2,0),
    TeamGoalsConceded 	DECIMAL(2,0),
    LeagueID			DECIMAL(3,0),
    StadiumID			DECIMAL(3,0),
    PRIMARY KEY (TeamID),
    FOREIGN KEY (LeagueID) REFERENCES FootballLeague (LeagueID) ON DELETE SET NULL,
    FOREIGN KEY (StadiumID) REFERENCES Stadium (StadiumID) ON DELETE SET NULL
    );
      
CREATE TABLE Player
	(PlayerId			DECIMAL(3,0),
    PlayerName			VARCHAR(20),
    PlayerSalary		DECIMAL(8,2),
    PlayerGoals			DECIMAL(2,0),
    PlayerAssists		DECIMAL(2,0),
    PlayerRedCards		DECIMAL(2,0),
    PlayerYellowCards	DECIMAL(2,0),
    TeamID				DECIMAL(3,0),
    PRIMARY KEY(PlayerID),
	FOREIGN KEY (TeamID) REFERENCES Team (TeamID) ON DELETE SET NULL
    );
    
CREATE TABLE Referee
	(RefereeID		DECIMAL(3,0),
    RefereeName		VARCHAR(20),
    RefereeSalary	DECIMAL(8,2),
    RefereeCountry	VARCHAR(15),
    PRIMARY KEY(RefereeId)
    );

CREATE TABLE Matches
	(MatchID		DECIMAL(3,0),
    StadiumID		DECIMAL(3,0),
    RefereeID		DECIMAL(3,0),
    HomeTeamName		VARCHAR(15),
    AwayTeamName		VARCHAR(15),
    HomeTeamGoals	DECIMAL(3,0),
    AwayTeamGoals	DECIMAL(3,0),
    PRIMARY KEY(MatchID),
	FOREIGN KEY (StadiumID) REFERENCES Stadium (StadiumID) ON DELETE SET NULL,
	FOREIGN KEY (RefereeID) REFERENCES Referee (RefereeID) ON DELETE SET NULL
    );

CREATE TABLE Coach
    (CoachID        DECIMAL(3,0),
    CoachName       VARCHAR(15),
    TeamID		    DECIMAL(3,0),
    OriginCountry   VARCHAR(15),
    PRIMARY KEY(CoachID),
    FOREIGN KEY(TeamID) REFERENCES Team (TeamID) ON DELETE SET NULL
    );
    
INSERT FootballLeague VALUES
('123','SundayLeague');

INSERT Stadium VALUES
('111','DTU Stadium','Lyngby','1000'),
('112','Camp Nou','Spain','55000'),
('113','Old Trafford','England','45000');

INSERT Team VALUES
('001','GigaSoft','69','22','3','3','66','26','123','111'),
('002','DBAllStars','61','19','4','4','67','25','123','112'),
('003','BallersFC','50','15','6','5','41','35','123','113');

INSERT Player VALUES
('001','Leonel Messi','150000','28','19','0','0','001'),
('002','Robert Lewandowski','100000','21','13','0','1','002'),
('003','Cristiano Ronaldo','90000','8','0','3','3','003'),
('004','Jamal Musiala','90000','4','7','0','2','001'),
('005','Ngolo Kante','90000','0','1','0','4','001'),
('006','Jude Bellingham','90000','1','7','0','2','002'),
('007','Declan Rice','90000','0','0','0','5','002'),
('008','Pablo Gavi','90000','0','3','0','2','003'),
('009','Leon Goretzka','90000','2','3','0','2','003'),
('010','Kalidou Koulibaly','90000','1','0','1','3','001'),
('011','De Ligt','90000','0','0','0','5','001'),
('012','Kyle Walker','90000','0','0','0','5','002'),
('013','Van Dijk','90000','2','0','0','3','002'),
('014','Sergio Ramos','90000','2','0','4','3','003'),
('015','Joe Gomez','90000','0','0','0','2','003'),
('016','Manuel Neuer','90000','0','0','0','0','001'),
('017','Ter Stegen','90000','0','0','0','0','002'),
('018','Keylor Navas','90000','0','0','0','0','003');

INSERT Referee VALUES
('111','Jose Pablo','1500','Mexico'),
('222','Hernandez Hernandez','1500','Spain'),
('333','Andy Taylor','2500','England');

INSERT Matches VALUES
('100','111','333','GigaSoft','BallersFC','8','2'),
('200','111','333','Gigasoft','DBAllStars','3','3'),
('300','112','222','DBAllStars','BallersFC','0','4'),
('400','113','111','BallersFC','GigaSoft','1','2');

#Make a view of the topscorer for the entire league
CREATE VIEW TopScorers as
SELECT PlayerId, PlayerName, PlayerGoals
FROM Player 
Order by PlayerGoals DESC;

#SELECT * FROM TopScorer

#Make a view for the most paid player
CREATE VIEW HighestPaidPlayers as
SELECT PlayerId, PlayerName, PlayerSalary as Salary
FROM Player 
Order by PlayerSalary DESC;

#SELECT * FROM HighestPaidPlayers

#Ranking for the league
CREATE VIEW LeagueRanking as
SELECT TeamName, Points, TeamWins as Wins, 
TeamLosses as Losses, TeamGoals as Goals, TeamGoalsConceded as GoalsConceded
FROM Team 
Order by Points DESC;

#SELECT * FROM LeagueRanking

#mathes played
CREATE VIEW MatchHistory as
SELECT HomeTeamName, AwayTeamName, HomeTeamGoals, AwayTeamGoals, 
StadiumName as Stadium, RefereeName as Referee
FROM Matches 
NATURAL JOIN Stadium
NATURAL JOIN Referee;

#SELECT * FROM MatchHistory

#Function to add to a team
DELIMITER //
CREATE PROCEDURE AddNewPlayer
	(IN vPlayerID DECIMAL(3,0), IN vPlayerName VARCHAR(20), IN vPlayerSalary DECIMAL(8,2), IN vTeamID DECIMAL(3,0))
    BEGIN
		INSERT Player(PlayerID, PlayerName, PlayerSalary, PlayerGoals, PlayerAssists, PlayerRedCards, PlayerYellowCards, TeamID)
			VALUES(vPlayerID, vPlayerName, vPlayerSalary, 0, 0, 0, 0, vTeamID);
	END //
DELIMITER ;

#Function to remove from team
DELIMITER //
CREATE PROCEDURE RemovePlayer
	(IN vPlayerID DECIMAL(3,0), IN vTeamID DECIMAL(3,0))
    BEGIN
		DELETE FROM Player WHERE PlayerID = vPlayerID AND TeamID = vTeamID;
	END //
DELIMITER ;

#Function to transfer to new team
DELIMITER //
CREATE PROCEDURE TransferPlayer
	(IN vPlayerID DECIMAL(3,0), IN vOldTeamID DECIMAL(3,0),IN vNewTeamID DECIMAL(3,0), IN vNewPlayerSalary DECIMAL(8,2))
    BEGIN
		DECLARE vPlayerName NVARCHAR(20);
		SET vPlayerName = (SELECT PlayerName FROM Player WHERE PlayerId = vPlayerID);
		CALL RemovePlayer(vPlayerID, vOldTeamID);
		CALL AddNewPlayer(vPlayerID, vPlayerName, vNewPlayerSalary, vNewTeamID);
	END //
DELIMITER ;

#Team 001 sells an expensive player to team 003
CALL TransferPlayer('001', '001','003', '180000');

#Team 001 gets a raise with the money earned
UPDATE Player 
	SET PlayerSalary = PlayerSalary * 1.05
    WHERE TeamID = 001;
 
#Function to add goals to a player 
DELIMITER //
CREATE PROCEDURE PlayerScores
	(IN vPlayerID DECIMAL(3,0), IN vScoredGoals DECIMAL(3,0))
    BEGIN
		UPDATE Player
        SET PlayerGoals = PlayerGoals + vScoredGoals
        WHERE PlayerId = vPlayerID;
	END //
DELIMITER ;

#A few players scores during the week
CALL PlayerScores('001', '3');
CALL PlayerScores('012', '1');

#Function to count player amount from each team
DELIMITER //
CREATE FUNCTION PlayerCount(vTeamID DECIMAL(3,0)) RETURNS INT
	BEGIN
		DECLARE vCount INT;
        SELECT COUNT(*) INTO vCount FROM Player
        WHERE TeamID = vTeamID;
        RETURN vCOUNT;
    END//
DELIMITER ;

#Function to ensure fair pay amongst players
DELIMITER //
CREATE TRIGGER PlayerBeforeInsert
	BEFORE INSERT ON Player FOR EACH ROW
	BEGIN
		IF NEW.PlayerSalary < 1000 THEN SET NEW.PlayerSalary = 1000 ;
		ELSEIF NEW.PlayerSalary > 99999999  THEN SET NEW.PlayerSalary = 99999999;
		END IF;
	END //
DELIMITER ;

SELECT TeamID, PlayerCount(TeamID) AS Players FROM Team;