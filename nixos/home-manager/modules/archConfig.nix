{
  config,
  pkgs,
  ...
}: let
  nixgh-wrap = bin: name: driver: (pkgs.writeShellScriptBin name ''
    ${pkgs.nixgl.${driver}}/bin/${driver} ${bin} $@
  '');
in {
  targets.genericLinux.enable = true;
  home.packages = with pkgs; [
    neovim

    #utils
    ncdu
    iotop
    unzip
    curl
    nixgl.nixGLIntel
    nixgl.nixVulkanIntel
    j4-dmenu-desktop
    bemenu

    (nixgh-wrap "${imv}/bin/imv" "imv" "nixGLIntel")
    (nixgh-wrap "${wineWowPackages.unstable}/bin/wine" "wine" "nixGLIntel")
    (nixgh-wrap "${(nixgh-wrap "${gamescope}/bin/gamescope" "gamescope" "nixVulkanIntel")}/bin/gamescope" "gamescope" "nixGLIntel" )
    (nixgh-wrap "${mpv}/bin/mpv" "mpv" "nixGLIntel")
  ];
}
