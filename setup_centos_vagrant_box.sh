# setup centos vagrant box
vagrant init box-cutter/centos72-docker

## edit Vagrantfile to increase memory, set hostname, and forward ports
Vagrant.configure(2) do |config|
	#...
	config.vm.provider "virtualbox" do |vb|
		vb.memory = "2048"
	end

	config.vm.hostname="centos"

	config.vm.network :forwarded_port, guest: 80, host: 10080
	config.vm.network :forwarded_port, guest: 8080, host: 18080
	config.vm.network :forwarded_port, guest: 3000, host: 13000
end

# startup and connect
vagrant up
vagrant ssh

#####

# create backup user for when you screw up the .bashrc for vagrant user and can't login anymore
sudo adduser aaron
sudo passwd aaron
usermod -a -G wheel aaron

# login as user
ssh -p 2222 aaron@localhost
sudo su -

#####

# update 
sudo yum update

# install development tools
sudo yum groupinstall "Development Tools"

# install misc tools
sudo yum install mlocate

# install other libraries
sudo yum install bzip2 bzip2-devel bzip2-libs
#sudo yum install gettext readline
#sudo yum install zlib zlib-devel
#sudo yum install openssh openssh-libs openssl openssl-devel

# install git
sudo yum install git

# install java (openjdk)
sudo yum install java-1.8.0-openjdk-devel
echo "export JAVA_HOME=/etc/alternatives/java_sdk" >> ~/.bashrc
source ~/.bashrc 

# install java (oracle JDK)
# need to copy download from external source first (because of clickthrough agreement)
cp /vagrant/jdk-8u77-linux-x64.tar.gz . 
tar -xvzf jdk-8u77-linux-x64.tar.gz
ln -s jdk1.8.0_77 java
echo "export PATH=$JAVA_HOME/bin:$PATH" >> ~/.bashrc

# install maven
wget http://download.nextag.com/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar -xvzf apache-maven-3.3.9-bin.tar.gz
ln -s apache-maven-3.3.9 maven
echo "export M2_HOME=~/maven" >> ~/.bashrc
echo "export PATH=\$M2_HOME/bin:\$PATH" >> ~/.bashrc

# install node.js (using nvm https://github.com/creationix/nvm)
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
source ~/.bashrc
nvm install 4.3.2
nvm use default 4.3.2

# install go (binary)
wget https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
tar -xvzf go1.6.linux-amd65.tar.gz
mv go go-1.6
ln -s go-1.6 golang

echo "export GOROOT=~/golang" >> ~/.bashrc
echo "export GOPATH=~/gopath" >> ~/.bashrc
echo "export PATH=\$GOROOT:\$PATH"
source ~/.bashrc
mkdir -p  $GOPATH

# install go from source (using gvm https://github.com/moovweb/gvm)
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
gvm install go1.4
gvm use 1.4
gvm install go1.6
gvm use go1.6 --default

echo '[[ -s "$HOME/.gvm/bin/gvm-init.sh" ]] && source "$HOME/.gvm/bin/gvm-init.sh"' >> ~/.bashrc

# install python (using pyenv https://github.com/yyuu/pyenv)
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
echo "export PYENV_ROOT=\$HOME/.pyenv" >> ~/.bash_profile
echo "export PATH=\$PYENV_ROOT/bin:$PATH" >> ~/.bash_profile
echo "eval \$(pyenv init -)" >> ~/.bash_profile
source ~/.bash_profile
pyenv install 2.7.10
pyenv install 3.4.3
echo "export PYENV_VERSION=2.7.10:3.4.3" >> ~/.bash_profile
source ~/.bash_profile

# install ruby (using rvm https://rvm.io/)
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.profile
rvm install 2.2.4
rvm use default 2.2.4

# install jenkins (https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Red+Hat+distributions)
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins
sudo service jenkins start

# install zeromq & libs 
...


