{pkgs,config, ...}: {
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
    })
  ];

  services.gnome-keyring.enable = true;
  home.packages = with pkgs; [
    gcr
    waybar
    wofi
    swaybg
    nixos-option
    # bottles
    # grapejuice
    wl-clipboard
    foot
    tmux
    swaylock
    swayidle
  ];
}
