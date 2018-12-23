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

    retval=$(echo $instructions | sed -r 's/[\^\$]+//g')
    retval=$(echo $retval | sed -r 's/((NEWS)|(NWES)|(SEWN)|(SWEN)|(WNSE)|(WSNE)|(ENSW)|(ESNW))+//g')
    retval=$(echo $retval | sed -r 's/(\(\|+\))*//g')
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

    clean_instructions $instructions
    instructions=$retval

    while test -n "$instructions"; do
        char=${instructions:0:1}
        instructions=${instructions:1}

        if [ "$char" = "|" ]; then
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
            get_parenthesis_content '('$instructions
            sub_instructions=$retval_1
            instructions=$retval_2
            evaluate_instructions $sub_instructions
            sub_nb_doors=$retval_nb_doors
            end_index=$((retval_size + 1)) # +1 because we pass the last closing parenthesis
            nb_doors=$((nb_doors + sub_nb_doors))
            index=$((index + end_index))
        else
            ((nb_doors++))
        fi
        ((index++))
    done
    # echo "$initial_nstructions => $nb_doors"


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

clean_instructions "^NEWS"
if [ "$retval" != "" ]; then
    echo "ERROR : \"$retval\" is not equal to \"\""
fi

clean_instructions "^N(NEWS|)E"
if [ "$retval" != "NE" ]; then
    echo "ERROR : \"$retval\" is not equal to \"NE\""
fi

clean_instructions "^(SWEN|NEWS|)"
if [ "$retval" != "" ]; then
    echo "ERROR : \"$retval\" is not equal to \"\""
fi

clean_instructions "^(SWEN|NWES|SEWN|NEWS|ENSW|WNSE|ENSW|ESNW|)"
if [ "$retval" != "" ]; then
    echo "ERROR : \"$retval\" is not equal to \"\""
fi



# ===============================================
# ==== evaluate_instructions 

echo "==============================================="
evaluate_instructions "^N$" 
if [ $retval_nb_doors -ne 1 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 1"
fi

echo "==============================================="
evaluate_instructions "^W$" 
if [ $retval_nb_doors -ne 1 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 1"
fi

echo "==============================================="
evaluate_instructions "^E$" 
if [ $retval_nb_doors -ne 1 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 1"
fi

echo "==============================================="
evaluate_instructions "^S$"
if [ $retval_nb_doors -ne 1 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 1"
fi

echo "==============================================="
evaluate_instructions "^SE$"
if [ $retval_nb_doors -ne 2 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 2"
fi

echo "==============================================="
evaluate_instructions "^SEEEEEE$"
if [ $retval_nb_doors -ne 7 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 7"
fi

echo "==============================================="
evaluate_instructions "^SEEEEEE|ESN$"
if [ $retval_nb_doors -ne 7 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 7"
fi

echo "==============================================="
evaluate_instructions "^SEE|EEEEESN$"
if [ $retval_nb_doors -ne 7 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 7"
fi

echo "==============================================="
evaluate_instructions "^SEE|EEEEESNEE|WEWEWEW$"
if [ $retval_nb_doors -ne 9 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 9"
fi

echo "==============================================="
evaluate_instructions "^N(SEE|EEEEESNEE)E$"
if [ $retval_nb_doors -ne 11 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 11"
fi

echo "==============================================="
evaluate_instructions "^N(SEE|EEE(EE|S)NEE)E$"
if [ $retval_nb_doors -ne 10 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 10"
fi

echo "==============================================="
evaluate_instructions "^N(SEE|EEEEESNEE)E(SS|NNN)SSS$"
if [ $retval_nb_doors -ne 17 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 17"
fi

echo "==============================================="
echo "==============================================="
echo "==============================================="

# === Examples from adventofcode
echo "==============================================="
evaluate_instructions "^WNE$"
if [ $retval_nb_doors -ne 3 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 3"
fi

echo "==============================================="
evaluate_instructions "^ENWWW(NEEE|SSE(EE|N))$"
if [ $retval_nb_doors -ne 10 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 10"
fi

echo "==============================================="
evaluate_instructions "^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$"
if [ $retval_nb_doors -ne 18 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 18"
fi

echo "==============================================="
evaluate_instructions "^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$"
if [ $retval_nb_doors -ne 23 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 23"
fi

echo "==============================================="
evaluate_instructions "^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$"
if [ $retval_nb_doors -ne 31 ]; then
    echo "ERROR : $retval_nb_doors is not equal to 31"
fi



echo "TEST ARE DONE !"


# echo "================================================="
# evaluate_complex_instructions "SSWNNE(E|W)N" position[@]
# echo $retval


