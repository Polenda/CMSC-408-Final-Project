--  Code specifications.
--  0. Where there a conflict between the problem statement in the google doc and this file, this file wins.
--  1. creates publisher table
--  2. creates genre table
--  3. creates gamePlatform table
--  4. creates completion table
--  5. creats developer table
--  6. creates game table
--  7. creates library table
--  8. creates personalInfo table
--  9. creates LibraryGame table
--  10. creates UserLibrary table
--  11. sets all foreign keys that are needed
--  12. alters all tables for needed beginer data

-- Disable foreign key checks to allow table recreation
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS LibraryGame;
DROP TABLE IF EXISTS UserLibrary;
DROP TABLE IF EXISTS Completion;
DROP TABLE IF EXISTS Publisher;
DROP TABLE IF EXISTS Developer;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS GamePlatform;
DROP TABLE IF EXISTS Library;
DROP TABLE IF EXISTS PersonalInfo;
DROP TABLE IF EXISTS Game;
SET FOREIGN_KEY_CHECKS=1;

-- Genre Table
CREATE TABLE `Genre` (
    `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `gameID` BIGINT UNSIGNED NOT NULL,
    `genreName` VARCHAR(255) NOT NULL,
    `theme` VARCHAR(255) NOT NULL,
    `perspective` VARCHAR(255) NOT NULL
);

-- GamePlatform Table
CREATE TABLE `GamePlatform` (
    `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `gameID` BIGINT UNSIGNED NOT NULL,
    `platformSystem` VARCHAR(255) NOT NULL,
    `application` VARCHAR(255) NOT NULL,
    `platformName` VARCHAR(255) NOT NULL
);

-- Completion Table
CREATE TABLE `Completion` (
    `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `userID` BIGINT UNSIGNED NOT NULL,
    `gameID` BIGINT UNSIGNED NOT NULL,
    `personalTime` TIME NOT NULL,
    `achievementPercent` FLOAT NOT NULL,
    `completed` BOOLEAN NOT NULL
);

-- Publisher Table
CREATE TABLE `Publisher` (
    `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `publisherName` VARCHAR(255) NOT NULL,
    `ownership` BOOLEAN NOT NULL,
    `gameID` BIGINT UNSIGNED NOT NULL
);

-- Developer Table
CREATE TABLE `Developer` (
    `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `developerName` VARCHAR(255) NOT NULL,
    `multiStudio` BOOLEAN NOT NULL,
    `gameID` BIGINT UNSIGNED NOT NULL
);

-- Game Table
CREATE TABLE `Game` (
    `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `gameName` VARCHAR(255) NOT NULL,
    `gameValue` FLOAT NOT NULL,
    `year` YEAR NOT NULL
);

-- Library Table
CREATE TABLE `Library` (
    `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `totalValue` BIGINT NOT NULL,
    `totalGames` BIGINT NOT NULL
);

-- PersonalInfo Table
CREATE TABLE `PersonalInfo` (
    `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(255) NOT NULL,
    `password` CHAR(255) NOT NULL
);

-- Library-Game Junction Table
CREATE TABLE `LibraryGame` (
    `libraryID` BIGINT UNSIGNED NOT NULL,
    `gameID` BIGINT UNSIGNED NOT NULL,
    `userRating` FLOAT NOT NULL,
    PRIMARY KEY (`libraryID`, `gameID`),
    FOREIGN KEY (`libraryID`) REFERENCES `Library`(`ID`) ON DELETE CASCADE,
    FOREIGN KEY (`gameID`) REFERENCES `Game`(`ID`) ON DELETE CASCADE
);

-- User-Library Junction Table
CREATE TABLE `UserLibrary` (
    `userID` BIGINT UNSIGNED NOT NULL,
    `libraryID` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`userID`, `libraryID`),
    FOREIGN KEY (`userID`) REFERENCES `PersonalInfo`(`ID`) ON DELETE CASCADE,
    FOREIGN KEY (`libraryID`) REFERENCES `Library`(`ID`) ON DELETE CASCADE
);


-- Add Foreign Key Constraints
ALTER TABLE `Completion` 
    ADD CONSTRAINT `completion_gameid_foreign` FOREIGN KEY (`gameID`) REFERENCES `Game`(`ID`) ON DELETE CASCADE,
    ADD CONSTRAINT `completion_userid_foreign` FOREIGN KEY (`userID`) REFERENCES `PersonalInfo`(`ID`);

