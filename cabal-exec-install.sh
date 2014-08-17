#!/bin/bash


# short-description:
#   script for automatic sandboxed installation of executable packages from cabal.
# main properties:
#   - sandboxes for everything (one sandbox per package).
#   - installs executables to $HOME/.cabal/bin
#     (so add that to PATH, and be done)
#   - currently the sandbox directory is hardcoded to $HOME/.cabal/sandboxes/
# usage description:
#   0) [optional] delete $HOME/.ghc and $HOME/.cabal
#   1) add $HOME/.cabal/bin to PATH
#   2) modify the MAIN section of this script to contain a "echo-install foo" line
#      for each executable foo you want installed.
#   3) run this script.
#   4) wait an hour while everything installs
#   result:
#     - each foo will be sandbox-installed in $HOME/.cabal/sandboxes/foo/
#     - the executables will be put in $HOME/.cabal/bin/
# uninstall:
#   1) delete $HOME/.cabal/sandboxes
#   2) delete the relevant executables
#   3) delete this file :D
# target:
#   - linux
#   - tested on archlinux with only the ghc package installed
#   - NOT haskell platform

# notes: 
# - one warning: the sandbox directory can easily grow to several GB of size.
# - it might be possible to delete certain intermediate files after one
#   executable has finished installation. (todo) 
# - no abortion on errors, and lots of output from cabal-install. kinda ugly (todo).

# NO WARRANTIES.

# Copyright 2014 Lennart Spitzner




############## UTILITES

function install {
  mkdir -p $HOME/.cabal/sandboxes/$1/
  cd $HOME/.cabal/sandboxes/$1/
  cabal sandbox init
  cabal install -v0 "$1" --bindir=$HOME/.cabal/bin/
}

function echo-install {
  echo "INSTALLING $1 $2"
  install $1
}

function deleteAll {
  echo "DELETING .cabal and .ghc"
  rm -rf $HOME/.cabal
  rm -rf $HOME/.ghc

  # necessary, because .cabal/bin might be in $PATH
  hash -r
}

function init {
  echo "cabal update"
  cabal update
  cabal --version
  
  pushd . > /dev/null
}

function exit {
  popd > /dev/null
 
  echo "hoogle data"
 
  hoogle data
 
  echo "INSTALLED APPLICATIONS:"
  ls $HOME/.cabal/bin
}

############# MAIN

# if you want to delete .ghc and .cabal every time.
# note that you might have hand-configured some config in .cabal and
# do not want to delete that..
# my advise is against using this.
#deleteAll

init

echo-install cabal-install
cabal --version

# not completely certain that this is necessary; better safe than sorry.
cabal update

# make bash acknowledge the new cabal executable
hash -r

echo-install happy
echo-install hoogle
echo-install pointful
echo-install pointfree
echo-install alex "(required by gtk2hs-buildtools)"

# echo-install gtk2hs-buildtools "(required by gtk)"
# echo-install leksah

echo-install aeson
echo-install haddock

# eclipse-fp stuff; does not compile with my current setup :-(
#echo-install buildwrapper-0.7.2
#echo-install scion-browser
#echo-install threadscope

echo-install hlint
echo-install ghc-core
#echo-install djinn
#echo-install arrowp

# echo-install darcs

exit

############## unused, old stuff:

#function init-clear-sandbox() {
#  rm -rf /tmp/cabal
#  mkdir -p /tmp/cabal
#  cd /tmp/cabal/
#  cabal sandbox init
#}
#function clear-sandbox() {
#  rm -rf /tmp/cabal
#}
#function copy-executable() {
#  mkdir -p $HOME/.cabal/bin
#  cp /tmp/cabal/.cabal-sandbox/bin/* $HOME/.cabal/bin/
#}

