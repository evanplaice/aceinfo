# Aceinfo Vagrant Setup

## Step 1 - Provision a Windows Server 2019 Box

After installing both VirtualBox and Vagrant provision a bare Windows Server 2019 box

```ruby
Vagrant.configure("2") do |config|
  # use a Windows Server 2019 Standard base box
  config.vm.box = "gusztavvargadr/windows-server"
  # set the hostname
  config.vm.hostname = "aceinfo"
  # set the local IP Address
  config.vm.network "private_network", ip: "192.168.50.4"
end
```

Build the VM
```sh
vagrant init
```

Check it with
```sh
vagrant ssh
```

**References**
- [Machine Settings - Vagrant](https://www.vagrantup.com/docs/vagrantfile/machine_settings)
- [Building a Disposable Windows 2016 Domain Controller in 20 Minutes with Vagrant](https://medium.com/subpointsolutions/building-a-disposable-windows-2016-domain-controller-in-20-minutes-with-vagrant-fce6eb4e01bd)
- [Windows 2018 Server Standard Box](https://app.vagrantup.com/gusztavvargadr)


## Step 2 - Enable RDP (Remote Desktop Protocol)

Enable the Remote Desktop Protocol in the Windows Box

*Vagrantfile*
```ruby
Vagrant.configure("2") do |config|
  # use RDP for communication
  config.vm.communicator = "winrm"
  # configure port forwarding for RDP
  config.vm.network "forwarded_port", guest: 3389, host: 3389

  # run the RDP configuration script
  config.vm.provision :enable_rdp, type: "shell", path: "scripts/enable-rdp.ps1"
end
```

Update the VM
```sh
vagrant reload --provision
```

**Resources**
- [How do I RDP into my vagrant box - StackOverflow](https://stackoverflow.com/a/52510541/290340)
- [bigfix/vagrant-mssql - GitHub](https://github.com/bigfix/vagrant-mssql)

## Step 3 - Installing Software

This step will install the following using the Chocolatey CLI utility

- python3
- nginx
- sql server 2019 (dev)
- sql server management studio

*Vagrantfile*
```ruby
Vagrant.configure("2") do |config|
  # run the chocolately installation script
  config.vm.provision :choco_install, type: "shell", path: "scripts/choco-install.ps1"
```

Update the VM
```sh
vagrant reload --provision
```

*References*
- [Chocolatey.org](https://chocolatey.org/)
- [Vagrant Part 5 - Installing Your Software](https://digitaldrummerj.me/vagrant-installing-your-software/)


## Step 4 - Configure MSSQL

This step enables MSSQLSERVER TCP access on port 1433

*Vagrantfile*
```ruby
Vagrant.configure("2") do |config|
  # configure port forwarding for MSSQL
  config.vm.network "forwarded_port", guest: 1433, host: 1433

  # run the MSSQL configuration script
  config.vm.provision :choco_install, type: "shell", path: "scripts/choco-install.ps1"
end
```

Update the VM
```sh
vagrant reload --provision
```

- [How to: Enable or Disable a Server Network Protocol (SQL Server PowerShell)](https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/dd206997(v=sql.105)?redirectedfrom=MSDN)

## Appendix A - Notes

### Check if .NET is installed

```powershell
get-windowsfeature net-framework*
```

- [How to enable a Windows feature via Powershell - StackOverflow]](https://stackoverflow.com/a/14236507/290340)

### Search and List Windows Services

Use this to ensure that the background services are installed and running

```cmd
sc query [service]
```

*nginx*
```cmd
sc query nginx
```

**mssql**
```cmd
sc query MSSQLSERVER
```

- [Windows: List Services – CMD & PowerShell](https://www.shellhacks.com/windows-list-services-cmd-powershell/)

### Find MSSQL TCP Port

Find the PID (Process ID) in Task Manager then...

```cmd
netstat -ano | findstr *PID*
```

- [How to find SQL Server running port? - StackOverflow](https://stackoverflow.com/a/17188494/290340)

## Appendix B - Useful Tools

- [Ruby Plugin for VSCode](https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby)
- [SQL Server Plugin for VSCode](https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql)
- [rDesktop - Remote Desktop Client for Linux](https://www.rdesktop.org/)
