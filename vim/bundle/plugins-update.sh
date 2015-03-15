#!/bin/bash
for plugin in $(cat plugins-list.txt | cut -d'/' -f2) ; do
    echo Updating $plugin
    cd $plugin || exit 1
    git pull
    cd - >/dev/null
done
