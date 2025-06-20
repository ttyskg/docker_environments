#!/bin/bash

cd $(dirname ${0})

# Copy msmtprc and setting permissions

if [ -f msmtprc ]; then
    cp msmtprc ~/.msmtprc
    chmod 600 ~/.msmtprc
    echo "msmtprc is copied correctly"
else
    echo "msmtprc file not found. Please ensure it exists in the current directory."
    exit 1
fi

# Download notify_me.sh from my gist
mkdir -p ../lib
if [ ! -f ../lib/notify_me.sh ]; then
    wget -O ../lib/notify_me.sh https://gist.githubusercontent.com/ttyskg/f4ecb2039ea83951708348ec55b79919/raw/98fd3a6e3b88d1382c22bbedc12cf443f494e092/notify_me.sh
    chmod +x ../lib/notify_me.sh
    echo "notify_me.sh has been downloaded and made executable."
    echo "################################################################"
    echo "ACTION REQUIRED: You need to set the To address in the script."
    echo "################################################################"
else
    echo "notify_me.sh already exists in ../lib/"
fi
