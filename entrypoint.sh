#!/bin/bash

# Run CUPS as non-root user within a container.

# Ensure our user is in the /etc/passwd file
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
    if [ $? -ne 0 ]; then
      echo "Failed to add user to /etc/passwd. Ensure execution user is part of GID 0."
    fi
  fi
fi

# Start CUPS server
/usr/sbin/cupsd -f &

# Function to check lpstat status
lpstat_check ()
{
  lpstat -h 127.0.0.1:6631 -r | egrep -q 'scheduler is running'
}

# Wait for CUPS to come online
CUPS_TIMEOUT=30
i=0
while [ ${i} -lt ${CUPS_TIMEOUT} ] && ! lpstat_check; do
  i=$(($i+1))
  sleep 1
done

# Check if CUPS came online successfully
if lpstat_check; then
  echo "CUPS is now running."
  # Put other necessary tasks, like connecting to devices and print queues
  # below this line.
else
  echo "CUPS failed to run; exiting."
  exit 1
fi

while true; do
  sleep 60
done
