#!/bin/bash

go env GOROOT 2> /dev/null
STATUS=$?
if [ $STATUS -eq 0 ]; then
	GOROOT=$(go env GOROOT)
elif [ $STATUS -eq 1 ] || [ $STATUS -eq 2 ]; then
	GOROOT=/usr/local
fi

TEMP=/tmp
# Move old go version to /tmp to be erased on next boot
if [ ! $GOROOT == "/usr/local" ]; then
	sudo mv $GOROOT $TEMP
	OLDGO="${TEMP}/go"
	# Rename folder to something recognizable
	sudo mv $OLDGO "${OLDGO}-old"
fi

# Unpack downloaded new go version 
NEWGO=$(ls $HOME/Downloads | grep 'go*' | sort | tail -n1)
DOWNLOADS=$HOME/Downloads
cd $DOWNLOADS && sudo tar -C /usr/local -xzf $NEWGO
