{
  inputs,
  cell,
}: let
  ociNamer = oci: builtins.unsafeDiscardStringContext "${oci.imageName}:${oci.imageTag}";
  inherit (cell) oci-images;
in
  {
    namespace,
    datacenters,
    domain,
    image-variant ? namespace,
  }: {
    job."${namespace}-web-ghc" = {
      inherit namespace datacenters;

      type = "service";

      constraint = [
        {
          attribute = "\${node.class}";
          value = "client";
        }
      ];

      group.web-ghc-server = {
        network = {
          mode = "host";
          port.web-ghc = {};
        };

        count = 1;

        service."${namespace}-web-ghc" = {
          address_mode = "host";
          port = "web-ghc";
          tags = [
            namespace
            "ingress"
            "traefik.enable=true"
            "traefik.http.routers.${namespace}-web-ghc.rule=Host=(${domain})"
            "traefik.http.routers.${namespace}-web-ghc.entrypoints=https"
            "traefik.http.routers.${namespace}-web-ghc.tls=true"
          ];
          check.health = {
            type = "http";
            port = "web-ghc";
            interval = "10s";
            path = "/health";
            timeout = "2s";
          };
        };

        # TODO extract out commonalities like the plutus-ops "SimpleTask"
        task.web-ghc = {
          driver = "docker";

          config.image = ociNamer oci-images."web-ghc-${image-variant}";

          kill_timeout = "30s";

          vault = {
            policies = ["nomad-cluster"];
            change_mode = "noop";
          };

          resources = {
            cpu = 4000;
            memory = 4000;
          };

          env = {
            PATH = "/bin";
          };
        };
      };
    };
  }
