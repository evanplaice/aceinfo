Vagrant.configure("2") do |config|
  config.vm.box = "gusztavvargadr/windows-server"
  config.vm.hostname = "aceinfo"
  config.vm.communicator = "winrm"
  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.network "forwarded_port", guest: 3389, host: 3389
  config.vm.network "forwarded_port", guest: 1433, host: 1433

  config.vm.provision :enable_rdp, type: "shell", path: "scripts/enable-rdp.ps1"
  config.vm.provision :choco_install, type: "shell", path: "scripts/choco-install.ps1"
  config.vm.provision :mssql_config, type: "shell", path: "scripts/mssql-config.ps1"
end
