#!/bin/bash

# This script makes an appointment in a salon

PSQL='psql -U freecodecamp -d salon --no-align --tuples-only -c'

SERVICES_MENU () {
  if [[ -z $1 ]]
  then

    # Get the service id and name
    AVAILABLE_SERVICES=$( $PSQL "SELECT * FROM services;")

    # Print each service id and name in a formatted manner
    echo -e "\n~~~~~ Welcome to Spa da Beleza ~~~~~\n"

    echo -e "$AVAILABLE_SERVICES" | while IFS="|" read ID NAME
    do
      echo "$ID) $NAME"

    done

    echo -e "\nSelect a service:"

    read SERVICE_ID_SELECTED
  
  else
    echo $1

    SERVICES_MENU

  fi

  SERVICE_ID=$( $PSQL "SELECT * FROM services WHERE service_id=$SERVICE_ID_SELECTED;" )
  
  if [[ -n $SERVICE_ID ]]
  then
    echo 'Service found.'
  
  else
    SERVICES_MENU 'Please select a valid option.'
  
  fi

} 

SERVICES_MENU