#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
if [[ $1 ]]
then
  #check if number or not
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_DETAILS=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1")
  else
    #check if symbol or not
    if [[ $(echo $1 | wc -c) < 4 ]]
    then
      ELEMENT_DETAILS=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$1'")
    else
      ELEMENT_DETAILS=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name = '$1'")
    fi
  fi

  if [[ -z $ELEMENT_DETAILS ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT_DETAILS | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_WEIGHT MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_WEIGHT amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi
