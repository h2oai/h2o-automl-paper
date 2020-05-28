#!/bin/bash

echo "it will take a little while..."
echo "you can also create the files by running ./prep_data.R &"

wget https://h2o-airlines-unpacked.s3.amazonaws.com/airlines_train_100000000.csv
wget https://h2o-airlines-unpacked.s3.amazonaws.com/airlines_train_10000000.csv
wget https://h2o-airlines-unpacked.s3.amazonaws.com/airlines_train_1000000.csv
wget https://h2o-airlines-unpacked.s3.amazonaws.com/airlines_train_100000.csv
wget https://h2o-airlines-unpacked.s3.amazonaws.com/airlines_train_10000.csv
wget https://h2o-airlines-unpacked.s3.amazonaws.com/airlines_test_100000.csv
