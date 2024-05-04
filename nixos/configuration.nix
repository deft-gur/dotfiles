# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, ... }:

let
in {
  nix.settings.trusted-users = [ "root" "${username}" ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nixos-pkgs/kmonad/default.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

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

  # Change behaviour of Lid close.
  # For MSI GS65 after suspending it will go into air plane mode which blocks
  # the wireless wlan at hardware level.
  # So either we don't goto suspend mode or we disable airplane mode. But
  # airplane mode doesn't have any actions (There is a post that fixes this but
  # it requires to change grub configuration file).
  services.logind.lidSwitch = "ignore";

  # Enable bluetooth
  hardware.bluetooth.enable = true;
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

  # CPU Power management.
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

  # Tell Xorg to use nvidia driver and intel driver. So both external and laptop screens work.
  #services.xserver.videoDrivers = [ "nvidia" "intel"];
  services.xserver.videoDrivers = [  "intel" ];
  #services.xserver.videoDrivers = [ "nvidia" ];

  # Add a specialisation for booting with gpu.
  specialisation = {
    nvidia.configuration = {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.opengl.enable = true;
      hardware.nvidia = {
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
        open = true;
        prime = {
          sync.enable = true;
          # Can be found by lspci.
          nvidiaBusId = "PCI:1:0:0";
          intelBusId = "PCI:0:2:0";
        };
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
    discord
    dolphin
    fd
    feh
    firefox
    gfortran
    git
    gnome.nautilus
    gnumake
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
    python3
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
    xorg.xf86videointel
    xorg.xorgserver
    xournalpp
    zathura
    zip
    zlib
    zsh
  ];

  fonts.fonts = with pkgs; [
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
  system.stateVersion = "22.11"; # Did you read the comment?

  # Enable flake.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
