{
  description = "Plutus World";

  inputs.std.url = "github:divnix/std?ref=imp/lib-entrypoints";
  inputs.n2c.url = "github:nlewo/nix2container";
  inputs.data-merge.follows = "std/data-merge";
  inputs = {
    # --- Bitte Stack ----------------------------------------------
    bitte.url = "github:input-output-hk/bitte";
    bitte.inputs.capsules.url = "github:divnix/blank";
    bitte-cells.url = "github:input-output-hk/bitte-cells";
    # --------------------------------------------------------------
    # --- Auxiliaries ----------------------------------------------
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    capsules.url = "github:input-output-hk/devshell-capsules";
    # --------------------------------------------------------------
  };
  outputs = inputs: let
    inherit (inputs) bitte;
    system = "x86_64-linux";
    cloud = inputs.self.${system}.cloud;
  in
    inputs.std.growOn
    {
      inherit inputs;
      cellsFrom = ./nix;
      # debug = ["cells" "backend"];
      organelles = [
        # the 4 layers of packaging
        (inputs.std.installables "packages")
        (inputs.std.runnables "entrypoints")
        (inputs.std.containers "oci-images")
        (inputs.std.functions "nomadCharts")

        # the 2 layers of observability

        # cloud
        (inputs.std.data "constants")
        (inputs.std.functions "hydrationProfiles")
        (inputs.std.data "namespaces/dev-node")
        (inputs.std.data "namespaces/production")
        (inputs.std.data "namespaces/plutus-production")
        (inputs.std.data "namespaces/staging")
        (inputs.std.data "namespaces/currentSprintMarlowe")
        (inputs.std.data "namespaces/plutus-staging")
        (inputs.std.data "namespaces/hernan")
        (inputs.std.data "namespaces/pablo")
        (inputs.std.data "namespaces/shlevy")
        (inputs.std.data "namespaces/marlowe-pioneers")

        # repo automation
        (inputs.std.devshells "devshells")
        (inputs.std.nixago "nixago")

        # metal
        (inputs.std.functions "bitteProfile")
      ];
    }
    # soil
    # 1) bitte instrumentation (TODO: `std`ize bitte)
    (
      let
        bitte = inputs.bitte.lib.mkBitteStack {
          inherit inputs;
          inherit (inputs) self;
          domain = "plutus.aws.iohkdev.io";
          bitteProfile = inputs.self.${system}.metal.bitteProfile.default;
          nomadEnvs = inputs.self.${system}.cloud.nomadEnvs;
          hydrationProfile = inputs.self.${system}.cloud.hydrationProfiles.default;
          deploySshKey = "./secrets/ssh-plutus";
        };
      in
        # if the bitte input is silenced (replaced by divnix/blank)
        # then don't generate flake level attrNames from mkBitteStack (it fails)
        if inputs.bitte ? lib
        then bitte
        else {}
    )
    # 2) renderes nomad environments (TODO: `std`ize as actions)
    (let
      mkNomadJobs = let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
        builtins.mapAttrs (
          n: job:
            pkgs.linkFarm "job.${n}" [
              {
                name = "job";
                path = pkgs.writeText "${n}.nomad.json" (builtins.toJSON job);
              }
            ]
        );
    in {
      dev-node = mkNomadJobs cloud."namespaces/dev-node";
      production = mkNomadJobs cloud."namespaces/production";
      plutus-production = mkNomadJobs cloud."namespaces/plutus-production";
      staging = mkNomadJobs cloud."namespaces/staging";
      currentSprintMarlowe = mkNomadJobs cloud."namespaces/currentSprintMarlowe";
      plutus-staging = mkNomadJobs cloud."namespaces/plutus-staging";
      hernan = mkNomadJobs cloud."namespaces/hernan";
      pablo = mkNomadJobs cloud."namespaces/pablo";
      shlevy = mkNomadJobs cloud."namespaces/shlevy";
      marlowe-pioneers = mkNomadJobs cloud."namespaces/marlowe-pioneers";
    });
  # --- Flake Local Nix Configuration ----------------------------
  nixConfig = {
    extra-substituters = ["https://cache.iog.io" "https://iog.cachix.org"];
    extra-trusted-public-keys = ["hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" "iog.cachix.org-1:nYO0M9xTk/s5t1Bs9asZ/Sww/1Kt/hRhkLP0Hhv/ctY="];
    allow-import-from-derivation = "true";
  };
  # --------------------------------------------------------------
}
