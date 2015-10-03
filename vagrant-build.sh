#!/bin/bash
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get -y install git postgresql-9.3 libpq-dev libmagick++-dev libmagickwand-dev libqt4-dev libqtwebkit-dev libqt5webkit5-dev npm unzip
sudo -u postgres -H -- psql -c "DROP ROLE vagrant"
sudo -u postgres -H -- psql -c "CREATE ROLE vagrant SUPERUSER CREATEDB LOGIN PASSWORD 'vagrant'"
cp /vagrant/config/database.yml.example /vagrant/config/database.yml
sed -i -e "s/username: rsnap/username: vagrant/g" /vagrant/config/database.yml
sed -i -e "s/password:/password: vagrant/g" /vagrant/config/database.yml
su - vagrant -c 'gpg --keyserver "hkp://keys.gnupg.net" --recv-keys "D39DC0E3"'
su - vagrant -c '\curl -sSL https://get.rvm.io | bash'
source ~/.rvm/scripts/rvm
echo "source ~/.rvm/scripts/rvm" >> /home/vagrant/.bashrc
su - vagrant -c 'rvm install ruby-2.1.1'
su - vagrant -c 'rvm alias create system 2.1.1'
su - vagrant -c 'rvm install rubygems latest'
su - vagrant -c 'cd /vagrant && rvm gemset install rails -v "4.1"'
su - vagrant -c 'cd /vagrant && bundle install'
rm /vagrant/config/secrets.yml
RAILS_ENV="development"
SECRET="$(su - vagrant -c  'cd /vagrant && RAILS_ENV=$RAILS_ENV rake secret ')"
echo "$RAILS_ENV:" >> /vagrant/config/secrets.yml
echo "    secret_key_base: $SECRET" >> /vagrant/config/secrets.yml
RAILS_ENV="production"
SECRET="$(su - vagrant -c  'cd /vagrant && RAILS_ENV=$RAILS_ENV rake secret ')"
echo "$RAILS_ENV:" >> /vagrant/config/secrets.yml
echo "    secret_key_base: $SECRET" >> /vagrant/config/secrets.yml
RAILS_ENV="test"
SECRET="$(su - vagrant -c  'cd /vagrant && RAILS_ENV=$RAILS_ENV rake secret ')"
echo "$RAILS_ENV:" >> /vagrant/config/secrets.yml
echo "    secret_key_base: $SECRET" >> /vagrant/config/secrets.yml
rm -r /vagrant/public
rm /vagrant/rsnap_development.dump
cd /vagrant && unzip dump.zip
su - vagrant -c "cd /vagrant && rake db:drop db:create"
su - vagrant -c "cd /vagrant && psql -f rsnap_development.dump -d rsnap_development"
su - vagrant -c "cd /vagrant && rake modif_admin['Vagrant','Vagrant','Vagrant@rsnap.com','rsnap']"
su - vagrant -c "git clone -n git@github.com:simonhock/Snap--Build-Your-Own-Blocks.git /vagrant/app/assets/javascripts/snap-byob"
su - vagrant -c "git clone -n git@github.com:simonhock/Snap--Build-Your-Own-Blocks.git /vagrant/lib/assets/javascripts/snap-byob"
su - vagrant -c "cd /vagrant/app/assets/javascripts/snap-byob && git checkout"
su - vagrant -c "cd /vagrant/lib/assets/javascripts/snap-byob && git checkout"
sudo npm install bower -g
sudo apt-get -y install nodejs-legacy
su - vagrant -c 'echo -e "\n\n\n" | ssh-keygen -t rsa'
cp /home/vagrant/.ssh/id_rsa.pub /vagrant/
echo "Please add the rsa public key contained in \"id_rsa.pub\" in your github account then ssh to your vagrant (vagrant ssh) and run /vagrant/bagrant-build-2.sh "