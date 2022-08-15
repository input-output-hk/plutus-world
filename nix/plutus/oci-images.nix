{
  inputs,
  cell,
}: {
  chain-index = entrypoints.chain-index.mkDebugOCI "registry.ci.iog.io/plutus-chain-index";
  chain-index-hard = entrypoints.chain-index.mkOCI "registry.ci.iog.io/plutus-chain-index-hardened";
  playground-client = entrypoints.playground-client.mkDebugOCI "registry.ci.iog.io/plutus-playground-client";
  playground-client-hard = entrypoints.playground-client.mkOCI "registry.ci.iog.io/plutus-playground-client-hardened";
  playground-server = entrypoints.playground-server.mkDebugOCI "registry.ci.iog.io/plutus-playground-server";
  playground-server-hard = entrypoints.playground-server.mkOCI "registry.ci.iog.io/plutus-playground-server-hardened";
  web-ghc = entrypoints.web-ghc.mkDebugOCI "registry.ci.iog.io/plutus-web-ghc";
  web-ghc-hard = entrypoints.web-ghc.mkOCI "registry.ci.iog.io/plutus-web-ghc-hardened";
}
