{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim
  ];
  xdg.configFile."nvim/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/config/nvim/init.lua";
}

