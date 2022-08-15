{
  inputs,
  cell,
}: {
  inherit (inputs.marlowe.packages) web-ghc;
  inherit (inputs.marlowe.packages) pab;
  inherit (inputs.marlowe.packages) dashboard-client;
  inherit (inputs.marlowe.packages) dashboard-server;
  inherit (inputs.marlowe.packages) playground-client;
  inherit (inputs.marlowe.packages) playground-server;
  inherit (inputs.marlowe-web.packages) website;
}
