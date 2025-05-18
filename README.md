# opreturn
Shell scripts that operate 0x51 P2SH and LN Anchor keyless addresses.

## Dependencies

 - curl
 - jq
 - mempool.space

## Usage

Works on Testnet3, Testnet4 and Signet so far.

Start by sending sats to `2ND8PB9RrfCaAcjfjP1Y6nAgFd9zWHYX4DN`

Then use `otlna.sh` script to move them to `tb1pfees9rn5nz` (LN Anchor) and then `lnas.sh` to spend and write OP_RETURN output from there.
