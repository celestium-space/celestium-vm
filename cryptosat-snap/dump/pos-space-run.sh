#!/bin/bash
set -e

EXTERNAL_PATH=/home/ubuntu/cryptosat_external/pos
KEY_PATH=/home/ubuntu/cryptosat/pos/cryptosat.key
INPUT_DIR=$EXTERNAL_PATH/input
OUTPUT_DIR=$EXTERNAL_PATH/output

mkdir -p $INPUT_DIR
mkdir -p $OUTPUT_DIR

DATE=$(date '+%Y%m%d%H%M%S')
for INPUT_PATH in $INPUT_DIR/*; do
  [ -f "$INPUT_PATH" ] || continue
  INPUT_FILE=$(basename $INPUT_PATH)
  OUTPUT_FILE=$INPUT_FILE.output.$DATE
  OUTPUT_PATH=$OUTPUT_DIR/$OUTPUT_FILE
  printf "processing $INPUT_FILE... ";
  cryptosat-iss-pos process \
    --key=$KEY_PATH \
    --requests=$INPUT_PATH \
    --output=$OUTPUT_PATH \
    2>&1 | tee $OUTPUT_DIR/process.log.$DATE
  printf "done.\n"
done

echo "Proof of space process completed. Stored output files in $OUTPUT_DIR"
