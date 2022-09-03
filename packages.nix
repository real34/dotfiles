{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "1password"
    "1password-cli"

    "ngrok"
    "postman"
    "vscode"

    "google-chrome-beta"
    "slack"
    "spotify"
    "spotify-unwrapped"
    "zoom"
  ];

  home.packages = with pkgs; [
    wget
    curl
    httpie
    bind
    gcc
    openssl.dev
    patchelf
    postman
    k6
    hey
    ngrok
    openssl

    pulseaudioFull
    pavucontrol
    bluezFull

    sakura
    fasd
    ripgrep
    tree
    ncdu
    pv
    jq
    yq
    fx
    whois
    gnumake
    file
    bc
    ts
    mcfly
    fzf
    bat
    bat-extras.prettybat
    delta

    atool
    unzip
    zip

    pass
    lastpass-cli
    bitwarden-cli
    _1password
    _1password-gui
    yubico-pam
    yubikey-manager
    pam_u2f
    polkit_gnome # fun fact: https://gitlab.gnome.org/GNOME/gdm/-/issues/613

    arandr
    feh
    pcmanfm
    udiskie
    tldr

    gitAndTools.tig
    meld
    glab

    firefox
    google-chrome-beta
    epiphany
    thunderbird
    slack
    signal-desktop
    zoom-us
    libreoffice
    freemind
    filezilla
    vokoscreen
    ffmpeg
    flameshot
    gimp
    copyq
    wireshark
    gcalcli

    spotify
    vlc
    audacity
    obs-studio
    shotcut

    jetbrains-mono
    vscode

    unclutter-xfixes
    playerctl
    numlockx

    nodejs-16_x
    cypress
    docker
    docker-compose
    kube3d
    kubectl
    kubernetes-helm
    stern

    php
    php81Packages.composer
    python
    mkcert
    goaccess

    checkbashisms
    shellcheck

    # Perso
    nextcloud-client
    rclone
    #    calibre
    gparted
  ];
}