{
  inputs,
  cell,
}: {
  web-ghc = import ./web-ghc.nix {inherit inputs cell;};
}
