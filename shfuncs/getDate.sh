#!/bin/bash

# getDate
# Get start/end dates from user
function getDate() {

  # Select whether the date to be entered is the start or end
  if [[ $flag == 0 ]]; then
    textstring="Start Date from which"
  else
    textstring="End Date upto which"
  fi

  # Prompt user for date. Re-prompt if date length is not 8 digits long, or if quit has been requested
  while [[ ${#DATE} -ne 8 ]] && [[ $DATE != "0" ]]; do

    PRMPT1="Enter "${textstring}" to acquire HI-1A data (YYYYMMDD)"  # Create user prompt text
    PRMPT2="(use switch --ohelp to list orbits and dates, if necessary)"
    PRMPT3="Enter 0 to quit."
    DATEENT="$(prompt "$PRMPT1\n$PRMPT2\n$PRMPT3")"  # Prompt user to enter value
    DATE="${DATEENT%" "}"                   # Remove trailing space

  done

  echo $DATE   # Return entered date

}

export -f getDate
