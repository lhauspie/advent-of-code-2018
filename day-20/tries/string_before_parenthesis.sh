my_string="azertyuio(lkjlkj)kkjhgf"
echo $my_string
echo ${my_string%'('*} # get the string before the first open parenthesis
echo '('${my_string#*'('} # get the string after the first open parenthesis ==> So we add the '(' to keep the open parenthesis

echo ""

my_string="(lkjlkj)kkjhgf"
echo $my_string
echo ${my_string%'('*} # get the string before the first open parenthesis
echo '('${my_string#*'(|'} # get the string after the first open parenthesis ==> So we add the '(' to keep the open parenthesis

my_string="unestringsansparenthese"
echo $my_string
echo ${my_string%'('*} # get the string before the first open parenthesis
echo '('${my_string#*'(|'} # get the string after the first open parenthesis ==> So we add the '(' to keep the open parenthesis
