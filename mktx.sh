#!/bin/sh
#
# Usage: mktx.sh < tx.in
# the input contains both types of lines:
#  txid:vout
#  addr,amount

tmp=$(mktemp)
cat > $tmp
oldifs=$IFS

{
echo '['
IFS=:
grep -v "^#" $tmp | grep ":" | while read txid vout
do
cat <<EOF
{"txid":"$txid","vout":$vout}
EOF
done | paste -d, -s
echo ']'
} | tr -d '\n '; echo

{
echo '['
IFS=,
grep -v "^#" $tmp | grep "," | while read addr amount
do
cat <<EOF
{"$addr":$amount}
EOF
done | paste -d, -s
echo ']'
} | tr -d '\n '
echo
echo $((0x7015))
#echo $((0x0a51))
#echo 0
#$(($RANDOM%12345))
echo true
rm $tmp
