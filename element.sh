PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Display function
DISPLAY_DATA() {
  if [[ -z $1 ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$1" | while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_PT BAR BOILING_PT BAR SYMBOL BAR NAME BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_PT celsius and a boiling point of $BOILING_PT celsius."
    done
  fi
}

INPUT_ARG=$1

if [[ -z $INPUT_ARG ]]
then
  echo "Please provide an element as an argument."
else
  # inupt argument is atomic number
  if [[ $INPUT_ARG =~ ^[0-9]+$ ]]
  then
    OUTPUT=$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $INPUT_ARG;")
    DISPLAY_DATA "$OUTPUT"
  else
    # input argument is symbol
    if [[ $(echo -n "$INPUT_ARG" | wc -m) -le 2 ]];
    then
      OUTPUT=$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$INPUT_ARG';")
      DISPLAY_DATA "$OUTPUT"
    else 
      # input argument is name
      OUTPUT=$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$INPUT_ARG';")
      DISPLAY_DATA "$OUTPUT"
    fi
  fi
fi
