function index_of() {
    local search_char=$1
    local string=$2

    local index=0

    while test -n "$string"
    do
        char=${string:0:1}  # Get the first character
        # echo $char
        if [[ "$char" == "$search_char" ]]
        then
            # echo "$char" == "$search_char"
            string="" # found ==> so just empty the string to make the while condition false
            retval=$index
        else
            # echo "$char" != "$search_char"
            ((index++))
            string=${string:1}  # Get the first character
        fi
    done
    # echo $index
}

my_string="this is a (parenthesis) test"
index_of '(' $my_string
echo $retval



