# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
 
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #NIX
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;


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
      zram = {
        device = "/dev/zram";
        options = [ "defaults" "pri=32767" ];
        fsType = "swap";
      };
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

  #BOOT
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

  #SYSTEMD
  systemd = {
    services.snapshots = {
      enable = true;
      path = with pkgs;[ bashInteractive btrfs-progs gawk gnused ];
      description = "Do a root and home snapshot";
      serviceConfig = {
        ExecStart = "/special/scripts/snapshots.sh -r";
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
  };



  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

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

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;

  #USERS
  users.users = {
    markus = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
      ];
    };
    root.shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget


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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;


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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
