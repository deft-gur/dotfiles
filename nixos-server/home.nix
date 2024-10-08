{ config, pkgs, ... }:

let
  gruvboxPlus = import ./gruvbox-plus.nix { inherit pkgs; };
in
{
  # Don't let home manager manager keyboard.
  home.keyboard = null;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ziwen";
  home.homeDirectory = "/home/ziwen";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.direnv
    pkgs.mpv
    pkgs.nixd
    pkgs.obs-studio
    pkgs.openvpn
    pkgs.screenkey
    pkgs.typst
    pkgs.vesktop
    pkgs.you-get
    pkgs.yt-dlp
    (import ./python-packages.nix { inherit pkgs; })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ziwen/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
    };
    defaultApplications = {
      "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
    };
  };

  # Zsh:
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
    };

    initExtraFirst = ''
      [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
      eval "$(direnv hook zsh)"
    '';

    envExtra = ''
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    '';
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "jeffreytse/zsh-vi-mode"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      ];
    };
  };

  # Theme:
  #qt.enable = true;

  ## platform theme "gtk" or "gnome"
  #qt.platformTheme = "gtk";

  ## name of the qt theme
  #qt.style.name = "adwaita-dark";

  ## detected automatically:
  ## adwaita, adwaita-dark, adwaita-highcontrast,
  ## adwaita-highcontrastinverse, breeze,
  ## bb10bright, bb10dark, cde, cleanlooks,
  ## gtk2, motif, plastique

  ## package to use
  #qt.style.package = pkgs.adwaita-qt;

  gtk.enable = true;

  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Ice";

  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3";

  gtk.iconTheme.package = gruvboxPlus;
  gtk.iconTheme.name = "GruvboxPlus";
  # Theme END
}
