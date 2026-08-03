{ config, pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./direnv.nix
    ./font.nix
    ./vscode.nix
    ./zsh.nix
  ];
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
