#!/bin/bash

####################
# Import functions #
####################

SRCBASHDIR="./src/Bash/"

source ${SRCBASHDIR}"prompt.sh"
source ${SRCBASHDIR}"update.sh"
source ${SRCBASHDIR}"getVal.sh"
source ${SRCBASHDIR}"ifHelp.sh"
source ${SRCBASHDIR}"getOrbits.sh"
source ${SRCBASHDIR}"getStarname.sh"
source ${SRCBASHDIR}"getCoords.sh"
source ${SRCBASHDIR}"checkCoords.sh"
source ${SRCBASHDIR}"getDate.sh"
source ${SRCBASHDIR}"getMonthLDay.sh"

SWS=${*}   # (Global) Array of switches

# Check if '--help' switch has been activated
ifHelp

###################################
# SET UP FILE AND DIRECTORY PATHS #
###################################

echo ' '
echo 'Setting up directory paths & URL...'

# Absolute path to this script
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DIRSFILENM="directory_file_lists.txt"
DIRSFILENAME=${BASEDIR}/"tables"/${DIRSFILENM}

# Initialize empty key/value (global) arrays
KEYS=()  # Define empty key (input value description) array
VALS=()  # Define empty value (input file/directory) array

#
# Read each key/value pair line from list file
# separated with '=' delimiter
while IFS='=', read -r KEY VAL; do

  # Execute if the list of input switches is not empty
  if [[ $SWS == *"-d"* ]] || [[ $SWS == *"-u"* ]]
  then
    # Update directories/filenames as signified by switches
    # update function inputs $SWS, $KEY, $VAL, outputs $OUTVAL
    OUTVAL="$(update)"
  else
    OUTVAL="${VAL%"/"}"   # Remove trailing "/"
  fi

  # Add keys/values to respective arrays
  KEYS+=($KEY)
  VALS+=($OUTVAL)

done < "$DIRSFILENAME"

