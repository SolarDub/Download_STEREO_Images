#!/bin/bash

# update
# If "-d (--dir)"/"-u (--url)" switch is included, prompt user to enter directory/url names
function update() {

# Follow-on line with backslash and nothing after
  if [[ $SWS == *"-d"* && $KEY == *"_DIR"* ]] \
  || [[ $SWS == *"-u"* && $KEY == *"_URL"* ]]
  then
    local PRMPT="Enter "${KEY}":"             # Create user prompt text
    local VALENT="$(prompt "$PRMPT" "$VAL")"  # Prompt user to accept or change value
    echo "${VALENT%"/"}"                # Remove trailing / for adding to values array
  else
    echo "${VAL%"/"}"                   # Remove trailing / for adding to values array
  fi

}

export -f update
