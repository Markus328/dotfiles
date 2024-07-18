{
  pkgs,
  config,
  scripts,
  ...
}: {
  imports = [./home.nix];

  services.gnome-keyring.enable = true;

  services.mako = {
    enable = true;
    extraConfig = builtins.readFile ../../../.config/mako/config.backup;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../../../.config/hypr/hyprland.conf.backup;
    settings = {
      decoration.blur.enabled = false;
      animations.enabled = false;
    };
  };
  home.packages = with pkgs;
    [
      gcr
      waybar
      hyprpaper
      hyprlock
      hypridle
      libnotify
    ]
    ++ (with scripts; [
      fd_command
      rg_command
      fzf-finder
      print-wlroots
      volumectl
      distrobox-delta
      fuzzel-kill
    ]);
}
