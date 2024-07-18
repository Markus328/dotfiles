{
  config,
  pkgs,
  username,
  host,
  ...
}: {
  imports = [
    ./themes.nix
  ];
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "22.05";
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

}
