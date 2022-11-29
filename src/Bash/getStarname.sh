#!/bin/bash

# getStarname
# Get Starname from user
function getStarname() {

  if [[ $SWS == *"-s"* ]]   # Perform only if star selection is requested
  then

    PRMPT1="Enter single star name"  # Create user prompt text
    PRMPT2="(Coordinates will be obtained automatically)"
    PRMPT3="Enter 0 to quit."

    STARENT="$(prompt "$PRMPT1\n$PRMPT2\n$PRMPT3")"  # Prompt user to enter value

    starname="${STARENT%" "}"                    # Remove trailing space

    echo $starname   # Return entered starname

  else

    echo ""          # Return nothing

  fi
}

export -f getStarname
