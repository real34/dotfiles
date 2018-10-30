{ pkgs, ... }:

let
  latest = import <nixpkgs>{};
in
{
  home.packages = with pkgs; [
    latest.wget
    latest.curl
    latest.httpie

    latest.fasd
    latest.ripgrep
    latest.tree
    latest.ncdu
    latest.pv
    latest.jq
    latest.whois
    latest.gnumake
    latest.file

    latest.atool
    latest.unzip
    latest.zip
    latest.p7zip

    latest.pass

    latest.pcmanfm
    latest.udiskie

    latest.gitAndTools.gitflow
    latest.gitAndTools.tig

    firefox
    google-chrome-beta
    latest.thunderbird
    latest.rambox
    latest.libreoffice
    latest.freemind
    latest.filezilla
    latest.shutter
    latest.gimp
    latest.skypeforlinux
    latest.zoom-us

    latest.google-play-music-desktop-player
    latest.vlc

    latest.vscode
    latest.jetbrains.phpstorm
    latest.zeal
    latest.apache-directory-studio

    unclutter-xfixes
    latest.playerctl latest.numlockx

    python
    latest.docker
    latest.docker_compose

    # Peek. See https://github.com/NixOS/nixpkgs/issues/39832
    peek
      ffmpeg
      glib
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      keybinder

    # urxvt. See https://github.com/rycee/home-manager/blob/master/modules/programs/urxvt.nix
    latest.rxvt_unicode-with-plugins
  ];

  # Doc: https://rycee.gitlab.io/home-manager/options.html

  services.unclutter.enable = true;
  services.parcellite.enable = true;
  services.gpg-agent.enable = true;

  programs.home-manager = {
    enable = true;
    path = https://github.com/rycee/home-manager/archive/release-18.03.tar.gz;
  };

  ## TODO Enable when available in this current branch of
  ## Home manager, or switch to master
  # programs.urxvt = {
  #   enable = true;
  #   package = latest.rxvt_unicode-with-plugins;
  # };

  # TODO polybar
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
          "${modifier}+Return" = "exec urxvtc";

          # See https://faq.i3wm.org/question/3747/enabling-multimedia-keys.1.html
          # Pulse Audio controls
          # bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume 0 +5% #increase sound volume
          # bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume 0 -5% #decrease sound volume
          # bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute 0 toggle # mute sound

          # Sreen brightness controls
          # bindsym XF86MonBrightnessUp exec light -A 2 # increase screen brightness
          # bindsym XF86MonBrightnessDown exec light -U 2 # decrease screen brightness

          # Touchpad controls
          # bindsym XF86TouchpadToggle exec /some/path/toggletouchpad.sh # toggle touchpad

          # Media player controls
          # bindsym XF86AudioPlay exec playerctl play
          # bindsym XF86AudioPause exec playerctl pause
          # bindsym XF86AudioNext exec playerctl next
          # bindsym XF86AudioPrev exec playerctl previous
        };

      startup = [
        # { command = "dropbox start"; notification = false; }
        { command = "setxkbmap -layout fr -variant bepo"; notification = false; }
        { command = "urxvtd -q -o -f"; notification = false; }
        { command = "udiskie"; notification = false; }
        { command = "parcellite -d"; notification = false; }
        { command = "numlockx on"; notification = false; } # turn verr num on
        #{ command = "docker start nginx-proxy "; notification = false; }# docker run -d -p 8080:8080 -p 81:80 -v /dev/null:/etc/traefik/traefik.toml -v /var/run/docker.sock:/var/run/docker.sock --name traefik traefik --web --docker --docker.domain=test --logLevel=INFO
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
      plugins = [ "git" "git-flow" "docker" "ssh-agent" "last-working-dir" "fasd" ];
    };

    initExtra = "
      bindkey ' ' forward-word
    ";

    sessionVariables = {
      EDITOR = "vim";
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=7";
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
      copy = "xclip -selection c";
      deploy = "docker run -it --rm -v ~/.ssh:/root/.ssh -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -v $(pwd):/source neolao/capistrano:3.4.0 bash";

      bepo = "setxkbmap -layout fr -variant bepo";
      fr = "setxkbmap -layout fr -variant oss";

      m = "make";
      t = "task";
      p = "pass";
      tg = "tig --all";
      tgs = "tig status";
    };
  };

  programs.git = {
    enable = true;
    package = latest.gitAndTools.gitFull;

    userEmail = "pierre@occitech.fr";
    userName = "Pierre Martin";

    aliases = {
      co = "checkout";
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
  };

  programs.htop = {
    enable = true;
  };

  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" ];
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

    #TODO profiles
  };
}

# TODO
#
# - setup GPG for Git, mails etc...
# - try fzf?