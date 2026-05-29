{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts
    liberation_ttf
    noto-fonts-color-emoji
  ];
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    monospace = [
      "JetBrainsMono Nerd Font"
      "Noto Sans Mono CJK TC"
    ];
    sansSerif = [
      "Noto Sans CJK TC"
      "Noto Sans"
    ];
    serif = [
      "Noto Serif CJK TC"
      "Noto Serif"
    ];
    emoji = [ "Noto Color Emoji" ];
  };
}
