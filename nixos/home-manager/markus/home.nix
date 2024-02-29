{
  config,
  scripts,
  pkgs,
  username,
  host,
  ...
}: {
  services.syncthing.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  services.mako = {
    enable = true;
    extraConfig = builtins.readFile ../../../.config/mako/config.backup;
  };
  programs.home-manager.enable = true;
  home.packages = with pkgs;
    [
      t64gram
      tmux
      zathura
      yt-dlp
      gamemode
      shellcheck
      fuzzel
      alejandra
      ncdu
      nil
      # grapejuice
      # alsa-utils

      obsidian
      keepassxc
      nextcloud-client
      stremio
      qbittorrent-qt5
      osu-lazer
      heroic
      nextcloud-client
    ]
    ++ (with scripts; [
      fd_command
      rg_command
      fzf-finder
      print-wlroots
      volumectl
      snapshots
      distrobox-delta
      fuzzel-kill
      vnc
    ]);
}
