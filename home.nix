{ pkgs, ... }:

let
  latest = import <nixpkgs>{};
in
{
  home.stateVersion = "22.05";

  home.file.".i3status.conf".source = ./files/.i3status.conf;
  home.file.".config/traefik/traefik.toml".source = ./files/traefik.toml;

  home.packages = with pkgs; [
    latest.wget
    latest.curl
    latest.httpie
    latest.bind
    latest.gcc
    latest.openssl.dev
    latest.patchelf
    latest.postman
    latest.k6
    latest.hey
    latest.ngrok
    latest.openssl

    latest.pavucontrol
    latest.bluezFull

    latest.sakura
    latest.fasd
    latest.ripgrep
    latest.tree
    latest.ncdu
    latest.pv
    latest.jq
      latest.yq
      latest.fx
    latest.whois
    latest.gnumake
    latest.file
    latest.bc
    latest.ts
    latest.mcfly
    latest.fzf
    latest.bat
      latest.bat-extras.prettybat
    latest.delta

    latest.atool
    latest.unzip
    latest.zip

    latest.pass
    latest.lastpass-cli
    latest.bitwarden-cli
    latest._1password
    latest._1password-gui
    latest.yubico-pam
    latest.yubikey-manager
    latest.pam_u2f

    latest.arandr
    latest.feh
    latest.pcmanfm
    latest.udiskie
    latest.tldr

    latest.gitAndTools.tig
    latest.sublime-merge
    latest.meld
    latest.glab

    latest.firefox
    latest.google-chrome-beta
      latest.epiphany
    latest.thunderbird
    latest.slack
    latest.signal-desktop
    latest.zoom-us
    latest.libreoffice
    latest.freemind
    latest.filezilla
    latest.vokoscreen
    latest.ffmpeg
    latest.flameshot
    latest.gimp
    latest.copyq
    latest.wireshark
    latest.gcalcli

    latest.spotify
    latest.vlc
    latest.audacity
    latest.obs-studio
    latest.shotcut

    latest.jetbrains-mono
    latest.vscode

    unclutter-xfixes
    latest.playerctl latest.numlockx

    latest.nodejs-16_x
      latest.cypress
    latest.docker
    latest.docker-compose
      latest.kube3d
      latest.kubectl
      latest.kubernetes-helm
      latest.stern

    latest.php
    latest.php81Packages.composer
    latest.python
    latest.mkcert
    latest.goaccess

    latest.checkbashisms
    latest.shellcheck

    # Perso
    latest.nextcloud-client
    latest.rclone
#    latest.calibre
    latest.gparted
  ];

  programs.vscode = {
    enable = true;
    extensions = [];
  };

  services.unclutter.enable = true;
  services.gpg-agent.enable = true;
  services.blueman-applet.enable = true;

  programs.rofi = {
    enable = true;
    plugins = [ latest.rofi-calc latest.rofi-emoji ];
    terminal = "sakura";
  };

  xsession.windowManager.i3 = let
    modifier = "Mod4";
  in {
    enable = true;
    config = {
      assigns = {
        # https://rycee.gitlab.io/home-manager/options.html#opt-xsession.windowManager.i3.config.assigns
      };
      focus = {
        mouseWarping = false; # Whether mouse cursor should be warped to the center of the window when switching focus to a window on a different output.
      };

      modifier = modifier;

      # see https://rycee.gitlab.io/home-manager/options.html#opt-xsession.windowManager.i3.config.keybindings
      keybindings = pkgs.lib.mkOptionDefault {
          "${modifier}+Return" = "exec sakura"; #i3-sensible-terminal

          ### BÉPO ###
          "${modifier}+b" = "kill";
          "${modifier}+d" = "exec rofi -combi-modi 'window#run#ssh#emoji#calc'  -modi 'calc#combi' -show combi";
          "${modifier}+e" = "fullscreen toggle";
          # change container layout (stacked, tabbed, toggle split)
          "${modifier}+u" = "layout stacking";
          "${modifier}+eacute" = "layout tabbed";
          "${modifier}+p" = "layout toggle split";
          "${modifier}+Shift+t" = "i3lock --colour=000000";
          # switch to workspace
          "${modifier}+quotedbl" = "workspace 1";
          "${modifier}+guillemotleft" = "workspace 2";
          "${modifier}+guillemotright" = "workspace 3";
          "${modifier}+parenleft" = "workspace 4";
          "${modifier}+parenright" = "workspace 5";
          "${modifier}+at" = "workspace 6";
          "${modifier}+plus" = "workspace 7";
          "${modifier}+minus" = "workspace 8";
          "${modifier}+slash" = "workspace 9";
          "${modifier}+asterisk" = "workspace 10";
          # move workspaces between outputs
          "${modifier}+Control+Left" = "move workspace to output left";
          "${modifier}+Control+Right" = "move workspace to output right";
          "${modifier}+Control+Up" = "move workspace to output up";
          "${modifier}+Control+Down" = "move workspace to output down";
          # move focused container to workspace
          "${modifier}+Shift+quotedbl" = "move container to workspace 1";
          "${modifier}+Shift+guillemotleft" = "move container to workspace 2";
          "${modifier}+Shift+guillemotright" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+at" = "move container to workspace 6";
          "${modifier}+Shift+plus" = "move container to workspace 7";
          "${modifier}+Shift+minus" = "move container to workspace 8";
          "${modifier}+Shift+slash" = "move container to workspace 9";
          "${modifier}+Shift+asterisk" = "move container to workspace 10";
          ### /BÉPO ###

          # See https://faq.i3wm.org/question/3747/enabling-multimedia-keys.1.html
          # Pulse Audio controls
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 0 +5%"; #increase sound volume
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 0 -5%"; #decrease sound volume
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle"; # mute sound

          # Media player controls
          "XF86AudioPlay" = "exec playerctl play";
          "XF86AudioPause" = "exec playerctl pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";

          # Sreen brightness controls
          "XF86MonBrightnessUp" = "exec light -A 2"; # increase screen brightness
          "XF86MonBrightnessDown" = "exec light -U 2"; # decrease screen brightness
        };

      startup = [
        { command = "nextcloud"; notification = false; }
        { command = "setxkbmap -layout fr -variant bepo"; notification = false; }
        { command = "udiskie"; notification = false; }
        { command = "copyq"; notification = false; }
        { command = "numlockx on"; notification = false; } # turn verr num on

        { command = "autorandr -c"; notification = false; }
        { command = "feh --bg-scale /home/pierre/Documents/Graphisme/fc-bg-light-black.png"; notification = false; }

        # docker run -d --net traefik --ip 172.10.0.10 --restart always -v /var/run/docker.sock:/var/run/docker.sock:ro --name traefik -p 80:80 -p 8080:8080 traefik:2.4.9 --api.insecure=true --providers.docker
        { command = "docker start traefik"; notification = false; }
      ];
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history = {
      ignoreDups = true;
      save = 100000000000;
      size = 100000000000;
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "docker"
        "fasd"
        "git"
        "httpie"
        "last-working-dir"
        "pass"
        "ssh-agent"
      ];
      extraConfig = ''
        zstyle :omz:plugins:ssh-agent lazy yes
      '';
    };

    # `$` must be escaped with `''` :metal:
    # source: https://nixos.org/nix-dev/2015-December/019018.html
    initExtra = ''
      bindkey ' ' forward-word
      zstyle ':completion:*:hosts' hosts ''${=''${''${''${''${(@M)''${(f)"''$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
      setopt PROMPT_CR
      setopt PROMPT_SP

m2wipe() {
  echo "Pouf pouf pouf…"
  sudo rm -rf $1/generated $1/var/cache/**/* $1/pub/static/* $1/var/page_cache $1/var/view_preprocessed
  mkdir $1/generated
  sudo chmod -R 777 $1/{var,pub,generated,app/etc}
  echo "… tchak !"
}

dcrefresh() {
	dc stop -t0 $1 && dc rm -vf $1 && dc up -d $1
}

akamai() {
  # see https://gist.github.com/saml/4758360
  curl -v -s -H "Pragma: akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-ser"  "$1" 2>&1 > /dev/null
}

unalias v

# see https://github.com/cantino/mcfly
export MCFLY_FUZZY=true
eval "$(mcfly init zsh)"

eval "$(op completion zsh)"; compdef _op op

eval "$(glab completion -s zsh)"

# K8s
source <(helm completion zsh)
source <(k3d completion zsh)
source <(kubectl completion zsh)
'';

    sessionVariables = {
      EDITOR = "vim";
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=7";
      TERMINAL = "sakura";
      PATH = "$PATH:$HOME/.npm/bin";
    };

    shellAliases = {
      a = "fasd -a";        # any
      s = "fasd -si";       # show / search / select
      d = "fasd -d";        # directory
      f = "fasd -f";        # file
      sd = "fasd -sid";     # interactive directory selection
      sf = "fasd -sif";     # interactive file selection
      z = "fasd_cd -d";     # cd, same functionality as j in autojump
      j = "fasd_cd -d";     # cd, same functionality as j in autojump
      zz = "fasd_cd -d -i"; # cd with interactive selection

      dc = "docker-compose";
      dcr = "docker-compose run --rm";
      dcrm = "docker-compose rm -fsv";
      copy = "xclip -selection c";

      bepo = "setxkbmap -layout fr -variant bepo";
      fr = "setxkbmap -layout fr -variant oss";

      m = "make";
      t = "task";
      p = "~/.platformsh/bin/platform";
      k = "kubectl --context build";
      kp = "kubectl --context prod.eu1";
      kp2 = "kubectl --context prod-eu2";
      flyctl = "~/.fly/bin/flyctl";
      g = "git";
      tg = "tig --all";
      tgs = "tig status";
    };
  };

  programs.git = {
    enable = true;
    package = latest.gitAndTools.gitFull;

    userEmail = "pierre@front-commerce.com";
    userName = "Pierre Martin";

    aliases = {
      co = "checkout";
      mr = "!sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";
    };

    ignores = [
      ".DS_Store"
      ".svn"
      "*~"
      "*.swp"
      "*.rbc"
      ".watsonrc"
      ".idea"
      ".vscode"
    ];

    extraConfig = {
      # see https://github.com/dandavison/delta#get-started
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";

      merge.tool = "meld";
      diff.algorithm = "patience";
      pull.ff = "only";
      credential.helper = "store";
      init.defaultBranch = "main";

      # see https://betterprogramming.pub/8-advanced-git-commands-university-wont-teach-you-fe63b483d34b
      help.autocorrect = 1;
      fetch.prune = true;
      push.autoSetupRemote = true;
    };
  };

  programs.htop = {
    enable = true;
  };

  programs.vim = {
    enable = true;
  };

  programs.autorandr = {
    enable = true;
    hooks = {
      postswitch = {
        "notify-i3" = "${pkgs.i3}/bin/i3-msg restart";
      };
    };
  };
}
