{
  config,
  pkgs,
  username,
  hostname,
  inputs,
  ...
}:
{
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.primaryUser = username;
  system = {
    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };
      finder = {
        _FXShowPosixPathInTitle = true;
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
    };
  };
  system.activationScripts.extraActivation.text = ''
    softwareupdate --install-rosetta --agree-to-license
  '';
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.auto-optimise-store = false;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  environment.systemPackages = with pkgs; [
    just
    nil
    nixfmt
  ];
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
  homebrew = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [
      "BarutSRB/tap"
    ] ++ builtins.attrNames (config.nix-homebrew.taps or {});
    brews = [
      "mas"
    ];
    casks = [
      "discord"
      "futubull"
      "google-chrome"
      "omniwm"
      "raycast"
      "tradingview"
      "utm"
      "visual-studio-code"
    ];
    masApps = {
      LINE = 539883307;
    };
  };
}
