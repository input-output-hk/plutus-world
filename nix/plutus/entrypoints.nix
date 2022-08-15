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
    entrypoint = ''
    '';
    env = {};
    runtimeInputs = [
      /*
      packages.yourpackage
      nixpkgs.yourpackage
      */
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
