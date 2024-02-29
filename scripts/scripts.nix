{
  pkgs,
  scriptsPath,
  ...
}:
with pkgs; let
  importScript = script: deps: (
    import (lib.path.append scriptsPath "scriptBuilder.nix") {
      inherit pkgs;
      script = lib.path.append scriptsPath script;
      inherit deps;
    }
  );
in rec {
  fd_command = importScript "fd_command" [fd getopt];
  rg_command = importScript "rg_command" [ripgrep];
  fzf-finder = importScript "fzf-finder" [fd_command rg_command bc fzf xdg-utils getopt];
  volumectl = importScript "volumectl" [wob alsa-utils pamixer];

  print-wlroots = importScript "print-wlroots" [grim slurp];

  fuzzel-kill = importScript "fuzzel-kill" [fuzzel];
  snapshots = importScript "snapshots" [];
  distrobox-delta = importScript "distrobox-delta" [distrobox bindfs];

  vnc = importScript "vnc" [jq wayvnc];
}
