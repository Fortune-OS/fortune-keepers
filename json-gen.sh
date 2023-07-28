#!/usr/bin/env bash
#
# Copyright (C) 2023 FortuneOS
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

helpmenu() {
	echo -e "
*** A Simple bash script to create ota json ***
Usage :
      $0 [args]
Arguments :
 -d 	--device	: Set device name

 -c     --codename	: Set device codename

 -f     --filename	: Set OTA file name

 -m     --maintainer	: Set maintainer name"
}

# Function to display an error message and exit
err() {
	echo "Error: $1" >&2
	exit 1
}

END_OF_OPT=
POSITIONAL=()
while [[ $# -gt 0 ]]; do
	case "${END_OF_OPT}${1}" in
	-d | --device)
		if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
			device="$2"
			shift 2
		else
			err "Error: Argument for $1 is missing or more/less than 1 argument"
		fi
		;;
	-c | --codename)
		if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
			codename="$2"
			shift 2
		else
			err "Error: Argument for $1 is missing or more/less than 1 argument"
		fi
		;;
	-f | --filename)
		if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
			file_name="$2"
			shift 2
		else
			err "Error: Argument for $1 is missing or more/less than 1 argument"
		fi
		;;
	-m | --maintainer)
		if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
			maintainer="$2"
			shift 2
		else
			err "Error: Argument for $1 is missing or more/less than 1 argument"
		fi
		;;
	-h | --help)
		helpmenu
		exit 0
		;;
	*)
		echo "Invalid argument passed: '${arg}' Run '$0 --help' to view available options."
		exit 1
		;;
	esac
done

set -- "${POSITIONAL[@]}"

if [[ -z "$device" || -z "$codename" || -z "$file_name" || -z "$maintainer" ]]; then
	err "Error: Missing arguments. Please specify all options -d, -d, -f, and -m."
else
	outdir="../out/target/product/$codename"
	zip_file="$outdir/$file_name"
	file_size=$(stat -c%s $zip_file)
	datetime=$(date -u +%s)
	id=$(sha256sum $zip_file | awk '{ print $1 }')
	romtype="COMMUNITY"
	if [ ! -f "device/$codename.json" ]; then
		touch device/$codename.json
	fi
		echo "
		{
		  "response": [
		    {
		      "datetime":$datetime,
		      "filename": "$file_name",
		      "id": "$id",
		      "romtype": "$romtype",
		      "size":$file_size,
		      "url": "https://master.dl.sourceforge.net/project/fortuneos/$codename/$file_name",
		      "version": "13.0",
		      "device_name": "$device",
		      "device_codename" : "$codename",
		      "maintainer": "$maintainer"
		    }
		  ]
		}" >~/official-keepers/device/$codename.json
fi
