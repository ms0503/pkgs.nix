(import (
  let
    lock = builtins.fromJSON (builtins.readFile ./flake.lock);
    name = lock.nodes.root.inputs.flake-compat;
  in
  builtins.fetchTarball {
    sha256 = lock.nodes.${name}.locked.narHash;
    url =
      lock.nodes.${name}.locked.url
        or "https://github.com/edolstra/flake-compat/archive/${lock.nodes.${name}.locked.rev}.tar.gz";
  }
) { src = ./.; }).defaultNix
