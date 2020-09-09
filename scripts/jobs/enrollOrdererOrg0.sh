#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/../utils.sh"

set -e

export CA_ORDERER_HOST=rca-org0.hlf-production-network:7053
export CA_TLS_HOST=ca-tls.hlf-production-network:7052


log "Enroll Orderer at Org0 enrollment ca"

export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/orderer
export FABRIC_CA_CLIENT_TLS_CERTFILES=assets/ca/org0-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
mkdir -p $FABRIC_CA_CLIENT_HOME/assets/ca
cp /tmp/hyperledger/org0/ca/crypto/ca-cert.pem $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_TLS_CERTFILES

fabric-ca-client enroll -u https://orderer-org0:ordererpw@$CA_ORDERER_HOST


log "Enroll Orderer at TLS Ca"

export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=assets/tls-ca/tls-ca-cert.pem
mkdir -p $FABRIC_CA_CLIENT_HOME/assets/tls-ca
cp /tmp/hyperledger/org0/ca/ca-cert.pem $FABRIC_CA_CLIENT_HOME/assets/tls-ca/tls-ca-cert.pem

fabric-ca-client enroll -u https://orderer-org0:ordererPW@$CA_TLS_HOST --enrollment.profile tls --csr.hosts orderer-org0

mv /tmp/hyperledger/org0/orderer/tls-msp/keystore/*_sk /tmp/hyperledger/org0/orderer/tls-msp/keystore/key.pem

log "Enroll Org0's Admin"

export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=../orderer/assets/ca/org0-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -u https://admin-org0:org0adminpw@$CA_ORDERER_HOST
mkdir -p /tmp/hyperledger/org0/orderer/msp/admincerts
cp /tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /tmp/hyperledger/org0/orderer/msp/admincerts/orderer-admin-cert.pem