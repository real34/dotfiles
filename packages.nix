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
    #httpie # TMP: broken (2022-12-19) - see https://github.com/NixOS/nixpkgs/pull/207035
    hurl
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
    bluez # was bluezFull before 27th september 2022

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
    git-filter-repo
    meld
    glab
    sapling

    firefox
    google-chrome-beta
    epiphany
    thunderbird
    ferdium
    slack
    signal-desktop
    zoom-us
    libreoffice
    freemind
    filezilla
    vokoscreen
    asciinema
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
    zettlr # TMP: broken (2022-12-19) - patched with clisp overlay

    unclutter-xfixes
    playerctl
    numlockx

    nixpkgs-fmt
    nodejs-18_x
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
    python3
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