ALTER TABLE `Publisher` 
    ADD CONSTRAINT `publisher_gameid_foreign` FOREIGN KEY (`gameID`) REFERENCES `Game`(`ID`) ON DELETE CASCADE;

ALTER TABLE `Developer` 
    ADD CONSTRAINT `developer_gameid_foreign` FOREIGN KEY (`gameID`) REFERENCES `Game`(`ID`) ON DELETE CASCADE;

ALTER TABLE `GamePlatform` 
    ADD CONSTRAINT `gameplatform_gameid_foreign` FOREIGN KEY (`gameID`) REFERENCES `Game`(`ID`) ON DELETE CASCADE;

ALTER TABLE `Genre` 
    ADD CONSTRAINT `genre_gameid_foreign` FOREIGN KEY (`gameID`) REFERENCES `Game`(`ID`) ON DELETE CASCADE;


-- Insert into Game table
INSERT INTO `Game` (`gameName`, `gameValue`, `year`)
VALUES 
('Mario kart Wii', 26.00, 2008),
('Pokemon Crystal', 153.00, 2001),
('Halo: Combat Evolved', 7.10, 2001),
("Baldur's Gate 3", 59.99, 2023),
('Minecraft', 29.99, 2011),
('The Last of Us', 6.32, 2013),
('World of Warcraft', 155.88, 2004),
('Fallout: New Vegas', 7.88, 2010),
("Tony Hawk's Underground 2", 8.34, 2004),
('Pokemon Sapphire', 74.32, 2003),
('Metroid Dread', 29.99, 2021),
('Red Dead Redemption 2', 13.82, 2018),
('Animal Crossing: New Leaf', 16.87, 2013),
('New Super Mario Bros.', 16.15, 2006),
('Silent Hill 2', 108.66, 2001),
('GoldenEye 007', 27.99, 1997),
("Tony Hawk's Pro Skater", 8.00, 1999),
('Call of Duty: Black Ops III', 9.33, 2015),
('Grand Theft Auto: Vice City', 8.02, 2002),
('Super Smash Bros. Ultimate', 35.07, 2018);

-- Retrieve the last inserted Game IDs
SET @gameID1 = LAST_INSERT_ID();
SET @gameID2 = @gameID1 + 1;
SET @gameID3 = @gameID2 + 1;
SET @gameID4 = @gameID3 + 1;
SET @gameID5 = @gameID4 + 1;
SET @gameID6 = @gameID5 + 1;
SET @gameID7 = @gameID6 + 1;
SET @gameID8 = @gameID7 + 1;
SET @gameID9 = @gameID8 + 1;
SET @gameID10 = @gameID9 + 1;
SET @gameID11 = @gameID10 + 1;
SET @gameID12 = @gameID11 + 1;
SET @gameID13 = @gameID12 + 1;
SET @gameID14 = @gameID13 + 1;
SET @gameID15 = @gameID14 + 1;
SET @gameID16 = @gameID15 + 1;
SET @gameID17 = @gameID16 + 1;
SET @gameID18 = @gameID17 + 1;
SET @gameID19 = @gameID18 + 1;
SET @gameID20 = @gameID19 + 1;

-- Retrive the last inserted User IDs
SET @libraryID1 = LAST_INSERT_ID();
SET @libraryID2 = @libraryID1 + 1;
SET @libraryID3 = @libraryID2 + 1;

-- Insert into Library table
INSERT INTO `Library` (`totalValue`, `totalGames`)
VALUES 
(0, 0),
(0, 0),
(0, 0);

-- Insert into PersonalInfo table
INSERT INTO `PersonalInfo` (`username`, `password`)
VALUES 
('polenda', 'password1'),
('hughes7', 'password2'),
('doutt', 'password3'),
('leonard', 'password123');

-- Insert into UserLibrary table
INSERT INTO `UserLibrary` (`userID`, `libraryID`)
VALUES
(1,1), (2,2), (3,2), (4,3);

