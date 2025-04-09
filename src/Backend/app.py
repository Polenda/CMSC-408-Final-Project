from flask import Flask, request, render_template, jsonify, session
import mysql.connector
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()
DB_USER = os.getenv("CMSC408_USER")
DB_PASSWORD = os.getenv("CMSC408_PASSWORD")
DB_HOST = os.getenv("CMSC408_HOST")
DB_NAME = os.getenv("FP_DB_NAME")

# Initialize Flask app
frontend_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '../Frontend'))

app = Flask(__name__, template_folder=frontend_path)
app.secret_key = "login-key"

# Connection function
connection = mysql.connector.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )
cursor = connection.cursor()

# html test router
@app.route('/', methods=['GET'])
def frontPage():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def login():
    username_input = request.json.get('username') 
    password_input = request.json.get('password') 

    try:
        query = "SELECT username, password FROM PersonalInfo WHERE username = %s"
        cursor.execute(query, (username_input,))
        result = cursor.fetchone()

        if result:
            if result[1] == password_input:
                session["username"] = username_input
                return jsonify({"message": "Login successful", "username": result[0]}), 200
            else:
                return jsonify({"message": "Password not found"}), 404
                
        else:
            return jsonify({"message": "Username not found"}), 404

    except mysql.connector.Error as err:
        return f"Error: {err}"


@app.route('/project', methods=['GET'])
def project():
    
    return render_template('grid.html')
    
def userFind():
    global_username = session.get("username", None)
    if global_username == "polenda":
        return 1
    elif global_username == "hughes7":
        return 2
    elif global_username == "doutt":
        return 3
    elif global_username == "leonard":
        return 4

@app.route("/games")
def games():
    try:
        query = ("""
            SELECT DISTINCT
                Game.ID AS ID,
                Game.gameName,
                CONCAT('$', FORMAT(Game.gameValue, 2)) AS gameValue,
                MAX(LibraryGame.userRating) AS userRating,
                Game.year,
                MAX(Completion.personalTime) AS personalTime,
                CONCAT(MAX(Completion.achievementPercent), '%') AS achievementPercent,
                MAX(Completion.completed) AS completed,
                GROUP_CONCAT(DISTINCT Genre.genreName) AS genreName,
                GROUP_CONCAT(DISTINCT Genre.theme) AS theme,
                GROUP_CONCAT(DISTINCT Genre.perspective) AS perspective,
                GROUP_CONCAT(DISTINCT GamePlatform.platformSystem) AS platformSystem,
                GROUP_CONCAT(DISTINCT GamePlatform.application) AS application,
                GROUP_CONCAT(DISTINCT GamePlatform.platformName) AS platformName
            FROM 
                PersonalInfo
            JOIN UserLibrary ON PersonalInfo.ID = UserLibrary.userID
            JOIN Library ON UserLibrary.libraryID = Library.ID
            JOIN LibraryGame ON Library.ID = LibraryGame.libraryID
            JOIN Game ON LibraryGame.gameID = Game.ID
            LEFT JOIN Completion ON Game.ID = Completion.gameID
            LEFT JOIN Genre ON Game.ID = Genre.gameID
            LEFT JOIN GamePlatform ON Game.ID = GamePlatform.gameID
            GROUP BY Game.ID, Game.gameName, Game.gameValue, Game.year
     
                 """)
        
        cursor.execute(query)

        results = cursor.fetchall()
        for j, i in enumerate(results):
            timestr = str(i[5])
            if (i[7] == 1):
                boolstr = True
            elif (i[7] == 0):
                boolstr = False
            results[j] = list(i)
            results[j][5] = timestr
            results[j][7] = boolstr
            results[j] = tuple(results[j])


        return jsonify(results)
    except mysql.connector.Error as err:
        return f"Error: {err}"

