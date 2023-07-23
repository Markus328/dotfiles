{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../themes.nix
  ];
  home.username = "markus";
  home.homeDirectory = "/home/markus";
  home.stateVersion = "23.05";

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    initExtra = ''source ~/.zshrc'';
    loginExtra = ''source .zlogin'';
  };
  programs.fzf = {
  home.file.".local/bin/finder".source = ".config/util/fzf-finder";
    enable = true;
    enableZshIntegration = true;
  };
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    t64gram
    tmux
    zathura
    syncthing

    #Neovim
    # cargo
    alejandra
    gamemode
    shfmt
    shellcheck
    # rnix-lsp
    stylua
    isort
    black
    nodePackages.prettier
    yt-dlp
    fd
    ripgrep
    bc
  ];
}
