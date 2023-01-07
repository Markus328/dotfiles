{ pkgs, ... }:
let
  t64gram = (import "/userdata/@workspace/clone/64gram/nix-build/default.nix");
in
{

  home.username = "markus";
  home.homeDirectory = "/home/markus";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    pavucontrol
    tdesktop
    nixos-option
    bottles
    imv
    grapejuice
    wl-clipboard
    foot
    keepassxc
    nextcloud-client
    tmux
    wineWowPackages.unstableFull

    #programming
    clang
    clang-tools
    cargo
    rnix-lsp
    nodejs

  ];

}

