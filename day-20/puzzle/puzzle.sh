#!/bin/bash

declare -A global_matrix
declare -A input
declare -A visited_matrix

function display_global_matrix() {
    local pos_x=$1
    local pos_y=$2
    local range=$3
    
    local minx=(pos_x-range)
    local maxx=(pos_x+range)
    local miny=(pos_y-range)
    local maxy=(pos_y+range)

    for ((y=miny;y<=maxy;y++)) do
        for ((x=minx;x<=maxx;x++)) do
            to_display=${global_matrix[$y,$x]}
            if [ "$to_display" = "" ]; then
                global_matrix[$y,$x]="#"
                to_display="#"
            fi
            printf "%1s" $to_display
        done
        echo
    done
}

function display_visited_matrix() {
    local pos_x=$1
    local pos_y=$2
    local range=$3
    
    local minx=(pos_x-range)
    local maxx=(pos_x+range)
    local miny=(pos_y-range)
    local maxy=(pos_y+range)

    for ((y=miny;y<=maxy;y++)) do
        for ((x=minx;x<=maxx;x++)) do
            to_display=${visited_matrix[$y,$x]}
            if [ "$to_display" = true ]; then
                to_display="T"
            else
                to_display=" "
            fi
            printf "%1s" $to_display
        done
        echo
    done
}


function fill_map() {
    # inputs
    local start_x=$1
    local start_y=$2
    
    # internals
    local ends_x
    local ends_y
    local ends_n=0
    
    local position_x # internal variable to loop over the positions array
    local position_y # internal variable to loop over the positions array

    local positions_x
    local positions_y
    local positions_n=0
    
    local next_positions_x
    local next_positions_y
    local next_positions_n=0

    # add the start position the positions list
    positions_x[0]=$start_x
    positions_y[0]=$start_y
    ((positions_n++))

    while test -n "$input"; do
        char=${input:0:1} # Get the first character
        input=${input:1} # Cut the input
        if [ "$char" = ")" ]; then
            break
        fi

        # reinit the list of next_positions
        next_positions_x=()
        next_positions_y=()
        next_positions_n=0
#         echo "next_positions size after init: $next_positions_n"

        for ((pos_index=0;pos_index<positions_n;pos_index++)); do
            # get the nth position in the list
            position_x=${positions_x[$pos_index]}
            position_y=${positions_y[$pos_index]}
#             echo "position before all move => x: $position_x / y: $position_y"

            if [ "$char" = "(" ]; then
#                 echo "the char ("
                fill_map $position_x $position_y
                returned_positions_x=$retval_x
                returned_positions_y=$retval_y
                returned_positions_n=$retval_n

#                 echo "recursive call returns retval_n: $retval_n"
                for ((next_index=0;next_index<returned_positions_n; next_index++)); do
                    returned_position_x=${returned_positions_x[next_index]}
                    returned_position_y=${returned_positions_y[next_index]}
#                     echo "recursive call returns a position: x: $returned_position_x / y: $returned_position_y"

                    next_positions_x[$next_positions_n]=$returned_position_x
                    next_positions_y[$next_positions_n]=$returned_position_y
                    ((next_positions_n++))
                done
#                 echo "next_positions_n after recursive call: $next_positions_n"

            elif [ "$char" = "|" ]; then
#                 echo "the char |"
                ends_x[$ends_n]=$position_x
                ends_y[$ends_n]=$position_y
                ((ends_n++))

                next_positions_x=()
                next_positions_y=()
                next_positions_n=0

                next_positions_x[$next_positions_n]=$start_x
                next_positions_y[$next_positions_n]=$start_y
                ((next_positions_n++))
#                 echo "next_positions_n after encountering |: $next_positions_n"

            elif [ "$char" = "E" ] || [ "$char" = "W" ] || [ "$char" = "S" ] || [ "$char" = "N" ]; then
#                 echo "the char $char"
#                 echo "calling evaluate_instruction whit char($char), position_x($position_x) position_y($position_y)"
                evaluate_instruction $char $position_x $position_y # fill in the globale matrix with the good char (|-.) and get the new position
                next_position_x=$retval_x
                next_position_y=$retval_y
#                 echo "position after encountering $char => x: $next_position_x / y: $next_position_y"
#                 echo "next_positions_n before adding the next_position => ${next_positions_n}"
                next_positions_x[$next_positions_n]=$next_position_x;
                next_positions_y[$next_positions_n]=$next_position_y;
                ((next_positions_n++))
#                 echo "next_positions_n after adding the next_position => ${next_positions_n}"
            fi
        done
        positions_x=$next_positions_x
        positions_y=$next_positions_y
        positions_n=$next_positions_n
    done

    for ((pos_index=0;pos_index<positions_n;pos_index++)); do
        ends_x[$ends_n]=$position_x
        ends_y[$ends_n]=$position_y
        ((ends_n++))
    done

    retval_x=$ends_x
    retval_y=$ends_y
    retval_n=$ends_n
}

