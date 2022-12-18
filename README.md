# README

##必要パッケージ導入まで
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y build-essential git libssl-dev libreadline-dev zlib1g-dev npm
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL -l


mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv install 3.1.3
rbenv global 3.1.3

sudo apt-get install -y npm
sudo npm install n -g
sudo n stable
sudo apt-get purge nodejs npm
sudo apt-get autoremove
exec $SHELL -l

sudo npm install yarn -g

gem install -v 7.0.4 rails

##このアプリのセットアップまで
cd
git clone https://github.com/s191049/piyo.git
cd piyo
bundle install
rails yarn:install
rails db:migrate:reset

##起動方法
cd ~/piyo
bin/dev




<!--
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# piyo
-->
