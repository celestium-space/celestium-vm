#!/bin/bash
set -e

STATE_DIR=/home/ubuntu/cryptosat/gotham/ground
OUTPUT_DIR=/home/ubuntu/cryptosat_external/gotham/ground/output
INPUT_FILE=$STATE_DIR/tx_unsigned
OUTPUT_FILE=$OUTPUT_DIR/tx_signed

# Parse command line flags
while [ $# -gt 0 ]; do
  case "$1" in
    --space_ip)
      SPACE_IP="$2"
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

mkdir -p $OUTPUT_DIR

pkill gotham-client || true

# Client should be started in the same directory where ground.tar was unpacked.
cd $STATE_DIR

gotham-city.gotham-client \
  --endpoint http://$SPACE_IP:8000 \
  transaction sign \
  -i $INPUT_FILE \
  -o $OUTPUT_FILE \
  --force-yes \
  --hash f860f69633d4433b73d7fe430be7c9e05de2f46142c93526208fb3deb180f4f7 \
  2>&1 | tee $OUTPUT_DIR/gotham-client.log

mkdir -p $OUTPUT_DIR
