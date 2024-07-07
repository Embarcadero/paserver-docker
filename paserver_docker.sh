#!/bin/bash

./paserver -password=$PA_SERVER_PASSWORD
status=$?
if [ $status -ne 0 ]; then
	echo "Failed to start paserver: $status"
	exit $status
fi

while sleep 10; do
	ps aux |grep paserver |grep -q -v grep
	PA_SERVER_STATUS=$?
	echo $PA_SERVER_STATUS
	if [ $PA_SERVER_STATUS -eq 0 ]; then
		echo "Complete!"
		exit 1
	fi
done
