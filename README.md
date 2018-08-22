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

To register new users in the network, an LDAP administrator will have to create this entry. One example is included in artifacts/ldap-files.

The steps are:
+ Create a LDIF file with the new user info (new_user.ldif):
```
# User account
dn: uid=alejandro,ou=users,ou=fabric,dc=hyperledeger,dc=example,dc=com
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
uid: alejandro
cn: admin
sn: Hyperledeger
givenName: alejandro
o: Hyperledger
ou: Fabric
st: North Carolina
uidNumber: 10002
gidNumber: 10002
mail: alejandro@hyperledeger.example.com
loginShell: /bin/bash
homeDirectory: /home/alejandro
userPassword: alejandropw
```
+ Add this new entry `ldapadd -H ldap://localhost -D cn=admin,dc=example,dc=com -w admin -f /home/ldap-files/new_user.ldif`
+ Create a new LDIF file (add_newuser_to_group.ldif) to add this user to the existing group:
```
dn: cn=User,ou=groups,dc=example,dc=com
changetype: modify
add: member
member: uid=alejandro,ou=users,ou=fabric,dc=hyperledeger,dc=example,dc=com
```
+ Modify the existing group `ldapmodify -xcWD "cn=admin,dc=example,dc=com" -f add_newuser_to_group.ldif`

> NOTE: you can use phpLDAPadmin to do this task manually.
