{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../nixos-desktop.nix
    ./home.nix
  ];

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
    swayidle
    hyprlock
    hypridle
    libnotify
  ];
}
