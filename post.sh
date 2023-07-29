#!/usr/bin/env bash
#
# Copyright (C) 2023 FortuneOS
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Telegram setup
export BOT_MSG_URL="https://api.telegram.org/bot$TG_TOKEN/sendMessage"

send_message() {
	curl -s -X POST "$BOT_MSG_URL" -d chat_id="$TG_CHAT" \
		-d "disable_web_page_preview=true" \
		-d "parse_mode=html" \
		-d text="$1"
}

device="$1"
curl -s https://raw.githubusercontent.com/Fortune-OS/official-keepers/13.0/device/$device.json >$device.json
device_name=$(grep -o '"device_name": "[^"]*' $device.json | grep -o '[^"]*$')
filename=$(grep -o '"filename": "[^"]*' $device.json | grep -o '[^"]*$')
link="https://www.pling.com/p/2066862"
build_date=$(grep -o '"build_date": [^,]*' $device.json | grep -o '[0-9]*-[0-9]*-[0-9]*')
sha256sum=$(grep -o '"id": "[^"]*' $device.json | grep -o '[^"]*$')
maintainer=$(grep -o '"maintainer": "[^"]*' $device.json | grep -o '[^"]*$')
version=$(grep -o '"version": "[^"]*' $device.json | grep -o '[^"]*$')
romtype=$(grep -o '"romtype": "[^"]*' $device.json | grep -o '[^"]*$')

send_message "
New FortuneOS build available!
<b>By</b> : <b>$maintainer</b>

<b>Build date</b> : <code>$build_date</code>
<b>Device name</b> : <code>$device_name</code>
<b>Version</b> : <code>$version</code>
<b>File name</b> : <code>$filename</code>
<b>Buldtype</b> : <code>$romtype</code>
<b>SHA256</b> : <code>$sha256sum</code>

<b>Download</b> : <a href='$link'>Here!</a>

#fortune #letsfortune #keepfortune #$device"

rm $device.json
