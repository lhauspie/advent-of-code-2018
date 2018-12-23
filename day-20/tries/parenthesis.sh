
function get_parenthesis_content () {
    local string=$1
    local count=0
    local first=""

    while test -n "$string"
    do
        char=${string:0:1}  # Get the first character
        if [ "$char" = ")" ]; then ((count--)); fi
        if [[ $count > 0 ]]; then first="$first$char"; fi
        if [ "$char" = "(" ]; then ((count++)); fi
        string=${string:1}  # Trim the first character
        if [ $count -eq 0 ]
        then
            second="$string"
            string=""
        fi
    done
    retval_1=$first
    retval_2=$second
}

content="(ceci(est(un(exemple)de)t)e)st(avec)parentheses"
echo content: $content
get_parenthesis_content $content
val1=$retval_1
val2=$retval_2
echo val1: $val1
echo val2: $val2

echo "========================================"

next_content='('${retval_1#*(}
echo next_content: $next_content
get_parenthesis_content $next_content
echo retval_1: $retval_1
echo retval_2: $retval_2

echo "========================================"

echo ""
echo $val1
echo $val2
