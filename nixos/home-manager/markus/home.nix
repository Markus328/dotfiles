{
  config,
  scripts,
  pkgs,
  username,
  host,
  ...
}: {
  imports = [../home.nix];
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  home.packages = with pkgs; [
    foot
    tmux
    zathura
    obsidian
    stremio
    yt-dlp
    shellcheck
    fuzzel
    alejandra
    nil
    clang-tools
    keepassxc
    nextcloud-client
    wl-clipboard

    mpv
    imv
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = ["zathura.desktop"];
    "video/mp4" = ["mpv.desktop"];
    "image/png" = ["imv.desktop"];
    "image/jpeg" = ["imv.desktop"];
    "text/plain" = ["lvim.desktop"];

    "text/x-csrc" = ["lvim.desktop"];
    "text/x-lua" = ["lvim.desktop"];
    "text/x-c++src" = ["lvim.desktop"];
    "text/x-chdr" = ["lvim.desktop"];
  };
}
