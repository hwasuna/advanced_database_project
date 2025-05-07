CREATE DATABASE BoardGameApp;
USE BoardGameApp;

-- 1. User Table
CREATE TABLE User (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) NOT NULL,
    Email VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(50) NOT NULL,
    Role VARCHAR(50)
);

-- 2. Game Table
CREATE TABLE Game (
    GameID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50) NOT NULL,
    Description VARCHAR(255),
    YearPublished INT,
    NbPlayers INT,
    AverageRating FLOAT,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- 3. Event Table
CREATE TABLE Event (
    EventID INT PRIMARY KEY AUTO_INCREMENT,
    OrganizerID INT NOT NULL,
    EventDate DATE NOT NULL,
    EventTime TIME NOT NULL,
    Location VARCHAR(50),
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- 4. Rating Table
CREATE TABLE Rating (
    RatingID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    GameID INT NOT NULL,
    Score INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID)
);

-- Users
INSERT INTO User (UserID, Username, Email, Password, Role) VALUES
(1, 'lili_gamer', 'lina@example.com', 'pass123', 'User'),
(2, 'hawa_admin', 'hawa@example.com', 'adminpass', 'Admin'),
(3, 'rith_player', 'chakri@example.com', 'pass456', 'User'),
(4, 'wiwi_board', 'william@example.com', 'pass789', 'User'),
(5, 'mark_fan', 'alex@example.com', 'pass101', 'User');

-- Insert Games (using real data from CSV)
INSERT INTO Game (GameID, Name, Description, YearPublished, NbPlayers, AverageRating, UserID) VALUES
(1, 'Pandemic', 'In Pandemic, several virulent diseases have broken out...', 2008, 4, 8.2, 1),
(2, 'Carcassonne', 'Carcassonne is a tile-placement game in which players draw...', 2000, 5, 8.0, 2),
(3, 'Catan', 'In CATAN (formerly The Settlers of Catan), players try to be the dominant force...', 1995, 4, 8.5, 3),
(4, '7 Wonders', 'You are the leader of one of the 7 great cities of the Ancient World...', 2010, 7, 8.4, 4),
(5, 'Dominion', 'You are a monarch, like your parents before you, a ruler of a small pleasant kingdom...', 2008, 4, 7.9, 1);


-- Insert Events (organized by users)
INSERT INTO Event (EventID, OrganizerID, EventDate, EventTime, Location, UserID) VALUES
(1, 1, '2025-05-10', '18:00:00', 'Lina\'s House', 1),
(2, 2, '2025-05-12', '14:30:00', 'Gaming Cafe', 2),
(3, 3, '2025-05-14', '19:00:00', 'Lean\'s Apartment', 3);

-- Insert Ratings (users rate games)
INSERT INTO Rating (RatingID, UserID, GameID, Score) VALUES
(1, 1, 1, 9),  -- Lina rates Catan
(2, 2, 2, 8),  -- Hawa rates Carcassonne
(3, 3, 3, 7),  -- Rith rates Pandemic
(4, 4, 4, 10), -- William rates 7 Wonders
(5, 2, 1, 6),  -- Hawa rates Catan
(6, 1, 5, 9);  -- Lina rates Dominion

-- View 1: List of all available games with creator info
CREATE VIEW View_AvailableGames AS
SELECT 
    G.GameID,
    G.Name,
    G.Description,
    G.YearPublished,
    G.NbPlayers,
    G.AverageRating,
    U.Username AS Creator
FROM Game G
JOIN User U ON G.UserID = U.UserID;

-- View 2: User rating history
CREATE VIEW View_UserRatings AS
SELECT 
    R.RatingID,
    U.Username,
    G.Name AS GameName,
    R.Score
FROM Rating R
JOIN User U ON R.UserID = U.UserID
JOIN Game G ON R.GameID = G.GameID;

-- View 3: Upcoming events with organizer names
CREATE VIEW View_UpcomingEvents AS
SELECT 
    E.EventID,
    E.EventDate,
    E.EventTime,
    E.Location,
    U.Username AS Organizer
FROM Event E
JOIN User U ON E.OrganizerID = U.UserID
WHERE E.EventDate >= CURRENT_DATE;

-- Index 1: Optimize lookup by GameID
CREATE INDEX idx_game_id ON Game(GameID);

-- Index 2: Optimize lookup of ratings by UserID
CREATE INDEX idx_rating_user ON Rating(UserID);

-- Index 3: Optimize search for upcoming events by date
CREATE INDEX idx_event_date ON Event(EventDate);

-- Trigger 1: Update Game.AverageRating after insert on Rating
DELIMITER $$

CREATE TRIGGER trg_update_rating_after_insert
AFTER INSERT ON Rating
FOR EACH ROW
BEGIN
    UPDATE Game
    SET AverageRating = (
        SELECT AVG(Score)
        FROM Rating
        WHERE GameID = NEW.GameID
    )
    WHERE GameID = NEW.GameID;
END$$

DELIMITER ;

-- Trigger 2: Update Game.AverageRating after delete on Rating
DELIMITER $$

CREATE TRIGGER trg_update_rating_after_delete
AFTER DELETE ON Rating
FOR EACH ROW
BEGIN
    UPDATE Game
    SET AverageRating = (
        SELECT AVG(Score)
        FROM Rating
        WHERE GameID = OLD.GameID
    )
    WHERE GameID = OLD.GameID;
END$$

DELIMITER ;

-- Trigger 3: Prevent events from being scheduled in the past
DELIMITER $$

CREATE TRIGGER trg_check_event_date
BEFORE INSERT ON Event
FOR EACH ROW
BEGIN
    IF NEW.EventDate < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot schedule an event in the past';
    END IF;
END$$

DELIMITER ;

-- Procedure 1: Add a new event
DELIMITER //
CREATE PROCEDURE AddEvent (
    IN organizer INT,
    IN date_val DATE,
    IN time_val TIME,
    IN location_val VARCHAR(50),
    IN userid INT
)
BEGIN
    INSERT INTO Event (OrganizerID, EventDate, EventTime, Location, UserID)
    VALUES (organizer, date_val, time_val, location_val, userid);
END;
//
DELIMITER ;

-- Procedure 2: Rate a game
DELIMITER //
CREATE PROCEDURE RateGame (
    IN user_id INT,
    IN game_id INT,
    IN score_val INT
)
BEGIN
    INSERT INTO Rating (UserID, GameID, Score)
    VALUES (user_id, game_id, score_val);
END;
//
DELIMITER ;

-- Procedure 3: Get all events by a user
DELIMITER //
CREATE PROCEDURE GetUserEvents (
    IN user_id INT
)
BEGIN
    SELECT * FROM Event
    WHERE UserID = user_id;
END;
//
DELIMITER ;
