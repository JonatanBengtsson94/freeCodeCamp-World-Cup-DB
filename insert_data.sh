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
  # Get team ID
  TEAMID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  # If team not in table
  if [ -z "$TEAMID" ]
  then
    $PSQL " INSERT INTO teams(name) VALUES('$WINNER')"
  fi
  echo $TEAMID
  echo $WINNER
  echo $OPPONENT
  echo $YEAR
  echo $ROUND
  echo $WINNER_GOALS
  echo $OPPONENT_GOALS
done < games.csv