function move() {
    local position_x=$1
    local position_y=$2
    local char=$3
    local position_val=""

    if [ "$char" = "S" ]; then
        position_y=$((position_y+1))
        position_val=${global_matrix[$position_y,$position_x]}
        position_y=$((position_y+1))
    elif [ "$char" = "N" ]; then
        position_y=$((position_y-1))
        position_val=${global_matrix[$position_y,$position_x]}
        position_y=$((position_y-1))
    elif [ "$char" = "E" ]; then
        position_x=$((position_x+1))
        position_val=${global_matrix[$position_y,$position_x]}
        position_x=$((position_x+1))
    elif [ "$char" = "W" ]; then
        position_x=$((position_x-1))
        position_val=${global_matrix[$position_y,$position_x]}
        position_x=$((position_x-1))
    fi

    retval_x=$position_x
    retval_y=$position_y
    retval_val=$position_val
}

function evaluate_instruction() {
    local char=$1
    local position_x=$2
    local position_y=$3

    if [ "$char" = "N" ]; then
        position_y=$((position_y-1))
        global_matrix[$position_y,$position_x]='-'
        position_y=$((position_y-1))
    elif [ "$char" = "S" ]; then
        position_y=$((position_y+1))
        global_matrix[$position_y,$position_x]='-'
        position_y=$((position_y+1))
    elif [ "$char" = "E" ]; then
        position_x=$((position_x+1))
        global_matrix[$position_y,$position_x]='|'
        position_x=$((position_x+1))
    elif [ "$char" = "W" ]; then
        position_x=$((position_x-1))
        global_matrix[$position_y,$position_x]='|'
        position_x=$((position_x-1))
    fi
    global_matrix[$position_y,$position_x]='.'

    retval_x=$position_x
    retval_y=$position_y
}

