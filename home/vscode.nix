{ config, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
    ]
    ++ lib.optionals stdenv.isLinux [ vscode-fhs ];
  home.file."${
    if pkgs.stdenv.isDarwin then "Library/Application Support/Code/User" else ".config/Code/User"
  }/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/config/vscode/settings.json";
  home.file."${
    if pkgs.stdenv.isDarwin then "Library/Application Support/Code/User" else ".config/Code/User"
  }/keybindings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/config/vscode/keybindings.json";
}
