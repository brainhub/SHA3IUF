#!/bin/sh

THIS_SCRIPT=$(readlink -f $0)
P=`dirname $THIS_SCRIPT`
TOP=`dirname $P`

cd  $TOP
make sha3fuzz && ./sha3fuzz $P/seeds -max_total_time=100
