let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
in
{ pkgs ? import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
      sha256 = lock.nodes.nixpkgs.locked.narHash;
    })
    { }
}:

let
  my-python = pkgs.python3;
  python-with-my-packages = my-python.withPackages (p: with p; [
    requests
    # other python packages you want
  ]);
in

pkgs.mkShell {
  name = "rc3-map-scraper-shell";
  packages = with pkgs; [
    (pkgs.writeScriptBin "nixFlakes" ''
      exec ${pkgs.nixUnstable}/bin/nix --experimental-features "nix-command flakes" "$@"
    '')

    python-with-my-packages
  ];
  buildInputs = [
    python-with-my-packages
    # other dependencies
  ];
  shellHook = ''
    PYTHONPATH=${python-with-my-packages}/${python-with-my-packages.sitePackages}
    # maybe set more env-vars
  '';
  HISTFILE = "${toString ./.}/.history";
}
