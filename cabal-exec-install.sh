#!/bin/bash


# short-description:
#   script for (automatized) installation of haskell executables
#   with cabal using sandboxes.
# intention
#   if you..
#     - want a basic set of cabal executables (such as hoogle, pandoc,
#       hlint, ..), but do not use haskell platform
#     - do not want to clutter your global/user package databases,
#       but use sandboxes instead
#     - do not want to learn/use nix (http://nixos.org/nix/)
#       (i survived without it so far)
# target:
#   - linux
#   - tested on archlinux with only the ghc package installed
# main properties:
#   - sandboxes for everything (one sandbox per package).
#   - installs executables to $HOME/.cabal/bin
#     (so add that to PATH, and be done)
#   - currently the sandbox directory is hardcoded to $HOME/.cabal/sandboxes/
# usage description:
#   0) [optional] delete $HOME/.ghc and $HOME/.cabal
#   1) add $HOME/.cabal/bin to PATH
#   2) modify the MAIN section of this script to contain a "echo-install foo" line
#      for each executable foo you want installed
#   3) run this script
#   4) wait an hour while everything installs
#   5) [optional] enable "require-sandbox: True" to ~/.cabal/config to never
#      accidentally install stuff user-globally
#   result:
#     - each foo will be sandbox-installed in $HOME/.cabal/sandboxes/foo/
#     - the executables will be put in $HOME/.cabal/bin/
#     - the data directory for the executable will be $HOME/.cabal/data/foo/
# uninstall:
#   1) delete $HOME/.cabal/sandboxes
#   2) delete the relevant executables
#   3) delete this file :D

# notes: 
# - one warning: the sandbox directory can easily grow to several GB of size.
#   (there should be no problems deleting it once the executables are
#    installed, though. but then you need to re-install everything for
#    upgrades - not worth it imho)
# - no error handling, really. if there are errors, you will have to manually
#   fix them to get the relevant executables installed.

# NO WARRANTIES.

# Copyright 2014 Lennart Spitzner




############## UTILITES

PREFIX="$HOME/.cabal"

FLAGS="$*"

function install {
  SANDBOXDIR="$HOME/.cabal/sandboxes/$1"
  mkdir -p "$SANDBOXDIR"
  cd "$SANDBOXDIR"
  cabal sandbox init -v0
  # make sure we reinstall even if $package is a library as well, and already
  # installed, by unregistering the library package itself from the sandbox
  cabal sandbox hc-pkg -- unregister -v0 "$1" &> /dev/null
  cabal install -v0 "$1" --only-dependencies \
                         --disable-documentation \
                         --disable-library-profiling \
                         --disable-executable-dynamic \
                         $FLAGS
  cabal install -v1 "$1" --disable-documentation \
                         --disable-library-profiling \
                         --disable-executable-dynamic \
                         --bindir="$PREFIX/bin" \
                         --datadir="$PREFIX/share" \
                         $FLAGS | grep "Installed"
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

# not completely certain that this is necessary; better safe than sorry.
cabal update

# make bash acknowledge the new cabal executable
hash -r

echo-install happy
echo-install hoogle
echo-install pointful
echo-install pointfree
# threadscope does not compile atm, without specifying constraint gtk >= 0.12.1 && < 0.13.
# echo-install threadscope
# echo-install pandoc
echo-install alex "(required by gtk2hs-buildtools)"

# echo-install gtk2hs-buildtools "(required by gtk)"
# echo-install leksah-server
# echo-install leksah

echo-install aeson
echo-install hscolour
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

