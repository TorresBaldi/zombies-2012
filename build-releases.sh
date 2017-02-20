#!/bin/sh

copy_game_resources() {
	# $1: path of "releases folder/platofrm name"

	echo "-- copy_game_resources: $1 --"

	rm -fr "$1"
	mkdir "$1"
	cp -r "bgm/" "$1/bgm/"
	cp -r "sfx/" "$1/sfx/"
	cp -r "fpg/" "$1/fpg/"
}

compile_game() {
	# $1: game name
	# $2: path of binary bgdi
	# $3: path of "releases folder/platofrm name"

	echo "-- compile_game: $1, $2, $3 --"

	bgdc "main.prg" -s "$2" -o "$1"
	mv "$1" "$3/$1"
}

zip_game() {
	# $1: game name
	# $2: version name
	# $3: platform name
	# $4: path of "releases folder/platofrm name"

	echo "-- zip_game: $1, $2, $3, $4 --"

	local CURRENT=$(pwd)
	local FILENAME=$1-$2-$3.zip

	cd "$4"
	rm "../$FILENAME"
	zip -r "../$FILENAME" "." --exclude "*.DS_Store"
	cd "$CURRENT"
}


build_linux() {

	echo "----- build_linux -----"

	PLATFORM=linux
	PATH_PLATFORM="$PATH_RELEASES/$PLATFORM"
	PATH_BIN="$CURDIR/../bin/$PLATFORM"

	copy_game_resources $PATH_PLATFORM
	compile_game $GAMENAME "$PATH_BIN/bin/bgdi" $PATH_PLATFORM

	cp -r "$PATH_BIN/lib" "$PATH_PLATFORM/lib"
	cp -a "releases/linux.sh" "$PATH_PLATFORM/$GAMENAME.sh"

	zip_game $GAMENAME $VERSION $PLATFORM $PATH_PLATFORM
}

build_windows() {

	echo "----- build_windows -----"

	PLATFORM=windows
	PATH_PLATFORM="$PATH_RELEASES/$PLATFORM"
	PATH_BIN="$CURDIR/../bin/$PLATFORM"

	copy_game_resources $PATH_PLATFORM
	compile_game $GAMENAME "$PATH_BIN/bgdi.exe" $PATH_PLATFORM

	mv "$PATH_PLATFORM/$GAMENAME" "$PATH_PLATFORM/$GAMENAME.exe"
	cp -v "$PATH_BIN/*.dll" "$PATH_PLATFORM/"

	zip_game $GAMENAME $VERSION $PLATFORM $PATH_PLATFORM

}

CURDIR=$(pwd)
GAMENAME="zombies2012"
VERSION="$1"
PATH_RELEASES="$CURDIR/releases"

build_linux
build_windows
