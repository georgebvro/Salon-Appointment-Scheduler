#!/bin/bash
echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"
PSQL="psql --username=freecodecamp dbname=salon -t -c "

SERVICE_MENU () {
if [[ $1 ]]
then 
  echo -e "\n$1"
fi
SERVICE_LIST=$($PSQL "select * from services")
echo "$SERVICE_LIST" | while read SERVICE_ID BAR SERVICE_NAME
do 
  echo "$SERVICE_ID) $SERVICE_NAME"
done
read SERVICE_ID_SELECTED
}

SERVICE_MENU
SERVICE_NAME=$($PSQL "select name from services where service_id='$SERVICE_ID_SELECTED'")
if [[ -z $SERVICE_NAME ]]
then
  SERVICE_MENU "I could not find that service. What would you like today?"
fi

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi

echo -e "\nWhat time would you like your $(echo $SERVICE_NAME), $(echo $CUSTOMER_NAME)?"
read SERVICE_TIME
INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id, service_id, time) values((select customer_id from customers where phone='$CUSTOMER_PHONE'), $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
if [[ $INSERT_APPOINTMENT_RESULT == 'INSERT 0 1' ]]
then
  echo -e "\nI have put you down for a $(echo $SERVICE_NAME) at $SERVICE_TIME, $(echo $CUSTOMER_NAME)."
fi