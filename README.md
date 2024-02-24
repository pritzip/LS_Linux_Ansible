# Linux Team
> Talk's cheap; show me the code.
>               *Linus Torvalds*

** !!! LOGGING INTO UNIX HOSTS WILL BE DONE STRICTLY WITH SSH CERIFICATES **

## Objective
Our purpose is to create ansible playbooks and shell scripts for the hardening and monitoring of Linux & BSD hosts,  and create a knowledge base for future excercises

## Roles
During the excercise the roles of the team will be :
|  Name | Callsign | Role | Crowdstrike | Description|
| ----- | -------- | ---- | ----------- | ---------- |
| Nikolaidis | Banker | Head | ls22user13 | Coordinate efforts and Ansible operator |
| Valsamidis | Dealer | BEG Head | ls22user14 | Coordinate efforts in BEG and Ansible operator |
| Ntafos | Doorman | DMZ Infosec |  own  |Monitor firewalls |
| Veniamidis | Eagle | BEG Infosec | ls22user15 |Monitor FreeBSD/Linux hosts |
| Tsingelis | Joker | JIV Infosec - Forensics | ls22user16 | Monitor all BOB-JIV-KWT Linux hosts and provide Linux forensics |
| Papanikolaou | Ace | BAF Forensics | ls22user17 | BAF linux forensics **(no pub key submitted)**  |
| Papadakis | Adder | BAF Infosec | ls22user18 | Monitor linux hosts in BAF |

