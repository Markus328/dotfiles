# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  #NIX
  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [];

  ##IMPURITIES: boot - efi only grub

  boot.initrd.enable = true;
  # boot.initrd.extraFiles = {
  #   "/bin/vtoydrivers".source = "${inputs.self.vtoyboot}";
  #   "/bin/vtoydump".source = "${inputs.self.vtoyboot}";
  #   "/bin/vtoypartx".source = "${inputs.self.vtoyboot}";
  #   "/bin/vtoytool".source = "${inputs.self.vtoyboot}";
  #   "/bin/vtoydmpatch".source = "${inputs.self.vtoyboot}";
  # };
  # boot.initrd.preDeviceCommands = "";
  boot.initrd.postDeviceCommands = "ln -sf ${inputs.self.vtoyboot}/bin/* /bin && ventoy-setup";
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = ["mitigations=off"];
  boot.tmp.useTmpfs = true;
  boot.plymouth.enable = false;
  # boot.extraModulePackages = with pkgs; [
  #   xxHash
  # ];
  # boot.initrd.availableKernelModules = [
  #   "xxhash_generic"
  #   "btrfs"
  # ];
  boot.initrd.kernelModules = [
    "efivarfs"
  ];
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot/efi"; ## Set yourself
      # canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiInstallAsRemovable = true;
      efiSupport = true;
      device = "nodev";
    };
  };
  ##

  time.hardwareClockInLocalTime = true;
  # services.chrony.enable = true;
  #SYSTEMD
  systemd = {
    coredump.enable = true;
    coredump.extraConfig = ''
      MaxUse=256M
    '';
    ##IMPURITIES - snapshot service
    services = {
      rfkill-unblock-all = {
        enable = true;
        description = "Unblock all hardware devices";
        serviceConfig = {
          ExecStart = "rfkill unblock all";
        };
      };
      auto-gc = {
        enable = true;
        description = "collect nix garbage";
        serviceConfig = {
          ExecStart = "nix-collect-garbage";
        };
      };
      "touchpadctl@" = {
        description = "Enable or disable touchpad in a Hyprland session";
        serviceConfig = {
          ExecStart = "${inputs.self.scripts.touchpadctl}/bin/touchpadctl %I";
        };
      };
    };

    timers = {
      auto-gc = {
        enable = true;
        description = "Timer to run auto-gc.service each week";
        timerConfig = {
          OnCalendar = "Sun *-*-* 00:00:00";
          Persistent = true;
        };
        wantedBy = ["auto-gc.target"];
      };
    };
  };

  #DESKTOP
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  services.tailscale.enable = true;

  programs.adb.enable = true;
  services.udev.packages = [
    pkgs.android-udev-rules
    (import ./udev_rules/touchpad-autodisable.nix {
      inherit pkgs;
      inherit (inputs.self.scripts) touchpadctl;
    })
  ];

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 60; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };

  programs.zsh.enable = true;
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
  };
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];
  security.pam.services.gnome-keyring.text = with pkgs; ''
    auth     optional    ${gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
    session  optional    ${gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start

    password  optional    ${gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
  '';

  #USERS
  users.users = {
    markus = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = ["wheel" "markus" "adbusers"]; # Enable ‘sudo’ for the user.
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
    xdg-desktop-portal-gtk
    patchelf
    microcodeIntel
    # python38
    firefox
  ];

  #EXTRA
  networking = {
    interfaces.wlan0.wakeOnLan = {
      enable = true;
    };
    hostName = "nixos-portable"; # Define your hostname.
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
  };
  time.timeZone = "America/Fortaleza";

  # nixpkgs.config = {
  #   packageOverrides = pkgs: {
  #     vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  #   };
  # };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
    ];
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };
  services.blueman.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  virtualisation.virtualbox.guest = {
    enable = true;
    seamless = true;
    draganddrop = true;
    clipboard = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
