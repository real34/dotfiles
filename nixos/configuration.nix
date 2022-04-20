# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/nvme0n1"; # or "nodev" for efi only
  # Perso only ? (and comment grub.enable / version above)
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.cleanTmpDir = true;

  networking.hostName = "pierre"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Gnome is forcing us to use networkManager https://nixos.org/nixos/manual/index.html#sec-networkmanager
  networking.extraHosts = "
";


  hardware.bluetooth.enable = true;
  # see https://nixos.wiki/wiki/Bluetooth#Enabling_A2DP_Sink
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      MultiProfile = "multiple";
      AutoEnable = true;
    };
  };

  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;
  hardware.trackpoint.speed = 250;
  hardware.trackpoint.sensitivity = 150;

  # Select internationalisation properties.
  console.keyMap = "fr-bepo";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    thunderbolt
    wpa_supplicant
    #wpa_supplicant_gui
    gitAndTools.gitFull
    docker
    firefox
    unbound

    # Yubikey
    libu2f-host
    yubikey-manager
    yubikey-personalization-gui
    pcsclite

    # Sound
    blueman
    pulseaudio-modules-bt
    bluez-tools
  ];

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Specific configuration
  environment.pathsToLink = [ "/share/zsh" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.zsh.enable = true; # see https://github.com/NixOS/nixpkgs/issues/20548#issuecomment-261965667
  programs.light.enable = true;

  # List services that you want to enable:
  services.nscd.enable = true;
  services.tlp.enable = true;
  services.upower.enable = true; # keyboard backlight
  services.gnome.at-spi2-core.enable = true; # see https://github.com/NixOS/nixpkgs/pull/49636/files
  services.gnome.gnome-keyring.enable = true; # see https://nixos.wiki/wiki/Visual_Studio_Code#Error_after_Sign_On
  services.blueman.enable = true;

  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

  # see https://github.com/NixOS/nixpkgs/blob/2380f6a4faa57c6b91fed26c496e1c8ca5d91982/nixos/modules/services/networking/iunbound.nix#L52
  # services.unbound = {
  #   enable = true;
  #   settings = {
  #     # cache-max-negative-ttl = "0";
  #     local-zone = "test. redirect";
  #     local-data = [
  #       "test. 10800 IN NS localhost."
  #       "test. 10800 IN SOA test. nobody.invalid. 1 3600 1200 604800 10800"
  #       "test. 10800 IN A 172.10.0.10"
  #     ];
  #   };
  # };
  virtualisation.docker.enable = true;

  # Doc: https://nixos.org/manual/nixos/stable/index.html#sec-firewall
  networking.firewall.enable = true;

  # Enable CUPS to print documents.
  nixpkgs.config.allowUnfree = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip pkgs.gutenprint pkgs.cnijfilter_4_00 pkgs.cnijfilter2];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;

    # see https://nixos.wiki/wiki/Bluetooth#Managing_audio_devices
    extraConfig = "
      load-module module-switch-on-connect
    ";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "fr";
  services.xserver.xkbVariant = "bepo";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.videoDriver = "modesetting"; # to prevent "xrandr: Configure crtc 1 failed" issues
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.windowManager.i3.enable = true;

  # See https://nixos.wiki/wiki/Yubikey
  services.udev.packages = [ pkgs.yubikey-personalization pkgs.libu2f-host ];
  services.pcscd.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pierre = {
     isNormalUser = true;
     uid = 1000;
     home = "/home/pierre";
     shell = pkgs.zsh;
     extraGroups = [ "audio" "wheel" "networkmanager" "docker" "video" ];
  };

  system.autoUpgrade.enable = true;
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
