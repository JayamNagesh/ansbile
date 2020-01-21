#!/bin/bash
PROG="`basename $0`"
temp_file=/tmp/passwords

USER_LIST="root nagesh"

f_cleanup() {
	rm -rf $temp_file
	echo ""
}

f_help() {
cat <<EOUM >&2
	Usage: 
    This script will change the passwords for the users

    Usage:
     $0                 It will change the password for the existing users(default)
     $0 -s <username>   If you want to skip any user to change the passowrd(optional)
     $0 -p              Print list of users
     $0 -h              Help
    Examples:
     $0
     $0 -s root
EOUM
}

if [[ $(/usr/bin/id -u) -ne 0 ]]; then

    echo "script should be run as root user"
    exit
fi

touch $temp_file

f_check() {
	getent passwd "$1" > /dev/null

	if [ $? -eq 0 ]; then
		echo "yes the user $1 exists"
		echo "INFO: Changing the password for the user $1"
		echo "Enter the password for $username"
		read -s pass
		   if [ -z $pass ]
		   	then
		   		echo "password is blank we cant set the blank password"
		   		exit
		   else
		   	f_update_password $username $pass
		   fi
    else
    	echo "No, the user $1 does not exist"
    	echo "password not changed for the user $1 seems to be doesn't exist in the system" >> $temp_file
    fi
}

f_update_password() {
	echo "$2" | passwd --stdin "$1" > /dev/null
	echo "password successfully changed for the user $1" >> $temp_file
}

f_display() {
	echo "################################"
	cat $temp_file
	echo "################################"
}


case $1 in 
	 "")
	   for username in $USER_LIST
	    do
	    f_check $username
	    done
	    f_display
	    f_cleanup
	   ;;
	 -s)
       for username in $USER_LIST
         do
         	if [ "$2" == "$username" ]
         	 then
         	 	continue;
         	fi
         f_check $username
        done
          f_display
          f_cleanup
       ;;
     -p)
       echo "Below are the users"
        for username in $USER_LIST
          do
          	echo $username
          done
       ;;
     -h)
       f_help
       ;;
esac       
