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
  echo Welcome, $USERNAME
else
  echo Welcome back, $USERNAME
fi