# Number of defined directories
NUM_VALS=${#VALS[@]}

# Execute if the list of switches is not empty
if [[ $SWS == *"-d"* ]] || [[ $SWS == *"-u"* ]]
then
  rm "$DIRSFILENAME"    # Remove the directory/file text file ready to be rewritten

# Write directory and filenames
  for (( I=0; I<${NUM_VALS}; I++)); do
    echo "${KEYS["${I}"]}=${VALS["${I}"]}" >> "$DIRSFILENAME"
  done
fi

##################################################
# Read in directories and URL to named variables #
##################################################

# getVal function inputs $KEYS, $name, outputs $VALS

# Base path to this script, programs and executables
name='THIS_SCRIPT_DIR'
BASDIR="$(getVal)"

# Base path to STEREO HI-1A image data
name='HI1A_DATA_DIR'
HI1ADIR="$(getVal)"

# Base URL to STEREO HI-1A image data
name='HI1A_DATA_URL'
HI1AURL="$(getVal)"

echo ${BASDIR}
echo ${HI1ADIR}
echo ${HI1AURL}
echo ""

# Exit if only directory/URL path changes are to be made
if [[ $SWS == *"-d"* ]] || [[ $SWS == *"-u"* ]]
then
  exit
fi

# Cannot choose automated date range in which star appears during a give orbit
# and user-definable date range at the same time
if [[ $SWS == *"-s"* ]] && [[ $SWS == *"-r"* ]]
then

  echo ""
  echo "The date range (--range) and the star selection (--star) cannot be used at the same time."
  echo ""

  exit

fi

########################################################################
# Get star name & coordinates, and orbit during which to download data #
########################################################################
if [[ $SWS == *"-s"* ]] || [[ $SWS == *"-c"* ]]
then

  #############################
  # Prompt user for star name #
  #############################
  star="$(getStarname)"
  if [[ $star == "0" ]]; then
    exit
  else
    echo "Acquiring coordinates of "${star}":"
    # Perform star coordinate acquisition
    coords="$(getCoords $star)"
    echo "Coordinates of "${star}": "${coords}
    echo ""
    check="$(checkCoords $coords)"
    if [[ ${check} == 1 ]]; then
      echo ${star}" lies outside image bounds. Exiting."
      echo ""
      exit
    fi
  fi

  if [[ $SWS == *"-c"* ]]; then
    exit
  fi

  starname="$(echo -e "${star}" | tr -d '[:space:]')"   # Remove remaining whitespaces


  #######################################################
  # Prompt user for orbit during which to download data #
  #######################################################
  ORBS="$(getOrbits)"
  if [[ $ORBS == "0" ]]; then
    exit
  else
    echo "Orbit selected: ${ORBS}"
    echo ""
  fi

  DATES=$(./bin/getDateRange $starname $coords $BASDIR $HI1ADIR $ORBS)
  echo ${DATES}
  STARTDATE=${DATES:0:8}
  ENDDATE=${DATES:9:8}

fi

###########################################################
# Routine to input start-/end-date data range to download #
###########################################################
if [[ $SWS == *"-r"* ]]
then

  starname=""
  ORBS=""

  flag=0
  STARTDATE="$(getDate $flag)"
  if [[ $STARTDATE == "0" ]]; then
    exit
  fi

  flag=1
  ENDDATE="$(getDate $flag)"
  if [[ $ENDDATE == "0" ]]; then
    exit
  fi


fi

YSTART=${STARTDATE:0:4}
MSTART=${STARTDATE:4:2}
DSTART=${STARTDATE:6:2}
YEND=${ENDDATE:0:4}
MEND=${ENDDATE:4:2}
DEND=${ENDDATE:6:2}
echo "Date range (YYYY/MM/DD)"
echo "Start: ${YSTART}/${MSTART}/${DSTART}"
echo "End: ${YEND}/${MEND}/${DEND}"

if [[ $YEND < $YSTART ]] \
|| [[ $YEND == $YSTART && $MEND < $MSTART ]] \
|| [[ $YEND == $YSTART && $MEND == $MSTART && $DEND < $DSTART ]]
then
  echo ""
  echo "Range end date occurs before start date. Quitting."
  echo ""
  exit
fi

#################
# Download data #
#################
echo ' '
echo 'Entering download routine...'

readonly Z=0         # Set zero variable

FILEEXT=.fts

for ((yr=${YSTART}; yr<=${YEND}; yr=yr+1))
do

  YEAR=${yr}
  YEARDIR=${HI1ADIR}/${YEAR}/

  if [ ! -d "${YEARDIR}" ]; then
    mkdir ${YEARDIR}
  fi

  if [ $yr == ${YEND} ]
  then
    LMTH=${MEND}
  else
    LMTH=12
  fi

  for ((mt=${MSTART#0}; mt<=${LMTH#0}; mt=mt+1))
  do

    if [ $mt -lt 10 ]
    then
      MONTH=${Z}${mt}
    else
      MONTH=${mt}
    fi

    MONTHDIR=${YEARDIR}${MONTH}/

    if [ ! -d "${MONTHDIR}" ]; then
      mkdir ${MONTHDIR}
    fi

    if [[ $MONTH == ${MEND} ]] && [[ $yr == ${YEND} ]]
    then
      LDAY=${DEND}
    else
      LDAY="$(getMonthLDay ${mt})"
    fi

    for ((dy=${DSTART#0}; dy<=${LDAY#0}; dy=dy+1))
    do

      if [ $dy -lt 10 ]
      then
        DAY=${Z}${dy}
      else
        DAY=${dy}
      fi

      DAYDIR=${MONTHDIR}${DAY}/

      if [ ! -d "${DAYDIR}" ]; then
        mkdir ${DAYDIR}
      fi

      cd ${DAYDIR}

      URLDATE=${YEAR}${MONTH}${DAY}

      echo ' '
      echo "<<< Downloading from: "${HI1AURL}/${URLDATE}/
      echo ">>> Saving to:   "${DAYDIR}
      echo ' '

      if [[ $SWS != *"--test"* ]]
      then
        wget -q -r -np -nd -e robots=off -R "index.html*" -A "*24h1A_br01.fts" ${HI1AURL}/${URLDATE}/

        for f in *.fts
        do
          mv -- "$f" "${f%.*}.fits" # Change all .fts files to .fits
        done

       fi

    done

    DSTART=1 # At the end of each month, ensure that the first day of the month is reset

  done

  MSTART=1 # At the end of each year, ensure that the first month of the year is reset

done
