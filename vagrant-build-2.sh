#!/bin/bash
cd /vagrant && rake bower:install
cd /vagrant && git checkout vend*
echo "you can now start the server using \"rails s\", connect to it using localhost:8080 on your machine and use \"Vagrant@rsnap.com\" and \"rsnap\" as credentials to connect on the server "