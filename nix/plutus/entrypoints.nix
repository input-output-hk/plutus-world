{
  inputs,
  cell,
}: let
  inherit (cell) packages;

  inherit (inputs.cells) common;

  inherit (inputs) nixpkgs;
  inherit (inputs.std) std;

  l = nixpkgs.lib // builtins;
  /*
  TODO:
  This let block is likely to grow wild with the entrypint components
  maby a `nix/common/entrypoint-snippets.nix` might make sense if this
  is going to be shared between plutus & marlowe
  */
in {
  chain-index = std.lib.writeShellEntrypoint inputs {
    package = packages.chain-index;
    # NOTE: let's use the '${l.getExe packages.chain-index}' idiom for the main package
    # ... it just helps through syntax highlighting to quickly spot the line ...
    entrypoint = ''
      mkdir -p "$INDEX_STATE_DIR"
      wait-for-socket "$SOCKET_PATH"
      exec ${l.getExe packages.chain-index} \
        start-index --socket-path "$SOCKET_PATH" \
        --db-path "$INDEX_STATE_DIR/db.sqlite" \
        --port "$PORT" \
        --network-id "$NETWORK_MAGIC"
    '';
    env = {
      INDEX_STATE_DIR = "some-default"; # FIXME
      NETWORK_MAGIC = "some-default"; # FIXME
      PORT = "8080"; # NOTE: can be fixed at the level of the container; portmapping comes on top of it.
      SOCKET_PATH = "/alloc/node.sock"; # the entrypoint layer *must not* have semantic knowledge of nomad (yet)
      # ... that means, that you would provide SOCKET_PATH path as env in the nomadChart as per the concrete case
      # ... rationale: 4th layer (scheduling layer) cannot bleed into the 3rd layer (image layer) because that
      # would prevent the 3rd layer from being generic in principle.
    };
    runtimeInputs = [
      nixpkgs.coreutils
      common.packages.wait-for-socket
    ];
    debugInputs = [
      /*
      packages.yourpackage
      nixpkgs.yourpackage
      */
    ];
    livenessProbe = null;
    readinessProbe = null;
  };
  web-ghc = std.lib.writeShellEntrypoint inputs {
    package = packages.web-ghc;
    entrypoint = ''
    '';
    env = {};
    runtimeInputs = [];
    debugInputs = [];
    livenessProbe = null;
    readinessProbe = null;
  };
  playground-client = std.lib.writeShellEntrypoint inputs {
    package = packages.playground-client;
    entrypoint = ''
    '';
    env = {};
    runtimeInputs = [];
    debugInputs = [];
    livenessProbe = null;
    readinessProbe = null;
  };
  playground-server = std.lib.writeShellEntrypoint inputs {
    package = packages.playground-server;
    entrypoint = ''
    '';
    env = {};
    runtimeInputs = [];
    debugInputs = [];
    livenessProbe = null;
    readinessProbe = null;
  };
}
