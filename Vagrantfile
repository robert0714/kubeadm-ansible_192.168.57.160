# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"]
  else
    config.vm.synced_folder ".", "/vagrant"
  end
  (1..2).each do |i|
    config.vm.define "k8s-n#{i}" do |d|
      d.vm.box = "bento/centos-7.8"
      d.vm.hostname = "k8s-n#{i}" 
      d.vm.network "public_network", bridge: "eno4", gateway: "192.168.57.1" , ip: "192.168.57.16#{i}"  ,  netmask: "255.255.255.0" , auto_config: "false"
      # IP address of your LAN's router 
      default_router = "192.168.57.1"       
      # change/ensure the default route via the local network's WAN router, useful for public_network/bridged mode
      d.vm.provision :shell, inline: "ip route delete default 2>&1 >/dev/null || true; ip route add default via #{default_router}"
      
      d.vm.provider "virtualbox" do |v|
        v.memory = 8192
        v.cpus = 2
      end
    end
  end
  config.vm.define "k8s-m1" do |d| 
    d.vm.box = "bento/centos-7.7" 
    d.vm.hostname = "k8s-m1"
    d.vm.network "public_network", bridge: "eno4", ip: "192.168.57.160", auto_config: "false", netmask: "255.255.255.0" , gateway: "192.168.57.1"
    # IP address of your LAN's router 
    default_router = "192.168.57.1"       
    # change/ensure the default route via the local network's WAN router, useful for public_network/bridged mode
    d.vm.provision :shell, inline: "ip route delete default 2>&1 >/dev/null || true; ip route add default via #{default_router}"
    d.vm.provision :shell, path: "scripts/bootstrap4CentOs_ansible.sh"   
    d.vm.provider "virtualbox" do |v|
      v.memory = 8192
      v.cpus = 2
    end
  end
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
    config.vbguest.no_install = true 
    config.vbguest.no_remote = true
  end
  # Install of dependency packages using script
  # config.vm.provision :shell, path: "./hack/setup-vms.sh"
end
