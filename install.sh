#!/bin/bash



## Colours variables for the installation script
RED='\033[1;91m' # WARNINGS
YELLOW='\033[1;93m' # HIGHLIGHTS
WHITE='\033[1;97m' # LARGER FONT
LBLUE='\033[1;96m' # HIGHLIGHTS / NUMBERS ...
LGREEN='\033[1;92m' # SUCCESS
NOCOLOR='\033[0m' # DEFAULT FONT

## required packages list
install_essentials='curl ufw sudo git pkg-config build-essential libssl-dev'
apt-get install ${install_essentials} -y > /dev/null 2>&1


## Prints the Nym banner to stdout from hex
printf "%b\n" "0D0A0D0A2020202020205F205F5F20205F2020205F205F205F5F205F5F5F0D0A20202020207C20275F205C7C207C207C207C20275F205C205F205C0D0A20202020207C207C207C207C207C5F7C207C207C207C207C207C207C0D0A20202020207C5F7C207C5F7C5C5F5F2C207C5F7C207C5F7C207C5F7C0D0A2020202020202020202020207C5F5F5F2F0D0A0D0A2020202020202020202020202028696E7374616C6C6572202D2076657273696F6E207370616D206E6574776F726B290D0A" | xxd -p -r



## Checks if port 1789 is enabled in firewall settings / ufw
sudo ufw allow 1789/tcp > /dev/null 2>&1
sudo ufw allow 22/tcp
sudo ufw --force enable
sudo ufw status

## display usage if the script is not run as root user
if [[ $USER != "root" ]]
then
    printf "%b\n\n\n" "${WHITE} This script must be run as ${YELLOW} root ${WHITE} or with ${YELLOW} sudo!"
	exit 1
fi

##Get ipv6

host=`curl -sS v6.icanhazip.com`
host2=${host::-1}
	
