{
  inputs,
  cell,
}: {
  inherit (inputs.plutus.packages) chain-index; # consumed by marlowe
  inherit (inputs.plutus.packages) web-ghc;
  inherit (inputs.plutus.packages) playground-client;
  inherit (inputs.plutus.packages) playground-server;
}
