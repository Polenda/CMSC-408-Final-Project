# Welcome to CMSC-408 Final Project Repository
![Static Badge](https://img.shields.io/badge/build-passing-brightgreen) ![Static Badge](https://img.shields.io/badge/AI-YES-blue)
![Static Badge](https://img.shields.io/badge/contributors-3-orange) ![Static Badge](https://img.shields.io/badge/elapsed-58hr-white)
  
  This is a clone of my school project repo for personal storage, portfolio work, and potentially further development.

## Proejct Description
  The project aims to develop a robust system that allows users to track the history of video games they have played. The database will store specific and relevant data related to each game, enabling users to curate a personal catalogue of games they’ve experienced. By associating games with user data, genreal game data, and game metadata, the platform will offer a seamless way to manage, analyze, and explore ones personal gaming history.

[Final Project Video](https://youtu.be/c_xCT7hxRyg)

### Key Features:
- Personal User Tracking: Each user will have a dedicated profile that stores personal ratings, along with an aggregated average rating from all users for each game.
- Comprehensive Game Library: Users can track the number of games in their library, their total value, and other relevant game-specific data (such as year and individual game value).
- Detailed Game Information: Each game is associated with details such as the developer, publisher, platform, genre, and game-specific completion times. This allows for granular data analysis and personalized recommendations.
- Completion Tracking: The database will track both the average time to complete a game and the user's personal completion time.

### Database Entities:
- PersonalInfo: Stores the user’s identification and rating data, allowing the system to log personal ratings and compare them with the general consensus for each game.
          Attributes: ID, userRating, averageRating.
  
- Library: Represents the user’s collection of games, storing data on the total number of games owned and the total monetary value of the collection.
        Attributes: ID, totalGames, totalValue.
  
- Game: Holds core information about each game to be used in each library.
        Attributes: ID, gameName, gameVlaue, Year.
  
- UserLibrary: A junction table to allow each user to hold a single library.
        Attributes: userID (foreign key), libraryID (foreign key)
  
- LibraryGame: A junction table to allow each library to hold a unqiue amout of the same games.
        Attributes: gameID (foreign key), libraryID (foreign key), userRating
  
- Developer: A weak entity that tracks information about the game’s developer, such as the studio name and whether the development involved multiple studios.
        Attributes: ID, developerName, multiStudio, gameID (foreign key).
  
- Publisher: A weak entity that tracks the game’s publisher, detailing publisher name and the ownership of the development studio.
        Attributes: ID, publisherName, ownership, gameID (foreign key).
  
- GamePlatform: Stores details about the platform or system on which a game was played, including platform name, system type, and any relevant applications.
        Attributes: ID, platformName, platformSystem, Application, gameID (foreign key).
  
- Genre: Stores data related to the game’s genre, thematic elements, and the player’s perspective within the game.
        Attributes: ID, genreName, Theme, Perspective, gameID (foreign key).
  
- Completion: Tracks completion times, allowing users to log their personal time to finish the game and compare it with the community's average.
        Attributes: ID, personalTime, acheivementPercent, completed, userID (foreign key), gameID (foreign key).

### Benefits:
- Personalized Insights: Users can track their game progress, personal preferences, and compare their performance to the community, providing insight into gaming habits.
- Data-Driven Recommendations: With detailed game data, the system can generate tailored recommendations based on user history and preferences.
- Historical Archiving: Each game’s history and data will be preserved, offering users a complete view of their gaming journey over time over the many differect platforms there are, were, and will be.

## How To:

1. Download the Repo ont your local machine

2. Navigate to main directory in project folder in your terminal

### -- SELF HOST METHOD --

3. Navigate to `app/src/Backend`

4. Execute `poetry install` to confirm poetry shell

5. Execute `poetry shell` to open the shell

6. Execute `python app.py` to run the application

### -- DOCKER HOSTED METHOD --

3. Navigate to `app/src`

4. Execute `docker build -t flask-app .` to build the image

5. Execute `docker -p 5000:5000 --env-file Backend/.env flask-app` to build the container

### -------------------------------

[Visit the webpage on localhost](http://localhost:5000)
