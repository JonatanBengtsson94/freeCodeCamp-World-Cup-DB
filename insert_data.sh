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
  # Get id of winner team
  WINNERID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  # If team not in table insert the team
  if [ -z "$WINNERID" ]
  then
    $PSQL " INSERT INTO teams(name) VALUES('$WINNER')"
    echo inserted $WINNER into teams
  fi
  # Get id of opposing team
  OPPONENTID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  # If team not in table insert the team
  if [ -z "$OPPONENTID" ]
  then
    $PSQL " INSERT INTO teams(name) VALUES('$OPPONENT')"
    echo inserted $OPPONENT into teams
  fi
  echo $YEAR
  echo $ROUND
  echo $WINNER_GOALS
  echo $OPPONENT_GOALS
done < games.csv