function find_all_path() {
    # inputs
    local start_x=$1
    local start_y=$2

    # internal
    local -A fifo_x         # The queue that stores the X of coords
    local -A fifo_y         # The queue that stores the Y of coords
    local fifo_head=0       # head is were we read
    local fifo_queue=0      # queue is were we write
    local -A fifo_lengths   # stores the length of each collection inside the queue
    
    # the output
    local nb_doors=0
    local nb_paths=0

    visited_matrix=()

    # push the start position as the first path in the fifo
    fifo_lengths[$fifo_queue]=0
    fifo_x[$fifo_queue,0]=$start_x
    fifo_y[$fifo_queue,0]=$start_y

    # echo ""
    # for ((j=0;j<=10;j++)) do
    #     printf "$f1" $j
    #     for ((i=0;i<=10;i++)) do
    #         printf "%1s" ${fifo_x[$i,$j]} / ${fifo_y[$i,$j]} " - "
    #     done
    #     echo
    # done


    ((fifo_lengths[$fifo_queue]++))
    ((fifo_queue++))

    while [ $fifo_head -lt $fifo_queue ]; do
        # echo "START A NEW LOOP OF THE WHILE"
        # echo "fifo_length of fifo_head($fifo_head): ${fifo_lengths[$fifo_head]}"
        # echo -n "               The content is : "
        # for ((i=0;i<${fifo_lengths[$fifo_head]};i++)); do
        #     echo -n "x:${fifo_x[$fifo_head,$i]},y:${fifo_y[$fifo_head,$i]} "
        # done
        # echo

        # retrieve the length of the collection stored in the fifo_head
        path_length=${fifo_lengths[$fifo_head]}
        current_i=$((path_length-1))
        # retrieve the last position of the path contained in the fifo_head
        current_x=${fifo_x[$fifo_head,$current_i]}
        current_y=${fifo_y[$fifo_head,$current_i]}
        visited_matrix[$current_y,$current_x]=true
        # echo "Marking postion x:$current_x,y:$current_y as Visited"
        # echo "Dealing with the current position => x:$current_x,y:$current_y"

        for direction in "S" "N" "E" "W"; do
            # echo "dealing with the direction => \"$direction\""
            move $current_x $current_y $direction
            next_x=$retval_x
            next_y=$retval_y
            next_val=$retval_val # retval_val contains the content of the cell to cross to go to (next_x|next_y)

            if [ "$next_val" = "|" ] || [ "$next_val" = "-" ]; then
                # echo "Going from position x:$current_x,y:$current_y to position x:$next_x,y:$next_y is possible"
                if [ "${visited_matrix[$next_y,$next_x]}" != true ]; then
                    # Clone the path from the fifo_head into the fifo_queue
                    fifo_lengths[$fifo_queue]=0
                    for ((i=0;i<=current_i;i++)); do
                        fifo_x[$fifo_queue,$i]=${fifo_x[$fifo_head,$i]}
                        fifo_y[$fifo_queue,$i]=${fifo_y[$fifo_head,$i]}
                        ((fifo_lengths[$fifo_queue]++))
                    done

                    # Add the next step to the path in the fifo_queue
                    next_index=${fifo_lengths[$fifo_queue]}
                    fifo_x[$fifo_queue,$next_index]=$next_x
                    fifo_y[$fifo_queue,$next_index]=$next_y
                    ((fifo_lengths[$fifo_queue]++))

                    new_path_length=${fifo_lengths[$fifo_queue]}
                    if [ $new_path_length -gt $nb_doors ]; then
                        nb_doors=$new_path_length
                    fi
                    if [ $new_path_length -gt 1000 ]; then
                        ((nb_paths++))
                    fi
                    # echo "fifo_length of fifo_queue($fifo_queue): ${fifo_lengths[$fifo_queue]}"
                    ((fifo_queue++)) # fifo.push_back
                fi
            fi
        done
        # Remove the old path from fifo_head
        for ((i=0;i<${fifo_lengths[$fifo_head]};i++)); do
            unset fifo_x[$fifo_head,$i]
            unset fifo_y[$fifo_head,$i]
            unset fifo_lengths[$fifo_head,$i]
        done
        ((fifo_head++)) # fifo.pop_front

        # echo ""
        # for ((j=0;j<=10;j++)) do
        #     printf "$f1" $j
        #     for ((i=0;i<=10;i++)) do
        #         printf "%1s" ${fifo_x[$i,$j]} / ${fifo_y[$i,$j]} " - "
        #     done
        #     echo
        # done
    done
    ((nb_doors--))
    retval_step1=$nb_doors
    retval_step2=$nb_paths
}
    


global_matrix=()
input="ENWWW(NEEE|SSE(EE|N))"
echo "$input"
global_matrix[5,5]="X"
fill_map 5 5
find_all_path 5 5
echo "retval = $retval"
display_global_matrix 5 5 5
#   #########
#   #.|.|.|.#
#   #-#######
#   #.|.|.|.#
#   #-#####-#
#   #.#.#X|.#
#   #-#-#####
#   #.|.|.|.#
#   #########
display_visited_matrix 5 5 5



# global_matrix=()
# input="ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN"
# echo "$input"
# global_matrix[5,5]="X"
# fill_map 5 5
# find_all_path 5 5
# echo "retval = $retval"
# display_global_matrix 5 5 5
# #   ###########
# #   #.|.#.|.#.#
# #   #-###-#-#-#
# #   #.|.|.#.#.#
# #   #-#####-#-#
# #   #.#.#X|.#.#
# #   #-#-#####-#
# #   #.#.|.|.|.#
# #   #-###-###-#
# #   #.|.|.#.|.#
# #   ###########



function count() {
    while [ "" = "" ]; do
        sleep 5
        echo -n "."
    done;
}
count &
pid=$!


global_matrix=()
input=$(<input.txt)
input=$(echo $input | sed -r 's/[\^\$]+//g') # remove ^ of the start and $ of the end
global_matrix[210,210]="X"
fill_map 210 210
find_all_path 210 210
echo "retval_step1 = $retval_step1"
echo "retval_step2 = $retval_step2"
# display_global_matrix 210 210 105 > map


kill -9 $pid

# ......................................................................................................................................................................................................................................................................................................................................................................
