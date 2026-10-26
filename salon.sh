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
    echo -e "\n$1"

    SERVICES_MENU

  fi

  SERVICE_ID=$( $PSQL "SELECT * FROM services WHERE service_id=$SERVICE_ID_SELECTED;" )
  
  if [[ -z $SERVICE_ID ]]
  then
    SERVICES_MENU 'Please, select a valid option.'
  
  fi

  # Ask for the customer phone
  echo -e "\nEnter your phone number:"

  read CUSTOMER_PHONE

  # Search for the customer phone in the database
  REGISTERED_PHONE=$( $PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';" )
    
  # If negative, ask for the customer name
  if [[ -z $REGISTERED_PHONE ]]
  then
    echo -e "\nPlease, enter your name:"

    read CUSTOMER_NAME

    # Add name and phone to the customers table
    REGISTERED_NAME=$( $PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME');" )

  fi

  # Ask for the time of the appointment
  # Create an appointment in the appropriate table


} 

SERVICES_MENU