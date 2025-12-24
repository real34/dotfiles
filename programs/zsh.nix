{ pkgs, ... }:

{
  # see https://starship.rs/fr-fr/installing/#declaration-utilisateur-unique-via-home-manager
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion = { enable = true; };
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
    initContent = ''
      bindkey ' ' forward-word
      zstyle ':completion:*:hosts' hosts ''${=''${''${''${''${(@M)''${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
      setopt PROMPT_CR
      setopt PROMPT_SP

      m2wipe() {
        echo "Pouf pouf pouf…"
        sudo rm -rf $1/generated $1/var/cache/**/* $1/pub/static/* $1/var/page_cache $1/var/view_preprocessed
        mkdir $1/generated
        sudo chmod -R 777 $1/{var,pub,generated,app/etc}
        echo "… tchak !"
      }

      akamai() {
        # see https://gist.github.com/saml/4758360
        curl -v -s -H "Pragma: akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-ser"  "$1" 2>&1 > /dev/null
      }

      lh() {
        CHROME_PATH=$(which google-chrome) pnpm dlx lighthouse $1 --view
      }

      unalias v

      # see https://github.com/cantino/mcfly
      export MCFLY_FUZZY=true
      eval "$(mcfly init zsh)"

      eval "$(op completion zsh)"; compdef _op op
      eval "$(logcli --completion-script-zsh)"

      # https://docs.github.com/en/copilot/github-copilot-in-the-cli/using-github-copilot-in-the-cli?s=03#setting-up-aliases-for-copilot-in-the-cli
      eval "$(gh copilot alias -- zsh)"

      # K8s
      source <(helm completion zsh)
      source <(k3d completion zsh)
      source <(kubectl completion zsh)
      source <(k9s completion zsh); compdef _k9s k9s

      # https://github.com/Schniz/fnm#shell-setup
      eval "$(fnm env --use-on-cd --shell zsh)"
    '';

    sessionVariables = {
      EDITOR = "vim";
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=7";
      TERMINAL = "sakura";
      PATH = "$PATH:$HOME/.npm/bin:$HOME/.local/bin";
      # Use a local Cypress binary instead of the one installed by the CLI (not usable on NixOS)
      # see https://github.com/NixOS/nixpkgs/pull/56387 and https://discourse.nixos.org/t/cypress-with-npm/15137/4
      CYPRESS_INSTALL_BINARY = 0;
      CYPRESS_RUN_BINARY = "$HOME/.nix-profile/bin/Cypress";
      LD_LIBRARY_PATH = "${pkgs.libgcc}/lib";
    };

    shellAliases = {
      s = "fasd -si"; # show / search / select
      d = "fasd -d"; # directory
      f = "fasd -f"; # file
      sd = "fasd -sid"; # interactive directory selection
      sf = "fasd -sif"; # interactive file selection
      z = "fasd_cd -d"; # cd, same functionality as j in autojump
      j = "fasd_cd -d"; # cd, same functionality as j in autojump
      zz = "fasd_cd -d -i"; # cd with interactive selection

      dc = "docker compose";
      dcr = "docker compose run --rm";
      dcrm = "docker compose rm -fsv";
      copy = "xclip -selection c";

      bepo = "setxkbmap -layout fr -variant bepo";
      fr = "setxkbmap -layout fr -variant oss";

      m = "make";
      t = "task";
      k = "kubectl --context build";
      kb9 = "k9s --context build";
      kp = "kubectl --context prod-eu7";
      kp9 = "k9s --context prod-eu7";
      g = "git";
      gui = "gitui";
      htop = "btop";
      c = "claude";
      a = "antigravity";
    };
  };
}
