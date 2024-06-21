{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "1password"
    "1password-cli"

    "ngrok"
    "postman"
    "vscode"
    "code"

    "vivaldi"
    "google-chrome"
    "slack"
    "spotify"
    "spotify-unwrapped"
    "zoom"

    "ticktick"
  ];

  home.packages = with pkgs; [
    wget
    curl
    httpie
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
    tz
    mcfly
    fzf
    bat
    bat-extras.prettybat

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

    git-filter-repo
    gh
    meld
    difftastic

    firefox
    vivaldi
    google-chrome
    epiphany
    offpunk
    lagrange
    thunderbird
    slack
    signal-desktop
    tdesktop
    zoom-us
    libreoffice
    freemind
    filezilla
    vokoscreen-ng
    ffmpeg
    flameshot
    gimp
    copyq
    wireshark
    gcalcli

    spotify
    spotdl
    vlc
    audacity
    obs-studio
    shotcut

    jetbrains-mono
    vscode.fhs

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
    k9s
    krew

    php
    php81Packages.composer
    python3
    mkcert
    goaccess
    grafana-loki # logcli

    checkbashisms
    shellcheck

    # Perso
    nextcloud-client
    rclone
    #    calibre
    gparted
    ticktick
  ];
}
