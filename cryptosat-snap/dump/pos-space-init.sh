#!/bin/bash
set -e

EXTERNAL_PATH=/home/ubuntu/cryptosat_external
OUTPUT_DIR=$EXTERNAL_PATH/pos/output/
INPUT_DIR=$EXTERNAL_PATH/pos/input/
STATE_DIR=/home/ubuntu/cryptosat/pos
KEY_PATH=$STATE_DIR/cryptosat.key

mkdir -p $STATE_DIR
mkdir -p $OUTPUT_DIR
mkdir -p $INPUT_DIR

cryptosat-iss-pos init --key=$KEY_PATH --force | tee $OUTPUT_DIR/init.log
