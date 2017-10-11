# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
	# The most common configuration options are documented and commented below.
	# For a complete reference, please see the online documentation at
	# https://docs.vagrantup.com.

	# Every Vagrant development environment requires a box. You can search for
	# boxes at https://vagrantcloud.com/search.
	config.vm.box = "boxcutter/ubuntu1604"

	# The url from where the 'config.vm.box' box will be fetched if it
	# doesn't already exist on the user's system.
	config.vm.box_url = "https://app.vagrantup.com/boxcutter/boxes/ubuntu1604"

	# memory increase
	config.vm.provider "virtualbox" do |v|
        v.memory = 4964
        v.cpus = 4
    end
					  
	PATH_VAGRANT_PROJECT=File.dirname(__FILE__)
	
	
	# aws configs
	config.vm.provision "file", source: "#{PATH_VAGRANT_PROJECT}\\vagrant-configs\\.aws\\config", destination: "/home/vagrant/.aws/config"
	config.vm.provision "file", source: "#{PATH_VAGRANT_PROJECT}\\vagrant-configs\\.aws\\credentials", destination: "/home/vagrant/.aws/credentials"
	
	# docker configuration tells to trust the OpenShift registry
	config.vm.provision "file", source: "#{PATH_VAGRANT_PROJECT}\\vagrant-configs\\daemon.json", destination: "/home/vagrant/daemon.json"
	
	
	###############
	#####  LOCAL PROVISIONERS INSTEAD OF DOWNLOAD
	
	#config.vm.provision "file", source: "#{PATH_VAGRANT_PROJECT}\\vagrant-artifacts\\openshift-origin-client-tools-v3.6.0-c4dd4cf-linux-64bit.tar.gz", destination: "/home/vagrant/openshift-client.tar.gz"

	
	
	# forward ports

	# ldap
	config.vm.network :forwarded_port, guest: 389, host: 389
	config.vm.network :forwarded_port, guest: 8081, host: 8081
	config.vm.network :forwarded_port, guest: 636, host: 636
	config.vm.network :forwarded_port, guest: 8082, host: 8082
	
	# openshift
	config.vm.network :forwarded_port, guest: 8443, host: 8443
	config.vm.network :forwarded_port, guest: 53 , host: 53
	
	# all files here will be added to home
	config.vm.synced_folder "vagrant-home/", "//root/vagrant-home/"
	
  
	# Use shell script to provision
	config.vm.provision "shell", inline: <<-SHELL
			
	
		# update
		apt-get update	
		
		
		# ###############
		# ##### DOWNLOAD INSTEAD OF LOCAL PROVISIONERS
		wget -O '/home/vagrant/openshift-client.tar.gz' https://github.com/openshift/origin/releases/download/v3.6.0/openshift-origin-client-tools-v3.6.0-c4dd4cf-linux-64bit.tar.gz
		
		
		###############
		##### DOCKER
		
		# install docker
		apt-get -y install docker.io
		# tune docker to accept insecure openshift registry by using this configs
		sudo mv /home/vagrant/daemon.json /etc/docker/daemon.json
		
		#tune docker to use "systemd" as cgroupdriver, required to run OpenShift3 on Ubuntu
		# https://nology.de/openshift-systemd-is-different-from-docker-cgroup-driver-cgroupfs.html
		sudo chmod 777 /lib/systemd/system/docker.service
		sudo sed -E 's/^(ExecStart.*)/\\1 --exec-opt native.cgroupdriver=systemd/g' -i /lib/systemd/system/docker.service
		
		sudo systemctl daemon-reload
		sudo systemctl restart docker
		
		
		###############
		##### AWS
		
		apt-get -y install awscli
		sudo mv /home/vagrant/.aws /root/
		
		
		
		
		
		###############
		##### RESTORE BACKUPS		
		bash /root/vagrant-home/backup-RestoreFromS3.sh
		


		###############
		##### LDAP
		cd /root/vagrant-home/
		bash ./openldap-start.sh		
		
		# TODO integrate OpenShift with LDAP
		
		
		
		
		###############
		##### OPENSHIFT
		
		# unpack openshift
		cd /root/
		tar -xf /home/vagrant/openshift-client.tar.gz --directory /root/
		mv openshift-origin-client-tools-* openshift-client
		chmod -R 777 /root/openshift-client
		rm /home/vagrant/openshift-client.tar.gz
		
		# add oc to the path permanently
		echo -e "\n" >> /root/.bashrc
		echo -e 'export PATH=$PATH:/root/openshift-client/' >> /root/.bashrc
		source /root/.bashrc
		
		#start openshift
		cd /root/openshift-client/
		sudo ./oc cluster up --host-data-dir=/data/openshift --use-existing-config

	SHELL
  
end
