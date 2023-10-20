#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Truncate table
$PSQL " TRUNCATE TABLE teams, games"

# Read lines in csv
while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  # Skip first line
  if [[ $YEAR == "year" ]]
  then
    continue
  fi

  # Get id of winner team
  WINNERID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  # If team not in table insert the team
  if [ -z "$WINNERID" ]
  then
    $PSQL " INSERT INTO teams(name) VALUES('$WINNER')"
    echo inserted $WINNER into teams

    # Get the new team id
    WINNERID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
  
  # Get id of opposing team
  OPPONENTID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  # If team not in table insert the team
  if [ -z "$OPPONENTID" ]
  then
    $PSQL " INSERT INTO teams(name) VALUES('$OPPONENT')"
    echo Inserted $OPPONENT into teams
    # Get the new team id
    OPPONENTID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi
  # Insert the game into games
  $PSQL " INSERT INTO games(winner_id, opponent_id, winner_goals, opponent_goals, year, round) 
  VALUES($WINNERID, $OPPONENTID, $WINNER_GOALS, $OPPONENT_GOALS, $YEAR, '$ROUND')"
  echo Inserted $WINNER_GOALS - $OPPONENT_GOALS ,$ROUND, $YEAR into games

done < games.csv


