#!/usr/bin/bash
set -e

OUTPUT_DIR=/home/ubuntu/cryptosat_external/bounce/output

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

# process writes log files to working directory
cd $OUTPUT_DIR
bounce-blockchain.ground-station -a $SPACE_IP