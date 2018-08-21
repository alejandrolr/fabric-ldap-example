#!/bin/bash
echo
echo "Create the channel"
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
    cli peer channel create -o orderer.example.com:7050 -c mychannel -f ./channel/mychannel.tx
    #--tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
    
echo
echo "Join peers to the channel."
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" \
            -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
            -e "CORE_PEER_ADDRESS=peer0.org1.example.com:7051" \
            -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" \
    cli peer channel join -b mychannel.block

docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" \
            -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
            -e "CORE_PEER_ADDRESS=peer1.org1.example.com:7051" \
            -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt" \
    cli peer channel join -b mychannel.block

docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" \
            -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
            -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" \
            -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" \
    cli peer channel join -b mychannel.block

docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" \
            -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
            -e "CORE_PEER_ADDRESS=peer1.org2.example.com:7051" \
            -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt" \
    cli peer channel join -b mychannel.block
echo
echo "install chaincode on peers"

docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" \
            -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
            -e "CORE_PEER_ADDRESS=peer0.org1.example.com:7051" \
            -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" \
    cli peer chaincode install -n fabcar -v 1.0 -p github.com/chaincode/fabcar/go -l golang

docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" \
            -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
            -e "CORE_PEER_ADDRESS=peer1.org1.example.com:7051" \
            -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt" \
    cli peer chaincode install -n fabcar -v 1.0 -p github.com/chaincode/fabcar/go -l golang

docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" \
            -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
            -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" \
            -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" \
    cli peer chaincode install -n fabcar -v 1.0 -p github.com/chaincode/fabcar/go -l golang

docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" \
            -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
            -e "CORE_PEER_ADDRESS=peer1.org2.example.com:7051" \
            -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt" \
    cli peer chaincode install -n fabcar -v 1.0 -p github.com/chaincode/fabcar/go -l golang
echo
echo "instantiate chaincode"

docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" \
            -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
            -e "CORE_PEER_ADDRESS=peer1.org1.example.com:7051" \
            -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt" \
    cli peer chaincode instantiate -o orderer.example.com:7050 \
    -C mychannel -n fabcar -l golang -v 1.0 -c '{"Args":[""]}' -P "OR ('Org1MSP.member','Org2MSP.member')"
    #--tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
    
sleep 10
echo
echo "invoke to init the ledger with some cars on peer0 org1"

docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" \
            -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
            -e "CORE_PEER_ADDRESS=peer1.org1.example.com:7051" \
            -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt" \
    cli peer chaincode invoke -o orderer.example.com:7050 \
    -C mychannel -n fabcar -c '{"function":"initLedger","Args":[""]}'
#--tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
   
sleep 5
echo
echo "example to query on peer1 org2"

docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" \
            -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
            -e "CORE_PEER_ADDRESS=peer1.org2.example.com:7051" \
            -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt" \
    cli peer chaincode query -C mychannel -n fabcar -c '{"function":"queryAllCars","Args":[""]}'