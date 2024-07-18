{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../nixos-desktop.nix
    ./desktop.nix
  ];

  services.syncthing.enable = true;

  home.packages = with pkgs; [
    stremio
    heroic
  ];
}
