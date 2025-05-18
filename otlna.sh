#!/bin/sh

doit() {
addr="2ND8PB9RrfCaAcjfjP1Y6nAgFd9zWHYX4DN"
net=testnet
test "$1" = "s" && net=signet
test "$1" = "4" && net=testnet4
url=https://mempool.space/$net/api
test "$1" = "m" && url=https://mempool.space/api \
  && addr="3MaB7QVq3k4pQx3BhsvEADgzQonLSBwMdj"
howf=${2:-"300000"}
ins=$(($(curl -sSL \
  "$url/address/$addr/utxo" \
  | jq -r ".[] | .value" | wc -l) ))
howf=$(($(curl -sSL \
  "$url/address/$addr/utxo" \
  | jq -r ".[] | .value" | paste -d+ -s) ))
echo ins $ins howf $howf
howm=$((($howf-4-1-$ins*(32+4+1+2+4)-1-8-1-4-4)))
howh=$(printf "%016x" $howm | fold -w 2 | tac | tr -d '\n')
echo $howh
t=$(curl -sSL \
  "$url/address/$addr/utxo" \
  | jq -r ".[] | .txid, .vout" | paste -d " " - - \
  | awklist-allfee.sh | mktx.sh | crt.sh \
  | sed "s/010000000000000000066a043a2d2920/01 $howh 04 51024e73/" \
  | sed 's/000000f.ffffff/0000 02 0151 fdffffff/g')
#  | sed "s/010000000000000000066a043a2d2920/02$howh 04 5102 $howh 04 51024e73/")
# 020000000189bdb5483614e4be5c7bc3dd9defef6b1c8dd741aa134ca9e64d01d32bfd399d00000000 02 0151 fdffffff03 0000000000000000 04 51024e73 d301000000000000 04 51024e73 d301000000000000 04 51024e7300000000

echo $t #| nd-all.sh
echo $t \
  | tr -d ' ' \
  | curl -X POST -sSLd @- "$url/tx" | grep .
}

doit $1