-- Insert into Library table
INSERT INTO `LibraryGame` (`libraryID`, `gameID`, `userRating`)
VALUES
(@libraryID1, 1, 9.2), (@libraryID1, 2, 8.6), (@libraryID1, 3, 9.2), (@libraryID1, 4, 10.0), (@libraryID1, 5, 7.6),
(@libraryID2, 6, 8.5), (@libraryID2, 7, 7.2), (@libraryID2, 8, 8.8), (@libraryID2, 9, 9.0), (@libraryID2, 10, 8.9),
(@libraryID3, 1, 6.1), (@libraryID3, 2, 9.4), (@libraryID3, 3, 6.2), (@libraryID3,   4, 9.1), (@libraryID3, 5, 6.7), 
(@libraryID3, 6, 8.0), (@libraryID3, 7, 9.5), (@libraryID3, 8, 6.8), (@libraryID3, 9, 9.7), (@libraryID3, 10, 6.6), 
(@libraryID3, 11, 6.7), (@libraryID3, 12, 7.2), (@libraryID3, 13, 9.5), (@libraryID3, 14, 6.9), (@libraryID3, 15, 9.1),
(@libraryID3, 16, 8.7), (@libraryID3, 17, 9.4), (@libraryID3, 18, 9.1), (@libraryID3, 19, 7.2), (@libraryID3, 20, 8.1);

-- Insert into Publisher table
INSERT INTO `Publisher` (`publisherName`, `ownership`, `gameID`)
VALUES 
('Nintendo', TRUE, @gameID1),
('Nintendo', FALSE, @gameID2),
('Nintendo', FALSE, @gameID10),
('Nintendo', TRUE, @gameID11),
('Nintendo', TRUE, @gameID13),
('Nintendo', TRUE, @gameID14),
('Nintendo', TRUE, @gameID16),
('Nintendo', TRUE, @gameID20),
('Microsoft Game Studios', TRUE, @gameID3),
('Microsoft Game Studios', TRUE, @gameID5),
('Larian Studios', TRUE, @gameID4),
('Sony Computer Entertainment', TRUE, @gameID6),
('Bizzard Entertainment', TRUE, @gameID7),
('Bethesda Softworks', FALSE, @gameID8),
('Activision', TRUE, @gameID9),
('Activision', TRUE, @gameID17),
('Activision', TRUE, @gameID18),
('Rockstar Games', TRUE, @gameID12),
('Rockstar Games', TRUE, @gameID19),
('Konami', TRUE, @gameID15);


-- Insert into Developer table
INSERT INTO `Developer` (`developerName`, `multiStudio`, `gameID`)
VALUES 
('Nintendo EAD', FALSE, @gameID1),
('Nintendo EAD', TRUE, @gameID11),
('Nintendo EAD', FALSE, @gameID13),
('Nintendo EAD', FALSE, @gameID14),
('Game Freak', FALSE, @gameID2),
('Game Freak', FALSE, @gameID10),
('Bungie', FALSE, @gameID3),
('Larian Studios', FALSE, @gameID4),
('Mojang Studios', FALSE, @gameID5),
('Naughty Dog', FALSE, @gameID6),
('Blizard Entertainment', FALSE, @gameID7),
('Obsidian Entertainment', FALSE, @gameID8),
('Neversoft', FALSE, @gameID9),
('Neversoft', FALSE, @gameID17),
('Rockstar Games', TRUE, @gameID12),
('Team Silent', FALSE, @gameID15),
('Rare', FALSE, @gameID16),
('Treyarch', FALSE, @gameID18),
('Rockstar North', FALSE, @gameID19),
('Bandai Namco', TRUE, @gameID20);

-- Insert into GamePlatform table
INSERT INTO `GamePlatform` (`gameID`, `platformSystem`, `application`, `platformName`)
VALUES 
(@gameID1, 'Console', 'Store', 'Wii'),
(@gameID2, 'Handheld', 'Store', 'Gameboy Color/Adv.'),
(@gameID3, 'Console', 'Xbox Store', 'Xbox'),
(@gameID4, 'PC', 'Steam', 'Windows'),
(@gameID5, 'PC', 'Online Store', 'Windows'),
(@gameID6, 'Console', 'PlayStation Store', 'PlayStation 3'),
(@gameID7, 'PC', 'Battle.net', 'Windows'),
(@gameID8, 'Console', 'PlayStation Store', 'PlayStation 3'),
(@gameID9, 'Console', 'Xbox Store', 'Xbox'),
(@gameID10, 'Handheld', 'Store', 'Gameboy Color/Adv.'),
(@gameID11, 'Handheld', 'Nintendo eShop', 'Nintendo Switch'),
(@gameID12, 'Console', 'PlayStation Store', 'PlayStation 4'),
(@gameID13, 'Handheld', 'Store', 'Nintendo DS/3DS'),
(@gameID14, 'Handheld', 'Store', 'Nintendo DS/3DS'),
(@gameID15, 'Console', 'PlayStation Store', 'PlayStation 2'),
(@gameID16, 'Console', 'Store', 'Nintendo 64'),
(@gameID17, 'Console', 'PlayStation Store', 'PlayStation'),
(@gameID18, 'Console', 'Xbox Store', 'Xbox One'),
(@gameID19, 'Console', 'PlayStation Store', 'PlayStation 2'),
(@gameID20, 'Handheld', 'Nintendo eShop', 'Nintendo Switch');

