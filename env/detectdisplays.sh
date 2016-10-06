#!/bin/bash
# Inspired by https://wiki.archlinux.org/index.php/Xrandr
# Script for heterogeneous monitor displays. HD (1080p) & 4k (2160p)

# Workaround for suspend issue with DP monitors.
#declare -i count=2
#declare -i seconds=1

# Setup multiple displays.
XRANDR="xrandr"
DPI=96  # Standard Default for HD 1080p
CMD="${XRANDR} --dpi ${DPI}"
PADDING=1
declare -A VOUTS
eval VOUTS=$(${XRANDR}|awk 'BEGIN {printf("(")} /^\S.*connected/{printf("[%s]=%s ", $1, $2)} END{printf(")")}')
declare -A POS
#XPOS=0
#YPOS=0
#POS="${XPOS}x${YPOS}"

POS=([X]=0 [Y]=0)

find_mode() {
  echo $(${XRANDR} |grep ${1} -A1|awk '{FS="[ x]"} /^\s/{printf("WIDTH=%s\nHEIGHT=%s", $4,$5)}')
}

get_display_rotation() {
    # Rotates HDMI-0 interface.
    if [ "$1" = "HDMI-0" ]; then
        echo "--rotate left"
    fi
}

set_dpi() {
    # If 4K mointor is found, update DPI.
    if [ "$1" -eq "3840" ]; then
        DPI=163   # Standard 27" 4K Monitor.
    fi
}

get_scale() {
    # Hardcoding scaling factor to 1.5 ~ 2xHD for compensating 4K display.
    # Logic: 4K_DPI / HD_DPI (163/96). With some observations 1.5 works the best.
    if [ "$1" -eq "1920" ]; then
        # Resolves to ~96 DPI for HD Monitor.
        echo "--scale 1.5x1.5"
    fi
}

xrandr_params_for() {
  if [ "${2}" == 'connected' ]
  then
    ROTATE=
    ROTATION=$( get_display_rotation ${1} )
    eval $(find_mode ${1})  #sets ${WIDTH} and ${HEIGHT}
    MODE="${WIDTH}x${HEIGHT}"
    SCALE=$( get_scale $WIDTH )
    set_dpi $WIDTH

    CMD="${CMD} --output ${1} --mode ${MODE} --pos ${POS[X]}x${POS[Y]} ${ROTATION} ${SCALE}"

    # Height and width of the display with the scaling factor to avoid overlapping of screens.
    if [ -n "${SCALE}" ]; then
        HEIGHT=$(echo ${HEIGHT} | awk '{printf "%4.0f\n",$1*1.5}')
        WIDTH=$(echo ${WIDTH} | awk '{printf "%4.0f\n",$1*1.5}')
    fi
    # For rotated displays, append height.
    # Adjust X position based on rotation.
    if [ -n "${ROTATION}" ]; then
        POS[X]=$((${POS[X]}+${HEIGHT}))
    else
        POS[X]=$((${POS[X]}+${WIDTH}))
    fi

    return 0
  else
    CMD="${CMD} --output ${1} --off"
    return 1
  fi
}

for VOUT in ${!VOUTS[*]}
do
  xrandr_params_for ${VOUT} ${VOUTS[${VOUT}]}
done
set -x
${CMD}
set +x

while ((count)); do
    xrandr >/dev/null
    sleep $seconds
    ((count--))
done

# Setup background using Feh
feh --randomize --bg-fill \
	/data/misc/wallpapers/* \
	/data/misc/wallpapers/* \
	/data/misc/wallpapers/*
