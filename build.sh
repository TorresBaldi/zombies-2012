#!/bin/sh
cd "${0%/*}"

# get bennu binaries directory parameter, or set default
BGD_RUNTIME=${1:-"tools/bennugd-binaries/linux"}

# add bennugd to system path
export PATH=$BGD_RUNTIME/bin:$PATH
export LD_LIBRARY_PATH=$BGD_RUNTIME/lib:$LD_LIBRARY_PATH

# build bgd-fpgtool
tools/bgd-fpgtool/build.sh "../bennugd-binaries/linux"

# build fpg files
bgdi tools/bgd-fpgtool/fpgtools.dcb -c fpg-sources fpg 16

# export fpg files
#bgdi tools/bgd-fpgtool/fpgtools.dcb -e fpg-out fpg 16

# compile game in debug mode
bgdc -g -D DEBUG "main.prg"
bgdi "main.dcb"


# invert output status of bgdc
if [ $? -eq 1 ]
then
  exit 0
else
  exit 1
fi
