#!/bin/bash

search=$1
times=$2
mytimeout=$3


#default parmaters
search=""
c="0" # default
ctimeout="1" #default not to loop 
t=1s
username=*
p="0"


Usage (){ 
echo "Usage: ./psping.sh [-c] countPings [-t] alternateTimeOut [-u] userName [-p(mandatory)]exe-name"
exit
}

Main()
{
#check if put process
if [ $p -eq "0" ];  then Usage
    exit  
fi

# in no count input - run infinite
if [ $c -eq "0" ] ; then 
	ctimeout="0"
	c="1"
	echo "press CTRL+Z in order to stop"
fi



while [ $c -ne "0" ]

do
	ps aux | grep $p 
	sleep $t
	if [ $ctimeout -ne "0" ] ; then let "c-=1"
	fi
done
}



while getopts :c:t:u:p:h flag; do
    case "${flag}" in
       
        c) #counts and echo live process; def = infinite
           c=${OPTARG}
        ;;
        t) #Alternative time in sec; def = 1sec
           t=${OPTARG}
        ;;
        u) #define user; def = any user
           username=${OPTARG}
        ;;
        
        p) #process
            p=${OPTARG}
            ;;
        [?]) #display help
	Usage
	     exit
        ;;
        
    esac
done

Main



