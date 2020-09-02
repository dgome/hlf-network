source ./util.sh

header "Starting CLIs"

echo "Starting Org1 CLI"

# Provide admincerts to admin msp
d=$TMP_FOLDER/hyperledger/org1/admin/msp/admincerts/
mkdir -p "$d" && cp $TMP_FOLDER/hyperledger/org1/msp/admincerts/admin-org1-cert.pem "$d"

kubectl create -f "$K8S/org1-cli.yaml" -n hlf-production-network
# Copy channel.tx from orderer to peer1 to create the initial channel
cp $TMP_FOLDER/hyperledger/org0/orderer/channel.tx $TMP_FOLDER/hyperledger/org1/peer1/assets/

small_sep

echo "Starting Org2 CLI"

# Provide admincerts to admin msp
d=$TMP_FOLDER/hyperledger/org2/admin/msp/admincerts/
mkdir -p "$d" && cp $TMP_FOLDER/hyperledger/org2/msp/admincerts/admin-org2-cert.pem "$d"

kubectl create -f "$K8S/org2-cli.yaml" -n hlf-production-network
kubectl wait --for=condition=ready pod -l app=cli-org1 --timeout=120s -n hlf-production-network
kubectl wait --for=condition=ready pod -l app=cli-org2 --timeout=120s -n hlf-production-network