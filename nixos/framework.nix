#
# NixOS Configuration for Framework Laptop
# Source: https://gist.github.com/digitalknk/ee0379c1cd4597463c31a323ea5882a5
# Alt: https://github.com/NixOS/nixos-hardware/blob/master/framework/default.nix
# Alt: https://github.com/DAlperin/dotfiles/blob/main/machines/spaceship/default.nix
# Doc: https://wiki.archlinux.org/title/Framework_Laptop
#

{ config, lib, pkgs, modulesPath, ... }:

{
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "nvme.noacpi=1" # power consumption. See https://github.com/NixOS/nixos-hardware/blob/12620020f76b1b5d2b0e6fbbda831ed4f5fe56e1/framework/default.nix#L12
    "module_blacklist=hid_sensor_hub" # brightness keys. See https://dov.dev/blog/nixos-on-the-framework-12th-gen
  ];

  # TODO Understand why it is needed and uncomment it!
  # boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_latest.override {
  #   argsOverride = rec {
  #     src = pkgs.fetchurl {
  #       url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
  #       sha256 = "1j0lnrsj5y2bsmmym8pjc5wk4wb11y336zr9gad1nmxcr0rwvz9j";
  #     };
  #     version = "5.15.1";
  #     modDirVersion = "5.15.1";
  #   };
  # });

  powerManagement = {
    enable = true;
    powertop.enable = true;
    # TODO Not sure what it does: the default detection uses "powersave"
    # cpuFreqGovernor = lib.mkDefault "ondemand";
  };

  hardware.bluetooth.enable = true;

  # Enable thermal data
  services.thermald.enable = true;

  # TODO Enable fingerprint support
  # services.fprintd.enable = true;

  # TODO make second screen work!! ¯\_(ツ)_/¯
  # $ nix-shell -p glxinfo --run glxinfo | egrep "OpenGL vendor|OpenGL renderer"
  # OpenGL vendor string: Mesa/X.org
  # OpenGL renderer string: llvmpipe (LLVM 13.0.1, 256 bits)
  hardware.video.hidpi.enable = lib.mkDefault true; # https://github.com/kvark/dotfiles/blob/master/nix/hardware-configuration.nix#L41
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    mesa_drivers
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  # Bring in some audio
  security.rtkit.enable = true; # rtkit is optional but recommended
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Backlight (see https://wiki.archlinux.org/title/Backlight#xbacklight_returns_:_No_outputs_have_backlight_property)
  hardware.acpilight.enable = true;
}