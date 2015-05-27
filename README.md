cabal-exec-install.sh
==================

script for (automatized) installation of haskell executables with cabal using sandboxes

### intention

if you..

- want a basic set of cabal executables (such as hoogle, pandoc, hlint, ..), but do not use haskell platform
- do not want to clutter your global/user package databases, but use sandboxes instead
- do not want to learn/use nix (http://nixos.org/nix/)
  (i survived without it so far)

### target:
- linux
- tested on archlinux with only the ghc package installed

### main properties:
- sandboxes for everything (one sandbox per package).
- installs executables to $HOME/.cabal/bin
  (so add that to PATH, and be done)
- currently the sandbox directory is hardcoded to $HOME/.cabal/sandboxes/

### usage description:
0. [optional] delete $HOME/.ghc and $HOME/.cabal
1. add $HOME/.cabal/bin to PATH
2. modify the MAIN section of this script to contain a "echo-install foo" line for each executable foo you want installed
3. run the script
4. wait an hour while everything installs
5. [optional] enable "require-sandbox: True" in ~/.cabal/config to never
   accidentally install stuff user-globally

  - result:
    - each foo will be sandbox-installed in $HOME/.cabal/sandboxes/foo/
    - the executables will be put in $HOME/.cabal/bin/
    - the data directory for the executable will be $HOME/.cabal/data/foo/

### uninstall:
1. delete $HOME/.cabal/sandboxes
2. delete the relevant executables
3. delete this file :D

### notes:
- one warning: the sandbox directory can easily grow to several GB of size.
  (there should be no problems deleting it once the executables are
   installed, though. but then you need to re-install everything for
   upgrades - not worth it imho)
- no error handling, really. if there are errors, you will have to manually
  fix them to get the relevant executables installed.
- ghc-7.8.4 still is the safest bet for installing executables (until all
  major packages become compatible with ghc-7.10). If your system ships with
  ghc-7.10, you can use a locally installed ghc-7.8.4 by passing the
  `--with-compiler=..` flag to this script; it will be forwarded to cabal.
