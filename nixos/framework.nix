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
    "i915.enable_psr=0" # https://community.frame.work/t/periodic-stuttering-on-fresh-gnome-40-wayland-install-on-arch-linux/3912/6
    "layout=bls" # Read $KERNEL_INSTALL_LAYOUT from /etc/machine-info. Please move it to the layout= setting of /etc/kernel/install.conf.
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # prevent "/boot/efi No space left on device" errors - see https://github.com/NixOS/nixpkgs/issues/23926
  boot.loader.grub.configurationLimit = 10;

  powerManagement = {
    enable = true;

    # TODO tweak it a bit better? https://github.com/fenrus75/powertopw
    # Alternative https://github.com/ebzzry/dotfiles/blob/main/nixos/configuration.nix#L365
    # Deactivated to try to disable USB autosuspend.
    # See https://community.frame.work/t/bluetooth-mouse-lag/12933 or https://community.frame.work/t/bluetooth-keyboard-delay/6387
    powertop.enable = false;

    # TODO Not sure what it does: the default detection uses "powersave"
    # cpuFreqGovernor = lib.mkDefault "ondemand";
  };

  hardware.bluetooth.enable = true;

  # Enable thermal data
  services.thermald.enable = true;

  # Enable fingerprint support
  # see https://wiki.archlinux.org/title/fprint for usage
  services.fprintd.enable = true;

  # Display things like a boss
  ## Make it work
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    mesa
    intel-vaapi-driver # used to be vaapiIntel
    libva-vdpau-driver # used to be vaapiVdpau
    intel-media-driver
  ];
  ## Make it nice (https://nixos.wiki/wiki/Xorg && https://wiki.archlinux.org/title/Framework_Laptop#HiDPI_settings)
  # https://github.com/kvark/dotfiles/blob/master/nix/hardware-configuration.nix#L41

  # - The option definition `hardware.video.hidpi.enable' in `/etc/nixos/framework.nix' no longer has any effect; please remove it.
  # Consider manually configuring fonts.fontconfig according to personal preference.
  # hardware.video.hidpi.enable = lib.mkDefault true;
  services.xserver.dpi = 130;

  environment.variables = {
    GDK_SCALE = "1.3";
    GDK_DPI_SCALE = "0.77"; # 1/1.3
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.3";
  };

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
  services.libinput.enable = true;

  # Backlight (see https://wiki.archlinux.org/title/Backlight#xbacklight_returns_:_No_outputs_have_backlight_property)
  hardware.acpilight.enable = true;
}
