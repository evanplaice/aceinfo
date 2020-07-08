chocolatey feature enable -n=allowGlobalConfirmation

choco install python3
choco install nginx
choco install sql-server-2019
choco install sql-server-management-studio

chocolatey feature disable -n=allowGlobalConfirmation
