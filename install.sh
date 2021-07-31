#!/bin/bash
ls -A | grep -v '.git\|LICENSE\|README.md\|install.sh' | xargs -t -p cp -vr {} -t $HOME
