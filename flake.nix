{
  description = "rc3 map scraper";

  # To update all inputs:
  # $ nixFlakes flake lock --recreate-lock-file
  inputs = {
    # Update input flake-compat:
    # $ nixFlakes flake lock --update-input flake-compat
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    # Update input flake-utils:
    # $ nixFlakes flake lock --update-input flake-utils
    flake-utils.url = "github:numtide/flake-utils";

    # Update input nixpkgs:
    # $ nixFlakes flake lock --update-input nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          devShell = import ./shell.nix { inherit pkgs; };
        }
      );
}
