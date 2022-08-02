{
  inputs,
  cell,
}: let
  inherit (inputs) cells bitte-cells;
in {
  # Bitte Hydrate Module
  # -----------------------------------------------------------------------
  default = {
    bittelib,
    pkgs,
    ...
  }: {
    # NixOS-level hydration
    # --------------
    cluster = {
      name = "plutus";
      adminNames = ["shea.levy"];
      developerGithubNames = [];
      adminGithubTeamNames = ["devops" "plutus-devops"];
      developerGithubTeamNames = ["plutus"];
      domain = "plutus.aws.iohkdev.io";
      extraAcmeSANs = [
        "*.marlowe-finance.io"
        "marlowe-finance.io"
      ];
      kms = "arn:aws:kms:eu-central-1:048156180985:key/7aa3ec8c-168f-42b8-9f77-6f5d7a9002d0";
      s3Bucket = "iog-plutus-world";
    };
    users.extraUsers.root.openssh.authorizedKeys.keys =
      pkgs.ssh-keys.devOps
      ++ [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/fJqgjwPG7b5SRPtCovFmtjmAksUSNg3xHWyqBM4Cs shlevy@shlevy-laptop"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvmmnk1CO+alJANNP8UFn0TA0fwDVfiwT8zRpt5Y9qMLeRpvaBV7qpKHQuGB1dRLGpAq7Q1hyT2RzypueTkUBx6JxIFPxOsOfNgSoygTFamhWhlWbSbvvvmt9BVM29af6Ju5wLSZqvj0yFjrVi4mb0Rmu2cFbTXIHruwIFWRTmyJMCZEsaXW266ss0etNGiFW5KX3n9hqncjgYaAnQtG86XNASVM+tZcSHlci47SQB8LsKFC/olf2KOAVL/kM2KTIT1Rimm1N/gbixd5psICAYY7py7wFQO08dh7ylJJgNaAyT6FVFoIhk6ztSGxVH9wTA2wE2F1PlJM+1AgHDPWUISmNHkhEztwjiVPP80ysXDDuRfilQWI53piPtJTAyJu5mFDzVhfjFMJ2EEP7uBrVEA3SpoP931JF/98BhUNH/dW5tkFr0IY7ecAEP5qg5QXzvHKS2WDLwbDeQslq0QVkz1dogLTShfB2HzE/YLwfkkeM9oWHt/kr42Bacv7flVWnu9hnIrlDS01tOV+QD2HZH5MLd2s5RNrgJbA2kmbn9n3Tob+SKaTL5FMF8RrnKxc259P1HqRWybjkOUyp9nnjM5GFrz7i0jcue9t6Zj2+3TPEV3aEaZWfkZkaodcdKyBceW1xXpFQp7v5HKAXea0Z9R+vVrG1LNO3M8sq0gCfjNQ=="
      ];
    services = {
      nomad.namespaces = {
        dev-node.description = "Marlowe dev testnet CI node";

        production.description = "Marlowe Production";

        plutus-production.description = "Plutus Apps Production";

        staging.description = "Staging";

        currentSprintMarlowe.description = "Marlowe Current Sprint";

        plutus-staging.description = "Plutus Apps Staging";

        hernan.description = "Hernán's ad hoc environment";

        pablo.description = "Pablo's test environment";

        shlevy.description = "Shea's test environment";

        marlowe-pioneers.description = "Marlowe Pioneers Program";
      };
    };

    # cluster level (terraform)
    # --------------
    tf.hydrate-cluster.configuration = {
      # ... operator role policies
      locals.policies = {
        consul.developer = {};
        nomad.developer = {};
        nomad.admin = {
          namespace."*".policy = "write";
          host_volume."*".policy = "write";
        };
      };
    };
    # Observability State
    # --------------
    tf.hydrate-monitoring.configuration = {
      resource =
        inputs.bitte-cells._utils.library.mkMonitoring
        # Alerts
        {
          # Upstream alerts
          inherit
            (inputs.bitte-cells.bitte.alerts)
            bitte-consul
            bitte-deadmanssnitch
            bitte-loki
            bitte-system
            bitte-vault
            bitte-vm-health
            bitte-vm-standalone
            bitte-vmagent
            ;
        }
        # Dashboards
        {
          inherit
            (inputs.bitte-cells.bitte.dashboards)
            bitte-consul
            bitte-log
            bitte-loki
            bitte-nomad
            bitte-system
            bitte-traefik
            bitte-vault
            bitte-vmagent
            bitte-vmalert
            bitte-vm
            bitte-vulnix
            ;
        };
    };

    # application state (terraform)
    # --------------
    tf.hydrate-app.configuration = let
      vault' = {
        dir = ./. + "/kv/vault";
        prefix = "kv";
      };
      consul' = {
        dir = ./. + "/kv/consul";
        prefix = "config";
      };
      vault = bittelib.mkVaultResources {inherit (vault') dir prefix;};
      consul = bittelib.mkConsulResources {inherit (consul') dir prefix;};
    in {
      data = {inherit (vault) sops_file;};
      resource = {
        inherit (vault) vault_generic_secret;
        inherit (consul) consul_keys;
      };
    };
  };
}
