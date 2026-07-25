{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    vim
  ];
  home.file.".vim/vimrc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/config/vim/vimrc";
}

