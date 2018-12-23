#!/bin/bash
array[0]="foo"
array[1]="bar"
array[2]="base"

array_len=${#array[@]}
for (( i=0; i<${array_len}; i++ )); do
  echo ${array[$i]}
done

for i in {0..0}; do
   echo "Welcome $i times"
done

for i in {0..5}; do
   echo "Welcome $i times"
done

copy=${array[*]}

echo $copy