## Current Status
Here you'll find the latest updates for LS22.
For now we have:
- The Action Plan
- The latest network map (Apr 11 version)
- The Ansible Inventory (Apr 11 version)
- Playbooks for recconnaisance (read [Recce tests](#recce-rests))
- Playbook for bootstrapping UNIX hosts to Ansible
- Playbook for Phase 1 of the Action Plan (read [Phase1 tests](#phase1-rests))
- Playbook for Phase 2 of the Action Plan (read [Phase2 tests](#phase2-rests))
- Playbook for Phase 3 of the Action Plan (needs review/testing & split into roles)
- Script to create inventory used for the initial password change task
- The initial user database in [xlsx](https://github.com/BT17GR/LS22/blob/main/LinuxTeam/Users.xlsx?raw=true) and [csv](https://github.com/BT17GR/LS22/blob/main/LinuxTeam/Users.csv?raw=true) formats
- The initial host database in [xlsx](https://github.com/BT17GR/LS22/blob/main/LinuxTeam/Hosts.xlsx?raw=true) and [csv](https://github.com/BT17GR/LS22/blob/main/LinuxTeam/Hosts.csv?raw=true) formats
- All host information in the EXPO database in json files

All are open to suggestions, so don't hesitate.

**ATENTION** the connection to LS22 will be through OpenConnect VPN client
```console
sudo apt install openconnect network-manager-openconnect-gnome (or network-manager-openconnect-kde)
```
- Click on network manager, select "Settings", and press "+" in the VPN group  
- Select Mutiprotocol VPN cleint (openconnect) 
- Enter a name for the VPN:**LS22**, the gateway:**vpn.cr14.net** ans save
- Click on network manager, select "LS22" or the name you entered and connect using CR14 credentials
- Create an email account and the "LS22 email signup" service below 
- if you experience DNS problems add in /etc/resolv.conf:
```console
nameserver 100.100.100.2
nameserver 100.100.100.3 
```

**ATENTION** Contact your team leader for the crowdstrike password

## Services

The web services for the exercise are:
|  Service | VPN | Login |
| -------- | --- | ----- |
| [Chat&VTC](https://chat.cr14.net) | N | CR14 |
| [Documentation](https://natocr14.sharepoint.com/sites/LS22) | N | CR14 |
| [VPN](https://vpn.cr14.net) | N | CR14 |
| [Exercise Portal (EXPO)](https://expo.berylia.org) | Y | CR14 |
| [Nerylia maps](https://maps.berylia.org) | Y | N/A |
| [Green Team Tickets](https://ticket.berylia.org) | Y | LS22 |
| [Development platform](https://providentia.cr14.net) | Y | CR14 |
| [LS22 email signup](https://mail.berylia.org/admin/ui/user/signup) | Y | N/A |
| [LS22 email](https://mail.berylia.org/webmail) | Y | LS22 |
| [Public upload](https://upload.berylia.org/#/) | Y | N/A |
| ISO upload sftp://sftp.c-lab.ee/ | N | CR14 |
| [News (virtual)](https://news.berylia.org/#/) | Y | N/A |
| [IP check](http://ip.berylia.org/#/) | Y | N/A |

## Points of Interest
Some points of interest that we need to take a closer look are:
- Create logical firewall rules for hosts
- Install sysmon for Linux vs aide(not syslog friendly)+custom monitoring scripts(forkstat,dtrace,tcpflow...)
- 4 hosts with multiple interfaces in BAF 5G CORE(1) 5G RAN(3)
- No DMZ for KWT nets
- Securing the Kubernetes cluster
- Identifying additional Docker hosts not listed in the map below (store, prices are probable public web servers in the Kubernets cluster, and there are more internal services )

![Network Map](https://github.com/BT17GR/LS22/blob/main/LinuxTeam/network.png?raw=true)

## Recce tests
The reconnaisanve playbooks cover linux hosts mostly. All the data collected are transferred to the ansible host and will be uploaded to github during FAMEX to be examined.

Unfortunately not all tests run smoothly, but the good news is that docker benchmark is available, although the bad news is that docker hardening should be done manually. 

## Phase1 Tests
To accommodate the need of password changes a script is included (scripts/init_inventory). The script produces an initial inventory (init_inventory.yaml) to be used only in phase 1 cleanup users task, because the default credentials are not active yet.

The hosts should have at least one sudoer, and Python installed. To create a playbook that handles all these issues is quite complex for different OSes, so the noncompliant hosts should be identified during FAMEX and should be dealt with manually:

```console
ssh user_name@noncompliant_host
su - #if not root
pkg(or apt or yum or brew or whatever) install sudo, python
usermod -aG sudo(or wheel) user_name
vi /path/to/sudoers #ensure there is an uncommented line %sudo ALL=(ALL) NOPASSWD:ALL OR %wheel ALL=(ALL) NOPASSWD:ALL
```

All non compliant hosts will be assigned equally to all the Linux team members in order to make the necessary changes as fast as possible. **So please excercise the task above to get well acquainted with it.**

## Phase2 Tests
Hardening works on Linux systems without problems, but unfortunately FreeBSD hosts are roughly covered. Although the excution is very fast during tests, the real execution time for all LS22 might exceed 10mins.

The problem here is to detect any service interruptions that are due to the hardening

## Useful Tips
Everyone will be working on their own workstation located within the 10.17.60.0/23, 2a07:1182:17:6000::/64 IP range

You may use the github [Issues tab](https://github.com/BT17GR/LS22/issues) to communicate suggestions/questions and other matters, please add 'Linux:' as first word in the issue title

Create an SSH key if you haven't one already, prefer RSA 2048bit to avoid compatibility issues, [and post it here](https://github.com/BT17GR/LS22/issues/2), your key needs to be included in the roles/cleanup_users/files/trustedkeys.pub in order to login to excercise hosts
```console
ssh-keygen -b 2048 -t rsa
cat ~/.ssh/id_rsa.pub
```

Install terminator on your workstation(s) to be able to monitor many hosts at once (or tmux, if you're a connoisseur)
```console
sudo apt update || sudo yum update
sudo apt install terminator -y || sudo yum install terminator -y
```
The OSes installed are:
- Ubuntu 20.04, 18.04
- Debian 11, 10
- Almalinux Linux 8
- Scientific Linux 7
- FreeBSD 12
 
Listing all hosts for given OS and version from the inventory:
```console
grep -A1 -B5 freebsd ~/ansible/inventory.yml | grep -B6 "ver: 12" | grep -oE [0-9a-z_]+:\s*$ | sort
```

If you make changes to the ansible inventory be sure to test them:
```console
ansible-inventory [-i <inventory_file>] --list
```

To test a playbook, add the test host in the inventory and use:
```console
ansible-playbook <playbook> --check --diff --limit <test host>
```

If you use a Windows workstation please install the Linux subsystem (WSL) or cygwin. Anthough there's an ansible package for cygwin, it is old, and I recommend to install it using python. Cygwin installs many versions of python, and can be troublesome to install ansible, but it is possible using python 3.8, and of course you'll need to install gcc-core, gcc-g++, make, automake, python38-pip, python38-cython before installing ansible as described below

To query about a host(s):
```console
scripts/expo_search_host.sh "ws1|ws2"
```

To query about a user(s):
```console
scripts/expo_search_user.sh <username>
```

To set password:
```console
scripts/expo_set_password.sh <realm> <username> <password>
```

To get information about all hosts:
```console
 cat scripts/expo_hosts.db | grep 17\.bery | sed s/.17.berylia.org//  | xargs -L1 -I{} sh -c 'FILE=$(echo "$1"|sed "s/\./_/g").json;~/ansible/scripts/expo_search_host.sh "$1" > ~/ansible/expo/"$FILE"' -- {}
 find ~/ansible/expo/ -type f -size 38c | xargs -L1 rm
```

## Ansible installation
> To err is human, to really scr*w up the whole network is ansible
```console
sudo apt install python3-pip sshpass git -y || sudo yum install python3-pip sshpass git -y
cd ~/Documents && git clone https://github.com/BT17GR/LS22
python -m pip install --user ansible paramiko
mkdir ~/.ansible && ln -s ~/.ansible ~/ansible
tee -a ~/.ansible.cfg > /dev/null <<EOT
[defaults]
inventory=~/.ansible/inventory.yml
filter_plugins=$(find / -xdev -name filter 2>/dev/null | grep -v collections | grep ansible/plugins | tr '\n' ':')~/.ansible/filters
forks = 20


[ssh_connection]
scp_if_ssh=True
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o PreferredAuthentications=publickey,password
EOT
cp -r ~/Documents/LS22/LinuxTeam/* ~/ansible/
cd ~/ansible/
ansible-galaxy install -r requirements.yml
```

## Monitoring & Reporting
Every player wiil be assigned some hosts to monitor closely in order to detect suspicious activity

Such monitoring can be done for example using terminator, sshing to the hosts to be monitored and enter:
```console
tail -f /var/log/auth.log & tail -f /var/log/syslog | grep 'aide\:|clamav:\|netwatch:'
```

The purpose of reporting is to answer the questions who? what? where? when?

The answer to what is the Indicators Of Compromise (IOCs) that can take many detectable forms:
- Existence of a file name
- Existence of file content (represented by a hash in the report)
    - md5sum \<file\>
    - hasher -a md5 \[-S \<starting offset\>\] \[-E \<ending offset\>\] \[-L <\length\>] \<file\>
    - grep \<pattern\> \<file\> | hasher -a md5 -L \<length\>
- An open port
- Configuration changes
- Process Names
- Incorrect log-ins
- Access denials
- Multiple network connections to a port
- Multiple network connections from a host
- blah blah

The first person to report to is the zone team leader, and then the Linux team leader, more details on this later on

## Incident Response
The rules of engagement are:
- The are no rules, everything goes if it does not involve shooting yourself in the foot

