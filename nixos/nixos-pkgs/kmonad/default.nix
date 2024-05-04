{ pkgs, username, ... }:

let
  kmonad = (import ../../pkgs/kmonad/derivation.nix) pkgs;
in
{
  environment.systemPackages = with pkgs; [
    kmonad
  ];

  users.groups = { uinput = {}; };

  services.udev.extraRules =
    ''
      # KMonad user access to /dev/uinput
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';

  #services.kmonad = {
  #  enable = true;
  #  configfiles = [ ../../pkgs/kmonad/config/laptop.kbd ];
  #  package = kmonad;
  #};

  services.xserver = {
    xkbOptions = "compose:ralt";
    layout = "us";
  };

  users.extraUsers.${username} = {
    extraGroups = [ "input" "uinput" ];
  };
}
