Preseed.cfg - selects Standard Debian packages and SSH server  

line 55 - Add encrypted Root password (Ex: Use mkpasswd --method=SHA-512 --rounds=4096 which prompt to enter a password)  
line 118 - Also installs qemu-guest-agent, cloud-init, vim, htop, and ntp  
line 191 - add SSH key for Root user (after ssh-rsa)  
line 195 - add IP address of NTP server if needed  


debian11.pkr.hcl - Update variables as needed  

line 23 - Change VM disk size  
line 28 - Change VM storage  
line 38 - Change VM memory amount  
line 43 - Update VLAN number or remove variable if not used  
line 71 - Update network adapter  
line 95 - Update Template name  
line 101 - Add SSH passsword for cloud-init  


cloud.cfg - Cloud init configuration file  

line 78 - Add username if needed  
line 79 - Add groups for user  
line 82 - Add encrypted password for user  
line 84 - Add SSH key for user  


Use commands below to validate and run Proxmox Debian template  

packer validate -var-file variables.pkrvars.hcl debian11.pkr.hcl  
packer build -var-file variables.pkrvars.hcl debian11.pkr.hcl  
