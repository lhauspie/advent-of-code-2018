#!/bin/bash
declare -A matrix
declare -A matrix_two
declare -A visited
num_rows=4
num_columns=5

for ((i=-1;i<=num_rows;i++)) do
    for ((j=-1;j<=num_columns;j++)) do
        matrix[$i,$j]='#'
        # visited[$i,$j]=${matrix[$i,$j]}
    done
done

echo ${matrix[@]}
visited=(${matrix[0,*]})

f1="%$((${#num_rows}+1))s"
f2=" %9s"

printf "$f1" ''
for ((i=-1;i<=num_rows;i++)) do
    printf "$f2" $i
done
echo

for ((j=-1;j<=num_columns;j++)) do
    printf "$f1" $j
    for ((i=-1;i<=num_rows;i++)) do
        printf "$f2" ${matrix[$i,$j]}
    done
    echo
done
echo ""
for ((j=-1;j<=num_columns;j++)) do
    printf "$f1" $j
    for ((i=-1;i<=num_rows;i++)) do
        printf "$f2" ${visited[$i,$j]}
    done
    echo
done

a=1
b=$a

echo $b
a=4
echo $b



matrix_two[0,0]=1
matrix_two[1,0]=2
matrix_two[1,1]=3
matrix_two[2,0]=4
matrix_two[2,1]=5
matrix_two[2,2]=6

echo ""
for ((j=-1;j<=num_columns;j++)) do
    printf "$f1" $j
    for ((i=-1;i<=num_rows;i++)) do
        printf "$f2" ${matrix_two[$i,$j]}
    done
    echo
done
