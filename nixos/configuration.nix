# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, nixpkgs-howdy, ... }:

let
in {
  nix.settings.trusted-users = [ "root" "${username}" ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nixos-pkgs/kmonad/default.nix
      #"${nixpkgs-howdy}/nixos/modules/services/security/howdy/default.nix"
    ];

  #disabledModules = ["security/pam.nix"];
  #services = {
  #  howdy = {
  #    enalbe = true;
  #    device = "/dev/video1";
  #  };
  #};

  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_6_9;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Enable all firmware.
  hardware.enableAllFirmware = true;
  hardware.firmware = [
    pkgs.firmwareLinuxNonfree
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set up input for pinyin
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons ];
  };

  # Setup redshift for eye protection.
  services.redshift = {
    enable = true;
    latitude = "43.45747";
    longitude = "-80.38593";
    brightness = {
      # Note the string values below.
      day = "1";
      night = "1";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  # Enable bluetooth
  # Enabling bluetooth will decrease the wifi connection by almost half!
  # TODO: Replace the media tech wifi card with intel ax210 later.
  #hardware.bluetooth.enable = true;
  #hardware.bluetooth.powerOnBoot = true;
  #services.blueman.enable = true;

  # Enable volume
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    autorun = false;

    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
   };

    desktopManager.plasma5 = {
      enable = true;
    };

    displayManager = {
      startx.enable = true;
      defaultSession = "none+i3";
      # Use gdm instead of lightdm
      gdm.enable = true;
      # Create another session for plasma + i3
      # See https://gist.github.com/bennofs/bb41b17deeeb49e345904f2339222625
      session = [
        {
        manage = "desktop";
        name = "plasma+i3+whatever";
        start = ''exec env KDEWM=${pkgs.i3-gaps}/bin/i3 ${pkgs.plasma-workspace}/bin/startplasma-x11'';
        }
      ];
    };

  };

  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [ pkgs.mesa.drivers ];
  };

  # enable touchpad
  services.xserver.libinput.enable = true;

  # Tell Xorg to use nvidia driver and intel driver. So both external and laptop screens work.
  services.xserver.videoDrivers = [  "amdgpu" ];

  # Add a specialisation for booting with gpu.
  specialisation = {
    # Nvidia card broken with latest kernel. Disable it for now.
    # TODO: Fix this later.
    #nvidia.configuration = {
    #  services.xserver.videoDrivers = [ "nvidia" ];
    #  hardware.opengl.enable = true;
    #  hardware.nvidia = {
    #    nvidiaSettings = true;
    #    # This is borken!
    #    package = config.boot.kernelPackages.nvidiaPackages.stable;
    #    modesetting.enable = true;
    #    open = true;
    #    prime = {
    #      sync.enable = true;
    #      # Can be found by lspci.
    #      nvidiaBusId = "PCI:1:0:0";
    #      amdgpuBusId = "PCI:65:0:0";
    #    };
    #  };
    #  services.supergfxd.enable = true;
    #  systemd.services.supergfxd.path = [ pkgs.pciutils ];
    #  services.asusd = {
    #    enable = true;
    #    enableUserService = true;
    #  };
    #  programs.rog-control-center.enable = true;
    #};
    powerSave.configuration = {
      # CPU Power management.
      powerManagement = {
        enable = true;
        powertop.enable = true;
        cpuFreqGovernor = "powersave";
      };
      # P-P-D conflicts with tlp.
      services.power-profiles-daemon.enable = false;
      services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 20;
        };
      };
      services.thermald.enable = true;
      services.udev.extraRules = ''
          # Remove NVIDIA USB xHCI Host Controller devices, if present
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
          # Remove NVIDIA USB Type-C UCSI devices, if present
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
          # Remove NVIDIA Audio devices, if present
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
          # Remove NVIDIA VGA/3D controller devices
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
        '';
      boot = {
        extraModprobeConfig = ''
          blacklist nouveau
          options nouveau modeset=0
        '';
        blacklistedKernelModules =
          [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "Ziwen Wang";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Allow podman for toolbox
  virtualisation = {
    podman = {
      enable = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #chezmoi
    #libgccjit
    #lshw
    R
    abiword
    alacritty
    asusctl
    autoconf
    automake
    bashmount
    breeze-icons
    brightnessctl
    ccls
    chromium
    clang
    clang-tools
    cscope
    ctags
    direnv
    (discord.override { withVencord = true; })
    dolphin
    fd
    feh
    firefox
    gfortran
    git
    gnome.nautilus
    gnumake
    home-manager
    hunspell
    imagemagick
    jdk8
    kitty
    libreoffice-qt
    libxml2
    libxml2.dev
    libxslt
    neovim
    nodejs
    oxygenfonts
    pandoc
    pciutils
    powertop
    qutebrowser
    ranger
    readline
    ripgrep
    rofi
    rofimoji
    rstudio
    shutter
    stow
    texlive.combined.scheme-full
    tmux
    toolbox
    unzip
    wget
    xclip
    xf86_input_wacom
    xorg.libX11
    xorg.libX11.dev
    xorg.xf86inputevdev
    xorg.xf86inputsynaptics
    xorg.xf86videoamdgpu
    xorg.xorgserver
    xournalpp
    zathura
    zip
    zlib
    zsh
  ];

  fonts.packages = with pkgs; [
    dina-font
    fira-code
    fira-code-symbols
    liberation_ttf
    mplus-outline-fonts.githubRelease
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    noto-fonts-extra
    proggyfonts
  ];

  # Sway.
  #programs.sway = {
  #  enable = true;
  #};

  # zshell settings.
  programs.zsh = {
    enable = true;
  };
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  programs.neovim = {
    defaultEditor = true;
    enable = true;
  };

  # Add swap files
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 32*1024;
  } ];

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # Enable flake.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