-- Insert into Genre table
INSERT INTO `Genre` (`gameID`, `genreName`, `theme`, `perspective`)
VALUES 
(@gameID1, 'Arcade-Racing', 'Fictional', 'Third Person'),
(@gameID2, 'RPG', 'Fictional', 'Top Down'),
(@gameID3, 'FPS', 'Furturistic', 'First Person'),
(@gameID4, 'RPG', 'High-Fantasy', 'Orthographic'),
(@gameID5, 'Open World-Sandbox', 'Fictional', 'First/Third Person'),
(@gameID6, 'Action-Adventure', 'Post-Apocalyptic', 'Third Person'),
(@gameID7, 'MMO-RPG', 'High-Fantasy', 'Third person'),
(@gameID8, 'Action-RPG', 'Post-Apocalyptic', 'First/Third Person'),
(@gameID9, 'Arcade-Sports', 'Realistic', 'Third Person'),
(@gameID10, 'RPG', 'Fictional', 'Top Down'),
(@gameID11, 'Action-Adventure', 'Futuristic', 'Side View'),
(@gameID12, 'Action-Adventure', 'Wild Western', 'Third Person'),
(@gameID13, 'Social-Simulation', 'Fictional', '2.5D View'),
(@gameID14, 'Platform', 'Fictional', 'Side View'),
(@gameID15, 'Survival-Horror', 'Post-Apocalyptic', 'Third Person'),
(@gameID16, 'FPS', 'Realistic', 'First Person'),
(@gameID17, 'Arcade-Sports', 'Realistic', 'Third Person'),
(@gameID18, 'FPS', 'Futuristic', 'First Person'),
(@gameID19, 'Action-Adventure', 'Realistic', 'Third Person'),
(@gameID20, 'Fighting', 'Fictional', 'Side View');

-- Insert into Completion table
INSERT INTO `Completion` (`userID`, `gameID`, `personalTime`, `achievementPercent`, `completed`)
VALUES 

(1, @gameID1, '00:00:00', 0.0, FALSE),
(1, @gameID2, '00:00:00', 0.0, FALSE),
(1, @gameID3, '00:00:00', 0.0, FALSE),
(1, @gameID4, '00:00:00', 0.0, FALSE),
(1, @gameID5, '00:00:00', 0.0, FALSE),
    
(2, @gameID6, '00:00:00', 0.0, FALSE),
(2, @gameID7, '00:00:00', 0.0, FALSE),
(2, @gameID8, '00:00:00', 0.0, FALSE),
(2, @gameID9, '00:00:00', 0.0, FALSE),
(2, @gameID10, '00:00:00', 0.0, FALSE),

(3, @gameID1, '00:00:00', 0.0, FALSE),
(3, @gameID2, '00:00:00', 0.0, FALSE),
(3, @gameID3, '00:00:00', 0.0, FALSE),
(3, @gameID4, '00:00:00', 0.0, FALSE),
(3, @gameID5, '00:00:00', 0.0, FALSE),
(3, @gameID6, '00:00:00', 0.0, FALSE),
(3, @gameID7, '00:00:00', 0.0, FALSE),
(3, @gameID8, '00:00:00', 0.0, FALSE),
(3, @gameID9, '00:00:00', 0.0, FALSE),
(3, @gameID10, '00:00:00', 0.0, FALSE),
(3, @gameID11, '00:00:00', 0.0, FALSE),
(3, @gameID12, '00:00:00', 0.0, FALSE),
(3, @gameID13, '00:00:00', 0.0, FALSE),
(3, @gameID14, '00:00:00', 0.0, FALSE),
(3, @gameID15, '00:00:00', 0.0, FALSE),
(3, @gameID16, '00:00:00', 0.0, FALSE),
(3, @gameID17, '00:00:00', 0.0, FALSE),
(3, @gameID18, '00:00:00', 0.0, FALSE),
(3, @gameID19, '00:00:00', 0.0, FALSE),
(3, @gameID20, '00:00:00', 0.0, FALSE);

-- END
