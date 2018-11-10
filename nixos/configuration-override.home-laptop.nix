{ pkgs, ... }:

{
  i18n = {
    consoleKeyMap = "fr";
  };

  users.users.celine = {
     isNormalUser = true;
     home = "/home/celine";
     shell = pkgs.zsh;
     extraGroups = [ "audio" "wheel" "networkmanager" ];
  };

  services.xserver.desktopManager.gnome3.enable = true;
}