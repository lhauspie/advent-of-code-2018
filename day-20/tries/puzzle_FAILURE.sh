#!/bin/bash

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

function clean_instructions() {
    local instructions=$1
    local before=$instructions
    local after=$instructions

    after=$(echo $instructions | sed -r 's/[\^\$]+//g')     # remove `^` and `$` at the first and last char
    while [ "$after" != "$before" ]; do
        before=$after
        after=$(echo $after | sed -r 's/((NEWS)|(NWES)|(SEWN)|(SWEN)|(WNSE)|(WSNE)|(ENSW)|(ESNW))+//g')   # remove all unnecessary instructions
        after=$(echo $after | sed -r 's/((NS)|(SN)|(EW)|(WE))+//g')                                       # remove all instructions that has no effect
        after=$(echo $after | sed -r 's/(\([^\(\)]*\|\))+//g')                                            # remove all group of instructions `(XXX|XXX)` that ends with | (ex: `(NS|EW|)`)
        after=$(echo $after | sed -r 's/(\(\|+\))*//g')                                                   # remove all empty group of instructions `(|)`
    done
    retval=$after
}

function clean_translated_instructions() {
    local instructions=$1
    local before=$instructions
    local after=$instructions

    after=$(echo $instructions | sed -r 's/\+0//g')                 # remove `+0` that are useless
    echo "AFTER = $after"
    while [ "$after" != "$before" ]; do
        before=$after
        after=$(echo $after | sed -r 's/(\+\([^\(\)]*\|0\))//g')  # remove all group of instructions `(XXX|XXX)` that ends with | (ex: `(NS|EW|)`)
    done
    retval=$after
}


function translate_instructions() {
    local instructions=$1
    local char
    local nb_steps=0
    local translation=""

    while test -n "$instructions"; do
        char=${instructions:0:1}
        instructions=${instructions:1}
        if [ "$char" = "(" ]; then
            translation="$translation$nb_steps+$char"
            nb_steps=0
        elif [ "$char" = ")" ] ; then
            translation="$translation$nb_steps$char+"
            nb_steps=0
        elif [ "$char" = "|" ]; then
            translation="$translation$nb_steps$char"
            nb_steps=0
        else
            ((nb_steps++))
        fi
    done

    retval=$translation
}

function evaluate_instructions() {
    local initial_nstructions=$1
    local instructions=$1
    local char
    local nb_doors=0
    local alternative=0
    local index=0
    local end_index=0
    local sub_nb_doors=0

    # echo "instructions = $instructions"

    while test -n "$instructions"; do
        char=${instructions:0:1}
        instructions=${instructions:1}

        if [ "$char" = "|" ]; then
            # echo -n "$nb_doors$char"
            # here we have an alternative path, just calculate the next steps and compare to the current to know wich is longer
            evaluate_instructions $instructions
            alternative=$retval_nb_doors
            end_index=$retval_size
            if [ $alternative -gt $nb_doors ]; then
                nb_doors=$alternative
            fi
            instructions=${instructions:$end_index}
            index=$((index + end_index))
            retval_size=$index
        elif [ "$char" = "(" ]; then
            # echo -n "$nb_doors("
            get_parenthesis_content '('$instructions
            sub_instructions=$retval_1
            instructions=$retval_2
            evaluate_instructions $sub_instructions
            sub_nb_doors=$retval_nb_doors
            # echo -n "$sub_nb_doors"
            end_index=$((retval_size + 1)) # +1 because we pass the last closing parenthesis
            nb_doors=$((nb_doors + sub_nb_doors))
            index=$((index + end_index))
            # echo -n ")"
        else
            ((nb_doors++))
        fi
        ((index++))
    done
    # echo "$initial_nstructions => $nb_doors"

    # echo -n "$nb_doors"

    retval_nb_doors=$nb_doors
    retval_size=$index
}















# ===========================================================
# ===========================================================
# =======================  UNIT TESTS  ======================
# ===========================================================
# ===========================================================


# ===============================================
# ==== clean_instructions 
clean_instructions "^NESWW$"
if [ "$retval" != "NESWW" ]; then
    echo "ERROR : \"$retval\" is not equal to \"NESWW\""
fi

