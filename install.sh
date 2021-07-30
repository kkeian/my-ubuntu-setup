#!/bin/bash
ls -A | grep -v '.git\|LICENSE\|REAME.md\|install.sh' | xargs -t -p cp -vr {}
