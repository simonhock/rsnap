#!/bin/bash
cd /vagrant && rake bower:install
cd /vagrant && git checkout vend*
su - vagrant -c "git clone -n git@github.com:simonhock/Snap--Build-Your-Own-Blocks.git /vagrant/app/assets/javascripts/snap-byob"
su - vagrant -c "git clone -n git@github.com:simonhock/Snap--Build-Your-Own-Blocks.git /vagrant/lib/assets/javascripts/snap-byob"
su - vagrant -c "cd /vagrant/app/assets/javascripts/snap-byob && git checkout"
su - vagrant -c "cd /vagrant/lib/assets/javascripts/snap-byob && git checkout"
echo "you can now start the server using \"rails s\", connect to it using localhost int your browser on your machine and use \"Vagrant@rsnap.com\" and \"rsnap\" as credentials to connect on the server "