#!/bin/bash

UPF_BUILD_SCRIPT_PATH=$(cd `dirname $0`; pwd)
UPF_BUILD_PATH=$UPF_BUILD_SCRIPT_PATH/..
UPF_TOP_PATH=$UPF_BUILD_PATH/..

UPF_INSTALL_PATH=$UPF_TOP_PATH/install
source $UPF_BUILD_SCRIPT_PATH/build_val.sh

MICROHTTPD_LIB_DIR=$UPF_TOP_PATH/libs/microhttpd
MICROHTTPD_TAR_NAME=libmicrohttpd-latest.tar.gz
MICROHTTPD_URL=https://ftpmirror.gnu.org/libmicrohttpd/${MICROHTTPD_TAR_NAME}

MICROHTTPD_LIB_PATH=$UPF_INSTALL_PATH/lib/libmicrohttpd.a

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
    if [ ! -d $MICROHTTPD_LIB_DIR ]
    then
        RET=-1
        COUNT=0
        
        while [ $RET -ne 0 ]
        do
            wget ${MICROHTTPD_URL} -P $MICROHTTPD_LIB_DIR
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
    if [ ! -f $MICROHTTPD_LIB_PATH ]
    then
        pushd .
        cd $MICROHTTPD_LIB_DIR
        tar -zxvf ${MICROHTTPD_TAR_NAME} --strip-components=1
        rm ${MICROHTTPD_TAR_NAME}
        ./configure --prefix=$UPF_INSTALL_PATH
        make
        sudo make install
        popd
    fi
}

if [[ $1 == "clean"  ]]
then
    if [ -d $MICROHTTPD_LIB_DIR ]
    then
        make uninstall -C $MICROHTTPD_LIB_DIR
        make clean -C $MICROHTTPD_LIB_DIR
    fi
elif [[ $1 == "download" ]]
then
    LIBS_DOWNLOAD
else
    mkdir -p $UPF_INSTALL_PATH/lib
    mkdir -p $UPF_INSTALL_PATH/include
    LIBS_DOWNLOAD
    LIBS_BUILD
    if [ ! -f $UPF_INSTALL_PATH/lib/libmicrohttpd.a ]; then
        exit -1
    fi
fi
