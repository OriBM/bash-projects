#!/bin/bash

set -e

vmode="0" #verbose off
r="" #recursive off
cnt=$# #arg count 

extract () 
# list of supported zip
{
     if [ -f $1 ] ; then
	     file_type=$(file -i "$1")
         case $file_type in
        *application/zip*)       unzip $1       ;;
	*application/x-bzip2*)       bunzip2 $1     ;;
	*application/gzip*)        gunzip $1      ;;
       *application/x-compress*)      uncompress $1  ;;
#             *.tar.bz2)   tar xjf $1     ;;
#             *.tar.gz)    tar xzf $1     ;;
#             *.tbz2)      tar xjf $1     ;;
#             *.tgz)       tar xzf $1     ;;
#             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

Main()
# extracting files
{
    for file in ${list[@]};
	do
	if [ $vmode -eq "1" ] ; then 
		$vcmd $file
		extract $file 
		else
		extract $file
	fi 
	done
exit
}

Verbose ()
#handle files in direcotry with verbose mode
{
	if [ $cnt -eq 1 ]; then 
	    #checking if directory
	    echo file -i ${v};
	    if [ -d ${v} ]; then 
		list=$(find ${v} -type f -prune) ;
		else 
		list=$(file ${v} | cut -d ":" -f1) ;
	        fi
	else
    		list=$(file ${v} | cut -d ":" -f1) ;
	fi
	Main
exit
}



Recurse()
#handle recurse files in direcotry
{
    if [ -d $r ] ; then 
    echo "recursive on and got a directory file" 
 	list=$(find $r -type f | xargs file -i |  cut -d ":" -f1)   
 	Main
 	exit
   else
    	echo "Cannot excute recursive on File"
    	Help
    	exit
    fi
}


Help()
{
   echo "The [unpack] command will extract all gunzip|bunzip2|unzip|ncompress in its way"
   echo "   Version 1.0.1   "
   echo "Syntax: unpack [-r|-v|-h]"
   echo "options:"
   echo "*	 All files in directory"
   echo "-r     Recurse into folders"
   echo "-v     Verbose mode."
   echo "-h     Print this Help."
   echo
}

while getopts v:r:h flag; do
    case "${flag}" in
       
        v) #Verbose mode
           v=${OPTARG}
           vmode="1"
           vcmd="echo unpacking "
           let "cnt-=1"

           Verbose
           exit
                      ;;
        r) #Recurse files
           r=${OPTARG}
           let "cnt-=1"
           Recurse
            exit
            ;;

        h | *) #display help
            Help
            exit
            ;;
    esac
done
#checking if no argument
if [ -z "${v}" ] && [ -z "${r}" ] && [ -z "${@}" ]; then
    Help
    else 
	if [ $# -eq 1 ]; then 
	    #checking if directory
	    if [ -d $@ ]; then 
		list=$(find $@ -type f -prune) ;
		else 
		list=$(file $@ | cut -d ":" -f1) ;
	    fi
	else
    		list=$(file $@ | cut -d ":" -f1) ;
	fi
   
fi

Main

exit





