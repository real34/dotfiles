{
  # TODO replace with  Starship: https://starship.rs/fr-fr/installing/#declaration-utilisateur-unique-via-home-manager
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
      source <(k9s completion zsh); compdef _k9s k9s
    '';

    sessionVariables = {
      EDITOR = "vim";
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=7";
      TERMINAL = "sakura";
      PATH = "$PATH:$HOME/.npm/bin";
    };

    shellAliases = {
      a = "fasd -a"; # any
      s = "fasd -si"; # show / search / select
      d = "fasd -d"; # directory
      f = "fasd -f"; # file
      sd = "fasd -sid"; # interactive directory selection
      sf = "fasd -sif"; # interactive file selection
      z = "fasd_cd -d"; # cd, same functionality as j in autojump
      j = "fasd_cd -d"; # cd, same functionality as j in autojump
      zz = "fasd_cd -d -i"; # cd with interactive selection

      dc = "docker-compose";
      dcr = "docker-compose run --rm";
      dcrm = "docker-compose rm -fsv";
      copy = "xclip -selection c";

      bepo = "setxkbmap -layout fr -variant bepo";
      fr = "setxkbmap -layout fr -variant oss";

      m = "make";
      t = "task";
      k = "kubectl --context build";
      kb9 = "k9s --context build";
      kp = "kubectl --context prod-eu5";
      kp9 = "k9s --context prod-eu5";
      ks = "kubectl --context prod-eu6";
      ks9 = "k9s --context prod-eu6";
      g = "git";
      gui = "gitui";
      htop = "btop";
    };
  };
}
