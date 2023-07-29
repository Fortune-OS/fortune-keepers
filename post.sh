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
model="$(curl -s "https://raw.githubusercontent.com/Fortune-OS/official-keepers/13.0/device/$device.json" | jq -r '.response[].device_name')"
filename="$(curl -s "https://raw.githubusercontent.com/FortuneOS/official-keepers/13.0/device/$device.json" | jq '.filename')"
link="https://www.pling.com/p/2066862"
current_date="$(date +'%d-%m-%Y')"
build_date="$(curl -s "https://raw.githubusercontent.com/Fortune-OS/official-keepers/13.0/device/$device.json" | jq -r '.response[].build_date')"
sha256sum="$(curl -s "https://raw.githubusercontent.com/Fortune-OS/official-keepers/13.0/device/$device.json" | jq -r '.response[].id')"
maintainer="$(curl -s "https://raw.githubusercontent.com/Fortune-OS/official-keepers/13.0/device/$device.json" | jq -r '.response[].maintainer')"
version="$(curl -s "https://raw.githubusercontent.com/Fortune-OS/official-keepers/13.0/device/$device.json" | jq -r '.response[].version')"
romtype="$(curl -s "https://raw.githubusercontent.com/Fortune-OS/official-keepers/13.0/device/$device.json" | jq -r '.response[].romtype')"

if [ "$current_date" != "$build_date" ]; then
	echo "Build date is not the same as the one in the json or the build has already been posted!"
	exit 0
else

	send_message "
	New build available for <b>"$model"</b> codename <b>"$device"</b>!
	By: <b>'$maintainer'</b>

	<b> Build date </b> : <code>'$build_date'</code>
	<b> Version </b> : <code>'$version'</code>
	<b> File name </b> : <code>'$filename'</code>
	<b> Buldtype </b> : <code>'$romtype'</code>
	<b> SHA256 </b> : <code>'$sha256sum'</code>

	<b>Download </b> : <a href='$link'>Here!</a>

	#letsfortune #keepfortune #$device"
fi
