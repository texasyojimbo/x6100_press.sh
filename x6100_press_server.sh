#!/bin/bash

#################################################################
##
##  x6100_press_server.sh
##
##  Description: minimalist web server for x6100_press.sh
##
#################################################################
##
##  Version: 
##
##  1.0		initial release		December 8, 2022
##
#################################################################

PORT=8081
HOME_DIR="."
COMMAND="$HOME_DIR/x6100_press.sh"
WEBPAGE="$HOME_DIR/x6100_press.html"

while true; 
do
	{ echo -ne "HTTP/1.1 200 OK\n\n$(cat $WEBPAGE)"; } | nc -l -k -q 1 $PORT | grep "GET /" | grep -v favicon | awk '{print $2}' | sed -e 's/\// /g' | xargs -r -t $COMMAND  > /dev/null
done
