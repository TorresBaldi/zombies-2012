#!/bin/sh

clean() {

	echo "-- clean --"

	rm -rf "releases/*"

}

compile_assets() {

	echo "-- compile_assets --"

	bgdc tools/bgd-fpgtool/fpgtools.prg
	bgdi tools/bgd-fpgtool/fpgtools.dcb -c fpg-sources fpg 16

}

copy_game_resources() {
	# $1: path of "releases folder/platofrm name"

	echo "-- copy_game_resources: $1 --"

	rm -fr "$1"
	mkdir -p "$1"
	cp -r "bgm/" "$1/bgm/"
	cp -r "sfx/" "$1/sfx/"
	cp -r "fpg/" "$1/fpg/"
}

compile_stubbed_game() {
	# $1: game name
	# $2: path of binary bgdi
	# $3: path of "releases folder/platofrm name"

	echo "-- compile_stubbed_game: $1, $2, $3 --"

	bgdc "main.prg" -s "$2" -o "$1"
	mv "$1" "$3/$1"
}

compile_game() {
	# $1: game name
	# $2: path of "releases folder/platofrm name"

	echo "-- compile_game: $1, $2 --"

	bgdc "main.prg" -o "$1"
	mv "$1" "$2/$1"
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
	zip -rq "../$FILENAME" "." --exclude "*.DS_Store" "*.gitignore"
	cd "$CURRENT"
}


build_linux() {

	echo "----- build_linux -----"

	PLATFORM=linux
	PATH_PLATFORM="$PATH_RELEASES/$PLATFORM"
	PATH_BIN="$CURDIR/tools/bennugd-binaries/$PLATFORM"

	copy_game_resources $PATH_PLATFORM
	compile_stubbed_game $GAMENAME "$PATH_BIN/bin/bgdi" $PATH_PLATFORM

	cp -r "$PATH_BIN/lib" "$PATH_PLATFORM/lib"
	cp -a "release-files/linux.sh" "$PATH_PLATFORM/$GAMENAME.sh"

	zip_game $GAMENAME $VERSION $PLATFORM $PATH_PLATFORM
}

build_windows() {

	echo "----- build_windows -----"

	PLATFORM=windows
	PATH_PLATFORM="$PATH_RELEASES/$PLATFORM"
	PATH_BIN="$CURDIR/tools/bennugd-binaries/$PLATFORM"

	copy_game_resources $PATH_PLATFORM
	compile_stubbed_game $GAMENAME "$PATH_BIN/bgdi.exe" $PATH_PLATFORM

	mv "$PATH_PLATFORM/$GAMENAME" "$PATH_PLATFORM/$GAMENAME.exe"

	# cp "$PATH_BIN/." "$PATH_PLATFORM"
	#find "$PATH_BIN" -name '*.dll' | cpio -p "$PATH_PLATFORM"
	# find $PATH_BIN -name '*.dll' -exec cp {} $PATH_PLATFORM \
	find $PATH_BIN -name '*.dll' | xargs -i cp '{}' $PATH_PLATFORM

	zip_game $GAMENAME $VERSION $PLATFORM $PATH_PLATFORM

}

build_wiz() {

	echo "----- build_wiz -----"

	PLATFORM=wiz
	PATH_PLATFORM="$PATH_RELEASES/$PLATFORM/$GAMENAME"
	PATH_BIN="$CURDIR/tools/bennugd-binaries/$PLATFORM"

	copy_game_resources $PATH_PLATFORM
	compile_game $GAMENAME $PATH_PLATFORM

	cp -r "$PATH_BIN/bgd-runtime" "$PATH_PLATFORM/bgd-runtime"
	cp -a "release-files/icon.png" "$PATH_PLATFORM/icon.png"
	cp -a "release-files/script.gpe" "$PATH_PLATFORM/$GAMENAME.gpe"
	cp -a "release-files/wiz.ini" "$PATH_RELEASES/$PLATFORM/$GAMENAME.ini"

	zip_game $GAMENAME $VERSION $PLATFORM "$PATH_RELEASES/$PLATFORM"
}

build_canoo() {

	echo "----- build_canoo -----"

	PLATFORM=canoo
	PATH_PLATFORM="$PATH_RELEASES/$PLATFORM/$GAMENAME"
	PATH_BIN="$CURDIR/tools/bennugd-binaries/$PLATFORM"

	copy_game_resources $PATH_PLATFORM
	compile_game $GAMENAME $PATH_PLATFORM

	cp -r "$PATH_BIN/bgd-runtime" "$PATH_PLATFORM/bgd-runtime"
	cp -a "release-files/title.png" "$PATH_PLATFORM/title.png"
	cp -a "release-files/script.gpe" "$PATH_PLATFORM/$GAMENAME.gpe"
	cp -a "release-files/caanoo.ini" "$PATH_RELEASES/$PLATFORM/$GAMENAME.ini"

	zip_game $GAMENAME $VERSION $PLATFORM "$PATH_RELEASES/$PLATFORM"
}

CURDIR=$(pwd)
GAMENAME="zombies2012"
VERSION="$1"
PATH_RELEASES="$CURDIR/releases"

clean

compile_assets

build_linux
build_windows
build_wiz
build_canoo