@app.route("/library")
def libraries():
    try:
        query = ("""
            SELECT DISTINCT
                Game.ID AS GameID,
                Game.gameName,
                CONCAT('$', FORMAT(Game.gameValue, 2)) AS gameValue,
                LibraryGame.userRating,
                Game.year,
                Developer.developerName,
                Publisher.publisherName,
                Genre.genreName,
                GamePlatform.platformName,
                GamePlatform.application,
                Completion.personalTime
            FROM 
                PersonalInfo
            JOIN 
                UserLibrary ON PersonalInfo.ID = UserLibrary.userID
            JOIN 
                Library ON UserLibrary.libraryID = Library.ID
            JOIN 
                LibraryGame ON Library.ID = LibraryGame.libraryID
            JOIN 
                Game ON LibraryGame.gameID = Game.ID
            LEFT JOIN 
                Publisher ON Game.ID = Publisher.gameID
            LEFT JOIN 
                Developer ON Game.ID = Developer.gameID
            LEFT JOIN 
                Genre ON Game.ID = Genre.gameID
            LEFT JOIN 
                GamePlatform ON Game.ID = GamePlatform.gameID
            LEFT JOIN 
                Completion ON Game.ID = Completion.gameID
            WHERE 
                PersonalInfo.ID = %s

        """)
        
        id = userFind()
        cursor.execute(query, (id,))
        
        results = cursor.fetchall()
        for j, i in enumerate(results):
            timestr = str(i[10])
            results[j] = list(i)
            results[j][10] = timestr
            results[j] = tuple(results[j])

        return jsonify(results)
    except mysql.connector.Error as err:
        return f"Error: {err}"
    
@app.route("/librarySum")
def total():
    try:
        query = ("""
            UPDATE Library
            SET 
                totalValue = (
                    SELECT 
                        IFNULL(SUM(Game.gameValue), 0)
                    FROM 
                        LibraryGame
                    JOIN 
                        Game ON LibraryGame.gameID = Game.ID
                    JOIN 
                        UserLibrary ON LibraryGame.libraryID = UserLibrary.libraryID
                    WHERE 
                        Library.ID = LibraryGame.libraryID
                        AND UserLibrary.userID = %s
                ),
                totalGames = (
                    SELECT 
                        IFNULL(COUNT(Game.ID), 0)
                    FROM 
                        LibraryGame
                    JOIN 
                        Game ON LibraryGame.gameID = Game.ID
                    JOIN 
                        UserLibrary ON LibraryGame.libraryID = UserLibrary.libraryID
                    WHERE 
                        Library.ID = LibraryGame.libraryID
                        AND UserLibrary.userID = %s
                );

                """)
        
        id = userFind()
        cursor.execute(query, (id, id))
        query = ("""
            SELECT 
                Library.totalValue AS TotalValue,
                Library.totalGames AS TotalGames
            FROM 
                Library
            JOIN 
                UserLibrary ON Library.ID = UserLibrary.libraryID
            WHERE 
                UserLibrary.userID = %s
                 """)
        
        cursor.execute(query, (id,))
        results = cursor.fetchall()
        return jsonify(results)

    except mysql.connector.Error as err:
        return f"Error: {err}"

    
@app.route("/developers-Publishers")
def developers():
    try:
        cursor.execute("""
                    SELECT 
                        Game.ID,
                        Game.gameName,
                        Developer.developerName,
                        Developer.multiStudio,
                        Publisher.publisherName,
                        Publisher.ownership
                    FROM 
                        Game
                    LEFT JOIN 
                        Developer ON Game.ID = Developer.gameID
                    LEFT JOIN 
                        Publisher ON Game.ID = Publisher.gameID;
                       """)

        results = cursor.fetchall()
        for j, i in enumerate(results):
            if (i[3] == 1):
                multibool = True
            elif (i[3] == 0):
                multibool = False
            if (i[5] == 1):
                ownbool = True
            elif (i[5] == 0):
                ownbool = False
            results[j] = list(i)
            results[j][3] = multibool
            results[j][5] = ownbool
            results[j] = tuple(results[j])

        return jsonify(results)
    except mysql.connector.Error as err:
        return f"Error: {err}"
    

