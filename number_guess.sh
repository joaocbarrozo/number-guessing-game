#!/bin/bash
# PSQL variable to access the database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# Randomnumber to guess
NUMBER=$(( ($RANDOM % 1000) + 1 ))
# Read user name
echo Enter your username:
read -r USERNAME
# Check if user already exists
CHECK_USERNAME=$($PSQL "SELECT * FROM users WHERE name LIKE '$USERNAME'")
if [[ -z $CHECK_USERNAME ]]; then
  $PSQL "INSERT INTO users(name) VALUES('$USERNAME')"
  echo Welcome, $USERNAME! It looks like this is your first time here.
else
  # Get user stats
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games JOIN users USING(user_id) WHERE name LIKE '$USERNAME'")
  BEST=$($PSQL "SELECT MIN(attempts) FROM games JOIN users USING(user_id) WHERE name LIKE '$USERNAME'")
  echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST guesses.
fi
#Start guessing
echo Guess the secret number between 1 and 1000:
USER_ID=$($PSQL "SELECT user_id FROM users WHERE name LIKE '$USERNAME'")
ATTEMPTS=0
# Function to tries
try() {
  read -r TRY
  # Check if TRY is a number
  if [[ $TRY =~ ^[0-9]+$ ]]; then
    echo is a number
  else
    echo That is not an integer, guess again:
    try
  fi
}
try
