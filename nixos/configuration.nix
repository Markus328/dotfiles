# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./filesystems.nix
    ];

  #NIX
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  ##IMPURITIES: boot - efi only grub
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };
  ##

  #SYSTEMD
  systemd = {
    ##IMPURITIES - snapshot service
    services.snapshots = {
      enable = true;
      path = with pkgs;[ bashInteractive btrfs-progs gawk gnused ];
      description = "Do a root and home snapshot";
      serviceConfig = {
        ExecStart = "/special/scripts/snapshots.sh -r"; ## set the correct path of the script
      };
    };
    timers.snapshots = {
      enable = true;
      description = "Timer to run snapshots.service at 9:00:00 and and 17:00:00";
      timerConfig = {
        OnCalendar = "*-*-* 9,17:00:00";
        Persistent = true;
      };
      wantedBy = [ "snapshots.target" ];
    };
    ## 
  };




  #DESKTOP
  services.xserver = {
    enable = true;
    desktopManager.plasma5 = {
      enable = true;
      mobile.installRecommendedSoftware = false;
      excludePackages = with pkgs.plasma5Packages; [
        plasma-browser-integration
        konsole
        okular
        powerdevil
        bluedevil
        bluez-qt
        breeze-plymouth
        breeze-grub
      ];
    };

    displayManager.lightdm.enable = false;

    layout = "us,br";
    xkbVariant = "workman,abnt2";
    xkbOptions = "grp:win_space_toggle";
  };
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];
    fontDir.enable = true;
  };

  programs.zsh.enable = true;

  #USERS
  users.users = {
    markus = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
    root.shell = pkgs.zsh;
  };

  #PACKAGES
  environment.systemPackages = with pkgs; [
    wget
    git
    neovim
    zip
    unzip
    compsize
    xdg-desktop-portal-kde
    xdg-desktop-portal-gtk
    patchelf
    microcodeIntel
    python38
    firefox
    grapejuice
  ];


  #EXTRA
  networking.hostName = "nixos-desktop"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  time.timeZone = "America/Fortaleza";


  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    ];
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
