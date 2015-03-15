#!/bin/bash
for plugin in $(cat plugins-list.txt) ; do
    git clone https://github.com/$plugin.git
done
