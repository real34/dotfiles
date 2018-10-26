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

    latest.atool
    latest.unzip
    latest.zip
    latest.p7zip

    latest.pass

    latest.pcmanfm
    latest.udiskie

    latest.gitAndTools.gitflow latest.gitAndTools.tig

    google-chrome-beta

    latest.vscode
    latest.jetbrains.phpstorm

    unclutter-xfixes

    python

    # Peek. See https://github.com/NixOS/nixpkgs/issues/39832
    peek
      ffmpeg
      glib
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      keybinder
  ];

  # Doc: https://rycee.gitlab.io/home-manager/options.html

  services.unclutter.enable = true;
  services.parcellite.enable = true;
  services.gpg-agent.enable = true;

  programs.home-manager = {
    enable = true;
    path = https://github.com/rycee/home-manager/archive/release-18.03.tar.gz;
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
}

# TODO
#
# - setup GPG for Git, mails etc...
# - try fzf?