#
BGD_RUNTIME = tools/bennugd-binaries/linux
export PATH := $(PATH):$(BGD_RUNTIME)/bin
export LD_LIBRARY_PATH := $(LD_LIBRARY_PATH):$(BGD_RUNTIME)/lib


# make dependencies and run game
.PHONY: run
run: zombies2012.dcb | fpg
	bgdi zombies2012.dcb


# make dependencies and run game in debug mode
.PHONY: debug
debug: zombies2012-debug.dcb | fpg
	bgdi zombies2012-debug.dcb


# Removes Generated Files
.PHONY: clean
clean:
	rm -rf fpg
	rm -f *.dcb savegame.dat


# Compile Game DCB
zombies2012.dcb:
	! bgdc main.prg -o zombies2012.dcb


# Compile Game DCB in DEBUG MODE
zombies2012-debug.dcb:
	! bgdc -g -D DEBUG main.prg -o zombies2012-debug.dcb


# Compile Game Graphics
fpg:
	mkdir -p fpg
	! tools/bgd-fpgtool/build.sh "../bennugd-binaries/linux"
	bgdi tools/bgd-fpgtool/fpgtools.dcb -c fpg-sources fpg 16
