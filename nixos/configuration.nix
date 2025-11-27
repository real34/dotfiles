# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./framework.nix
    <home-manager/nixos>
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.tmp.cleanOnBoot = true;

  # Networking
  networking.hostName = "pierre"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.extraHosts = "";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "fr";
      variant = "bepo";
    };

    windowManager = { i3 = { enable = true; }; };
  };
  services.displayManager = { defaultSession = "none+i3"; };

  # Configure console keymap
  console.keyMap = "fr";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pierre = {
    isNormalUser = true;
    description = "Pierre";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" "video" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };
  home-manager.users.pierre = import /home/pierre/dotfiles/home.nix;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    thunderbolt

    # Basics
    docker
    gitFull
    vim

    # Sound
    blueman
    bluez-tools

    # VPN - see https://www.wireguard.com/install/
    wireguard-tools
  ];
  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.zsh.enable =
    true; # see https://github.com/NixOS/nixpkgs/issues/20548#issuecomment-261965667
  programs.light.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ fnm stdenv.cc.cc.lib ];
  };

  # List services that you want to enable:
  services.nscd.enable = true;
  services.tlp.enable = true;
  services.upower.enable = true; # keyboard backlight
  services.gnome.at-spi2-core.enable =
    true; # see https://github.com/NixOS/nixpkgs/pull/49636/files
  services.gnome.gnome-keyring.enable =
    true; # see https://nixos.wiki/wiki/Visual_Studio_Code#Error_after_Sign_On
  services.blueman.enable = true;
  services.udisks2.enable = true;
  services.resolved.enable = true;
  services.gvfs.enable =
    true; # to view MTP devices in file manager - https://www.perplexity.ai/search/how-to-browse-files-from-bus-0-QWBoYG1gRLu3uMRqFSzw9A

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # Ports: 9003 - Xdebug
  networking.firewall.allowedTCPPorts = [ 9003 ];
  networking.firewall.allowedUDPPorts = [ 9003 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # https://github.com/nix-community/nix-direnv/
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
