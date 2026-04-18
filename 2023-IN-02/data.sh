#!/bin/bash

mkdir test_optometry
cd test_optometry

echo "measurement_data_1" > file1.txt
echo "measurement_data_1" > file2.txt
echo "measurement_data_1" > file3.txt

echo "measurement_data_2" > linkA1.txt
ln linkA1.txt linkA2.txt

echo "measurement_data_3" > groupB1.txt
ln groupB1.txt groupB2.txt
echo "measurement_data_3" > groupC1.txt
ln groupC1.txt groupC2.txt

echo "unique_measurement" > unique.txt

touch empty1.txt
touch empty2.txt

cd ..
echo "Тестовата директория 'test_optometry' е готова."
