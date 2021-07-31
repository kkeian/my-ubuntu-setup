#!/bin/bash

GOROOT=$(go env GOROOT)
OLDGO="${GOROOT}-old"
# Change name of old go base dir
sudo mv $GOROOT $OLDGO

# Unpack downloaded new go version 
NEWGO=$(ls $HOME/Downloads | grep 'go*' | sort | tail -n1)
NEWGOLOC=$(find $HOME/Downloads -name 'go*' -type f | sort | tail -n1)
cd $NEWGOLOC && sudo tar -C /usr/local -xzf $NEWGO

# Remove old version of go from system
sudo rm -rf $OLDGO
