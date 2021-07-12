#!/usr/bin/bash
set -e

NUM_SECONDS=300
INTERVAL_SECONDS=10
OUTPUT_DIR=/home/ubuntu/cryptosat_external/bounce/output

mkdir -p $OUTPUT_DIR

pkill space-station || true

# process writes log files to working directory
cd $OUTPUT_DIR
bounce-blockchain.space-station -a 0.0.0.0 &

for i in $(seq 0 $INTERVAL_SECONDS $NUM_SECONDS); do
  echo "Bounce server running... ($i/$NUM_SECONDS seconds elapsed)"
  sleep $INTERVAL_SECONDS

  # exit early if server was terminated.
  NUM_BACKGROUND_JOBS=$(jobs -l | wc -l)
  if [ $NUM_BACKGROUND_JOBS -eq 0 ]; then
    break
  fi

done

echo "Bounce server terminated"

kill %
