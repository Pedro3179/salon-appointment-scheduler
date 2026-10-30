#!/bin/bash

# This script makes an appointment at a salon

PSQL='psql -U freecodecamp -d salon --no-align --tuples-only -c'

SERVICES_MENU () {
  if [[ -z $1 ]]
  then
    # Get the service ID and name
    echo -e "\n~~~~~ Welcome to Spa da Beleza ~~~~~\n"

    AVAILABLE_SERVICES=$( $PSQL "SELECT * FROM services ORDER BY service_id;" )
    
    # Print each service id and name in a formatted manner
    echo "$AVAILABLE_SERVICES" | while IFS="|" read ID NAME
    do
      echo "$ID) $NAME"

    done

    echo -e "\nSelect a service:"

    read SERVICE_ID_SELECTED
    
  else
    echo -e "\n$1"

    SERVICES_MENU

  fi

  SERVICE=$( $PSQL "SELECT * FROM services WHERE service_id=$SERVICE_ID_SELECTED;" )
  
  if [[ -z $SERVICE ]]
  then
    SERVICES_MENU 'Please select a valid option.'
  
  fi

  # Ask for the customer's phone
  echo -e "\nEnter your phone number:"

  read CUSTOMER_PHONE

  # Search for the customer's name in the database
  CUSTOMER_NAME=$( $PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';" )
    
  # If it is not found, ask for the customer's name
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nPlease enter your name:"

    read CUSTOMER_NAME

    # Add name and phone to the customers table
    REGISTERED_CUSTOMER=$( $PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME');" )

  fi

  # Ask for the time of the appointment
  echo -e "\nWhat time works best for you?"

  read SERVICE_TIME

  # Create an appointment in the appropriate table
  CUSTOMER_ID=$( $PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME';" )
    
  BOOKED_SERVICE=$( $PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');" )

  SERVICE_NAME=$( echo $SERVICE | sed 's/.|//' )

  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  exit 0
} 

SERVICES_MENU