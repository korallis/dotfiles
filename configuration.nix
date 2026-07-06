{ ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = "leebarry";
  users.users.leebarry = {
    home = "/Users/leebarry";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };
  nix-homebrew = {
    enable = true;
    user = "leebarry";
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    # Custom taps for the desktop-rice tools.
    taps = [
      "nikitabobko/tap"      # AeroSpace
      "felixkratz/formulae"  # JankyBorders + SketchyBar
    ];
    brews = [
      "herdr"
      "borders"     # JankyBorders - window borders (felixkratz/formulae)
      "sketchybar"  # status bar (felixkratz/formulae)
    ];
    casks = [
      "wezterm"
      "claude-code"
      "codex"
      "aerospace"                # tiling window manager (nikitabobko/tap)
      "font-sketchybar-app-font" # app-icon glyphs for the SketchyBar workspaces
      # cursor-agent is NOT installed via Homebrew: the cask ships an unsigned
      # binary that fails to load. It's installed from Cursor's official script
      # in home.nix instead (installs to ~/.local/bin).
    ];
  };
}
