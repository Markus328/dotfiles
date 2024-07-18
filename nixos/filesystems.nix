# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{...}: {
  ##IMPURITIES: filesystem - add/remove/subs according the current hardware
  #SWAP
  zramSwap = {
    enable = true;
    # numDevices = 4;
    swapDevices = 4;
    algorithm = "zstd";
    priority = 32767;
  };

  #FILESYSTEM
  fileSystems = let
    options = ["rw" "noatime" "space_cache=v2" "nodiscard"];
    compress.options = options ++ ["compress-force=zstd"];
    device = "/dev/disk/by-uuid/5bdf738b-59cc-41ab-bdfb-91d52e83c4d7";
    fsType = "btrfs";
  in {
    "/" = {
      inherit device;
      options = compress.options ++ ["subvol=/@"];
      inherit fsType;
    };
    "/nix" = {
      inherit device;
      options = compress.options ++ ["subvol=/@nix"];
      inherit fsType;
    };
    "/home" = {
      inherit device;
      options = compress.options ++ ["subvol=@home"];
      inherit fsType;
    };
  };
  ##
}
