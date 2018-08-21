# fabric-ldap-example
Fabric fabcar example using an openLDAP based fabric-ca

### 1. Set up the example:

Execute the script:
```
./runApp.sh
```
This will create a fabric network with the following containers:
+ 1 orderer
+ 4 peers (2 per org)
+ 4 couchDB (one per peer) as the state database
+ 1 cli
+ 1 openldap to store the users
+ 1 phpLDAPadmin to interact with LDAP
+ 2 CAs

The first CA (ca_peerOrg1) is connected to an LDAP server that has been initialized with some users (see artifacts/ldap-files/init-ldap-structure.sh).

The files to configure this fabric-ca to use LDAP as the registry are in artifacts/fabric-ca-files (pay special attention to fabric-ca-server-config.yaml).

The network will create a channel (mychannel), join all peers to it, install and instantiate the fabcar chaincode using the cli (see artifacts/scripts/start-fabcar.sh). After that you can use the node SDK to interact with the network.

### 2. Interact with the network using the SDK

Inside **fabric-sdk-with-ldap** there are several files to interact with the network:

+ enrollUser.js, enroll a specified user with the LDAP based fabric-ca. The user must be registered into the LDAP structure. Example: `node enrollUser.js admin adminpw`
+ query.js, is used to query the ledger using the provided client (previously enrolled). Example: `node query.js admin`
+ invoke.js, is used to query the ledger using the provided client (previously enrolled). Example: `node invoke.js admin`

### 3. Register new users

To register new users in the network, an LDAP administrator will have to create this entry. Some examples are included in artifacts/ldap-files/init-ldap-structure.sh.

The steps are:
+ Create a LDIF file
+ Add to the server. Connect to the openldap container `docker exec -it openldap bash` and execute `ldapadd -H ldap://localhost -D cn=admin,dc=example,dc=com -w admin -f add-users.ldif`
