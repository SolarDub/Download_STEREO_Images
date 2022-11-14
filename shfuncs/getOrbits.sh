#!/bin/bash

# getOrbits
# Get list of orbit numbers from user (Fixed at 10 for now)
function getOrbits() {


  if [[ $SWS == *"-s"* ]]    # Perform only if a specific star has been requested
  then

    Z=0           # Set up zero variable for padding
    ORBS=99       # Default to an orbit value that may never be used

    while [[ $ORBS > "17" ]] && [[ $ORBS != "0" ]]; do   # Orbits 1-17 available. 0 to quit.

      PRMPT1="Enter orbit (up to 17)"  # Create user prompt text
      PRMPT2="(use switch --ohelp to list orbits and dates)"
      PRMPT3="Enter 0 to quit."

      ORBENT="$(prompt "$PRMPT1\n$PRMPT2\n$PRMPT3")"  # Prompt user to enter value

      ORB="${ORBENT%" "}"                   # Remove trailing space

      if [[ $ORB -lt 10 && $ORB -ne 0 ]]; then   # Pad orbit number to two digits, if less than zero
        ORBS=${Z}${ORB}
      else
        ORBS=${ORB}
      fi

    done

    echo $ORBS   # Return entered orbit number

  else
    echo ""      # Return nothing
  fi

}

export -f getOrbits
