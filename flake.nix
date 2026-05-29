{
  description = "My nix based dotfiles";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      ...
    }:
    let
      myLib = import ./lib { inherit inputs; };
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forEachSystem =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f (import nixpkgs { inherit system; }));
    in
    {
      darwinConfigurations = {
        "yingying" = myLib.mkDarwinSystem {
          system = "aarch64-darwin";
          hostname = "yingying";
          username = "cya";
        };
      };
      devShells = forEachSystem (
        pkgs:
        let
          cpp = import ./shell/cpp.nix { inherit pkgs; };
          nodejs = import ./shell/nodejs.nix { inherit pkgs; };
          python = import ./shell/python.nix { inherit pkgs; };
          r = import ./shell/r.nix { inherit pkgs; };
        in
        {
          inherit
            cpp
            nodejs
            python
            r
            ;
          default = myLib.mergeShells pkgs {
            inherit
              cpp
              nodejs
              python
              r
              ;
          };
        }
      );
    };
}
