{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../themes.nix
  ];
  home.username = "talita";
  home.homeDirectory = "/home/talita";
  home.stateVersion = "23.05";

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    initExtra = ''source ~/.zshrc'';
    loginExtra = ''source .zlogin'';
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    t64gram
    yt-dlp
    fd
    ripgrep
    bc
  ];
}
