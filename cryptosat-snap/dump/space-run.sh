#!/usr/bin/bash
set -e

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

###############################################################################
# Run experiments
###############################################################################

./pos-space-run.sh &
./bounce-space-run.sh &
./drand-space-run.sh --space_ip $SPACE_IP &
./gotham-space-run.sh &

###############################################################################

# Wait for all running background jobs to finish
wait $(jobs -rp)

echo "Experiment completed (v2)"
