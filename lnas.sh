#!/bin/sh

doit() {
net=testnet
a=tb1pfees9rn5nz
test "$1" = "s" && net=signet
test "$1" = "4" && net=testnet4
url=https://mempool.space/$net/api
test "$1" = "m" && url=https://mutinynet.com/api
shift
t=$(curl -sSL \
  "$url/address/tb1pfees9rn5nz/utxo" \
  | jq -r ".[] | .txid, .vout, .value" \
  | paste -d " " - - - \
  | awklist-allfee.sh -m "$1" \
  | mktx.sh | crt.sh)

echo $t #| nd-all.sh
echo $t \
  | curl -X POST -sSLd @- "$url/tx"
}

doit $1 $2
