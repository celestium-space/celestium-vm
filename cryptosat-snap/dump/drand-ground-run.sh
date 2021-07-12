#!/bin/bash
set -e

SHARED_SECRET="hATDw3MaFnqzl9Go3yskOrg9eTAs6SXJr80tJcZ9p9x/qDfXg5eEpeundKp9"
STATE_DIR=/home/ubuntu/cryptosat/drand/
SECRET_PATH=$STATE_DIR/ground_secret
KEYS_DIR=$STATE_DIR/ground_keys
GROUND_PORT=8654
SPACE_PORT=8655
CONTROL_PORT=9655
OUTPUT_DIR=/home/ubuntu/cryptosat_external/drand/output
GROUP_FILEPATH=$OUTPUT_DIR/ground_group.toml
NUM_SECONDS=300
INTERVAL_SECONDS=10

# Parse command line flags
while [ $# -gt 0 ]; do
  case "$1" in
    --space_ip)
      SPACE_IP="$2"
      ;;
    --ground_ip)
      GROUND_IP="$2"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
  shift
done

if [ -z "$SPACE_IP" ]
then
  echo "ERROR: Space IP address not provided."
  echo "Please supply the address of the space station using the --space_ip flag";
  exit 1
fi

if [ -z "$GROUND_IP" ]
then
  echo "ERROR: Ground IP address not provided.";
  echo "Please supply the address of the ground station using the --ground_ip flag";
  exit 1
fi

# comment this out when testing both the ground and iss scripts on the
# same machine. The additional true is used for exiting without an error code
# in case no process is currently running.
pkill -x drand || true


rm -rf $STATE_DIR
mkdir -p $KEYS_DIR
mkdir -p $STATE_DIR
mkdir -p $OUTPUT_DIR

echo $SHARED_SECRET > $SECRET_PATH

drand generate-keypair \
  --folder $KEYS_DIR \
  --tls-disable $GROUND_IP:$GROUND_PORT \
  2>&1 | tee $OUTPUT_DIR/ground_generate-keypair.log

drand start \
  --tls-disable \
  --folder $KEYS_DIR \
  --control $CONTROL_PORT \
  > $OUTPUT_DIR/ground_start.log &

sleep 1

drand share \
  --connect $SPACE_IP:$SPACE_PORT \
  --nodes 2 \
  --threshold 2 \
  --secret-file $SECRET_PATH \
  --period 10s \
  --tls-disable \
  --control $CONTROL_PORT \
  2>&1 | tee $OUTPUT_DIR/ground_share.log

drand show group \
  --out $GROUP_FILEPATH \
  --control $CONTROL_PORT \
  2>&1 | tee $OUTPUT_DIR/ground_show_group.log

for i in $(seq 0 $INTERVAL_SECONDS $NUM_SECONDS); do
  drand get public $GROUP_FILEPATH >> $OUTPUT_DIR/ground_get.log
  echo "DRAND process running... ($i/$NUM_SECONDS seconds elapsed)"
  sleep $INTERVAL_SECONDS

  # exit early if server was terminated.
  NUM_BACKGROUND_JOBS=$(jobs -l | wc -l)
  if [ $NUM_BACKGROUND_JOBS -eq 0 ]; then
    break
  fi

done

echo "DRAND process terminated"

kill %

