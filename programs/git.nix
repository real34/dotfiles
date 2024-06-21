{ pkgs, ... }:

{
  programs.gitui.enable = true;
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    # TODO: https://www.imagile.fr/utiliser-automatiquement-plusieurs-identites-sur-git/
    userEmail = "pierre@front-commerce.com";
    userName = "Pierre Martin";

    aliases = {
      co = "checkout";
      pushf = "push --force-with-lease --force-if-includes";
      aimr = "log --pretty=format:'%s%n%b---'";
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
      "shell.nix"
      ".envrc"
      ".direnv"
    ];

    # see https://github.com/dandavison/delta#get-started
    delta.enable = true;
    extraConfig = {
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";

      merge.tool = "meld";
      diff.external = "difft";
      diff.algorithm = "patience";
      pull.ff = "only";
      credential.helper = "store";
      init.defaultBranch = "main";

      # see https://betterprogramming.pub/8-advanced-git-commands-university-wont-teach-you-fe63b483d34b
      help.autocorrect = 1;
      fetch.prune = true;
      push.autoSetupRemote = true;

      # see https://michaelheap.com/git-ignore-rev/
      # Not activated globally because it throws errors if the file is not present.
      # Enable it in a specific repository if needed.
      # blame.ignoreRevsFile = ".git-blame-ignore-revs";

      # see https://adamj.eu/tech/2022/10/15/how-to-rebase-stacked-git-branches/
      rebase.updateRefs = true;
    };
  };
}
