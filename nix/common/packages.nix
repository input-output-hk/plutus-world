{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  l = nixpkgs.lib // builtins;
in {
  wait-for-socket = nixpkgs.writeShellScriptBin "wait-for-socket" ''
    set -eEuo pipefail
    export PATH="${l.makeBinPath [nixpkgs.coreutils nixpkgs.socat]}"
    sock_path="$1"
    delay_iterations="''${2:-8}"
    for ((i=0;i<delay_iterations;i++))
    do
      if socat -u OPEN:/dev/null "UNIX-CONNECT:''${sock_path}"
      then
        exit 0
      fi
      let delay=2**i
      echo "Connecting to ''${sock_path} failed, sleeping for ''${delay} seconds" >&2
      sleep "''${delay}"
    done
    socat -u OPEN:/dev/null "UNIX-CONNECT:''${sock_path}"
  '';

  sleep-until-restart-slot = nixpkgs.writeShellScriptBin "sleep-until-restart-slot" ''
    set -eEuo pipefail
    export PATH="${l.makeBinPath [nixpkgs.coreutils]}"
    nowHour=$(date -u +%-H)
    hoursLeft=$((3 - (nowHour % 3)))
    wakeHour=$(((nowHour + hoursLeft) % 24))
    exec sleep $((($(date -u -f - +%s- <<< "$wakeHour"$':00 tomorrow\nnow')0)%86400))
  '';
}
