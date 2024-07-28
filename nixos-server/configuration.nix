# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, nix-doom-emacs, system, ... }:

let
  doom-emacs = nix-doom-emacs.packages.${system}.default.override {
    # Point to my current doom config file but I don't have one for now.
    #doomPrivateDir = ./doom.d;
  };
in {
  nix.settings.trusted-users = [ "root" "ziwen" ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nixos-pkgs/kmonad/default.nix
    ];

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

  # Configure a static ip addr.
  #networking.interfaces.eth0.ipv4.adresses = [ {
  #  address = "192.168.2.84";
  #  prefixLength = 24;
  #} ];
  networking.hostName = "nixos-server"; # Define your hostname.
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
  location.latitude = 43.45747;
  location.longitude = -80.38593;
  services.redshift = {
    enable = true;
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

  # Enable mySQL
  services.mysql = {
    enable = true;
    package = pkgs.mysql;
  };

  # Enable bluetooth
  # Enabling bluetooth will decrease the wifi connection by almost half!
  # TODO: Replace the media tech wifi card with intel ax210 later.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

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
    #driSupport = true;
    driSupport32Bit = true;
    extraPackages = [ pkgs.mesa.drivers ];
  };

  # enable touchpad
  services.xserver.libinput.enable = true;

  # Tell Xorg to use nvidia driver and intel driver. So both external and laptop screens work.
  services.xserver.videoDrivers = [  "amdgpu" ];

  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  # Add a specialisation for booting with gpu.
  specialisation = {
    nvidia.configuration = {
      #nixpkgs.config.cudaSupport = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.opengl.enable = true;
      hardware.nvidia = {
        nvidiaSettings = true;
        modesetting.enable = true;
        open = true;
        prime = {
          sync.enable = true;
          # Can be found by lspci.
          nvidiaBusId = "PCI:1:0:0";
          amdgpuBusId = "PCI:65:0:0";
        };
        package =  let 
          rcu_patch = pkgs.fetchpatch {
            url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
            hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
          };
        in config.boot.kernelPackages.nvidiaPackages.mkDriver {
            #version = "535.154.05";
            #sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
            #sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
            #openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
            #settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
            #persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";

            version = "550.40.07";
            sha256_64bit = "sha256-KYk2xye37v7ZW7h+uNJM/u8fNf7KyGTZjiaU03dJpK0=";
            sha256_aarch64 = "sha256-AV7KgRXYaQGBFl7zuRcfnTGr8rS5n13nGUIe3mJTXb4=";
            openSha256 = "sha256-mRUTEWVsbjq+psVe+kAT6MjyZuLkG2yRDxCMvDJRL1I=";
            settingsSha256 = "sha256-c30AQa4g4a1EHmaEu1yc05oqY01y+IusbBuq+P6rMCs=";
            persistencedSha256 = "sha256-11tLSY8uUIl4X/roNnxf5yS2PQvHvoNjnd2CB67e870=";
            patches = [ rcu_patch ];
         };

      };
      services.supergfxd.enable = true;
      systemd.services.supergfxd.path = [ pkgs.pciutils ];
      programs.rog-control-center.enable = true;
    };
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
  users.users.ziwen = {
    isNormalUser = true;
    description = "Ziwen Wang";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbEQFPmEQvJkymdUXyAzrvaRvNER66lbtuyM9f/3b+7 1308632188@qq.com"
    ];
    packages = with pkgs; [];
  };

  users.users.ziwen1 = {
    isNormalUser = true;
    description = "Ziwen Wang";
    extraGroups = [ "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbEQFPmEQvJkymdUXyAzrvaRvNER66lbtuyM9f/3b+7 1308632188@qq.com"
    ];
    packages = with pkgs; [];
  };

  users.users = {
    ccw = {
      isNormalUser = true;
      description = "ccw";
      extraGroups = [ "networkmanager" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbEQFPmEQvJkymdUXyAzrvaRvNER66lbtuyM9f/3b+7 1308632188@qq.com"
      ];
      packages = with pkgs; [];
    };
    qhn = {
      isNormalUser = true;
      description = "qhn";
      extraGroups = [ "networkmanager" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbEQFPmEQvJkymdUXyAzrvaRvNER66lbtuyM9f/3b+7 1308632188@qq.com"
      ];
     packages = with pkgs; [];
    };
    qq = {
      isNormalUser = true;
      description = "qq";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbEQFPmEQvJkymdUXyAzrvaRvNER66lbtuyM9f/3b+7 1308632188@qq.com"
      ];
      extraGroups = [ "networkmanager" ];
      packages = with pkgs; [];
    };
    angel = {
      isNormalUser = true;
      description = "angel";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbEQFPmEQvJkymdUXyAzrvaRvNER66lbtuyM9f/3b+7 1308632188@qq.com"
      ];
      extraGroups = [ "networkmanager" ];
      packages = with pkgs; [];
    };
    jackson = {
      isNormalUser = true;
      description = "jackson";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbEQFPmEQvJkymdUXyAzrvaRvNER66lbtuyM9f/3b+7 1308632188@qq.com"
      ];
      extraGroups = [ "networkmanager" ];
      packages = with pkgs; [];
    };
    yjl = {
      isNormalUser = true;
      description = "yjl";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbEQFPmEQvJkymdUXyAzrvaRvNER66lbtuyM9f/3b+7 1308632188@qq.com"
      ];
      extraGroups = [ "networkmanager" ];
      packages = with pkgs; [];
    };
    wan = {
      isNormalUser = true;
      description = "wan";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbEQFPmEQvJkymdUXyAzrvaRvNER66lbtuyM9f/3b+7 1308632188@qq.com"
      ];
      extraGroups = [ "networkmanager" ];
      packages = with pkgs; [];
    };
  };


  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Allow podman for toolbox
  virtualisation = {
    podman = {
      enable = true;
    };
  };

  # See https://github.com/nix-community/nix-doom-emacs/blob/master/docs/reference.md#home-manager
  services.emacs = {
    enable = true;
    package = doom-emacs;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #chezmoi
    #libgccjit
    #lshw
    mysql
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
    moonlight-qt
    neovim
    nodejs
    oxygenfonts
    pandoc
    pciutils
    powertop
    qutebrowser
    ranger
    readline
    remmina
    ripgrep
    rofi
    rofimoji
    rstudio
    shutter
    steam
    stow
    sunshine
    texlive.combined.scheme-full
    tmux
    toolbox
    unzip
    vscode
    wget
    x2goclient
    xclip
    xf86_input_wacom
    xorg.libX11
    xorg.libX11.dev
    xorg.xauth
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
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Sunshine config.
  #security.wrappers.sunshine = {
  #  owner = "root";
  #  group = "root";
  #  capabilities = "cap_sys_admin+p";
  #  source = "${pkgs.sunshine}/bin/sunshine";
  #};
  # Allow access to create virtual input interfaces.
  #services.udev.packages = [ pkgs.sunshine  ]; 

  services.xrdp = {
    enable = true;
    openFirewall = true;
    #defaultWindowManager = "startplasma-x11";
    defaultWindowManager = "${pkgs.i3-gaps}/bin/i3";
    # Need to update to nixos-24.05
    #extraConfDirCommands = ''
    #  substituteInPlace $out/xrdp.ini \
    #    --replace port=-1 port=ask-1 \
    #'';
  };

  # Needed for network discovery
  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      #PasswordAuthentication = false;
      X11Forwarding = true;
      PermitRootLogin = "no";
    };
  };

  # Open ports in the firewall.
  # Or disable the firewall altogether.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 3389 47984 47989 47990 48010 ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; }
      { from = 8000; to = 8010; }
    ];
  };

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
