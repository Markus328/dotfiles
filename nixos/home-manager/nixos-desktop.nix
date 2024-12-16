{
  config,
  pkgs,
  username,
  host,
  ...
}: {
  imports = [./home.nix];
  home.packages = with pkgs; [
    foot
    tmux
    wl-clipboard
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../../../.config/hypr/hyprland.conf.backup;
    settings = {
      decoration.blur.enabled = true;
      animations.enabled = true;
      monitor = [
        "desc:XXW HDMI,1440x900,0x0,1"
        "eDP-1,preferred,1440x276, 1.33"
      ];
    };
  };
}
