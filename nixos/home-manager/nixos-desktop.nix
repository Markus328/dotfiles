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
}
