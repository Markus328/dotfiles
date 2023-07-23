# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:
{


  ##IMPURITIES: filesystem - add/remove/subs according the current hardware
  #SWAP
  swapDevices = [{
    device = "/dev/sda2";
    priority = 0;
  }];
  zramSwap = {
    enable = true;
    numDevices = 4;
    swapDevices = 4;
    algorithm = "zstd";
    priority = 32767;
  };

  #FILESYSTEM
  fileSystems =
    let
      options = [ "rw" "noatime" "ssd" "space_cache=v2" ];
      compress.options = options ++ [ "compress-force=zstd" ];
      device = "/dev/sda3";
      fsType = "btrfs";
    in
    {
      "/" = {
        inherit device;
        options = compress.options ++ [ "subvol=/nixos/@" ];
        inherit fsType;
      };
      "/userdata" = {
        inherit device;
        options = compress.options ++ [ "subvol=/@userdata" ];
        inherit fsType;
      };
      "/home" = {
        inherit device;
        options = compress.options ++ [ "subvol=/nixos/@home" ];
        inherit fsType;
      };
      "/.snapshots" = {
        inherit device;
        options = compress.options ++ [ "subvol=/snapshots/root/@nixos" ];
        inherit fsType;
      };
      "/home/.snapshots" = {
        inherit device;
        options = compress.options ++ [ "subvol=/snapshots/@home-nixos" ];
        inherit fsType;
      };
      "/special" = {
        inherit device;
        options = options ++ [ "subvol=/@special" ];
        inherit fsType;
      };
      "/userdata/@dotfiles/.snapshots" = {
        inherit device;
        options = compress.options ++ [ "subvol=/snapshots/@dotfiles" ];
        inherit fsType;
      };
      "/userdata/@workspace/.snapshots" = {
        inherit device;
        options = compress.options ++ [ "subvol=/snapshots/@workspace" ];
        inherit fsType;
      };
      "/userdata/@games/.snapshots" = {
        inherit device;
        options = compress.options ++ [ "subvol=/snapshots/@games" ];
        inherit fsType;
      };
    };
  ##
}