@app.route("/users")
def users():
    try:
        cursor.execute("SELECT username, password FROM PersonalInfo")
        results = cursor.fetchall()
        return jsonify(results)
    except mysql.connector.Error as err:
        return f"Error: {err}"

@app.route("/edit", methods=["POST"])
def edit():
    """
    Add or remove a game from the user's library based on its presence.
    """
    try:
        data = request.json
        user_id = userFind()
        game_id = data

        if not user_id or not game_id:
            return jsonify({"error": "Both userID and gameID are required"}), 400

        # Check if the user has an associated library
        query_fetch_library = """
            SELECT libraryID
            FROM UserLibrary
            WHERE userID = %s
            LIMIT 1
        """
        cursor.execute(query_fetch_library, (user_id,))
        library_id_row = cursor.fetchone()

        if not library_id_row:
            return jsonify({"error": f"No library found for userID: {user_id}"}), 404

        library_id = library_id_row[0]

        # Check if the game is already in the library
        query_check_game = """
            SELECT 1
            FROM LibraryGame
            WHERE libraryID = %s AND gameID = %s
        """
        cursor.execute(query_check_game, (library_id, game_id))
        game_in_library = cursor.fetchone()

        if game_in_library:
            # Game is already in the library, remove it
            query_remove_game = """
                DELETE FROM LibraryGame
                WHERE libraryID = %s AND gameID = %s
            """
            cursor.execute(query_remove_game, (library_id, game_id))
            message = "Game removed from the user's library."
        else:
            # Game is not in the library, add it
            query_add_game = """
                INSERT INTO LibraryGame (libraryID, gameID, userRating)
                VALUES (%s, %s, %s)
            """
            cursor.execute(query_add_game, (library_id, game_id, 0.0))
            message = "Game added to the user's library."

        connection.commit()
        return jsonify({"message": message}), 200

    except Exception as e:
        connection.rollback()
        return jsonify({"error": str(e)}), 500


"""
BELLOW HERE ARE ALL CRUD ENDPOINTS
"""

@app.route('/add', methods=['POST'])
def add_record():
    """
    Endpoint to add a new record.
    Dynamically inserts values into multiple tables based on the provided fields.
    Retrieves `library.ID` based on the given `userID`.
    """
    try:
        # Extract the payload from the request
        data = request.json

        # Validate required fields for Game (as it's the primary entity)
        required_fields = ["gameName", "gameValue", "year"]
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing required field: {field}"}), 400

        user_id = userFind()

        # Fetch the library.ID associated with the userID
        query_fetch_library = """
            SELECT libraryID
            FROM UserLibrary
            WHERE userID = %s
            LIMIT 1
        """
        cursor.execute(query_fetch_library, (user_id,))
        library_id_row = cursor.fetchone()

        if not library_id_row:
            return jsonify({"error": f"No library found for userID: {user_id}"}), 404

        library_id = library_id_row[0]  # Extract the library ID

        # Define mappings for tables and their fields
        table_fields = {
            "Game": ["gameName", "gameValue", "year"],
            "LibraryGame": ["userRating"],
            "Developer": ["developerName", "multiStudio"],
            "Publisher": ["publisherName", "ownership"],
            "Completion": ["personalTime", "achievementPercent", "completed"],
            "GamePlatform": ["platformName", "platformSystem", "application"],
            "Genre": ["genreName", "theme", "perspective"],
        }

        # Insert into Game table first to get the new game ID
        game_fields = table_fields["Game"]
        game_values = [data[field] for field in game_fields if field in data]
        query_game = f"INSERT INTO Game ({', '.join(game_fields)}) VALUES ({', '.join(['%s'] * len(game_fields))})"
        cursor.execute(query_game, game_values)
        game_id = cursor.lastrowid  # Get the auto-generated ID for the new game record

        # Insert into LibraryGame table with the valid libraryID
        if "userRating" in data:
            query_library_game = """
                INSERT INTO LibraryGame (libraryID, gameID, userRating)
                VALUES (%s, %s, %s)
            """
            cursor.execute(query_library_game, (library_id, game_id, data["userRating"]))

        # Insert into other tables
        for table, fields in table_fields.items():
            if table in ["Game", "LibraryGame"]:  # Skip already-handled tables
                continue

            insert_fields = [field for field in fields if field in data]
            insert_values = [data[field] for field in insert_fields if field in data]

            if insert_fields:  # Only insert if there are valid fields
                if table == "Completion":
                    insert_fields.append("userID")  # Add userID as a foreign key
                    insert_values.append(user_id)  # Append the provided userID

                insert_fields.append("gameID")  # Add gameID as a foreign key
                insert_values.append(game_id)  # Append the new game ID to the values

                query = f"INSERT INTO {table} ({', '.join(insert_fields)}) VALUES ({', '.join(['%s'] * len(insert_fields))})"
                print(f"Executing query: {query}")  # Debugging statement
                print(f"With parameters: {insert_values}")  # Debugging statement
                cursor.execute(query, insert_values)

        # Commit the transaction
        connection.commit()
        return jsonify({
            "message": "Record added successfully",
            "gameID": game_id,
            "libraryID": library_id,
            "userID": user_id
        }), 201

    except Exception as e:
        # Roll back any changes in case of an error
        connection.rollback()
        return jsonify({"error": str(e)}), 500



