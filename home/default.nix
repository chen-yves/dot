{ config, pkgs, ... }:
{
  imports = [
    ./direnv.nix
    ./emacs.nix
    ./font.nix
    ./ghostty.nix
    ./neovim.nix
    ./vscode.nix
    ./zsh.nix
  ];
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
