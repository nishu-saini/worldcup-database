#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Delete data rows first in database if any..
echo $( $PSQL "TRUNCATE games, teams" )

# ADD data into teams table..
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $WINNER != 'winner' ]]
    then
      # get teams id if already existed..
      TEAM_ID1="$( $PSQL "SELECT team_id FROM teams WHERE name = '$WINNER' " )"
      TEAM_ID2="$( $PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT' " )"

      # if team 1 not in teams..
      if [[ -z $TEAM_ID1 ]]
      then
        insert_name="$( $PSQL "INSERT INTO TEAMS(name) VALUES('$WINNER')" )"
        if [[ $insert_name == 'INSERT 0 1' ]]
        then
          echo "inserted into teams, $WINNER"
        fi

      fi

       # if team 2 not in teams..
      if [[ -z $TEAM_ID2 ]]
      then
        insert_team_name="$( $PSQL "INSERT INTO TEAMS(name) VALUES('$OPPONENT')" )"
        if [[ $insert_team_name == 'INSERT 0 1' ]]
        then
          echo "inserted into teams, $OPPONENT"
        fi
        
      fi

    fi
  done

# ADD data into games table..
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $WINNER != 'winner' ]]
    then
      # get winner team id..
      WINNER_ID="$( $PSQL "SELECT team_id FROM teams WHERE name = '$WINNER' " )"

      # get opponent team id..
      OPPONENT_ID="$( $PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT' " )"

      # insert row into games..
      insert_game="$( $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS )" )"
      if [[ $insert_game == 'INSERT 0 1' ]]
        then
          echo "inserted into games, $YEAR | $ROUND | $WINNER | $OPPONENT | $WINNER_GOALS | $OPPONENT_GOALS"
      fi

    fi
  done


