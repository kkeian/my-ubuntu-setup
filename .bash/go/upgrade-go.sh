#!/bin/bash
# ensure this is run as root
if [[ $EUID -ne 0 ]]; then
	echo "Permission denied"
	exit 1
fi

GOROOT=$(go env GOROOT)
OLDGO="$GOROOT-old"
# Change name of old go base dir
sudo mv $GOROOT $OLDGO

# Unpack downloaded new go version 
NEWGO=$(ls $HOME/Downloads | grep 'go*' | sort | tail -n1)
sudo tar -C /usr/local -xzf $NEWGO

# Remove old version of go from system
sudo rm -rf $OLDGO
