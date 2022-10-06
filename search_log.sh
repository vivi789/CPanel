#!/bin/bash
function menu {
clear
echo "
███████╗██╗░░██╗██╗███╗░░░███╗  ██╗░░░░░░█████╗░░██████╗░
██╔════╝╚██╗██╔╝██║████╗░████║  ██║░░░░░██╔══██╗██╔════╝░
█████╗░░░╚███╔╝░██║██╔████╔██║  ██║░░░░░██║░░██║██║░░██╗░
██╔══╝░░░██╔██╗░██║██║╚██╔╝██║  ██║░░░░░██║░░██║██║░░╚██╗
███████╗██╔╝╚██╗██║██║░╚═╝░██║  ███████╗╚█████╔╝╚██████╔╝
╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝  ╚══════╝░╚════╝░░╚═════╝░
"
echo "*********************************************************************"
echo "* Code by: ViVi                                                     *"
echo "* Gitlab: https://gitlab.vinahost.vn/vint                           *"
echo "*********************************************************************"
echo "1) Search log today"
echo "2) Search log another day"
echo "3) Search ID"
echo "4) Search IP Blocked"
echo "5) Exit"
read -p "Which is your choice ?: " choice
case $choice in
1) today;;
2) not_today;;
3) id;;
4) ip_blocked;;
5) echo "Bye" && exit;;
*) echo "Bye" && exit;;
esac
}

function today {
	read -p "Please enter email sent (force): " email_sent
	read -p "Please enter email received: " email_received
	read -p "Please enter time: " time
	if [ -z $email_sent ]
        then
                echo "Can't search log. Please enter email sent !!!"
                today
	elif [ -z $email_received ] && [ ! -z $time ]
	then
		if cat /var/log/exim_mainlog | grep `date -I` | grep "$email_sent" | grep "<=" | grep "$time"
		then
			cat /var/log/exim_mainlog | grep `date -I` | grep "$email_sent" | grep "<=" | grep "$time"
		else
			echo "Can't find email"
			exit
		fi
	elif [ -z $time] && [ ! -z $email_received ]
	then
		if cat /var/log/exim_mainlog | grep `date -I` | grep "$email_sent" | grep "<=" | grep "$email_received"
		then
			cat /var/log/exim_mainlog | grep `date -I` | grep "$email_sent" | grep "<=" | grep "$email_received"
		else
			echo "Can't find email"
			exit
		fi
	elif [ -z $email_received ] && [ -z $time]
	then
		if cat /var/log/exim_mainlog | grep `date -I` | grep "$email_sent"
		then
			cat /var/log/exim_mainlog | grep `date -I` | grep "$email_sent"
		else
			echo "Can't find email"
			exit
		fi
	elif  [ ! -z $email_received ] && [ ! -z $time] 
	then
		if cat /var/log/exim_mainlog | grep `date -I` | grep "$email_sent" | grep "<=" | grep "$time" |grep "$email_received"
		then
			cat /var/log/exim_mainlog | grep `date -I` | grep "$email_sent" | grep "<=" | grep "$time" |grep "$email_received"
		else
			echo "Can't find email"
			exit
		fi
	else
		today
	fi
	question
}

function question {
	read -p "Do you want search ID? (y/n): " result
	if [ $result = y ]
	then
		id
        else
                menu
        fi
}

function id {
	read -p "Please enter the ID: " id
	if [ -z $id ]
	then
		id
	else
		cat /var/log/exim_mainlog | grep "$id"
	fi
	read -p "Do you want to continue searching ID? (y/n): " result_id
	if [ $result_id = y ]
        then
                id
        else
		menu
	fi
}

function not_today {
	read -p "Please enter email sent (force): " email_sent
        read -p "Please enter email received: " email_received
        read -p "Please enter the date (force): " date
	read -p "Please enter time: " time
	if [ -z $date ] || [ -z $email_sent ]
	then
		echo "Can't search log. Please enter email sent or the date!!!"
		not_today 
        elif [ -z $email_received ] && [ ! -z $time ]
        then
                if cat /var/log/exim_mainlog | grep "$date" | grep "$email_sent" | grep "<=" | grep "$time"
                then
			cat /var/log/exim_mainlog | grep "$date" | grep "$email_sent" | grep "<=" | grep "$time"
		else
			echo "Can't find email"	
			exit
		fi
        elif [ -z $time ] && [ ! -z $email_received ]
        then
                if cat /var/log/exim_mainlog | grep "$date" | grep "$email_sent" | grep "<=" | grep "$email_received"
                then
			cat /var/log/exim_mainlog | grep "$date" | grep "$email_sent" | grep "<=" | grep "$email_received"
		else
			echo "Can't find email"
			exit
		fi
        elif [ -z $email_received ] && [ -z $time]
        then
                if cat /var/log/exim_mainlog | grep "$date" | grep "$email_sent"
                then
			cat /var/log/exim_mainlog | grep "$date" | grep "$email_sent"
		else
			echo "Can't find email"
			exit
		fi
        elif [ ! -z $email_received ] && [ ! -z $time] 
	then
                if cat /var/log/exim_mainlog | grep $date | grep "$email_sent" | grep "<=" | grep "$time" |grep "$email_received"
                then
			cat /var/log/exim_mainlog | grep $date | grep "$email_sent" | grep "<=" | grep "$time" |grep "$email_received"
		else
			echo "Can't find email"
			exit
		fi
	else
		menu
        fi
	question
}

function ip_blocked {
	read -p "Please enter IP: " ip
	if [ ! -z $ip ]
	then
		if cat /var/log/maillog | grep "$ip" >& /dev/null
		then
   			echo -e "Emails login failed are:\n"
			echo -e "Time   Email"
			echo -e "-----------------------\n"
                	for i in $(cat /var/log/maillog | grep "$ip" | grep "auth failed" | grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" | sort | uniq)
			do
				 time=`cat /var/log/maillog | grep "$ip" | grep "auth failed" | grep "$i" | awk '{print $1 " "$2}' | sort | uniq`
				 echo -e "$time $i\n"
			done
		fi
		if ! cat /var/log/maillog | grep "$ip" >& /dev/null
		then
			echo "Can't find this IP in mail log"
                fi
	elif [ -z $ip ] 
	then
		echo "Please enter IP!!!"
		ip_blocked
	fi
	read -p "Do you want to continue searching IP? (y/n): " result_ip
	if [ $result_ip = y ]
        then
                ip_blocked
        else
                menu
        fi

}

menu
