{
  inputs,
  cell,
}: {
  dashboard-client = entrypoints.dashboad-client.mkDebugOCI "registry.ci.iog.io/marlowe-dashboard-client";
  dashboard-client-hard = entrypoints.dashboad-client.mkOCI "registry.ci.iog.io/marlowe-dashboard-client-hardened";
  dashboard-server = entrypoints.dashboad-server.mkDebugOCI "registry.ci.iog.io/marlowe-dashboard-server";
  dashboard-server-hard = entrypoints.dashboad-server.mkOCI "registry.ci.iog.io/marlowe-dashboard-server-hardened";
  playground-client = entrypoints.playground-client.mkDebugOCI "registry.ci.iog.io/marlowe-playground-client";
  playground-client-hard = entrypoints.playground-client.mkOCI "registry.ci.iog.io/marlowe-playground-client-hardened";
  playground-server = entrypoints.playground-server.mkDebugOCI "registry.ci.iog.io/marlowe-playground-server";
  playground-server-hard = entrypoints.playground-server.mkOCI "registry.ci.iog.io/marlowe-playground-server-hardened";
  web-ghc = entrypoints.web-ghc.mkDebugOCI "registry.ci.iog.io/marlowe-web-ghc";
  web-ghc-hard = entrypoints.web-ghc.mkOCI "registry.ci.iog.io/marlowe-web-ghc-hardened";
  website = entrypoints.website.mkDebugOCI "registry.ci.iog.io/marlowe-website";
  website-hard = entrypoints.website.mkOCI "registry.ci.iog.io/marlowe-website-hardened";
}
