#!/bin/bash

MACHINE="c5.metal"
RUNTIME=3600

#RUNTIME=60
#./blending_stacking_airlines-binary.R machine=$MACHINE train_size=10000 max_runtime_secs=$RUNTIME > test.out

# Various training sizes
./blending_stacking_airlines-binary.R machine=$MACHINE train_size=100000000 max_runtime_secs=$RUNTIME > airlines-binary_100000000_$RUNTIME.out
./blending_stacking_airlines-binary.R machine=$MACHINE train_size=10000000 max_runtime_secs=$RUNTIME > airlines-binary_10000000_$RUNTIME.out
./blending_stacking_airlines-binary.R machine=$MACHINE train_size=1000000 max_runtime_secs=$RUNTIME > airlines-binary_1000000_$RUNTIME.out
./blending_stacking_airlines-binary.R machine=$MACHINE train_size=100000 max_runtime_secs=$RUNTIME > airlines-binary_100000_$RUNTIME.out
./blending_stacking_airlines-binary.R machine=$MACHINE train_size=10000 max_runtime_secs=$RUNTIME > airlines-binary_10000_$RUNTIME.out