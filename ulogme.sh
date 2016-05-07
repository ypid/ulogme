#!/bin/bash

trap 'kill $(jobs -p)' EXIT

if [ "$(uname)" == "Darwin" ]; then
  # This is a Mac
  ./osx/run_ulogme_osx.sh
else
  # Assume Linux
  ./keyfreq.sh &
  ./logactivewin.sh
fi
