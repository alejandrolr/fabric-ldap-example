#!/bin/bash

sleep 10
echo "Creating base..."
ldapadd -H ldap://localhost -D cn=admin,dc=example,dc=com -w admin -f /home/ldap-files/base.ldif
echo "Adding users..."
ldapadd -H ldap://localhost -D cn=admin,dc=example,dc=com -w admin -f /home/ldap-files/add-users.ldif
echo "Creating groups..."
ldapadd -H ldap://localhost -D cn=admin,dc=example,dc=com -w admin -f /home/ldap-files/groups.ldif

tail -F /dev/null