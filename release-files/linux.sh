#!/bin/sh

# genero los paths
CURDIR=$(dirname 0)
BENNUBIN=$CURDIR
BENNULIB=$CURDIR/lib

# cambio los paths
export PATH=$BENNUBIN:$PATH
export LD_LIBRARY_PATH=$BENNULIB:$LD_LIBRARY_PATH

# ejecuto el juego
zombies2012
