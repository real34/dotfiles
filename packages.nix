{ pkgs, lib, ... }:

let
  atomicptr = import (fetchTarball
    "https://github.com/atomicptr/nix/archive/refs/heads/master.tar.gz") { };
in {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"

      "ngrok"
      "postman"
      "vscode"
      "code"

      "google-chrome"
      "slack"
      "spotify"
      "spotify-unwrapped"

      "ticktick"
    ];

  home.packages = with pkgs; [
    wget
    curl
    httpie
    hurl # TODO 2025-08-28 Compilation error: error: function pointer comparisons do not produce meaningful results since their addresses are not guaranteed to be unique
    bind
    gcc
    openssl.dev
    patchelf
    postman
    k6
    hey
    ngrok
    openssl
    atomicptr.crab

    pulseaudioFull
    pavucontrol
    bluez # was bluezFull before 27th september 2022

    # see https://discourse.nixos.org/t/error-nose-1-3-7-not-supported-for-interpreter-python3-12/48703
    # solaar # bluetooth unifying devices and receiver

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
    xsel
    trippy
    monolith # save a web page as a single file
    killport

    atool
    unzip
    zip

    _1password-cli
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
    glab

    firefox
    google-chrome
    offpunk
    lagrange
    thunderbird
    slack
    mattermost-desktop
    signal-desktop
    libreoffice
    freemind
    filezilla
    vokoscreen-ng
    ffmpeg
    ksnip
    gimp
    copyq
    wireshark
    gcalcli
    zed-editor
    kdePackages.kcachegrind

    spotify
    # spotdl see https://discourse.nixos.org/t/error-nose-1-3-7-not-supported-for-interpreter-python3-12/48703
    vlc

    jetbrains-mono
    vscode.fhs

    unclutter-xfixes
    playerctl
    numlockx

    nixfmt-classic
    nodejs_22
    fnm
    bun
    cypress
    docker
    docker-compose
    k3d
    kubectl
    kubernetes-helm
    stern
    k9s
    krew

    php
    php84Packages.composer
    mariadb
    adminer
    python312
    python312Packages.pip
    python312Packages.uv
    # pipx # for global python packages (aider-chat, fabric, etc.)
    twine
    # uv
    # conda
    mkcert
    goaccess
    grafana-loki # logcli

    checkbashisms
    shellcheck
    shfmt
    toilet

    # AI
    ollama
    whisper-cpp # STT local
    alsa-utils # arecord pour l'enregistrement
    xdotool # pour taper le texte transcrit
    libnotify # notifications

    # Perso
    nextcloud-client
    rclone
    # calibre
    gparted
    ticktick
    agate
    beancount

    ## TODO: fix fava
    # Checking runtime dependencies for fava-1.29-py3-none-any.whl
    # copying path '/nix/store/yxd2da4vc9gi5jbs1nlvwpsmwj308bp1-kdoctools-6.10.0' from 'https://cache.nixos.org'...
    #   - beancount<3,>=2.3.5 not satisfied by version 3.0.0
    # copying path '/nix/store/a8n27li3n2fy8jfdm99v9j3yn6w3yk5y-kguiaddons-6.10.0' from 'https://cache.nixos.org'...
    # error: builder for '/nix/store/2xd25ssas4yliykz4y4n8p6h762wcalm-fava-1.29.drv' failed with exit code 1
    # fava
  ];
}
