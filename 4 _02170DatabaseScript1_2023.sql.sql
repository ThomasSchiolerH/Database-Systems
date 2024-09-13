
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


