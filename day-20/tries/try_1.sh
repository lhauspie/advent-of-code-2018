#!/bin/bash

declare -A global_matrix

function display_matrix() {
    for ((j=490;j<=510;j++)) do
        for ((i=490;i<=510;i++)) do
            printf "%1s" ${global_matrix[$i,$j]}
        done
        echo
    done
}



function get_parenthesis_content () {
    local string=$1
    local count=0
    local content=""
    local next_content=""
    local char=''

    while test -n "$string"; do
        char=${string:0:1}  # Get the first character
        if [ "$char" = ")" ]; then ((count--)); fi
        if [[ $count > 0 ]]; then content="$content$char"; fi
        if [ "$char" = "(" ]; then ((count++)); fi
        string=${string:1}  # Trim the first character
        if [ $count -eq 0 ]
        then
            next_content="$string"
            string=""
        fi
    done
    retval_1=$content
    retval_2=$next_content
}





function evaluate_complex_instructions() {
    local string=$1
    local position=("${!2}")
    echo "evaluate_complex_instructions" $string "with" ${position[@]}

    local current_instructions=${string%'('*} # get the string before the first open parenthesis
    echo "current_instructions is" $current_instructions

    local next_instructions=${string#"$current_instructions"} # get the string that follow the string before opened parenthesis
    echo "next_instructions is" $next_instructions

    local inner_instructions=""

    local next_position=$position
    if [ "$current_instructions" != "" ]; then
        evaluate_instructions $current_instructions position[@]
        next_position=$retval
    fi

    if [ "$next_instructions" != "" ]; then
        get_parenthesis_content $next_instructions

        evaluate_complex_instructions $retval_1 position[@]
        evaluate_complex_instructions $retval_2 position[@]
        next_position=$retval
    fi

    # next_instructions

    # evaluate_complex_instructions $next_instructions X
    retval=$next_instructions
}


function evaluate_instruction() {
    local char=$1
    local position=("${!2}")
    local pos_x=${position[0]}
    local pos_y=${position[1]}

    if [ "$char" = "S" ]; then
        pos_x=$((pos_x+1))
        global_matrix[$pos_y,$pos_x]='-'
        pos_x=$((pos_x+1))
    elif [ "$char" = "N" ]; then
        pos_x=$((pos_x-1))
        global_matrix[$pos_y,$pos_x]='-'
        pos_x=$((pos_x-1))
    elif [ "$char" = "E" ]; then
        pos_y=$((pos_y+1))
        global_matrix[$pos_y,$pos_x]='|'
        pos_y=$((pos_y+1))
    elif [ "$char" = "W" ]; then
        pos_y=$((pos_y-1))
        global_matrix[$pos_y,$pos_x]='|'
        pos_y=$((pos_y-1))
    fi
    global_matrix[$pos_y,$pos_x]='.'

    retval=($pos_x $pos_y)
}

function evaluate_instructions() {
    local string=$1
    local position=("${!2}")
    # echo "position: $position"

    local x=${position[0]}
    local y=${position[1]}
    echo "x: $x / y: $y"

    while test -n "$string"; do
        char=${string:0:1}  # Get the first character
        string=${string:1}
        evaluate_instruction $char $position
    done

    retval=($x $y)
}

position=(500 500)
global_matrix[500,500]="X"
evaluate_instruction "S" position[@]
echo ${retval[@]}
evaluate_instruction "N" position[@]
echo ${retval[@]}
evaluate_instruction "W" position[@]
echo ${retval[@]}
evaluate_instruction "E" position[@]
echo ${retval[@]}




position=(500 500)
echo ${position[@]}

echo "================================================="
evaluate_instructions "WNE" position[@]
# echo $retval[@]

echo "================================================="
evaluate_complex_instructions "SSWNNE(E|W)N" position[@]
# echo $retval


display_matrix global_matrix[@]
