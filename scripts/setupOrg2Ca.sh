source ./util.sh

header "Org2 CA"

# Create deployment for org2 ca
echo "Creating Org2 CA deployment"
kubectl create -f $K8S/org2-ca/org2-ca.yaml -n hlf-production-network

# Expose service for org2 ca
echo "Creating Org2 CA service"
kubectl create -f $K8S/org2-ca/org2-ca-service.yaml -n hlf-production-network

export CA_ORG2_HOST=$(minikube service rca-org2 --url -n hlf-production-network | cut -c 8-)
echo "Org2 CA service exposed on $CA_ORG2_HOST"
small_sep

# Wait until pod is ready
echo "Waiting for pod"
kubectl wait --for=condition=ready pod -l app=rca-org2-root --timeout=120s -n hlf-production-network
sleep $SERVER_STARTUP_TIME
export ORG2_CA_NAME=$(get_pods "rca-org2-root")
echo "Using pod $ORG2_CA_NAME"
small_sep

export FABRIC_CA_CLIENT_TLS_CERTFILES=../crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$TMP_FOLDER/hyperledger/org2/ca/admin
mkdir -p $FABRIC_CA_CLIENT_HOME

# Query TLS CA server to enroll an admin identity
echo "Use CA-client to enroll admin"
small_sep
./$CA_CLIENT enroll $DEBUG -u https://rca-org2-admin:rca-org2-adminpw@$CA_ORG2_HOST
small_sep

# Query TLS CA server to register other identities
echo "Use CA-client to register identities"
small_sep
# The id.secret password ca be used to enroll the registered users lateron
./$CA_CLIENT register $DEBUG --id.name peer1-org2 --id.secret peer1PW --id.type peer -u https://$CA_ORG2_HOST
small_sep
./$CA_CLIENT register $DEBUG --id.name peer2-org2 --id.secret peer2PW --id.type peer -u https://$CA_ORG2_HOST
small_sep
./$CA_CLIENT register $DEBUG --id.name admin-org2 --id.secret org2AdminPW --id.type user -u https://$CA_ORG2_HOST
small_sep
./$CA_CLIENT register $DEBUG --id.name user-org2 --id.secret org2UserPW --id.type user -u https://$CA_ORG2_HOST