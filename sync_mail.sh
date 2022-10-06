#!/bin/bash
function menu {
clear
echo "
░██████╗██╗░░░██╗███╗░░██╗░█████╗░  ███╗░░░███╗░█████╗░██╗██╗░░░░░  ████████╗░█████╗░░█████╗░██╗░░░░░
██╔════╝╚██╗░██╔╝████╗░██║██╔══██╗  ████╗░████║██╔══██╗██║██║░░░░░  ╚══██╔══╝██╔══██╗██╔══██╗██║░░░░░
╚█████╗░░╚████╔╝░██╔██╗██║██║░░╚═╝  ██╔████╔██║███████║██║██║░░░░░  ░░░██║░░░██║░░██║██║░░██║██║░░░░░
░╚═══██╗░░╚██╔╝░░██║╚████║██║░░██╗  ██║╚██╔╝██║██╔══██║██║██║░░░░░  ░░░██║░░░██║░░██║██║░░██║██║░░░░░
██████╔╝░░░██║░░░██║░╚███║╚█████╔╝  ██║░╚═╝░██║██║░░██║██║███████╗  ░░░██║░░░╚█████╔╝╚█████╔╝███████╗
╚═════╝░░░░╚═╝░░░╚═╝░░╚══╝░╚════╝░  ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝╚══════╝  ░░░╚═╝░░░░╚════╝░░╚════╝░╚══════╝
"
echo "1) Crete Email"
echo "2) Sync Mail"
echo "3) Exit"
read -p "Which is your choose?: " choose
case $choose in
1) create_email;;
2) sync_mail;;
3) echo "Bye" && exit;;
*) exit;;
esac
}

function create_email {
read -p "Enter the path to file .csv: " file
while IFS=',' read -r e1 p1 e2 p2
do
        if /scripts/addpop $e2 $p2 0 >& /dev/null; then
		echo "Email $e2 has been created !!!"
	else
		echo "Can't create $e2"
	fi
done < $file
read -p "Do you want sync mail?(y/n): " answer
if [ $answer = y ]; then
	sync_mail
else
	menu
fi
}

function sync_mail {
read -p "Enter the path to file .csv: " file
read -p "Enter old SMTP server: " oldsrv
read -p "Enter new SMTP server: " newsrv

while IFS=',' read -r e1 p1 e2 p2
do
	if /usr/bin/imapsync \
    	--host1 $oldsrv --user1 $e1 --password1 $p1 --port1 993 --ssl1\
    	--host2 $newsrv --user2 $e2 --password2 $p2 --port2 993 --ssl2 >& /dev/null; then
		echo "Email $e1 has synced successfully !!!"
	else
		echo "Can't sync email $e1 !!!"
	fi
done < $file
}

menu

