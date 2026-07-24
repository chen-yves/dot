{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    emacs
  ];
  xdg.configFile."emacs/early-init.el".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/config/emacs/early-init.el";
  xdg.configFile."emacs/init.el".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/config/emacs/init.el";
}
