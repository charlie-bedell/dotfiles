#!/bin/bash

BATT_PERCENT=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)

if [[ $CHARGING != "" ]]; then
		sketchybar -m --set battery \
							 label=$(printf "${BATT_PERCENT}%%")
		exit 0
fi

sketchybar -m --set battery \
					 label=$(printf "${BATT_PERCENT}%%")
