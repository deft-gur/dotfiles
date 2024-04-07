# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  compiledLayout = pkgs.runCommand "keyboard-layout" {} ''
    ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${/home/ziwen/layout.xkb} $out
  '';
in {
  nix.settings.trusted-users = [ "root" "ziwen" ];
  
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
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
      # Use xkbcomp to swap esc and caps lock.
      sessionCommands = "${pkgs.xorg.xkbcomp}/bin/xkbcomp ${compiledLayout} $DISPLAY";
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

  # TODO: Right now if we specify both "nvidia" and "intel" then we can use graphic cards only on primary display. If we only specify "nvidia" then we can only use external display.
  # Tell Xorg to use nvidia driver and intel driver. So both external and laptop screens work.
  #services.xserver.videoDrivers = [ "nvidia" "intel"];
  #services.xserver.videoDrivers = [  "intel"];
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = true;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ziwen = {
    isNormalUser = true;
    description = "Ziwen Wang";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
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
    #libgccjit
    R
    alacritty
    autoconf
    abiword
    automake
    bashmount
    breeze-icons
    #chezmoi
    chromium
    clang
    direnv
    discord
    dolphin
    fd
    firefox
    gfortran
    git
    gnumake
    hunspell
    imagemagick
    jdk8
    kitty
    libxml2
    libxml2.dev
    libxslt
    libreoffice-qt
    #lshw
    neovim
    oxygenfonts
    pandoc
    python3
    qutebrowser
    readline
    ripgrep
    rstudio
    shutter
    stow
    unzip
    texlive.combined.scheme-full
    toolbox
    wget
    xclip
    xf86_input_wacom
    xorg.libX11
    xorg.libX11.dev
    xorg.xf86inputevdev
    xorg.xf86inputsynaptics
    xorg.xf86videointel
    xorg.xkbcomp
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

}