clean_instructions "^NEWS$"
if [ "$retval" != "" ]; then
    echo "ERROR : \"$retval\" is not equal to \"\""
fi

clean_instructions "^N(NEWS|)E$"
if [ "$retval" != "NE" ]; then
    echo "ERROR : \"$retval\" is not equal to \"NE\""
fi

clean_instructions "^(SWEN|NEWS|)$"
if [ "$retval" != "" ]; then
    echo "ERROR : \"$retval\" is not equal to \"\""
fi

clean_instructions "^(SWEN|NWES|SEWN|NEWS|ENSW|WNSE|ENSW|ESNW)$"
if [ "$retval" != "" ]; then
    echo "ERROR : \"$retval\" is not equal to \"\""
fi

clean_instructions "^EESWSEEN(SWWNSEEN|)$"
if [ "$retval" != "EESWSEEN" ]; then
    echo "ERROR : \"$retval\" is not equal to \"EESWSEEN\""
fi


# test_evaluate_instructions(instructions, expected)
function test_evaluate_instructions() {
    clean_instructions $1
    evaluate_instructions $retval
    if [ $retval_nb_doors -ne $2 ]; then
        echo "ERROR : \"$1\" returns ($retval_nb_doors), but ($2) expected"
    else
        echo -e "OK : \"$1\" returns ($retval_nb_doors)"
    fi
}


# ===============================================
# ==== Clean + evaluate_instructions
echo "=== My Unit Tests"
test_evaluate_instructions "^N$"                                1
test_evaluate_instructions "^W$"                                1
test_evaluate_instructions "^E$"                                1
test_evaluate_instructions "^S$"                                1
test_evaluate_instructions "^SE$"                               2
test_evaluate_instructions "^SEEEEEE$"                          7
test_evaluate_instructions "^SEEEEEE|ESN$"                      7
test_evaluate_instructions "^SEE|EEEEESN$"                      5
test_evaluate_instructions "^SEE|EEEEESNEE|WSESWSE$"            7
test_evaluate_instructions "^N(SEE|EEEEESNEE)E$"                9
test_evaluate_instructions "^N(SEE|EEE(EE|S)NEE)E$"             10
test_evaluate_instructions "^N(SEE|EEEEESNEE)E(SS|NNN)SSS$"     15

# ===============================================
# === Examples from adventofcode
echo "=== Examples from adventofcode"
test_evaluate_instructions "^WNE$" 3
test_evaluate_instructions "^ENWWW(NEEE|SSE(EE|N))$" 10
test_evaluate_instructions "^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$" 18
test_evaluate_instructions "^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$" 23
test_evaluate_instructions "^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$" 31

echo "TEST ARE DONE !"



echo "====================================="
translate_instructions "N(SEE|EEEEESNEE)E(SS|NNN)SSS"
echo $retval
clean_translated_instructions $retval
retval=$(echo $retval | sed -r 's/(\(3\|9\))/9/g' | sed -r 's/(\(2\|3\))/3/g')
echo $retval
echo "====================================="







# input=$(<input.txt)
# echo "AFTER READING FILE -----------------"
# echo $input
# clean_instructions $input
# input=$retval
# echo "AFTER CLEANING INSTRUCTIONS -----------------"
# echo $input
# translate_instructions $input
# input=$retval
# echo "AFTER INSTRUCTIONS TRANSLATION -----------------"
# echo $input
# clean_translated_instructions $input
# inpu=$retval
# echo "AFTER CLEANING TRANSLATED INSTRUCTIONS -----------------"
# echo $input
# # input=$(echo $input | sed -r 's/(\(1\|0\))/1/g' | sed -r 's/(\(0\|1\))/1/g')
# # echo "-----------------"
# # echo $input


# function count() {
#     while [ "" = "" ]; do
#         sleep 5
#         echo -n "."
#     done;
# }

# count &
# pid=$!

# NE PAS SUPPRIMER, C'EST LA SOLUTION (ENFIN, QUAND ELLE FONCTIONNERA)
input=$(<input.txt)
clean_instructions $input
input=$retval
# echo "Very long evaluation of the input is started"
evaluate_instructions $input
echo "Furthest room requires passing $retval_nb_doors doors"



# kill -9 $pid

