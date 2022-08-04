{
  inputs,
  cell,
}: let
  nomadCommon = inputs.cells.common.nomadCharts;
  inherit (cell.constants) datacenters fqdn;
in {
  mkMarloweComponents = {namespace}: {
    web-ghc = nomadCommon.web-ghc {
      inherit namespace datacenters;
      domain = "web-ghc-${namespace}.${fqdn}";
    };
  };

  mkPlutusComponents = {namespace}: {
    web-ghc = nomadCommon.web-ghc {
      inherit namespace datacenters;
      domain = "web-ghc-${namespace}.${fqdn}";
    };
  };
}
