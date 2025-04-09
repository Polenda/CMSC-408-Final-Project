SELECT 
    Game.ID,
    Game.gameName,
    Developer.developerName,
    Publisher.publisherName
FROM 
    Game
LEFT JOIN 
    Developer ON Game.ID = Developer.gameID
LEFT JOIN 
    Publisher ON Game.ID = Publisher.gameID;
