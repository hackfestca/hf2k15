#!/bin/bash

. ./_vars.sh
. ./_functions.sh

TYPE_LIST=('ca' 'server' 'client')

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root."
    exit
fi

usage()
{
    echo "Generate certificates by understanding what the fuck you are doing."
    echo " "
    echo "$0 -t TYPE -n NAME -s SUBJECT -i ISSUER -d DAYS [-a SAN]"
    echo " "
    echo "options:"
    echo "--help                    show brief help"
    echo "-t, --type=TYPE           Certificate type. Must be one of these: ca, server, client"
    echo "-n, --name=NAME           Certificate name. Especially used to identify issuer"
    echo "-s, --subject=SUBJECT     Subject DN. Example: /C=CA/ST=Qc/.../CN=blabla.hf"
    echo "-i, --issuer=ISSUER       Signing certificate name"
    echo "-d, --days=DAYS           Number of days of validity"
    echo "-a, --subjectAltName=SAN  Subject Alternate Name. Example: DNS:www.blabla.hf"
    echo "-p, --passwd=PASSWD          Password to use for encryption (client cert only)"
    echo ""
}

# Menu, arguments, help
while test $# -gt 0; do
        case "$1" in
                --help)
			usage
                        exit 0
                        ;;
                -t)
                        shift
                        export TYPE=$1
                        shift
                        ;;
                --type*)
                        export TYPE=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -n)
                        shift
                        export NAME=$1
                        shift
                        ;;
                --name*)
                        export NAME=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -s)
                        shift
                        export SUBJECT=$1
                        shift
                        ;;
                --subject*)
                        export SUBJECT=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -a)
                        shift
                        export SAN=$1
                        shift
                        ;;
                --subjectAltName*)
                        export SAN=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -i)
                        shift
                        export ISSUER=$1
                        shift
                        ;;
                --issuer*)
                        export ISSUER=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -d)
                        shift
                        export DAYS=$1
                        shift
                        ;;
                --days*)
                        export DAYS=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -p)
                        shift
                        export PASSWD=$1
                        shift
                        ;;
                --passwd*)
                        export PASSWD=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                *)
                        break
                        ;;
        esac
done

# Some validations
if [ -z $TYPE ] || [ -z $NAME ] || [ -z "$SUBJECT" ] || [ -z $ISSUER ] || [ -z $DAYS ]
then
	usage
	echo There are missing arguments
	exit 1
fi
containsElement "$TYPE" "${TYPE_LIST[@]}"
if [ $? -eq 1 ]; then
	usage
	echo Invalid type. Please use one of the following: "${TYPE_LIST[@]}"
	exit 1
fi
if ! [ "$DAYS" -eq "$DAYS" ]; then
    usage
    echo The -d argument must be a number. User input is: $DAYS
    exit 1
fi

# main
if [ "$TYPE" == 'ca' ]; then
    createCA $NAME "$SUBJECT" $ISSUER $DAYS
elif [ "$TYPE" == 'server' ]; then
    createCert $TYPE $NAME "$SUBJECT" $ISSUER $DAYS $SAN
elif [ "$TYPE" == 'client' ]; then
    createCert $TYPE $NAME "$SUBJECT" $ISSUER $DAYS '' "$PASSWD"
fi