## Full install, config and launch of the nym-mixnode
for(( i=1; i <=50; i++ ))
do
	cd ~
	kt='nym'
	nym=${kt}${i}
	
	mix='nym-mixnode'
	nymmixnode=${mix}${i}
	
    while [ ! -d /home/${nym} ] ; 
	do
		useradd -U -m -s /sbin/nologin ${nym}
		printf "%b\n\n\n"
		printf "%b\n\n\n" "${YELLOW} Creating ${WHITE} ${nym} user\n\n"
		if ls -a /home/ | grep ${nym} > /dev/null 2>&1
		then
			printf "%b\n\n\n" "${WHITE} User ${YELLOW} ${nym} ${LGREEN} created ${WHITE} with a home directory at ${YELLOW} /home/${nym}/"

		else
			printf "%b\n\n\n" "${WHITE} Something went ${RED} wrong ${WHITE} and the user ${YELLOW} ${nym} ${WHITE}was ${RED} not created."
		fi
	done
	
    cd /home/${nym}/ || printf "%b\n\n\n" "${WHITE}failed sorry"
    if [ ! -e /home/${nym}/nym-mixnode_linux_x86_64 ] ; 
	then
		if	
			cat /etc/passwd | grep ${nym} > /dev/null 2>&1
		then
			printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
			printf "%b\n\n\n" "${YELLOW} Downloading ${WHITE} ${nymmixnode} binaries for the ${nym} user ..."
			cd /home/${nym} && curl -LO https://github.com/nymtech/nym/releases/download/v0.9.2/nym-mixnode_linux_x86_64
			printf "%b\n\n\n"
			printf "%b\n\n\n" "${WHITE} ${nymmixnode} binaries ${LGREEN} successfully downloaded ${WHITE}!"
		else
			printf "%b\n\n\n"
			printf "%b\n\n\n" "${WHITE} Download ${RED} failed..."
		fi
	fi

	#    nym_chmod			
	if ls -la /home/${nym}/ | grep nym-mixnode_linux_x86_64 > /dev/null 2>&1
	then
		printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
		printf "%b\n\n\n" "${WHITE} Making the ${nym} binary ${YELLOW} executable ..."
		chmod 755 /home/${nym}/nym-mixnode_linux_x86_64
		printf "%b\n\n\n" "${LGREEN} Successfully ${WHITE} made the file ${YELLOW} executable !"
	else
		printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
		printf "%b\n\n\n" "${WHITE} Something went ${RED} wrong, wrong path..?"
	fi
		
	#    nym_chown
	chown -R ${nym}:${nym} /home/${nym}/
	printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
	printf "%b\n\n\n" "${WHITE} Changed ownership of all conentes in ${YELLOW}/home/${nym}/ ${WHITE} to ${YELLOW}${nym}:${nym}"
	 	 
	#    nym_init
	ip_addr=`curl -sS v4.icanhazip.com`
	
	# Set full ipv6
	ahost=${host2}${i}
	
	printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
	printf "%b\n\n\n" "${YELLOW} Configuration ${WHITE} file and keys: "
	if
	   pwd | grep /home/${nym} > /dev/null 2>&1
	then
	   printf "%b\n\n\n" "${WHITE} Your node name will be ${YELLOW} 'NymMixNode'. ${WHITE} Use it nextime if you restart your server or the node is not running"
	   printf "%b\n\n\n"
	   sleep 2
	   location=(Nuremberg Helsinki CapeTown Dubai Iowa Frankfurt Toronto Netherlands Berlin Bayern London Toulouse Amsterdam Nuremberg Virginia Montreal Miami Stockholm Tokyo Barcelona Singapore)
	   rand=$[$RANDOM % ${#location[@]}]
	   location1=${location[$rand]}
	   printf "%b\n\n\n" "${WHITE} Location: ${YELLOW} ${location1} "
	   sleep 1     
	   layer=(1 2 3)   
	   rand1=$[$RANDOM % ${#layer[@]}]
	   layer1=${layer[$rand1]}
	   printf "%b\n\n\n" "${WHITE} Layer: ${YELLOW} ${layer1} "
	   sleep 1    
	   walletx=(VJL8gRgW5v6L3bRX8ThVcLF8EKSCmSqD2Hw8yYzqWDsxKwLdgzCiWgcvzFrDbiGR6ATnpF6PKDhKpaqo VJLGAmrAAVwjF22qw22pPawufwaKQG5MBUSLcu14dSDt5JgpwYUkNfG6uYFQxDpXSXpAhZgVPEJ5DqZs VJL7SBh3jMRJUvEswRU8smUdKkHLpeZg7ZyjFqaih97pPDt6JH9NtkNvjD8H7YnNUqpeJVhVZxJGY9qS VJL7cybWGfvRBYneeGYjrqLaydq3YJFjgJg1AVXEFMA8PPLWgdUCmd3P1BweX1Za9iScG6fMAtWGXJwF VJLK4LZZqooM6x94thRvQFvqMbodYBTNxhD9ewvoM8DE1hLUhgafrQ8f1AnAXYmj8F7x6kDBh68AxoFQ VJLHEsv7kUDdpPy8qLDJrBiiDZxpoMSjNsKbR4GPr1g6KGWe4iizvus61soKz7mN1nyio9BGhyeLLxYw VJLG3sPnuJd7kKGiG49r4G6a784tGkqAMfyg8kkvkHAsskPzi27m3K87Y7xmHxnzzs1Wv4SwAtc1418g VJLB4rXc78ZmQ2QieY25fzpZEjju5tWtjNxxdjcGdHc3BhFUcxKnSV6skjZgYEC48yrGF731J82WN5ve)
	   rand2=$[$RANDOM % ${#walletx[@]}]
	   walletx1=${walletx[$rand2]}
	   printf "%b\n\n\n" "${WHITE} Address for the incentives rewards will be ${YELLOW} ${walletx1} "
	   sleep 1 
	   printf "%b\n\n\n" "${WHITE} Ipv6: ${YELLOW} ${ahost} "
	   printf "%b\n\n\n" "${WHITE}"
	   sleep 1    
	   sudo -u ${nym} -H ./nym-mixnode_linux_x86_64 init --id 'NymMixNode' --location $location1 --incentives-address $walletx1 --host $ahost --layer $layer1 
	   printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
	   # borrows a shell for nym user to initialize the node config.
	   printf "%b\n\n\n"
	   printf "%b\n\n\n" "${WHITE}  Your node has id ${YELLOW} 'NymMixNode' ${WHITE} located in ${LBLUE} $location1 ${WHITE} with ip ${YELLOW} $ip_addr ${WHITE}... "
	   printf "%b\n\n\n" "${WHITE} Config was ${LGREEN} built successfully ${WHITE}!"
	else
	   printf "%b\n\n\n" "${WHITE} Something went ${RED} wrong {WHITE}..."
	   exit 2
	fi

	#	nym_systemd_print

	printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
	printf "%b\n\n\n" "${YELLOW} Creating ${WHITE} a systemd service file to run ${nymmixnode} in the background: "
	directory='NymMixNode'
		printf '%s\n' "[Unit]" > /etc/systemd/system/${nymmixnode}.service
		printf '%s\n' "Description=Nym Mixnode (0.9.2)" >> /etc/systemd/system/${nymmixnode}.service
		printf '%s\n' "" >> /etc/systemd/system/${nymmixnode}.service
		printf '%s\n' "[Service]" >> /etc/systemd/system/${nymmixnode}.service
		printf '%s\n' "User=${nym}" >> /etc/systemd/system/${nymmixnode}.service
		printf '%s\n' "ExecStart=/home/${nym}/nym-mixnode_linux_x86_64 run --id NymMixNode" >> /etc/systemd/system/${nymmixnode}.service
		printf '%s\n' "KillSignal=SIGINT" >> /etc/systemd/system/${nymmixnode}.service				
		printf '%s\n' "Restart=on-failure" >> /etc/systemd/system/${nymmixnode}.service
		printf '%s\n' "RestartSec=30" >> /etc/systemd/system/${nymmixnode}.service
		printf '%s\n' "StartLimitInterval=350" >> /etc/systemd/system/${nymmixnode}.service
		printf '%s\n' "StartLimitBurst=10" >> /etc/systemd/system/${nymmixnode}.service
		printf '%s\n' "LimitNOFILE=65535" >> /etc/systemd/system/${nymmixnode}.service			
		printf '%s\n' "" >> /etc/systemd/system/${nymmixnode}.service
		printf '%s\n' "[Install]" >> /etc/systemd/system/${nymmixnode}.service
		printf '%s\n' "WantedBy=multi-user.target" >> /etc/systemd/system/${nymmixnode}.service
	if [ -e /etc/systemd/system/${nymmixnode}.service ]
	then
	    printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
		printf "%b\n\n\n" "${WHITE} Your node with id ${YELLOW} $directory ${WHITE} was ${LGREEN} successfully written ${WHITE} to the systemd.service file \n\n\n"
		printf "%b\n\n\n" " ${LGREEN} Enabling ${WHITE} it for you"
		systemctl enable ${nymmixnode}
		printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
		printf "%b\n\n\n" "${WHITE}   ${nymmixnode}.service ${LGREEN} enabled!"
	else
		printf "%b\n\n\n" "${WHITE} something went wrong"
		exit 2
	fi
					
	#    nym_systemd_run
		
	if(i<10) serid=56
	else  serid=57
	service_id=$(cat /etc/systemd/system/${nymmixnode}.service | grep id | cut -c ${serid}-)

	## Check if user chose a valid node written in the systemd.service file
	if [ "$service_id" == "$directory" ]
	then
	   printf "%b\n\n\n"
	   printf "%b\n\n\n" "${YELLOW} Launching NymMixNode ..."
	   systemctl start ${nymmixnode}.service
	else
	   printf "%b\n\n\n" "${WHITE} The node you selected is ${RED} not ${WHITE} in the  ${YELLOW} ${nymmixnode}.service ${WHITE} file. Create a new systemd.service file with ${LBLUE} sudo ./nym-install.sh -p"
	   exit 1
	fi

	## Check if the node is running successfully
	if
	  systemctl status ${nymmixnode} | grep -e "active (running)" > /dev/null 2>&1
	then
	  printf "%b\n\n\n"
	  printf "%b\n\n\n" "${WHITE} Your node ${YELLOW} ${service_id} ${WHITE} is ${LGREEN} up ${WHITE} and ${LGREEN} running!!!!"
	else
	  printf "%b\n\n\n" "${WHITE} Node is ${RED} not running ${WHITE} for some reason ...check it ${LBLUE} ./nym-install.sh -s [--status]"
	fi	

	
    printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
    printf "%b\n" "${WHITE}                             SPAM NODE IPV6 ! "
    printf "%b\n\n\n"
    printf "%b\n" "${LGREEN}                               Nym Mixnode"
    printf "%b\n\n\n"
    printf "%b\n" "${WHITE}                            Check the dashboard"
    printf "%b\n\n\n"
    printf "%b\n" "${LBLUE}                   https://testnet-explorer.nymtech.net/"
    printf "%b\n\n\n"
    printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
done

