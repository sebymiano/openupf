#!/bin/bash

UPF_BUILD_SCRIPT_PATH=$(cd `dirname $0`; pwd)
UPF_BUILD_PATH=$UPF_BUILD_SCRIPT_PATH/..
UPF_TOP_PATH=$UPF_BUILD_PATH/..

UPF_INSTALL_PATH=$UPF_TOP_PATH/install
source $UPF_BUILD_SCRIPT_PATH/build_val.sh

GNUTLS_LIB_DIR=$UPF_TOP_PATH/libs/gnutls
GNUTLS_TAR_NAME=gnutls-3.6.16.tar.xz
GNUTLS_URL=https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/${GNUTLS_TAR_NAME}

GNUTLS_LIB_PATH=$UPF_INSTALL_PATH/lib/libgnutls.so

help()
{
    local BN=`basename $1`
    echo "Usage:"
    echo "      ./$BN \$PARA1"
    echo ""
    echo "\$PARA1 :" 
    echo "       : make/clean"
    exit 0
}

if [ "$1" == "help" ] || [ "$1" == "?" ]
then
    help  $0
    exit 0
fi

LIBS_DOWNLOAD()
{    
    if [ ! -d $GNUTLS_LIB_DIR ]
    then
        RET=-1
        COUNT=0
        
        while [ $RET -ne 0 ]
        do
            wget ${GNUTLS_URL} -P $GNUTLS_LIB_DIR
            RET=$?
            COUNT=$(($COUNT+1))
            
            if [ $COUNT -ge 3 ]
            then
                exit -1
            fi
        done
    fi
}

LIBS_BUILD()
{
    if [ ! -f $GNUTLS_LIB_PATH ]
    then
        pushd .
        cd $GNUTLS_LIB_DIR
        tar -xvf ${GNUTLS_TAR_NAME} --strip-components=1
        rm ${GNUTLS_TAR_NAME}
        ./configure --prefix=$UPF_INSTALL_PATH --with-included-unistring
        make -j$(getconf _NPROCESSORS_ONLN)
        sudo make install
        popd
    fi
}

if [[ $1 == "clean"  ]]
then
    if [ -d $GNUTLS_LIB_DIR ]
    then
        make uninstall -C $GNUTLS_LIB_DIR
        make clean -C $GNUTLS_LIB_DIR
    fi
elif [[ $1 == "download" ]]
then
    LIBS_DOWNLOAD
else
    mkdir -p $UPF_INSTALL_PATH/lib
    mkdir -p $UPF_INSTALL_PATH/include
    LIBS_DOWNLOAD
    LIBS_BUILD
    if [ ! -f $UPF_INSTALL_PATH/lib/libgnutls.so ]; then
        exit -1
    fi
fi
