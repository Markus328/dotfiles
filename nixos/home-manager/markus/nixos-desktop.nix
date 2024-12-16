{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../nixos-desktop.nix
    ./desktop.nix
  ];

  home.packages = with pkgs; [
    heroic
  ];
}
