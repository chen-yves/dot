{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#f8e3a1,bg=#6e7681,bold,underline";
      strategy = [
        "history"
        "completion"
        "match_prev_cmd"
      ];
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
      theme = "af-magic";
    };
  };
}
