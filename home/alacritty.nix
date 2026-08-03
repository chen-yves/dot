{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
  ];
  xdg.configFile."alacritty/alacritty.toml" = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/config/alacritty/alacritty.toml";
}
