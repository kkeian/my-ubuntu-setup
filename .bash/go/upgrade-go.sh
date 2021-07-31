#!/bin/bash

go env GOROOT
STATUS=$?
if [ $STATUS -eq 0 ]; then
	GOROOT=$(go env GOROOT)
elif [ $STATUS -eq 1 ] || [ $STATUS -eq 2 ]; then
	GOROOT=/usr/local
fi

OLDGO="${GOROOT}-old"

# Change name of old go base dir
if [ $GOROOT != "" ]; then
	sudo mv $GOROOT $OLDGO
fi

# Unpack downloaded new go version 
NEWGO=$(ls $HOME/Downloads | grep 'go*' | sort | tail -n1)
DOWNLOADS=$HOME/Downloads
cd $DOWNLOADS && sudo tar -C /usr/local -xzf $NEWGO

# Remove old version of go from system
sudo rm -rf $OLDGO
