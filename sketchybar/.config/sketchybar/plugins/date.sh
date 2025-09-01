#!/bin/bash

DATE=$(date "+%a %B %d")
TIME=$(date "+%l:%M %p")

sketchybar -m --set date \
					label="$DATE"

sketchybar -m --set time \
					label="$TIME"
