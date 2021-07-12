#!/bin/bash
set -e

STATE_DIR=/home/ubuntu/cryptosat/gotham/space
OUTPUT_DIR=/home/ubuntu/cryptosat_external/gotham/space/output
NUM_SECONDS=300
INTERVAL_SECONDS=10
SPACE_PORT=8000

mkdir -p $OUTPUT_DIR

pkill server_exec || true
rm -f $STAT_DIR/db/LOCK

# Server should be started in the same directory where space.tar was unpacked.
cd $STATE_DIR
ROCKET_PORT=$SPACE_PORT gotham-city.gotham-server & \
  2>&1 | tee $OUTPUT_DIR/gotham-server.log

for i in $(seq 0 $INTERVAL_SECONDS $NUM_SECONDS); do
  echo "Gotham server running... ($i/$NUM_SECONDS seconds elapsed)"
  sleep $INTERVAL_SECONDS

  # exit early if server was terminated.
  NUM_BACKGROUND_JOBS=$(jobs -l | wc -l)
  if [ $NUM_BACKGROUND_JOBS -eq 0 ]; then
    break
  fi

done

echo "Gotham server terminated"

kill %