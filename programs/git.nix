{ pkgs, ... }:

{
  programs.gitui.enable = true;
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

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
      ".ddev"
      ".claude"
      "CLAUDE.local.md"
    ];

    # see https://github.com/dandavison/delta#get-started
    #delta.enable = true;
    # TEMPORARY DEACTIVATED due to the error
    # error[E0282]: type annotations needed for `Box<_>`
    #  --> /build/delta-0.17.0-vendor.tar.gz/time/src/format_description/parse/mod.rs:83:9

    settings = {
      alias = {
        co = "checkout";
        pushf = "push --force-with-lease --force-if-includes";
        aimr = "log --pretty=format:'%s%n%b---'";
      };

      user = {
        email = "pierre@front-commerce.com";
        name = "Pierre Martin";
      };

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
