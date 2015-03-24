#!/bin/sh

installDirectory=~/Library/Developer/Xcode/Templates/File\ Templates/Mobily

if [ -d "$installDirectory" ]
then
	rm -r "$installDirectory"
fi

mkdir -p "$installDirectory"

cp -r "$(dirname "$0")"/*.xctemplate "$installDirectory"
