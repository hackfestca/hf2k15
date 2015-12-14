#!/bin/bash

. ./_vars.sh

containsElement() {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

createCA() {
    NAME=$1
    SUBJECT=$2
    ISSUER=$3
    DAYS=$4

    CSR_FILE=$CA_DIR'/'$NAME'.csr'
    CRT_FILE=$CA_DIR'/'$NAME'.crt'
    KEY_FILE=$CA_DIR'/'$NAME'/private/'$NAME'.key'
    CRL_SRL_FILE=$CA_DIR'/'$NAME'/db/'$NAME'.crl.srl'
    CRT_SRL_FILE=$CA_DIR'/'$NAME'/db/'$NAME'.crt.srl'
    DB_FILE=$CA_DIR'/'$NAME'/db/'$NAME'.db'
    DB_ATTR_FILE=$CA_DIR'/'$NAME'/db/'$NAME'.db.attr'

    if [ -f $CSR_FILE ] || [ -f $KEY_FILE ]; then
        echo $LOG_PREFIX'csr or key already exist'
        exit 0
    fi

    mkdir -p $CA_DIR'/'$NAME'/db' $CA_DIR'/'$NAME'/private'
    touch $DB_FILE
    touch $CRL_SRL_FILE
    touch $DB_ATTR_FILE
    echo "21" > $CRT_SRL_FILE
    #echo "" >> $CRT_SRL_FILE

    # if name == issuer, consider this as a root CA
    if [ "$NAME" == $ISSUER ]; then
        echo $LOG_PREFIX'Generating root ca'
    else
        echo $LOG_PREFIX'Generating intermediate ca'
        if [ ! -f $CA_DIR'/'$ISSUER'.crt' ]; then
        	echo $LOG_PREFIXInvalid issuer. Could not find: $CA_DIR'/'$ISSUER'.crt'
        	exit 1
        fi
    fi
    env "subjectAltName=none" \
    openssl req -new \
        -config $CONFIG_FILE \
        -keyout $KEY_FILE \
        -out $CSR_FILE \
        -subj "$SUBJECT"
        
    signCA "$NAME" "$ISSUER" $DAYS
    genCAChain $NAME $ISSUER
    #openssl x509 -in $CRT_FILE -text
}

createCert() {
    TYPE=$1
    NAME=$2
    SUBJECT=$3
    ISSUER=$4
    DAYS=$5
    SAN=$6
    PASSWD=$7

    CSR_FILE=$CERT_DIR'/'$NAME'.csr'
    CRT_FILE=$CERT_DIR'/'$NAME'.crt'
    KEY_FILE=$CERT_DIR'/'$NAME'.key'

    if [ -f $CSR_FILE ] || [ -f $KEY_FILE ] 
    then
        echo $LOG_PREFIX'csr or key already exist'
        exit 0
    fi

    # Kind of weird but SAN cannot be null
    if [ "$SAN" == '' ]; then
        SAN='none'
    fi
    
    if [ "$PASSWD" == '' ]; then
        echo $LOG_PREFIX 'Creating certificate'
        env "subjectAltName=$SAN" \
        openssl req -new \
            -config $CONFIG_FILE \
            -out $CSR_FILE \
            -keyout $KEY_FILE \
            -subj "$SUBJECT"
    else
        echo $LOG_PREFIX 'Creating certificate without password'
        env "subjectAltName=$SAN" \
        openssl req -new -nodes \
            -config $CONFIG_FILE \
            -out $CSR_FILE \
            -keyout $KEY_FILE \
            -subj "$SUBJECT"
    fi
   
    signCert $TYPE $NAME $ISSUER $DAYS $SAN
    genCertChain $NAME $ISSUER
    genpkcs12 $NAME $ISSUER "$PASSWD"
}

signCA() {
    NAME=$1
    ISSUER=$2
    DAYS=$3

    CSR_FILE=$CA_DIR'/'$NAME'.csr'
    CRT_FILE=$CA_DIR'/'$NAME'.crt'
    KEY_FILE=$CA_DIR'/'$NAME'.key'

    if [ -f $CRT_FILE ]; then
        echo $LOG_PREFIX'crt file already exist'
        exit 0
    fi

    # if name == issuer, consider this as a root CA
    if [ "$NAME" == $ISSUER ]; then
        echo $LOG_PREFIX'Signing root CA'
        env "subjectAltName=none" \
        openssl ca -batch \
            -selfsign \
            -config $CONFIG_FILE \
            -days $DAYS \
            -in $CSR_FILE \
            -out $CRT_FILE \
            -name $ISSUER \
            -extensions root_ca_ext
    else
        echo $LOG_PREFIX'Signing intermediate CA'
        env "subjectAltName=none" \
        openssl ca -batch \
            -config $CONFIG_FILE \
            -days $DAYS \
            -in $CSR_FILE \
            -out $CRT_FILE \
            -name $ISSUER \
            -extensions inter_ca_ext
    fi
}

signCert() {
    TYPE=$1
    NAME=$2
    ISSUER=$3
    DAYS=$4
    SAN=$5

    CSR_FILE=$CERT_DIR'/'$NAME'.csr'
    CRT_FILE=$CERT_DIR'/'$NAME'.crt'
    KEY_FILE=$CERT_DIR'/'$NAME'.key'

    if [ -f $CRT_FILE ]; then
        echo $LOG_PREFIX'crt file already exist'
        exit 0
    fi

    echo $LOG_PREFIX'Signing certificate'
    if [ "$TYPE" == 'server' ]; then
        if [ "$SAN" == 'none' ]; then
            env "subjectAltName=none" \
            openssl ca -batch \
                -config $CONFIG_FILE \
                -days $DAYS \
                -in $CSR_FILE \
                -out $CRT_FILE \
                -name $ISSUER \
                -extensions server_reqext
        else
            env "subjectAltName=$SAN" \
            openssl ca -batch \
                -config $CONFIG_FILE \
                -days $DAYS \
                -in $CSR_FILE \
                -out $CRT_FILE \
                -name $ISSUER \
                -extensions san_reqext
        fi
    else
        env "subjectAltName=none" \
        openssl ca -batch \
            -config $CONFIG_FILE \
            -days $DAYS \
            -in $CSR_FILE \
            -out $CRT_FILE \
            -name $ISSUER \
            -extensions client_reqext
    fi
}

genpkcs12() {
    NAME=$1
    ISSUER=$2
    PASSWD=$3

    CRT_FILE=$CERT_DIR'/'$NAME'.crt'
    KEY_FILE=$CERT_DIR'/'$NAME'.key'
    P12_FILE=$CERT_DIR'/'$NAME'.p12'
    CA_CRT_FILE=$CA_DIR'/'$ISSUER'.chain.crt'

    if [ -f $P12_FILE ]; then
        echo $LOG_PREFIX'p12 file already exist'
        exit 0
    fi

    if [ "$PASSWD" == '' ]; then
        echo $LOG_PREFIX'Generating PKCS12 file'
        openssl pkcs12 -export \
            -out $P12_FILE \
            -inkey $KEY_FILE \
            -in $CRT_FILE \
            -certfile $CA_CRT_FILE
    else
        echo $LOG_PREFIX'Generating PKCS12 file with provided password'
        openssl pkcs12 -export \
            -out $P12_FILE \
            -inkey $KEY_FILE \
            -in $CRT_FILE \
            -certfile $CA_CRT_FILE \
            -password "pass:$PASSWD"
    fi
}

genCAChain() {
    NAME=$1
    ISSUER=$2

    CRT_FILE=$CA_DIR'/'$NAME'.crt'
    CA_CRT_FILE=$CA_DIR'/'$ISSUER'.crt'
    CHAIN_FILE=$CA_DIR'/'$NAME'.chain.crt'

    if [ -f $CHAIN_FILE ]; then
        echo $LOG_PREFIX'chain file already exist'
        exit 0
    fi
    
    cat $CA_CRT_FILE > $CHAIN_FILE
    cat $CRT_FILE >> $CHAIN_FILE
}

genCertChain() {
    NAME=$1
    ISSUER=$2

    CRT_FILE=$CERT_DIR'/'$NAME'.crt'
    CA_CRT_FILE=$CA_DIR'/'$ISSUER'.chain.crt'
    CHAIN_FILE=$CERT_DIR'/'$NAME'.chain.crt'

    if [ -f $CHAIN_FILE ]; then
        echo $LOG_PREFIX'chain file already exist'
        exit 0
    fi
    
    cat $CA_CRT_FILE > $CHAIN_FILE
    cat $CRT_FILE >> $CHAIN_FILE
}
