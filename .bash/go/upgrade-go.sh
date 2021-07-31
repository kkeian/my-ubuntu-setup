#!/bin/bash

go env GOROOT 2> /dev/null
STATUS=$?
if [ $STATUS -eq 0 ]; then
	GOROOT=$(go env GOROOT)
	OLDGO="${GOROOT}-old"
elif [ $STATUS -eq 1 ] || [ $STATUS -eq 2 ]; then
	GOROOT=/usr/local
	OLDGO=""
fi


# Change name of old go base dir
if [ ! $GOROOT == "" ]; then
	sudo mv $GOROOT $OLDGO
fi

# Unpack downloaded new go version 
NEWGO=$(ls $HOME/Downloads | grep 'go*' | sort | tail -n1)
DOWNLOADS=$HOME/Downloads
cd $DOWNLOADS && sudo tar -C /usr/local -xzf $NEWGO

# Remove old version of go from system
if [ ! $OLDGO == "" ]; then
	rm -r $OLDGO
fi
