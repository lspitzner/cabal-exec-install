cabal-exec-install.sh
==================

script for (automatized) installation of haskell executables with cabal using sandboxes

### intention

if you..
- want a basic set of cabal executables (such as hoogle, pandoc, hlint, ..), but do not use haskell platform
- do not want to clutter your global/user package databases, but use sandboxes instead
- do not want to learn/use nix (http://nixos.org/nix/) (i survived without it so far)

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
2. modify the MAIN section of this script to contain a "echo-install foo" line for each executable foo you want installed.
3. run the script.
4. wait an hour while everything installs

  - result:
    - each foo will be sandbox-installed in $HOME/.cabal/sandboxes/foo/
    - the executables will be put in $HOME/.cabal/bin/

### uninstall:
1. delete $HOME/.cabal/sandboxes
2. delete the relevant executables
3. delete this file :D

### notes:
- one warning: the sandbox directory can easily grow to several GB of size.
- it might be possible to delete certain intermediate files after one executable has finished installation. (todo)
- no abortion on errors, and lots of output from cabal-install. kinda ugly (todo).
