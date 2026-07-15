{
  system ? builtins.currentSystem,
}:
let
  flake-compat = import (fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/refs/heads/master.tar.gz";
    # pin this once you know the hash (see note below)
    # sha256 = "...";
  });

  llm-agents =
    (flake-compat {
      src = fetchTarball {
        url = "https://github.com/numtide/llm-agents.nix/archive/refs/heads/main.tar.gz";
        # sha256 = "...";
      };
    }).defaultNix;
in
llm-agents.packages.${system}
