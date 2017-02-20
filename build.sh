#!/bin/sh

# build fpg files
bgdc tools/bgd-fpgtool/fpgtools.prg
bgdi tools/bgd-fpgtool/fpgtools.dcb -c fpg-sources fpg 16


# compile game
bgdc "main.prg"


# invert output status of bgdc
if [ $? -eq 1 ]
then
  exit 0
else
  exit 1
fi
