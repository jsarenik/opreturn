#!/bin/sh

feerate=1
fee=141
add=0
test "$1" = "-f" && { fee=$2; shift 2; }
m=oops
m="this is the default limit of 80 bytes still present in Bitcoin Core v29.0 ......"
m=":-) "
test "$1" = "-m" && { shift; m="$*"; shift; }
echo ${#m} >&2
m=$(printf "$m" | xxd -p | tr -d '\\\n ')

awk "{sum+=\$3; print \$1\":\"\$2} END {sum-=($fee*$feerate+$add)/100000000; printf(\"data,\\\"$m\\\"\n\"); }"
