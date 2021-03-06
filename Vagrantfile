# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'example.config.rb'

if File.exist?('vagrant.config.rb')
  require_relative 'vagrant.config.rb'
elsif File.exist?('../vagrant.config.rb')
  require_relative '../vagrant.config.rb'
end

Vagrant.configure("2") do |config|
  config.vm.box = $box

  # setup virtual hostname and provision local IP
  config.vm.network :private_network, :ip => $ip
  config.vm.hostname = $hostname

  # Setup synced folders as defined in (vagrant./example.)config.rb.
  $synced_folders.each do |folder|
    config.vm.synced_folder folder[0],folder[1]
  end

  # Port forwarding.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "forwarded_port", guest: 443, host: 8443

  # Update vagrant bashrc.
  config.vm.provision :shell, path: "provision/shell/bashrc_update.sh"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "provision/puppet/manifests"
    puppet.module_path = "provision/puppet/modules"
    puppet.manifest_file  = "init.pp"
    # puppet.options="--verbose --debug"
  end

  # Fixes problem that apache2 won't start on boot.
  # @see http://stackoverflow.com/questions/21599728/apache-fails-to-start-on-vagrant
  config.vm.provision :shell,inline: "sudo service apache2 restart", run: "always"

  # Fix for slow external network connections
  config.vm.provider "virtualbox" do |vb|
    vb.name = $vb_name
    vb.memory = $vb_memory
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
  end
end
