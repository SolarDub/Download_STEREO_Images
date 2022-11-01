#!/bin/bash

# getVal
# Get value assigned to given key name
function getMonthLDay() {

  if [ $mt -eq 2 ]
  then
    rem=$((YEAR%4))
    if [ $rem -eq 0 ]
    then
      LDAY=29
    else
      LDAY=28
    fi
  elif [ $mt -eq 4 ] || [ $mt -eq 6 ] || [ $mt -eq 9 ] || [ $mt -eq 11 ]
  then
    LDAY=30
  else
    LDAY=31
  fi

  echo $LDAY

}

export -f getMonthLDay
