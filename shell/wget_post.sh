#!/bin/sh
LIST=$(echo $* | sed 's/ /#/g')",Tech"
SERVERURL=http://xxx.com/xxx.jsp
if [  $# -eq 0  ]
then
  cat <<EOF
  Sorry,Please check xxx,xxx is empty.
  usage:sh wget_post.sh xxx xxx...
EOF
  exit 1
fi
for((i=0;i<${#LIST;i++))
do
        ASCValue=$(printf "%d" "'${LIST:$i:1}")
        if [ $ASCValue -eq 90 ];then
                let ASCValue=$ASCValue-25;
        else
                let ASCValue=$ASCValue+1;
        fi
        CODEBASE=${CODEBASE}$(printf \\x$(printf %x $ASCValue))
done
echo "#online url"
echo "wget -O - -q ${SERVERURL} --post-data='codebase="${CODEBASE}"&language=1&update=true'"
echo "#offline url"
echo "wget -O - -q ${SERVERURL} --post-data='codebase="${CODEBASE}"&language=0&update=true'"