@app.route('/update', methods=['PUT'])
def update_record():
    """
    Endpoint to update a record.
    Updates only the provided fields in the request payload.
    """
    try:
        # Extract the payload from the request
        data = request.json
        user_id = data.get('id')

        # Validate required field
        if not user_id:
            return jsonify({"error": "User ID is required"}), 400

        # Define mappings for tables and their fields
        table_fields = {
            "Game": ["gameName", "gameValue", "year"],
            "LibraryGame": ["userRating"],
            "Developer": ["developerName", "multiStudio"],
            "Publisher": ["publisherName", "ownership"],
            "Completion": ["personalTime", "achievementPercent", "completed"],
            "GamePlatform": ["platformName", "platformSystem", "application"],
            "Genre": ["genreName", "theme", "perspective"],
        }

        # Iterate through tables and dynamically generate updates
        for table, fields in table_fields.items():
            updates = []
            params = []

            for field in fields:
                if field in data:
                    updates.append(f"{field} = %s")
                    params.append(data[field])

            if updates:
                # Append the identifier for the WHERE clause
                if table == "Game":
                    where_clause = "ID = %s"
                else:
                    where_clause = "gameID = %s"

                params.append(user_id)
                query = f"UPDATE {table} SET {', '.join(updates)} WHERE {where_clause}"
                print(f"Executing query: {query}")  # Debugging statement
                print(f"With parameters: {params}")  # Debugging statement
                cursor.execute(query, params)

        # Commit changes to the database
        connection.commit()
        return jsonify({"message": "Record updated successfully"}), 200

    except Exception as e:
        # Roll back any changes in case of an error
        connection.rollback()
        return jsonify({"error": str(e)}), 500


@app.route('/remove', methods=['DELETE'])
def remove_record():
    """
    Endpoint to remove a user record.
    Expects JSON payload with 'id'.
    """
    data = request.json
    game_id = data.get('id')

    if not game_id:
        return jsonify({"message": "ID is required"}), 400

    try:
        query = "DELETE FROM Game WHERE ID = %s"
        cursor.execute(query, (game_id,))
        connection.commit()

        if cursor.rowcount == 0:
            return jsonify({"message": "Record not found"}), 404

        return jsonify({"message": "Record removed successfully"}), 200
    except mysql.connector.Error as err:
        return jsonify({"message": f"Database error: {err}"}), 500

"""
END OF CRUD ENDPOINTS
"""

@app.route('/close')
def close():
    cursor.close()
    connection.close()

if __name__ == "__main__":
    app.run(debug=True)
    
    print(DB_USER, DB_PASSWORD, DB_HOST, DB_NAME)

