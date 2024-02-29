{
  config,
  pkgs,
  username,
  host,
  ...
}: {
  imports = [
    ../nixos-desktop.nix
    ./home.nix
  ];
}
