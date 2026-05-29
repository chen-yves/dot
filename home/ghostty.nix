{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    ghostty-bin
  ];
  xdg.configFile."ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/config/ghostty/config";
}
