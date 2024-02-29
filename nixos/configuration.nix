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
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  networking.interfaces.enp2s0.wakeOnLan.enable = true;

  ##IMPURITIES: boot - efi only grub
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
  # boot.initrd.kernelModules = [
  #   "xxhash_generic"
  #   "btrfs"
  # ];
  boot.loader = {
    efi = {
      # canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi"; ## Set yourself
    };
    grub = {
      enable = true;
      efiInstallAsRemovable = true;
      extraEntries = ''

        menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-f9290bd8-1635-4fff-aa7f-8a422c3e5132' {
        	load_video
        	set gfxpayload=keep
        	insmod gzio
        	insmod part_gpt
        	insmod btrfs
        	set root='hd0,gpt3'
        	if [ x$feature_platform_search_hint = xy ]; then
        	  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,gpt3 --hint-efi=hd0,gpt3 --hint-baremetal=ahci0,gpt3  f9290bd8-1635-4fff-aa7f-8a422c3e5132
        	else
        	  search --no-floppy --fs-uuid --set=root f9290bd8-1635-4fff-aa7f-8a422c3e5132
        	fi
        	echo	'Loading Linux linux-zen ...'
        	linux	/arch/@/boot/vmlinuz-linux-zen root=UUID=f9290bd8-1635-4fff-aa7f-8a422c3e5132 rw rootflags=subvol=arch/@  loglevel=3 quiet
        	echo	'Loading initial ramdisk ...'
        	initrd	/arch/@/boot/intel-ucode.img /arch/@/boot/initramfs-linux-zen.img
        }
        submenu 'Advanced options for Arch Linux' $menuentry_id_option 'gnulinux-advanced-f9290bd8-1635-4fff-aa7f-8a422c3e5132' {
        	menuentry 'Arch Linux, with Linux linux-zen' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-zen-advanced-f9290bd8-1635-4fff-aa7f-8a422c3e5132' {
        		load_video
        		set gfxpayload=keep
        		insmod gzio
        		insmod part_gpt
        		insmod btrfs
        		set root='hd0,gpt3'
        		if [ x$feature_platform_search_hint = xy ]; then
        		  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,gpt3 --hint-efi=hd0,gpt3 --hint-baremetal=ahci0,gpt3  f9290bd8-1635-4fff-aa7f-8a422c3e5132
        		else
        		  search --no-floppy --fs-uuid --set=root f9290bd8-1635-4fff-aa7f-8a422c3e5132
        		fi
        		echo	'Loading Linux linux-zen ...'
        		linux	/arch/@/boot/vmlinuz-linux-zen root=UUID=f9290bd8-1635-4fff-aa7f-8a422c3e5132 rw rootflags=subvol=arch/@  loglevel=3 quiet
        		echo	'Loading initial ramdisk ...'
        		initrd	/arch/@/boot/intel-ucode.img /arch/@/boot/initramfs-linux-zen.img
        	}
        	menuentry 'Arch Linux, with Linux linux-zen (fallback initramfs)' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-zen-fallback-f9290bd8-1635-4fff-aa7f-8a422c3e5132' {
        		load_video
        		set gfxpayload=keep
        		insmod gzio
        		insmod part_gpt
        		insmod btrfs
        		set root='hd0,gpt3'
        		if [ x$feature_platform_search_hint = xy ]; then
        		  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,gpt3 --hint-efi=hd0,gpt3 --hint-baremetal=ahci0,gpt3  f9290bd8-1635-4fff-aa7f-8a422c3e5132
        		else
        		  search --no-floppy --fs-uuid --set=root f9290bd8-1635-4fff-aa7f-8a422c3e5132
        		fi
        		echo	'Loading Linux linux-zen ...'
        		linux	/arch/@/boot/vmlinuz-linux-zen root=UUID=f9290bd8-1635-4fff-aa7f-8a422c3e5132 rw rootflags=subvol=arch/@  loglevel=3 quiet
        		echo	'Loading initial ramdisk ...'
        		initrd	/arch/@/boot/intel-ucode.img /arch/@/boot/initramfs-linux-zen-fallback.img
        	}
        }

      '';
      efiSupport = true;
      device = "nodev";
    };
  };
  ##

  #SYSTEMD
  systemd = {
    ##IMPURITIES - snapshot service
    services = {
      intel-gpu-frequency = {
        enable = true;
        description = "Set gpu frequency to max for better hyprland reponsiveness";
        serviceConfig = {
          type = "oneshot";
          ExecStart = "${pkgs.intel-gpu-tools}/bin/intel_gpu_frequency --max";
          RemainAfterExit = "yes";
        };
        wantedBy = ["multi-user.target"];
      };
      auto-gc = {
        enable = true;
        description = "collect nix garbage";
        serviceConfig = {
          ExecStart = "nix-collect-garbage";
        };
      };
      snapshots = {
        enable = true;
        path = with pkgs; [bashInteractive btrfs-progs];
        description = "Do a root and home snapshot";
        serviceConfig = {
          ExecStart = "${inputs.self.scripts.snapshots}/bin/snapshots -r"; ## set the correct path of the script
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
      snapshots = {
        enable = true;
        description = "Timer to run snapshots.service at 9:00:00 and and 17:00:00";
        timerConfig = {
          OnCalendar = "*-*-* 9,17:00:00";
          Persistent = true;
        };
        wantedBy = ["snapshots.target"];
      };
    };
    ##
  };

  #DESKTOP
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [xterm];

    layout = "us,br";
    xkbVariant = "workman,abnt2";
    xkbOptions = "grp:win_space_toggle";

    displayManager.lightdm.enable = false;
    displayManager.startx.enable = true;
    desktopManager.plasma5.enable = true;
    libinput.enable = true;
  };
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "Monofur"];})
    ];
    fontDir.enable = true;
  };

  programs.zsh.enable = true;
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  security.pam.services.swaylock = {};
  security.pam.services.gnome-keyring.text = with pkgs; ''
    auth     optional    ${gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so
    session  optional    ${gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start

    password  optional    ${gnome3.gnome-keyring}/lib/security/pam_gnome_keyring.so
  '';

  #USERS
  users.users = {
    markus = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = ["wheel" "markus"]; # Enable ‘sudo’ for the user.
    };
    talita = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = ["wheel" "talita"];
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
    # python38
    firefox

    wineWowPackages.unstable
    podman
    # flatpak
  ];

  services.flatpak.enable = true;
  #EXTRA
  networking.hostName = "nixos-desktop"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  time.timeZone = "America/Fortaleza";

  nixpkgs.config = {
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
    };
  };
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      # intel-media-driver # LIBVA_DRIVER_NAME=iHD
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
