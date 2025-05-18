#!/bin/sh

doit() {
addr="2ND8PB9RrfCaAcjfjP1Y6nAgFd9zWHYX4DN"
net=testnet
test "$1" = "s" && net=signet
test "$1" = "4" && net=testnet4
url=https://mempool.space/$net/api
test "$1" = "m" && url=https://mempool.space/api \
  && addr=3MaB7QVq3k4pQx3BhsvEADgzQonLSBwMdj
t=$(curl -sSL \
  "$url/address/$addr/utxo" \
  | jq -r ".[] | .txid, .vout" | paste -d " " - - \
  | awklist-allfee.sh | mktx.sh | crt.sh \
  | sed 's/000000f.ffffff/0000 02 0151 fdffffff/g')

#  | shuf | head -1 \
echo $t #| nd-all.sh
echo $t \
  | tr -d ' ' \
  | curl -X POST -sSLd @- "$url/tx" | grep .
}

doit $1
