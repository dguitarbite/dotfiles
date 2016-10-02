#!/bin/bash
# Script to set different display configurations.
# Functionality:
#   1. Auto-detect multiple displays.
#   2. Auto-scale DPI settings for multiple heterogeneous displays.
#   3. Should work for HD & 4K Monitors at present, other settings
#      can be easily added as if conditions.

XRANDR="xrandr"
CMD=""
DPI=96  # Standard Default
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
    if [ "$1" = "HDMI-0" ]; then
        echo "--rotate left"
    fi
}

set_dpi() {
    if [ "$1" -eq "3840" ]; then
        DPI=163   # Standard 27" 4K Monitor.
    fi
}

get_scale() {

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
CMD="${XRANDR} --dpi ${DPI} ${CMD}"
${CMD}
set +x
