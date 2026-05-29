{ inputs }:
let
  inherit (inputs)
    nix-darwin
    nix-homebrew
    home-manager
    nixpkgs
    homebrew-core
    homebrew-cask
    ;
in
{
  mkDarwinSystem =
    {
      system,
      hostname,
      username,
      withHomeManager ? true,
    }:
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs hostname username; };
      modules = [
        ../darwin
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = if system == "aarch64-darwin" then true else false;
            user = username;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };
            mutableTaps = false;
            autoMigrate = true;
          };
        }
      ]
      ++ (
        if withHomeManager then
          [
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs hostname username; };
              home-manager.users.${username} = import ../home;
            }
          ]
        else
          [ ]
      );
    };
  mkHomeConfiguration =
    {
      system,
      username,
      hostname ? "standalone",
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit inputs hostname username; };
      modules = [
        ../home
      ];
    };
  mergeShells =
    pkgs: shells:
    let
      shellsList = if builtins.isList shells then shells else builtins.attrValues shells;
    in
    pkgs.mkShell {
      inputsFrom = shellsList;
    };
}
