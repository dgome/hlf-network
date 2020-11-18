#!/bin/bash

export CHAINCODE_VERSION=$(head -1 /tmp/hyperledger/chaincode/assets/testversion.txt | tr -d '\r' | tr -d '\n')
echo "CHAINCODE VERSION:: $CHAINCODE_VERSION"

peer lifecycle chaincode checkcommitreadiness \
    --channelID mychannel \
    --name uc4-cc \
    --version $CHAINCODE_VERSION \
    --sequence 1 \
    --tls \
    --cafile /tmp/secrets/tls-ca/cert.pem \
    --output json \
    --collections-config /tmp/hyperledger/chaincode/assets/collections_config.json
