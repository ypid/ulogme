#!/bin/bash


# logs the key press frequency over 9 second window. Logs are written
# in logs/keyfreqX.txt every 9 seconds, where X is unix timestamp of 7am of the
# recording day.

LANG=en_US.utf8

helperfile='/dev/shm/keyfreqraw.txt'
## FIXME: Still potential security risk even when not logged to persistent storage.
## Maybe rewrite script in Python and count STDOUT directly and send SIGINT
## after 9 seconds.

mkdir -p logs

trap 'kill $(jobs -p)' EXIT

while true
do
  xinput test 11 > $helperfile &

  ## In case you can not get `xinput` to work. Note that you will need to run `showkey` as root.
  # showkey > $helperfile &

  # Work in windows of 9 seconds
  sleep 9

  # shellcheck disable=SC2046
  kill $(jobs -rp)
  # shellcheck disable=SC2046
  wait $(jobs -rp) 2>/dev/null

  # Count number of key release events
  num="$(grep --count release "$helperfile")"

  # Append unix time stamp and the number into file
  logfile="logs/keyfreq_$(python rewind7am.py).txt"
  echo "$(date +%s) $num" >> "$logfile"
  echo "logged key frequency: $(date) $num release events detected into $logfile"

done
